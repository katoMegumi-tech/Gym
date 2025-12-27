package com.gym.controller;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.gym.common.Result;
import com.gym.entity.UserVenue;
import com.gym.service.UserVenueService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@Tag(name = "用户场馆管理")
@RestController
@RequestMapping("/user-venues")
@RequiredArgsConstructor
public class UserVenueController {
    
    private final UserVenueService userVenueService;
    
    @Operation(summary = "获取用户管理的场馆")
    @GetMapping("/user/{userId}")
    public Result<List<UserVenue>> getUserVenues(@PathVariable Long userId) {
        LambdaQueryWrapper<UserVenue> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(UserVenue::getUserId, userId);
        return Result.success(userVenueService.list(wrapper));
    }
    
    @Operation(summary = "分配场馆给用户")
    @PostMapping
    public Result<Void> assign(@RequestParam Long userId, @RequestParam Long venueId) {
        // 检查是否已存在
        LambdaQueryWrapper<UserVenue> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(UserVenue::getUserId, userId)
               .eq(UserVenue::getVenueId, venueId);
        if (userVenueService.count(wrapper) > 0) {
            return Result.error("已分配该场馆");
        }
        
        UserVenue userVenue = new UserVenue();
        userVenue.setUserId(userId);
        userVenue.setVenueId(venueId);
        userVenueService.save(userVenue);
        return Result.success();
    }
    
    @Operation(summary = "取消场馆分配")
    @DeleteMapping
    public Result<Void> remove(@RequestParam Long userId, @RequestParam Long venueId) {
        LambdaQueryWrapper<UserVenue> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(UserVenue::getUserId, userId)
               .eq(UserVenue::getVenueId, venueId);
        userVenueService.remove(wrapper);
        return Result.success();
    }
}
