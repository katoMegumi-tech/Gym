package com.gym.controller;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.gym.common.Result;
import com.gym.entity.*;
import com.gym.service.ReservationService;
import com.gym.service.PaymentService;
import com.gym.service.VenueService;
import com.gym.service.CourtService;
import com.gym.service.TimeslotService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.*;

@Tag(name = "统计接口")
@RestController
@RequestMapping("/statistics")
@RequiredArgsConstructor
public class StatisticsController {
    
    private final ReservationService reservationService;
    private final PaymentService paymentService;
    private final VenueService venueService;
    private final CourtService courtService;
    private final TimeslotService timeslotService;
    
    @Operation(summary = "Dashboard统计数据")
    @GetMapping("/dashboard")
    public Result<Map<String, Object>> dashboard() {
        Map<String, Object> stats = new HashMap<>();
        
        // 总预约数
        long totalReservations = reservationService.count();
        stats.put("totalReservations", totalReservations);
        
        // 今日预约数
        LocalDate today = LocalDate.now();
        LambdaQueryWrapper<Reservation> todayWrapper = new LambdaQueryWrapper<>();
        todayWrapper.eq(Reservation::getSlotDate, today);
        long todayReservations = reservationService.count(todayWrapper);
        stats.put("todayReservations", todayReservations);
        
        // 总收入（已支付的）
        LambdaQueryWrapper<Payment> paymentWrapper = new LambdaQueryWrapper<>();
        paymentWrapper.eq(Payment::getPaymentStatus, "SUCCESS");
        List<Payment> payments = paymentService.list(paymentWrapper);
        BigDecimal totalRevenue = payments.stream()
                .map(Payment::getAmount)
                .reduce(BigDecimal.ZERO, BigDecimal::add);
        stats.put("totalRevenue", totalRevenue);
        
        // 今日收入
        LambdaQueryWrapper<Payment> todayPaymentWrapper = new LambdaQueryWrapper<>();
        todayPaymentWrapper.eq(Payment::getPaymentStatus, "SUCCESS")
                .ge(Payment::getPaidAt, today.atStartOfDay())
                .lt(Payment::getPaidAt, today.plusDays(1).atStartOfDay());
        List<Payment> todayPayments = paymentService.list(todayPaymentWrapper);
        BigDecimal todayRevenue = todayPayments.stream()
                .map(Payment::getAmount)
                .reduce(BigDecimal.ZERO, BigDecimal::add);
        stats.put("todayRevenue", todayRevenue);
        
        // 场馆数量
        long venueCount = venueService.count();
        stats.put("venueCount", venueCount);
        
        // 场地数量
        long courtCount = courtService.count();
        stats.put("courtCount", courtCount);
        
        // 场馆使用率（今日已预约时段/总时段）
        LambdaQueryWrapper<Timeslot> slotWrapper = new LambdaQueryWrapper<>();
        slotWrapper.eq(Timeslot::getSlotDate, today);
        long totalSlots = timeslotService.count(slotWrapper);
        
        slotWrapper.clear();
        slotWrapper.eq(Timeslot::getSlotDate, today)
                   .eq(Timeslot::getStatus, "BOOKED");
        long bookedSlots = timeslotService.count(slotWrapper);
        
        int usageRate = totalSlots > 0 ? (int) (bookedSlots * 100 / totalSlots) : 0;
        stats.put("venueUsageRate", usageRate);
        
        // 各状态预约数量
        Map<String, Long> reservationByStatus = new HashMap<>();
        String[] statuses = {"PENDING_PAYMENT", "PAID", "CONFIRMED", "COMPLETED", "CANCELLED"};
        for (String status : statuses) {
            LambdaQueryWrapper<Reservation> statusWrapper = new LambdaQueryWrapper<>();
            statusWrapper.eq(Reservation::getStatus, status);
            reservationByStatus.put(status, reservationService.count(statusWrapper));
        }
        stats.put("reservationByStatus", reservationByStatus);
        
        return Result.success(stats);
    }
    
    @Operation(summary = "近7天预约趋势")
    @GetMapping("/reservation-trend")
    public Result<List<Map<String, Object>>> reservationTrend() {
        List<Map<String, Object>> trend = new ArrayList<>();
        LocalDate today = LocalDate.now();
        
        for (int i = 6; i >= 0; i--) {
            LocalDate date = today.minusDays(i);
            LambdaQueryWrapper<Reservation> wrapper = new LambdaQueryWrapper<>();
            wrapper.eq(Reservation::getSlotDate, date);
            long count = reservationService.count(wrapper);
            
            Map<String, Object> item = new HashMap<>();
            item.put("date", date.toString());
            item.put("count", count);
            trend.add(item);
        }
        
        return Result.success(trend);
    }
    
    @Operation(summary = "各运动类型预约统计")
    @GetMapping("/sport-type-stats")
    public Result<List<Map<String, Object>>> sportTypeStats() {
        List<Map<String, Object>> stats = new ArrayList<>();
        String[] sportTypes = {"BASKETBALL", "BADMINTON", "TENNIS", "FITNESS", "YOGA", "SWIMMING"};
        String[] sportNames = {"篮球", "羽毛球", "网球", "健身", "瑜伽", "游泳"};
        
        for (int i = 0; i < sportTypes.length; i++) {
            // 获取该类型的所有场地ID
            LambdaQueryWrapper<Court> courtWrapper = new LambdaQueryWrapper<>();
            courtWrapper.eq(Court::getSportType, sportTypes[i]);
            List<Court> courts = courtService.list(courtWrapper);
            
            long count = 0;
            if (!courts.isEmpty()) {
                List<Long> courtIds = courts.stream().map(Court::getId).toList();
                LambdaQueryWrapper<Reservation> resWrapper = new LambdaQueryWrapper<>();
                resWrapper.in(Reservation::getCourtId, courtIds);
                count = reservationService.count(resWrapper);
            }
            
            Map<String, Object> item = new HashMap<>();
            item.put("type", sportTypes[i]);
            item.put("name", sportNames[i]);
            item.put("count", count);
            stats.add(item);
        }
        
        return Result.success(stats);
    }
}
