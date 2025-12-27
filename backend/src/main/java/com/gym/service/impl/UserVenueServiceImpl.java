package com.gym.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.gym.entity.UserVenue;
import com.gym.mapper.UserVenueMapper;
import com.gym.service.UserVenueService;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.stream.Collectors;

@Service
public class UserVenueServiceImpl extends ServiceImpl<UserVenueMapper, UserVenue> implements UserVenueService {
    
    @Override
    public List<Long> getUserVenueIds(Long userId) {
        LambdaQueryWrapper<UserVenue> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(UserVenue::getUserId, userId);
        return list(wrapper).stream()
                .map(UserVenue::getVenueId)
                .collect(Collectors.toList());
    }
    
    @Override
    public boolean hasVenuePermission(Long userId, Long venueId) {
        LambdaQueryWrapper<UserVenue> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(UserVenue::getUserId, userId)
               .eq(UserVenue::getVenueId, venueId);
        return count(wrapper) > 0;
    }
}
