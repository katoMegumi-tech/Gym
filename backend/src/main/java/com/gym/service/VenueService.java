package com.gym.service;

import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.gym.entity.Venue;
import com.gym.mapper.VenueMapper;
import org.springframework.stereotype.Service;

@Service
public class VenueService extends ServiceImpl<VenueMapper, Venue> {
}
