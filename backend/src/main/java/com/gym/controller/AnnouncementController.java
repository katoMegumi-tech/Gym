package com.gym.controller;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.gym.common.Result;
import com.gym.entity.Announcement;
import com.gym.mapper.AnnouncementMapper;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDateTime;

@Tag(name = "公告管理")
@RestController
@RequestMapping("/announcements")
@RequiredArgsConstructor
public class AnnouncementController {
    
    private final AnnouncementMapper announcementMapper;
    
    @Operation(summary = "公告列表")
    @GetMapping
    public Result<Page<Announcement>> list(
            @RequestParam(defaultValue = "1") Integer page,
            @RequestParam(defaultValue = "10") Integer size,
            @RequestParam(required = false) String type) {
        
        LambdaQueryWrapper<Announcement> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(Announcement::getStatus, "PUBLISHED");
        
        if (type != null && !type.isEmpty()) {
            wrapper.eq(Announcement::getType, type);
        }
        
        // 只显示未过期的公告
        wrapper.and(w -> w.isNull(Announcement::getExpireTime)
                         .or()
                         .gt(Announcement::getExpireTime, LocalDateTime.now()));
        
        wrapper.orderByDesc(Announcement::getPublishTime);
        
        return Result.success(announcementMapper.selectPage(new Page<>(page, size), wrapper));
    }
    
    @Operation(summary = "公告详情")
    @GetMapping("/{id}")
    public Result<Announcement> detail(@PathVariable Long id) {
        return Result.success(announcementMapper.selectById(id));
    }
    
    @Operation(summary = "创建公告")
    @PostMapping
    public Result<Void> create(@RequestBody Announcement announcement) {
        announcementMapper.insert(announcement);
        return Result.success();
    }
    
    @Operation(summary = "更新公告")
    @PutMapping("/{id}")
    public Result<Void> update(@PathVariable Long id, @RequestBody Announcement announcement) {
        announcement.setId(id);
        announcementMapper.updateById(announcement);
        return Result.success();
    }
    
    @Operation(summary = "删除公告")
    @DeleteMapping("/{id}")
    public Result<Void> delete(@PathVariable Long id) {
        announcementMapper.deleteById(id);
        return Result.success();
    }
}
