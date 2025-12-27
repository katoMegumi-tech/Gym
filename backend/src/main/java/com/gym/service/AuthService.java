package com.gym.service;

import cn.dev33.satoken.stp.StpUtil;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.gym.dto.LoginDTO;
import com.gym.dto.RegisterDTO;
import com.gym.entity.Role;
import com.gym.entity.User;
import com.gym.mapper.UserMapper;
import com.gym.util.Argon2Util;
import com.gym.vo.LoginVO;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@RequiredArgsConstructor
public class AuthService {
    
    private final UserMapper userMapper;
    private final RoleService roleService;
    
    public LoginVO login(LoginDTO dto, boolean isAdminLogin) {
        User user = userMapper.selectOne(new LambdaQueryWrapper<User>()
                .eq(User::getUsername, dto.getUsername()));
        
        if (user == null) {
            throw new RuntimeException("用户不存在");
        }
        
        if (!Argon2Util.verify(user.getPasswordHash(), dto.getPassword())) {
            throw new RuntimeException("密码错误");
        }
        
        if (!"ACTIVE".equals(user.getStatus())) {
            throw new RuntimeException("账号已被禁用");
        }
        
        // 获取角色信息
        Role role = roleService.getById(user.getRoleId());
        if (role == null) {
            throw new RuntimeException("用户角色不存在");
        }
        
        String roleCode = role.getRoleCode();
        
        // 如果是管理后台登录，检查角色权限
        if (isAdminLogin) {
            // 只允许超级管理员、系统管理员、场馆管理员登录后台
            if (!"SUPER_ADMIN".equals(roleCode) && 
                !"ADMIN".equals(roleCode) && 
                !"VENUE_MANAGER".equals(roleCode)) {
                throw new RuntimeException("无权限访问管理后台");
            }
        }
        
        StpUtil.login(user.getId());
        String token = StpUtil.getTokenValue();
        
        LoginVO vo = new LoginVO();
        vo.setToken(token);
        vo.setUserId(user.getId());
        vo.setUsername(user.getUsername());
        vo.setRealName(user.getRealName());
        vo.setRoleName(role.getRoleName());
        vo.setRoleCode(roleCode);
        
        return vo;
    }
    
    @Transactional
    public void register(RegisterDTO dto) {
        Long count = userMapper.selectCount(new LambdaQueryWrapper<User>()
                .eq(User::getUsername, dto.getUsername()));
        
        if (count > 0) {
            throw new RuntimeException("用户名已存在");
        }
        
        Role userRole = roleService.getOne(new LambdaQueryWrapper<Role>()
                .eq(Role::getRoleCode, "USER"));
        
        if (userRole == null) {
            throw new RuntimeException("系统配置错误");
        }
        
        User user = new User();
        user.setUsername(dto.getUsername());
        user.setPasswordHash(Argon2Util.hash(dto.getPassword()));
        user.setRoleId(userRole.getId());
        user.setPhone(dto.getPhone());
        user.setEmail(dto.getEmail());
        user.setRealName(dto.getRealName());
        user.setStatus("ACTIVE");
        
        userMapper.insert(user);
    }
}
