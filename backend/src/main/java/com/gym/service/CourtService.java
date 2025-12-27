package com.gym.service;

import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.gym.entity.Court;
import com.gym.mapper.CourtMapper;
import org.springframework.stereotype.Service;

@Service
public class CourtService extends ServiceImpl<CourtMapper, Court> {
}
