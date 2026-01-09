package com.gym.service;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.gym.entity.Payment;
import com.gym.entity.Reservation;
import com.gym.entity.Timeslot;
import com.gym.mapper.PaymentMapper;
import com.gym.mapper.ReservationMapper;
import com.gym.mapper.TimeslotMapper;
import com.gym.util.RedisLockUtil;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;

@Slf4j
@Service
@RequiredArgsConstructor
public class ReservationService extends ServiceImpl<ReservationMapper, Reservation> {
    
    private final TimeslotMapper timeslotMapper;
    private final PaymentMapper paymentMapper;
    private final RedisLockUtil redisLockUtil;
    
    // 锁过期时间（秒）
    private static final long LOCK_EXPIRE_SECONDS = 10;
    // 乐观锁重试次数
    private static final int MAX_RETRY_COUNT = 3;
    
    /**
     * 创建预约 - 使用分布式锁 + 乐观锁双重保障
     */
    public Reservation createReservation(Long userId, Long courtId, LocalDate slotDate, 
            LocalTime startTime, LocalTime endTime, BigDecimal amount,
            Integer participants, String contactName, String contactPhone) {
        
        // 1. 获取分布式锁
        String lockKey = RedisLockUtil.buildReservationLockKey(courtId, slotDate.toString(), startTime.toString());
        String lockValue = redisLockUtil.tryLock(lockKey, LOCK_EXPIRE_SECONDS);
        
        if (lockValue == null) {
            throw new RuntimeException("当前预约人数较多，请稍后重试");
        }
        
        try {
            // 2. 在锁保护下执行预约逻辑（带乐观锁重试）
            return doCreateReservationWithRetry(userId, courtId, slotDate, startTime, endTime, 
                    amount, participants, contactName, contactPhone);
        } finally {
            // 3. 释放锁
            redisLockUtil.releaseLock(lockKey, lockValue);
        }
    }
    
    /**
     * 带乐观锁重试的预约创建
     */
    private Reservation doCreateReservationWithRetry(Long userId, Long courtId, LocalDate slotDate,
            LocalTime startTime, LocalTime endTime, BigDecimal amount,
            Integer participants, String contactName, String contactPhone) {
        
        for (int retry = 0; retry < MAX_RETRY_COUNT; retry++) {
            try {
                return doCreateReservation(userId, courtId, slotDate, startTime, endTime,
                        amount, participants, contactName, contactPhone);
            } catch (OptimisticLockException e) {
                log.warn("乐观锁冲突，重试第{}次", retry + 1);
                if (retry == MAX_RETRY_COUNT - 1) {
                    throw new RuntimeException("预约失败，请重试");
                }
                // 短暂等待后重试
                try {
                    Thread.sleep(50);
                } catch (InterruptedException ie) {
                    Thread.currentThread().interrupt();
                    throw new RuntimeException("预约被中断");
                }
            }
        }
        throw new RuntimeException("预约失败，请重试");
    }
    
    /**
     * 实际的预约创建逻辑
     */
    @Transactional
    public Reservation doCreateReservation(Long userId, Long courtId, LocalDate slotDate,
            LocalTime startTime, LocalTime endTime, BigDecimal amount,
            Integer participants, String contactName, String contactPhone) {
        
        // 1. 查询时间段
        LambdaQueryWrapper<Timeslot> slotWrapper = new LambdaQueryWrapper<>();
        slotWrapper.eq(Timeslot::getCourtId, courtId)
                   .eq(Timeslot::getSlotDate, slotDate)
                   .eq(Timeslot::getStartTime, startTime)
                   .eq(Timeslot::getEndTime, endTime);
        Timeslot timeslot = timeslotMapper.selectOne(slotWrapper);
        
        if (timeslot == null) {
            throw new RuntimeException("时间段不存在");
        }
        
        // 2. 检查容量（基于quota判断，而非简单的状态）
        if (timeslot.getBookedCount() >= timeslot.getQuota()) {
            throw new RuntimeException("该时间段已约满");
        }
        
        // 3. 创建预约记录
        Reservation reservation = new Reservation();
        reservation.setReservationNo("R" + System.currentTimeMillis() + (int)(Math.random() * 1000));
        reservation.setUserId(userId);
        reservation.setCourtId(courtId);
        reservation.setSlotDate(slotDate);
        reservation.setStartTime(startTime);
        reservation.setEndTime(endTime);
        reservation.setAmount(amount);
        reservation.setStatus("PENDING_PAYMENT");
        reservation.setParticipants(participants != null ? participants : 1);
        reservation.setContactName(contactName);
        reservation.setContactPhone(contactPhone);
        this.save(reservation);
        
        // 4. 更新时间段（乐观锁会自动检查version）
        timeslot.setBookedCount(timeslot.getBookedCount() + 1);
        // 当预约数达到容量上限时，标记为已满
        if (timeslot.getBookedCount() >= timeslot.getQuota()) {
            timeslot.setStatus("BOOKED");
        }
        int updated = timeslotMapper.updateById(timeslot);
        
        // 5. 乐观锁更新失败，抛出异常触发重试
        if (updated == 0) {
            throw new OptimisticLockException("时间段已被其他用户预约");
        }
        
        log.info("预约创建成功: reservationNo={}, userId={}, courtId={}, date={}, time={}-{}",
                reservation.getReservationNo(), userId, courtId, slotDate, startTime, endTime);
        
        return reservation;
    }
    
    /**
     * 模拟支付
     */
    @Transactional
    public Payment simulatePayment(Long reservationId, String paymentMethod) {
        Reservation reservation = this.getById(reservationId);
        if (reservation == null) {
            throw new RuntimeException("预约不存在");
        }
        
        if (!"PENDING_PAYMENT".equals(reservation.getStatus())) {
            throw new RuntimeException("预约状态不正确");
        }
        
        // 1. 创建支付记录
        Payment payment = new Payment();
        payment.setReservationId(reservationId);
        payment.setPaymentNo("P" + System.currentTimeMillis());
        payment.setAmount(reservation.getAmount());
        payment.setPaymentMethod(paymentMethod != null ? paymentMethod : "WECHAT");
        payment.setPaymentStatus("SUCCESS");
        payment.setTransactionNo("T" + System.currentTimeMillis());
        payment.setPaidAt(LocalDateTime.now());
        paymentMapper.insert(payment);
        
        // 2. 更新预约状态
        reservation.setStatus("PAID");
        this.updateById(reservation);
        
        return payment;
    }
    
    /**
     * 取消预约
     */
    @Transactional
    public void cancelReservation(Long reservationId, String reason) {
        Reservation reservation = this.getById(reservationId);
        if (reservation == null) {
            throw new RuntimeException("预约不存在");
        }
        
        if (!"PENDING_PAYMENT".equals(reservation.getStatus()) && 
            !"PAID".equals(reservation.getStatus())) {
            throw new RuntimeException("当前状态不可取消");
        }
        
        // 1. 释放时间段
        LambdaQueryWrapper<Timeslot> slotWrapper = new LambdaQueryWrapper<>();
        slotWrapper.eq(Timeslot::getCourtId, reservation.getCourtId())
                   .eq(Timeslot::getSlotDate, reservation.getSlotDate())
                   .eq(Timeslot::getStartTime, reservation.getStartTime());
        Timeslot timeslot = timeslotMapper.selectOne(slotWrapper);
        
        if (timeslot != null) {
            timeslot.setBookedCount(Math.max(0, timeslot.getBookedCount() - 1));
            // 有空位时恢复为可预约状态
            if (timeslot.getBookedCount() < timeslot.getQuota()) {
                timeslot.setStatus("AVAILABLE");
            }
            timeslotMapper.updateById(timeslot);
        }
        
        // 2. 如果已支付，创建退款记录
        if ("PAID".equals(reservation.getStatus())) {
            LambdaQueryWrapper<Payment> paymentWrapper = new LambdaQueryWrapper<>();
            paymentWrapper.eq(Payment::getReservationId, reservationId)
                         .eq(Payment::getPaymentStatus, "SUCCESS");
            Payment payment = paymentMapper.selectOne(paymentWrapper);
            
            if (payment != null) {
                payment.setPaymentStatus("REFUNDED");
                payment.setRefundAmount(payment.getAmount());
                payment.setRefundedAt(LocalDateTime.now());
                paymentMapper.updateById(payment);
            }
            
            reservation.setStatus("REFUNDED");
        } else {
            reservation.setStatus("CANCELLED");
        }
        
        // 3. 更新预约状态
        reservation.setCancelReason(reason);
        reservation.setCancelledAt(LocalDateTime.now());
        this.updateById(reservation);
    }
    
    /**
     * 乐观锁异常
     */
    public static class OptimisticLockException extends RuntimeException {
        public OptimisticLockException(String message) {
            super(message);
        }
    }
}
