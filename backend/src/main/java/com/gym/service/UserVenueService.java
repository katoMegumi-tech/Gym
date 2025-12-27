package com.gym.service;

import com.baomidou.mybatisplus.extension.service.IService;
import com.gym.entity.UserVenue;

import java.util.List;

public interface UserVenueService extends IService<UserVenue> {
    /**
     * 获取用户管理的场馆ID列表
     */
    List<Long> getUserVenueIds(Long userId);
    
    /**
     * 检查用户是否有权限管理该场馆
     */
    boolean hasVenuePermission(Long userId, Long venueId);
}
