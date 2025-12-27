package com.gym.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.time.LocalDateTime;

@Data
@TableName("user_venue")
public class UserVenue {
    @TableId(type = IdType.AUTO)
    private Long id;
    private Long userId;
    private Long venueId;
    private LocalDateTime createdAt;
}
