package com.gym.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.gym.entity.Permission;
import com.gym.entity.RolePermission;
import com.gym.entity.User;
import com.gym.mapper.PermissionMapper;
import com.gym.mapper.RolePermissionMapper;
import com.gym.mapper.UserMapper;
import com.gym.service.PermissionService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class PermissionServiceImpl extends ServiceImpl<PermissionMapper, Permission> implements PermissionService {
    
    private final UserMapper userMapper;
    private final RolePermissionMapper rolePermissionMapper;
    private final PermissionMapper permissionMapper;
    
    @Override
    public List<Permission> getUserPermissions(Long userId) {
        User user = userMapper.selectById(userId);
        if (user == null) {
            return List.of();
        }
        return getRolePermissions(user.getRoleId());
    }
    
    @Override
    public List<Permission> getRolePermissions(Long roleId) {
        LambdaQueryWrapper<RolePermission> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(RolePermission::getRoleId, roleId);
        List<RolePermission> rolePermissions = rolePermissionMapper.selectList(wrapper);
        
        if (rolePermissions.isEmpty()) {
            return List.of();
        }
        
        List<Long> permissionIds = rolePermissions.stream()
                .map(RolePermission::getPermissionId)
                .collect(Collectors.toList());
        
        return permissionMapper.selectBatchIds(permissionIds);
    }
}
