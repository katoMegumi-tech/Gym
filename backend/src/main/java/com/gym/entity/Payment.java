package com.gym.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.math.BigDecimal;
import java.time.LocalDateTime;

@Data
@TableName("payment")
public class Payment {
    @TableId(type = IdType.AUTO)
    private Long id;
    private Long reservationId;
    private String paymentNo;
    private BigDecimal amount;
    private String paymentMethod; // WECHAT, ALIPAY, CASH, BALANCE
    private String paymentStatus; // PENDING, SUCCESS, FAILED, REFUNDED
    private String transactionNo;
    private LocalDateTime paidAt;
    private BigDecimal refundAmount;
    private LocalDateTime refundedAt;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
}
