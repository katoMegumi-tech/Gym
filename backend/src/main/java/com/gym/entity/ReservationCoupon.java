package com.gym.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.math.BigDecimal;
import java.time.LocalDateTime;

@Data
@TableName("reservation_coupon")
public class ReservationCoupon {
    @TableId(type = IdType.AUTO)
    private Long id;
    private Long reservationId;
    private Long userCouponId;
    private BigDecimal discountAmount;
    private LocalDateTime createdAt;
}
