package com.gym.controller;

import cn.dev33.satoken.stp.StpUtil;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.gym.common.Result;
import com.gym.entity.Coupon;
import com.gym.entity.UserCoupon;
import com.gym.service.CouponService;
import com.gym.service.UserCouponService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDateTime;

@Tag(name = "优惠券管理")
@RestController
@RequestMapping("/coupons")
@RequiredArgsConstructor
public class CouponController {
    
    private final CouponService couponService;
    private final UserCouponService userCouponService;
    
    @Operation(summary = "优惠券列表")
    @GetMapping
    public Result<Page<Coupon>> list(
            @RequestParam(defaultValue = "1") Integer page,
            @RequestParam(defaultValue = "10") Integer size,
            @RequestParam(required = false) String status) {
        
        LambdaQueryWrapper<Coupon> wrapper = new LambdaQueryWrapper<>();
        if (status != null && !status.isEmpty()) {
            wrapper.eq(Coupon::getStatus, status);
        }
        wrapper.orderByDesc(Coupon::getCreatedAt);
        
        return Result.success(couponService.page(new Page<>(page, size), wrapper));
    }
    
    @Operation(summary = "创建优惠券")
    @PostMapping
    public Result<Void> create(@RequestBody Coupon coupon) {
        coupon.setUsedQuantity(0);
        coupon.setStatus("ACTIVE");
        couponService.save(coupon);
        return Result.success();
    }
    
    @Operation(summary = "更新优惠券")
    @PutMapping("/{id}")
    public Result<Void> update(@PathVariable Long id, @RequestBody Coupon coupon) {
        coupon.setId(id);
        couponService.updateById(coupon);
        return Result.success();
    }
    
    @Operation(summary = "领取优惠券")
    @PostMapping("/{id}/claim")
    public Result<Void> claim(@PathVariable Long id) {
        Long userId = StpUtil.getLoginIdAsLong();
        
        Coupon coupon = couponService.getById(id);
        if (coupon == null) {
            return Result.error("优惠券不存在");
        }
        
        if (coupon.getUsedQuantity() >= coupon.getTotalQuantity()) {
            return Result.error("优惠券已领完");
        }
        
        // 检查是否已领取
        LambdaQueryWrapper<UserCoupon> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(UserCoupon::getUserId, userId)
               .eq(UserCoupon::getCouponId, id);
        if (userCouponService.count(wrapper) > 0) {
            return Result.error("已领取过该优惠券");
        }
        
        UserCoupon userCoupon = new UserCoupon();
        userCoupon.setUserId(userId);
        userCoupon.setCouponId(id);
        userCoupon.setStatus("UNUSED");
        userCoupon.setExpireAt(coupon.getEndTime());
        userCouponService.save(userCoupon);
        
        coupon.setUsedQuantity(coupon.getUsedQuantity() + 1);
        couponService.updateById(coupon);
        
        return Result.success();
    }
    
    @Operation(summary = "我的优惠券")
    @GetMapping("/my")
    public Result<Page<UserCoupon>> myCoupons(
            @RequestParam(defaultValue = "1") Integer page,
            @RequestParam(defaultValue = "10") Integer size,
            @RequestParam(required = false) String status) {
        
        Long userId = StpUtil.getLoginIdAsLong();
        
        LambdaQueryWrapper<UserCoupon> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(UserCoupon::getUserId, userId);
        if (status != null && !status.isEmpty()) {
            wrapper.eq(UserCoupon::getStatus, status);
        }
        wrapper.orderByDesc(UserCoupon::getCreatedAt);
        
        return Result.success(userCouponService.page(new Page<>(page, size), wrapper));
    }
}
