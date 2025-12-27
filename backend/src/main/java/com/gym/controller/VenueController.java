package com.gym.controller;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.gym.common.Result;
import com.gym.entity.Venue;
import com.gym.service.VenueService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

@Tag(name = "场馆管理")
@RestController
@RequestMapping("/venues")
@RequiredArgsConstructor
public class VenueController {
    
    private final VenueService venueService;
    
    @Operation(summary = "场馆列表")
    @GetMapping
    public Result<Page<Venue>> list(
            @RequestParam(defaultValue = "1") Integer page,
            @RequestParam(defaultValue = "10") Integer size,
            @RequestParam(required = false) String keyword) {
        
        LambdaQueryWrapper<Venue> wrapper = new LambdaQueryWrapper<>();
        if (keyword != null && !keyword.isEmpty()) {
            wrapper.like(Venue::getName, keyword)
                   .or().like(Venue::getAddress, keyword);
        }
        wrapper.orderByDesc(Venue::getCreatedAt);
        
        return Result.success(venueService.page(new Page<>(page, size), wrapper));
    }
    
    @Operation(summary = "场馆详情")
    @GetMapping("/{id}")
    public Result<Venue> detail(@PathVariable Long id) {
        return Result.success(venueService.getById(id));
    }
    
    @Operation(summary = "创建场馆")
    @PostMapping
    public Result<Void> create(@RequestBody Venue venue) {
        venueService.save(venue);
        return Result.success();
    }
    
    @Operation(summary = "更新场馆")
    @PutMapping("/{id}")
    public Result<Void> update(@PathVariable Long id, @RequestBody Venue venue) {
        venue.setId(id);
        venueService.updateById(venue);
        return Result.success();
    }
    
    @Operation(summary = "删除场馆")
    @DeleteMapping("/{id}")
    public Result<Void> delete(@PathVariable Long id) {
        venueService.removeById(id);
        return Result.success();
    }
}
