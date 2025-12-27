package com.gym.service;

import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.gym.entity.Reservation;
import com.gym.mapper.ReservationMapper;
import org.springframework.stereotype.Service;

@Service
public class ReservationService extends ServiceImpl<ReservationMapper, Reservation> {
}
