package com.gym.service;

import com.baomidou.mybatisplus.extension.service.IService;
import com.gym.entity.Permission;

import java.util.List;

public interface PermissionService extends IService<Permission> {
    /**
     * 获取用户权限列表
     */
    List<Permission> getUserPermissions(Long userId);
    
    /**
     * 获取角色权限列表
     */
    List<Permission> getRolePermissions(Long roleId);
}
