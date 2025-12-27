package com.gym.controller;

import cn.dev33.satoken.stp.StpUtil;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.gym.common.Result;
import com.gym.entity.Feedback;
import com.gym.mapper.FeedbackMapper;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDateTime;

@Tag(name = "反馈管理")
@RestController
@RequestMapping("/feedback")
@RequiredArgsConstructor
public class FeedbackController {
    
    private final FeedbackMapper feedbackMapper;
    
    @Operation(summary = "我的反馈列表")
    @GetMapping("/my")
    public Result<Page<Feedback>> myFeedback(
            @RequestParam(defaultValue = "1") Integer page,
            @RequestParam(defaultValue = "10") Integer size) {
        
        Long userId = StpUtil.getLoginIdAsLong();
        
        LambdaQueryWrapper<Feedback> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(Feedback::getUserId, userId)
               .orderByDesc(Feedback::getCreatedAt);
        
        return Result.success(feedbackMapper.selectPage(new Page<>(page, size), wrapper));
    }
    
    @Operation(summary = "反馈列表（管理员）")
    @GetMapping
    public Result<Page<Feedback>> list(
            @RequestParam(defaultValue = "1") Integer page,
            @RequestParam(defaultValue = "10") Integer size,
            @RequestParam(required = false) String status) {
        
        LambdaQueryWrapper<Feedback> wrapper = new LambdaQueryWrapper<>();
        if (status != null && !status.isEmpty()) {
            wrapper.eq(Feedback::getStatus, status);
        }
        wrapper.orderByDesc(Feedback::getCreatedAt);
        
        return Result.success(feedbackMapper.selectPage(new Page<>(page, size), wrapper));
    }
    
    @Operation(summary = "提交反馈")
    @PostMapping
    public Result<Void> submit(@RequestBody Feedback feedback) {
        Long userId = StpUtil.getLoginIdAsLong();
        feedback.setUserId(userId);
        feedback.setStatus("PENDING");
        feedbackMapper.insert(feedback);
        return Result.success();
    }
    
    @Operation(summary = "回复反馈")
    @PutMapping("/{id}/reply")
    public Result<Void> reply(@PathVariable Long id, @RequestParam String reply) {
        Feedback feedback = feedbackMapper.selectById(id);
        if (feedback == null) {
            return Result.error("反馈不存在");
        }
        
        feedback.setReply(reply);
        feedback.setRepliedAt(LocalDateTime.now());
        feedback.setStatus("RESOLVED");
        feedbackMapper.updateById(feedback);
        
        return Result.success();
    }
}
