package com.gym.service;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.gym.entity.Payment;
import com.gym.entity.Reservation;
import com.gym.entity.Timeslot;
import com.gym.mapper.PaymentMapper;
import com.gym.mapper.ReservationMapper;
import com.gym.mapper.TimeslotMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;

@Service
@RequiredArgsConstructor
public class ReservationService extends ServiceImpl<ReservationMapper, Reservation> {
    
    private final TimeslotMapper timeslotMapper;
    private final PaymentMapper paymentMapper;
    
    /**
     * 创建预约
     */
    @Transactional
    public Reservation createReservation(Long userId, Long courtId, LocalDate slotDate, 
            LocalTime startTime, LocalTime endTime, BigDecimal amount,
            Integer participants, String contactName, String contactPhone) {
        
        // 1. 检查时间段是否可用
        LambdaQueryWrapper<Timeslot> slotWrapper = new LambdaQueryWrapper<>();
        slotWrapper.eq(Timeslot::getCourtId, courtId)
                   .eq(Timeslot::getSlotDate, slotDate)
                   .eq(Timeslot::getStartTime, startTime)
                   .eq(Timeslot::getEndTime, endTime);
        Timeslot timeslot = timeslotMapper.selectOne(slotWrapper);
        
        if (timeslot == null) {
            throw new RuntimeException("时间段不存在");
        }
        
        if (!"AVAILABLE".equals(timeslot.getStatus())) {
            throw new RuntimeException("该时间段已被预约");
        }
        
        // 2. 创建预约记录
        Reservation reservation = new Reservation();
        reservation.setReservationNo("R" + System.currentTimeMillis());
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
        
        // 3. 更新时间段状态为已预约
        timeslot.setStatus("BOOKED");
        timeslot.setBookedCount(timeslot.getBookedCount() + 1);
        timeslotMapper.updateById(timeslot);
        
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
        payment.setTransactionNo("T" + System.currentTimeMillis()); // 模拟第三方交易号
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
        
        // 只有待支付和已支付状态可以取消
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
            timeslot.setStatus("AVAILABLE");
            timeslot.setBookedCount(Math.max(0, timeslot.getBookedCount() - 1));
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
}
