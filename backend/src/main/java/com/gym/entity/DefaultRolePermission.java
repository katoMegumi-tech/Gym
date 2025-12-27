package com.gym.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.time.LocalDateTime;

@Data
@TableName("default_role_permission")
public class DefaultRolePermission {
    @TableId(type = IdType.AUTO)
    private Long id;
    private String roleCode;
    private Long permissionId;
    private Boolean isRequired;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
}
