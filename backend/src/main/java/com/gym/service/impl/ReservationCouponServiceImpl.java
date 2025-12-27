package com.gym.service.impl;

import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.gym.entity.ReservationCoupon;
import com.gym.mapper.ReservationCouponMapper;
import com.gym.service.ReservationCouponService;
import org.springframework.stereotype.Service;

@Service
public class ReservationCouponServiceImpl extends ServiceImpl<ReservationCouponMapper, ReservationCoupon> implements ReservationCouponService {
}
