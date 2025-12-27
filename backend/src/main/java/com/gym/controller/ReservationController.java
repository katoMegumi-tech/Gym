package com.gym.controller;

import cn.dev33.satoken.stp.StpUtil;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.gym.common.Result;
import com.gym.entity.Reservation;
import com.gym.service.ReservationService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDateTime;

@Tag(name = "预约管理")
@RestController
@RequestMapping("/reservations")
@RequiredArgsConstructor
public class ReservationController {
    
    private final ReservationService reservationService;
    
    @Operation(summary = "我的预约列表")
    @GetMapping("/my")
    public Result<Page<Reservation>> myReservations(
            @RequestParam(defaultValue = "1") Integer page,
            @RequestParam(defaultValue = "10") Integer size) {
        
        Long userId = StpUtil.getLoginIdAsLong();
        
        LambdaQueryWrapper<Reservation> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(Reservation::getUserId, userId)
               .orderByDesc(Reservation::getCreatedAt);
        
        return Result.success(reservationService.page(new Page<>(page, size), wrapper));
    }
    
    @Operation(summary = "预约列表（管理员）")
    @GetMapping
    public Result<Page<Reservation>> list(
            @RequestParam(defaultValue = "1") Integer page,
            @RequestParam(defaultValue = "10") Integer size,
            @RequestParam(required = false) String status) {
        
        LambdaQueryWrapper<Reservation> wrapper = new LambdaQueryWrapper<>();
        if (status != null && !status.isEmpty()) {
            wrapper.eq(Reservation::getStatus, status);
        }
        wrapper.orderByDesc(Reservation::getCreatedAt);
        
        return Result.success(reservationService.page(new Page<>(page, size), wrapper));
    }
    
    @Operation(summary = "创建预约")
    @PostMapping
    public Result<Void> create(@RequestBody Reservation reservation) {
        Long userId = StpUtil.getLoginIdAsLong();
        reservation.setUserId(userId);
        reservation.setReservationNo("R" + System.currentTimeMillis());
        reservation.setStatus("PENDING_PAYMENT");
        reservationService.save(reservation);
        return Result.success();
    }
    
    @Operation(summary = "取消预约")
    @PutMapping("/{id}/cancel")
    public Result<Void> cancel(@PathVariable Long id, @RequestParam String reason) {
        Reservation reservation = reservationService.getById(id);
        if (reservation == null) {
            return Result.error("预约不存在");
        }
        
        Long userId = StpUtil.getLoginIdAsLong();
        if (!reservation.getUserId().equals(userId)) {
            return Result.error("无权操作");
        }
        
        reservation.setStatus("CANCELLED");
        reservation.setCancelReason(reason);
        reservation.setCancelledAt(LocalDateTime.now());
        reservationService.updateById(reservation);
        
        return Result.success();
    }
    
    @Operation(summary = "预约详情")
    @GetMapping("/{id}")
    public Result<Reservation> detail(@PathVariable Long id) {
        return Result.success(reservationService.getById(id));
    }
}
