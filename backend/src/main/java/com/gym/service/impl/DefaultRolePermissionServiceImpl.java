package com.gym.service.impl;

import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.gym.entity.DefaultRolePermission;
import com.gym.mapper.DefaultRolePermissionMapper;
import com.gym.service.DefaultRolePermissionService;
import org.springframework.stereotype.Service;

@Service
public class DefaultRolePermissionServiceImpl extends ServiceImpl<DefaultRolePermissionMapper, DefaultRolePermission> implements DefaultRolePermissionService {
}
