package com.gym.controller;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.gym.common.Result;
import com.gym.entity.Permission;
import com.gym.entity.RolePermission;
import com.gym.service.PermissionService;
import com.gym.service.RolePermissionService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@Tag(name = "权限管理")
@RestController
@RequestMapping("/permissions")
@RequiredArgsConstructor
public class PermissionController {
    
    private final PermissionService permissionService;
    private final RolePermissionService rolePermissionService;
    
    @Operation(summary = "权限列表")
    @GetMapping
    public Result<List<Permission>> list(@RequestParam(required = false) String permType) {
        LambdaQueryWrapper<Permission> wrapper = new LambdaQueryWrapper<>();
        if (permType != null && !permType.isEmpty()) {
            wrapper.eq(Permission::getPermType, permType);
        }
        wrapper.orderByAsc(Permission::getSortOrder);
        return Result.success(permissionService.list(wrapper));
    }
    
    @Operation(summary = "创建权限")
    @PostMapping
    public Result<Void> create(@RequestBody Permission permission) {
        permissionService.save(permission);
        return Result.success();
    }
    
    @Operation(summary = "更新权限")
    @PutMapping("/{id}")
    public Result<Void> update(@PathVariable Long id, @RequestBody Permission permission) {
        permission.setId(id);
        permissionService.updateById(permission);
        return Result.success();
    }
    
    @Operation(summary = "删除权限")
    @DeleteMapping("/{id}")
    public Result<Void> delete(@PathVariable Long id) {
        permissionService.removeById(id);
        return Result.success();
    }
    
    @Operation(summary = "获取角色权限")
    @GetMapping("/role/{roleId}")
    public Result<List<RolePermission>> getRolePermissions(@PathVariable Long roleId) {
        LambdaQueryWrapper<RolePermission> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(RolePermission::getRoleId, roleId);
        return Result.success(rolePermissionService.list(wrapper));
    }
    
    @Operation(summary = "分配角色权限")
    @PostMapping("/role/{roleId}")
    public Result<Void> assignPermissions(
            @PathVariable Long roleId,
            @RequestBody List<Long> permissionIds) {
        
        // 删除旧权限
        LambdaQueryWrapper<RolePermission> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(RolePermission::getRoleId, roleId);
        rolePermissionService.remove(wrapper);
        
        // 添加新权限
        for (Long permissionId : permissionIds) {
            RolePermission rp = new RolePermission();
            rp.setRoleId(roleId);
            rp.setPermissionId(permissionId);
            rolePermissionService.save(rp);
        }
        
        return Result.success();
    }
}
