package com.gym.controller;

import cn.dev33.satoken.stp.StpUtil;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.gym.common.Result;
import com.gym.entity.Favorite;
import com.gym.mapper.FavoriteMapper;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@Tag(name = "收藏管理")
@RestController
@RequestMapping("/favorites")
@RequiredArgsConstructor
public class FavoriteController {
    
    private final FavoriteMapper favoriteMapper;
    
    @Operation(summary = "我的收藏列表")
    @GetMapping("/my")
    public Result<List<Favorite>> myFavorites(@RequestParam(required = false) String targetType) {
        Long userId = StpUtil.getLoginIdAsLong();
        
        LambdaQueryWrapper<Favorite> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(Favorite::getUserId, userId);
        if (targetType != null && !targetType.isEmpty()) {
            wrapper.eq(Favorite::getTargetType, targetType);
        }
        wrapper.orderByDesc(Favorite::getCreatedAt);
        
        return Result.success(favoriteMapper.selectList(wrapper));
    }
    
    @Operation(summary = "添加收藏")
    @PostMapping
    public Result<Void> add(@RequestBody Map<String, Object> params) {
        Long userId = StpUtil.getLoginIdAsLong();
        String targetType = (String) params.get("targetType");
        Long targetId = Long.valueOf(params.get("targetId").toString());
        
        // 检查是否已收藏
        LambdaQueryWrapper<Favorite> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(Favorite::getUserId, userId)
               .eq(Favorite::getTargetType, targetType)
               .eq(Favorite::getTargetId, targetId);
        
        if (favoriteMapper.selectCount(wrapper) > 0) {
            return Result.error("已收藏");
        }
        
        Favorite favorite = new Favorite();
        favorite.setUserId(userId);
        favorite.setTargetType(targetType);
        favorite.setTargetId(targetId);
        favoriteMapper.insert(favorite);
        
        return Result.success();
    }
    
    @Operation(summary = "取消收藏")
    @DeleteMapping
    public Result<Void> remove(@RequestBody Map<String, Object> params) {
        Long userId = StpUtil.getLoginIdAsLong();
        String targetType = (String) params.get("targetType");
        Long targetId = Long.valueOf(params.get("targetId").toString());
        
        LambdaQueryWrapper<Favorite> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(Favorite::getUserId, userId)
               .eq(Favorite::getTargetType, targetType)
               .eq(Favorite::getTargetId, targetId);
        
        favoriteMapper.delete(wrapper);
        return Result.success();
    }
    
    @Operation(summary = "检查是否已收藏")
    @GetMapping("/check")
    public Result<Boolean> check(@RequestParam String targetType, @RequestParam Long targetId) {
        Long userId = StpUtil.getLoginIdAsLong();
        
        LambdaQueryWrapper<Favorite> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(Favorite::getUserId, userId)
               .eq(Favorite::getTargetType, targetType)
               .eq(Favorite::getTargetId, targetId);
        
        return Result.success(favoriteMapper.selectCount(wrapper) > 0);
    }
}
