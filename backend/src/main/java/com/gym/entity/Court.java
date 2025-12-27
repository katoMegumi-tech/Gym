package com.gym.entity;

import com.baomidou.mybatisplus.annotation.*;
import lombok.Data;
import java.time.LocalDateTime;

@Data
@TableName("court")
public class Court {
    @TableId(type = IdType.AUTO)
    private Long id;
    private Long venueId;
    private String name;
    private String sportType;
    private String description;
    private Integer capacity;
    private String images;
    private String status;
    
    @TableField(fill = FieldFill.INSERT)
    private LocalDateTime createdAt;
    
    @TableField(fill = FieldFill.INSERT_UPDATE)
    private LocalDateTime updatedAt;
}
