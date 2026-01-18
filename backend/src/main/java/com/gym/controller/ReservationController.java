package com.gym.controller;

import cn.dev33.satoken.stp.StpUtil;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.gym.common.Result;
import com.gym.entity.Court;
import com.gym.entity.Payment;
import com.gym.entity.Reservation;
import com.gym.entity.User;
import com.gym.entity.Venue;
import com.gym.mapper.UserMapper;
import com.gym.service.CourtService;
import com.gym.service.ReservationService;
import com.gym.service.VenueService;
import com.gym.vo.ReservationVO;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.BeanUtils;
import org.springframework.web.bind.annotation.*;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalTime;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@Tag(name = "预约管理")
@RestController
@RequestMapping("/reservations")
@RequiredArgsConstructor
public class ReservationController {
    
    private final ReservationService reservationService;
    private final CourtService courtService;
    private final VenueService venueService;
    private final UserMapper userMapper;
    
    @Operation(summary = "我的预约列表")
    @GetMapping("/my")
    public Result<Page<ReservationVO>> myReservations(
            @RequestParam(defaultValue = "1") Integer page,
            @RequestParam(defaultValue = "10") Integer size,
            @RequestParam(required = false) String status) {
        
        Long userId = StpUtil.getLoginIdAsLong();
        
        LambdaQueryWrapper<Reservation> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(Reservation::getUserId, userId);
        if (status != null && !status.isEmpty()) {
            wrapper.eq(Reservation::getStatus, status);
        }
        wrapper.orderByDesc(Reservation::getCreatedAt);
        
        Page<Reservation> reservationPage = reservationService.page(new Page<>(page, size), wrapper);
        
        // 转换为VO并填充关联信息
        Page<ReservationVO> voPage = new Page<>(reservationPage.getCurrent(), reservationPage.getSize(), reservationPage.getTotal());
        List<ReservationVO> voList = reservationPage.getRecords().stream().map(this::convertToVO).collect(Collectors.toList());
        voPage.setRecords(voList);
        
        return Result.success(voPage);
    }
    
    @Operation(summary = "预约列表（管理员）")
    @GetMapping
    public Result<Page<ReservationVO>> list(
            @RequestParam(defaultValue = "1") Integer page,
            @RequestParam(defaultValue = "10") Integer size,
            @RequestParam(required = false) String status,
            @RequestParam(required = false) String reservationNo) {
        
        LambdaQueryWrapper<Reservation> wrapper = new LambdaQueryWrapper<>();
        if (status != null && !status.isEmpty()) {
            wrapper.eq(Reservation::getStatus, status);
        }
        if (reservationNo != null && !reservationNo.isEmpty()) {
            wrapper.like(Reservation::getReservationNo, reservationNo);
        }
        wrapper.orderByDesc(Reservation::getCreatedAt);
        
        Page<Reservation> reservationPage = reservationService.page(new Page<>(page, size), wrapper);
        
        // 转换为VO并填充关联信息
        Page<ReservationVO> voPage = new Page<>(reservationPage.getCurrent(), reservationPage.getSize(), reservationPage.getTotal());
        List<ReservationVO> voList = reservationPage.getRecords().stream().map(this::convertToVO).collect(Collectors.toList());
        voPage.setRecords(voList);
        
        return Result.success(voPage);
    }
    
    @Operation(summary = "创建预约")
    @PostMapping
    public Result<Reservation> create(@RequestBody Map<String, Object> params) {
        Long userId = StpUtil.getLoginIdAsLong();
        
        Long courtId = Long.valueOf(params.get("courtId").toString());
        LocalDate slotDate = LocalDate.parse(params.get("slotDate").toString());
        LocalTime startTime = LocalTime.parse(params.get("startTime").toString());
        LocalTime endTime = LocalTime.parse(params.get("endTime").toString());
        BigDecimal amount = new BigDecimal(params.get("amount").toString());
        Integer participants = params.get("participants") != null ? 
                Integer.valueOf(params.get("participants").toString()) : 1;
        String contactName = params.get("contactName") != null ? 
                params.get("contactName").toString() : "";
        String contactPhone = params.get("contactPhone") != null ? 
                params.get("contactPhone").toString() : "";
        
        try {
            Reservation reservation = reservationService.createReservation(
                    userId, courtId, slotDate, startTime, endTime, amount,
                    participants, contactName, contactPhone);
            return Result.success(reservation);
        } catch (RuntimeException e) {
            return Result.error(e.getMessage());
        }
    }
    
    @Operation(summary = "模拟支付")
    @PostMapping("/{id}/pay")
    public Result<Payment> pay(@PathVariable Long id, 
            @RequestParam(defaultValue = "WECHAT") String paymentMethod) {
        
        Long userId = StpUtil.getLoginIdAsLong();
        Reservation reservation = reservationService.getById(id);
        
        if (reservation == null) {
            return Result.error("预约不存在");
        }
        if (!reservation.getUserId().equals(userId)) {
            return Result.error("无权操作");
        }
        
        try {
            Payment payment = reservationService.simulatePayment(id, paymentMethod);
            return Result.success(payment);
        } catch (RuntimeException e) {
            return Result.error(e.getMessage());
        }
    }
    
    @Operation(summary = "取消预约")
    @PutMapping("/{id}/cancel")
    public Result<Void> cancel(@PathVariable Long id, 
            @RequestParam(defaultValue = "用户取消") String reason) {
        
        Reservation reservation = reservationService.getById(id);
        if (reservation == null) {
            return Result.error("预约不存在");
        }
        
        // 检查权限（用户只能取消自己的预约，管理员可以取消任何预约）
        try {
            Long userId = StpUtil.getLoginIdAsLong();
            if (!reservation.getUserId().equals(userId)) {
                // 这里可以添加管理员权限检查
            }
        } catch (Exception ignored) {}
        
        try {
            reservationService.cancelReservation(id, reason);
            return Result.success();
        } catch (RuntimeException e) {
            return Result.error(e.getMessage());
        }
    }
    
    @Operation(summary = "预约详情")
    @GetMapping("/{id}")
    public Result<Map<String, Object>> detail(@PathVariable Long id) {
        Reservation reservation = reservationService.getById(id);
        if (reservation == null) {
            return Result.error("预约不存在");
        }
        
        // 获取场地和场馆信息
        Court court = courtService.getById(reservation.getCourtId());
        Venue venue = null;
        if (court != null) {
            venue = venueService.getById(court.getVenueId());
        }
        
        Map<String, Object> result = new HashMap<>();
        result.put("reservation", reservation);
        result.put("court", court);
        result.put("venue", venue);
        
        return Result.success(result);
    }
    
    @Operation(summary = "确认预约（管理员）")
    @PutMapping("/{id}/confirm")
    public Result<Void> confirm(@PathVariable Long id) {
        Reservation reservation = reservationService.getById(id);
        if (reservation == null) {
            return Result.error("预约不存在");
        }
        
        if (!"PAID".equals(reservation.getStatus())) {
            return Result.error("只有已支付的预约才能确认");
        }
        
        reservation.setStatus("CONFIRMED");
        reservationService.updateById(reservation);
        return Result.success();
    }
    
    @Operation(summary = "完成预约（管理员）")
    @PutMapping("/{id}/complete")
    public Result<Void> complete(@PathVariable Long id) {
        Reservation reservation = reservationService.getById(id);
        if (reservation == null) {
            return Result.error("预约不存在");
        }
        
        reservation.setStatus("COMPLETED");
        reservation.setCompletedAt(java.time.LocalDateTime.now());
        reservationService.updateById(reservation);
        return Result.success();
    }
    
    /**
     * 将Reservation转换为ReservationVO，填充关联信息
     */
    private ReservationVO convertToVO(Reservation reservation) {
        ReservationVO vo = new ReservationVO();
        BeanUtils.copyProperties(reservation, vo);
        
        // 填充用户信息
        User user = userMapper.selectById(reservation.getUserId());
        if (user != null) {
            vo.setUserName(user.getRealName() != null ? user.getRealName() : user.getUsername());
            vo.setUserPhone(user.getPhone());
        }
        
        // 填充场地和场馆信息
        Court court = courtService.getById(reservation.getCourtId());
        if (court != null) {
            vo.setCourtName(court.getName());
            vo.setSportType(court.getSportType());
            vo.setVenueId(court.getVenueId());
            
            Venue venue = venueService.getById(court.getVenueId());
            if (venue != null) {
                vo.setVenueName(venue.getName());
            }
        }
        
        return vo;
    }
}
