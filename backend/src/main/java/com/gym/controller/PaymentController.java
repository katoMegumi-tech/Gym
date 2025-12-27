package com.gym.controller;

import cn.dev33.satoken.stp.StpUtil;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.gym.common.Result;
import com.gym.entity.Payment;
import com.gym.service.PaymentService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDateTime;

@Tag(name = "支付管理")
@RestController
@RequestMapping("/payments")
@RequiredArgsConstructor
public class PaymentController {
    
    private final PaymentService paymentService;
    
    @Operation(summary = "支付列表")
    @GetMapping
    public Result<Page<Payment>> list(
            @RequestParam(defaultValue = "1") Integer page,
            @RequestParam(defaultValue = "10") Integer size,
            @RequestParam(required = false) String paymentStatus) {
        
        LambdaQueryWrapper<Payment> wrapper = new LambdaQueryWrapper<>();
        if (paymentStatus != null && !paymentStatus.isEmpty()) {
            wrapper.eq(Payment::getPaymentStatus, paymentStatus);
        }
        wrapper.orderByDesc(Payment::getCreatedAt);
        
        return Result.success(paymentService.page(new Page<>(page, size), wrapper));
    }
    
    @Operation(summary = "创建支付")
    @PostMapping
    public Result<Payment> create(@RequestBody Payment payment) {
        payment.setPaymentNo("P" + System.currentTimeMillis());
        payment.setPaymentStatus("PENDING");
        paymentService.save(payment);
        return Result.success(payment);
    }
    
    @Operation(summary = "支付成功回调")
    @PutMapping("/{id}/success")
    public Result<Void> paymentSuccess(
            @PathVariable Long id,
            @RequestParam String transactionNo) {
        
        Payment payment = paymentService.getById(id);
        if (payment == null) {
            return Result.error("支付记录不存在");
        }
        
        payment.setPaymentStatus("SUCCESS");
        payment.setTransactionNo(transactionNo);
        payment.setPaidAt(LocalDateTime.now());
        paymentService.updateById(payment);
        
        return Result.success();
    }
    
    @Operation(summary = "退款")
    @PutMapping("/{id}/refund")
    public Result<Void> refund(@PathVariable Long id) {
        Payment payment = paymentService.getById(id);
        if (payment == null) {
            return Result.error("支付记录不存在");
        }
        
        payment.setPaymentStatus("REFUNDED");
        payment.setRefundAmount(payment.getAmount());
        payment.setRefundedAt(LocalDateTime.now());
        paymentService.updateById(payment);
        
        return Result.success();
    }
}
