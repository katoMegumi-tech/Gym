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
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDateTime;
import java.util.Map;

@Slf4j
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
    
    @Operation(summary = "支付成功回调（模拟微信支付回调）")
    @PostMapping("/callback")
    public String paymentCallback(@RequestBody Map<String, String> callbackData) {
        try {
            // 1. 验证回调签名（模拟）
            if (!verifySignature(callbackData)) {
                log.error("支付回调签名验证失败");
                return "FAIL";
            }
            
            // 2. 获取支付单号
            String paymentNo = callbackData.get("paymentNo");
            String transactionNo = callbackData.get("transactionNo");
            String status = callbackData.get("status");
            
            if (paymentNo == null || transactionNo == null) {
                log.error("支付回调参数缺失");
                return "FAIL";
            }
            
            // 3. 查询支付记录
            LambdaQueryWrapper<Payment> wrapper = new LambdaQueryWrapper<>();
            wrapper.eq(Payment::getPaymentNo, paymentNo);
            Payment payment = paymentService.getOne(wrapper);
            
            if (payment == null) {
                log.error("支付记录不存在: paymentNo={}", paymentNo);
                return "FAIL";
            }
            
            // 4. 防止重复处理
            if ("SUCCESS".equals(payment.getPaymentStatus())) {
                log.info("支付已处理，跳过: paymentNo={}", paymentNo);
                return "SUCCESS";
            }
            
            // 5. 更新支付状态
            if ("SUCCESS".equals(status)) {
                payment.setPaymentStatus("SUCCESS");
                payment.setTransactionNo(transactionNo);
                payment.setPaidAt(LocalDateTime.now());
                paymentService.updateById(payment);
                
                log.info("支付回调处理成功: paymentNo={}, transactionNo={}", paymentNo, transactionNo);
            } else {
                payment.setPaymentStatus("FAILED");
                paymentService.updateById(payment);
                
                log.warn("支付失败: paymentNo={}, status={}", paymentNo, status);
            }
            
            return "SUCCESS";
            
        } catch (Exception e) {
            log.error("支付回调处理异常", e);
            return "FAIL";
        }
    }
    
    /**
     * 验证支付回调签名（模拟）
     * 实际项目中需要使用微信支付的签名验证算法
     */
    private boolean verifySignature(Map<String, String> data) {
        // 模拟签名验证
        // 实际项目中应该：
        // 1. 获取微信支付的签名
        // 2. 使用API密钥重新计算签名
        // 3. 比较两个签名是否一致
        
        String sign = data.get("sign");
        if (sign == null || sign.isEmpty()) {
            return false;
        }
        
        // 模拟验证通过
        log.info("模拟签名验证通过: sign={}", sign);
        return true;
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
