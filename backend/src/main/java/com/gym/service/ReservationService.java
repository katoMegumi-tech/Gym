package com.gym.service;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.gym.entity.Payment;
import com.gym.entity.Reservation;
import com.gym.entity.Timeslot;
import com.gym.entity.Coupon;
import com.gym.entity.UserCoupon;
import com.gym.entity.ReservationCoupon;
import com.gym.mapper.PaymentMapper;
import com.gym.mapper.ReservationMapper;
import com.gym.mapper.TimeslotMapper;
import com.gym.mapper.CouponMapper;
import com.gym.mapper.UserCouponMapper;
import com.gym.mapper.ReservationCouponMapper;
import com.gym.util.RedisLockUtil;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.util.List;

@Slf4j
@Service
@RequiredArgsConstructor
public class ReservationService extends ServiceImpl<ReservationMapper, Reservation> {
    
    private final TimeslotMapper timeslotMapper;
    private final PaymentMapper paymentMapper;
    private final RedisLockUtil redisLockUtil;
    private final CouponMapper couponMapper;
    private final UserCouponMapper userCouponMapper;
    private final ReservationCouponMapper reservationCouponMapper;
    
    // 锁过期时间（秒）
    private static final long LOCK_EXPIRE_SECONDS = 10;
    // 乐观锁重试次数
    private static final int MAX_RETRY_COUNT = 3;
    
    /**
     * 创建预约 - 使用分布式锁 + 乐观锁双重保障
     * @param couponId 优惠券ID（可选）
     */
    public Reservation createReservation(Long userId, Long courtId, LocalDate slotDate, 
            LocalTime startTime, LocalTime endTime, BigDecimal amount,
            Integer participants, String contactName, String contactPhone, Long couponId) {
        
        // 1. 获取分布式锁
        String lockKey = RedisLockUtil.buildReservationLockKey(courtId, slotDate.toString(), startTime.toString());
        String lockValue = redisLockUtil.tryLock(lockKey, LOCK_EXPIRE_SECONDS);
        
        if (lockValue == null) {
            throw new RuntimeException("当前预约人数较多，请稍后重试");
        }
        
        try {
            // 2. 在锁保护下执行预约逻辑（带乐观锁重试）
            return doCreateReservationWithRetry(userId, courtId, slotDate, startTime, endTime, 
                    amount, participants, contactName, contactPhone, couponId);
        } finally {
            // 3. 释放锁
            redisLockUtil.releaseLock(lockKey, lockValue);
        }
    }
    
    /**
     * 创建预约 - 兼容旧接口（无优惠券）
     */
    public Reservation createReservation(Long userId, Long courtId, LocalDate slotDate, 
            LocalTime startTime, LocalTime endTime, BigDecimal amount,
            Integer participants, String contactName, String contactPhone) {
        return createReservation(userId, courtId, slotDate, startTime, endTime, 
                amount, participants, contactName, contactPhone, null);
    }
    
    /**
     * 带乐观锁重试的预约创建
     */
    private Reservation doCreateReservationWithRetry(Long userId, Long courtId, LocalDate slotDate,
            LocalTime startTime, LocalTime endTime, BigDecimal amount,
            Integer participants, String contactName, String contactPhone, Long couponId) {
        
        for (int retry = 0; retry < MAX_RETRY_COUNT; retry++) {
            try {
                return doCreateReservation(userId, courtId, slotDate, startTime, endTime,
                        amount, participants, contactName, contactPhone, couponId);
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
            Integer participants, String contactName, String contactPhone, Long couponId) {
        
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
        
        // 3. 检查用户预约冲突
        if (checkUserConflict(userId, slotDate, startTime, endTime)) {
            throw new RuntimeException("您在该时间段已有其他预约，无法重复预约");
        }
        
        // 4. 应用优惠券（如果有）
        BigDecimal finalAmount = amount;
        BigDecimal discountAmount = BigDecimal.ZERO;
        Long userCouponId = null;
        
        if (couponId != null) {
            CouponResult couponResult = applyCoupon(userId, couponId, amount);
            finalAmount = couponResult.getFinalAmount();
            discountAmount = couponResult.getDiscountAmount();
            userCouponId = couponResult.getUserCouponId();
        }
        
        // 5. 创建预约记录
        Reservation reservation = new Reservation();
        reservation.setReservationNo("R" + System.currentTimeMillis() + (int)(Math.random() * 1000));
        reservation.setUserId(userId);
        reservation.setCourtId(courtId);
        reservation.setSlotDate(slotDate);
        reservation.setStartTime(startTime);
        reservation.setEndTime(endTime);
        reservation.setAmount(finalAmount); // 使用优惠后的金额
        reservation.setStatus("PENDING_PAYMENT");
        reservation.setParticipants(participants != null ? participants : 1);
        reservation.setContactName(contactName);
        reservation.setContactPhone(contactPhone);
        this.save(reservation);
        
        // 6. 如果使用了优惠券，记录优惠券使用信息
        if (userCouponId != null) {
            ReservationCoupon reservationCoupon = new ReservationCoupon();
            reservationCoupon.setReservationId(reservation.getId());
            reservationCoupon.setUserCouponId(userCouponId);
            reservationCoupon.setDiscountAmount(discountAmount);
            reservationCoupon.setCreatedAt(LocalDateTime.now());
            reservationCouponMapper.insert(reservationCoupon);
            
            // 标记优惠券为已使用
            UserCoupon userCoupon = userCouponMapper.selectById(userCouponId);
            userCoupon.setStatus("USED");
            userCoupon.setUsedAt(LocalDateTime.now());
            userCouponMapper.updateById(userCoupon);
        }
        
        // 7. 更新时间段（乐观锁会自动检查version）
        timeslot.setBookedCount(timeslot.getBookedCount() + 1);
        // 当预约数达到容量上限时，标记为已满
        if (timeslot.getBookedCount() >= timeslot.getQuota()) {
            timeslot.setStatus("BOOKED");
        }
        int updated = timeslotMapper.updateById(timeslot);
        
        // 8. 乐观锁更新失败，抛出异常触发重试
        if (updated == 0) {
            throw new OptimisticLockException("时间段已被其他用户预约");
        }
        
        log.info("预约创建成功: reservationNo={}, userId={}, courtId={}, date={}, time={}-{}, finalAmount={}, discount={}",
                reservation.getReservationNo(), userId, courtId, slotDate, startTime, endTime, finalAmount, discountAmount);
        
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
        
        // 检查取消时间限制：预约开始前2小时才能取消
        LocalDateTime reservationStartTime = LocalDateTime.of(
                reservation.getSlotDate(), reservation.getStartTime());
        LocalDateTime now = LocalDateTime.now();
        LocalDateTime cancelDeadline = reservationStartTime.minusHours(2);
        
        if (now.isAfter(cancelDeadline)) {
            throw new RuntimeException("预约开始前2小时内不能取消");
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
        
        // 2. 如果使用了优惠券，恢复优惠券
        LambdaQueryWrapper<ReservationCoupon> rcWrapper = new LambdaQueryWrapper<>();
        rcWrapper.eq(ReservationCoupon::getReservationId, reservationId);
        ReservationCoupon reservationCoupon = reservationCouponMapper.selectOne(rcWrapper);
        
        if (reservationCoupon != null) {
            UserCoupon userCoupon = userCouponMapper.selectById(reservationCoupon.getUserCouponId());
            if (userCoupon != null) {
                userCoupon.setStatus("UNUSED");
                userCoupon.setUsedAt(null);
                userCouponMapper.updateById(userCoupon);
            }
        }
        
        // 3. 如果已支付，创建退款记录
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
        
        // 4. 更新预约状态
        reservation.setCancelReason(reason);
        reservation.setCancelledAt(LocalDateTime.now());
        this.updateById(reservation);
        
        log.info("预约取消成功: reservationId={}, reason={}", reservationId, reason);
    }
    
    /**
     * 应用优惠券
     * @param userId 用户ID
     * @param couponId 优惠券ID
     * @param originalAmount 原始金额
     * @return 优惠券应用结果
     */
    private CouponResult applyCoupon(Long userId, Long couponId, BigDecimal originalAmount) {
        // 1. 查询用户优惠券
        LambdaQueryWrapper<UserCoupon> userCouponWrapper = new LambdaQueryWrapper<>();
        userCouponWrapper.eq(UserCoupon::getUserId, userId)
                        .eq(UserCoupon::getCouponId, couponId)
                        .eq(UserCoupon::getStatus, "UNUSED");
        UserCoupon userCoupon = userCouponMapper.selectOne(userCouponWrapper);
        
        if (userCoupon == null) {
            throw new RuntimeException("优惠券不存在或已使用");
        }
        
        // 2. 检查优惠券是否过期
        if (userCoupon.getExpireAt() != null && 
                userCoupon.getExpireAt().isBefore(LocalDateTime.now())) {
            throw new RuntimeException("优惠券已过期");
        }
        
        // 3. 查询优惠券详情
        Coupon coupon = couponMapper.selectById(couponId);
        if (coupon == null || !"ACTIVE".equals(coupon.getStatus())) {
            throw new RuntimeException("优惠券不可用");
        }
        
        // 4. 检查最低消费限制
        if (coupon.getMinAmount() != null && 
                originalAmount.compareTo(coupon.getMinAmount()) < 0) {
            throw new RuntimeException("未达到优惠券最低消费金额：" + coupon.getMinAmount() + "元");
        }
        
        // 5. 计算优惠金额
        BigDecimal discountAmount;
        BigDecimal finalAmount;
        
        if ("AMOUNT".equals(coupon.getType())) {
            // 固定金额优惠
            discountAmount = coupon.getValue();
            finalAmount = originalAmount.subtract(discountAmount);
        } else if ("PERCENTAGE".equals(coupon.getType())) {
            // 百分比优惠
            discountAmount = originalAmount.multiply(coupon.getValue())
                    .divide(new BigDecimal("100"), 2, RoundingMode.HALF_UP);
            finalAmount = originalAmount.subtract(discountAmount);
        } else {
            throw new RuntimeException("不支持的优惠券类型");
        }
        
        // 6. 确保最终金额不为负数
        if (finalAmount.compareTo(BigDecimal.ZERO) < 0) {
            finalAmount = BigDecimal.ZERO;
            discountAmount = originalAmount;
        }
        
        log.info("应用优惠券: userId={}, couponId={}, originalAmount={}, discountAmount={}, finalAmount={}",
                userId, couponId, originalAmount, discountAmount, finalAmount);
        
        return new CouponResult(finalAmount, discountAmount, userCoupon.getId());
    }
    
    /**
     * 优惠券应用结果
     */
    private static class CouponResult {
        private final BigDecimal finalAmount;
        private final BigDecimal discountAmount;
        private final Long userCouponId;
        
        public CouponResult(BigDecimal finalAmount, BigDecimal discountAmount, Long userCouponId) {
            this.finalAmount = finalAmount;
            this.discountAmount = discountAmount;
            this.userCouponId = userCouponId;
        }
        
        public BigDecimal getFinalAmount() {
            return finalAmount;
        }
        
        public BigDecimal getDiscountAmount() {
            return discountAmount;
        }
        
        public Long getUserCouponId() {
            return userCouponId;
        }
    }
    
    /**
     * 检查用户预约冲突
     * 检查用户在指定日期和时间段是否已有预约
     */
    private boolean checkUserConflict(Long userId, LocalDate slotDate, 
            LocalTime startTime, LocalTime endTime) {
        
        // 查询用户在该日期的所有有效预约
        LambdaQueryWrapper<Reservation> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(Reservation::getUserId, userId)
               .eq(Reservation::getSlotDate, slotDate)
               .in(Reservation::getStatus, "PENDING_PAYMENT", "PAID", "CONFIRMED");
        
        List<Reservation> userReservations = this.list(wrapper);
        
        // 检查时间是否重叠
        for (Reservation reservation : userReservations) {
            if (isTimeOverlap(startTime, endTime, 
                    reservation.getStartTime(), reservation.getEndTime())) {
                return true; // 存在冲突
            }
        }
        
        return false; // 无冲突
    }
    
    /**
     * 检查两个时间段是否重叠
     * 时间段1: [start1, end1)
     * 时间段2: [start2, end2)
     * 重叠条件: start1 < end2 && start2 < end1
     */
    private boolean isTimeOverlap(LocalTime start1, LocalTime end1, 
            LocalTime start2, LocalTime end2) {
        return start1.isBefore(end2) && start2.isBefore(end1);
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
