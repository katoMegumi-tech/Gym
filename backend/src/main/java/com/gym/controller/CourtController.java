package com.gym.controller;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.gym.common.Result;
import com.gym.entity.Court;
import com.gym.service.CourtService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

@Tag(name = "场地管理")
@RestController
@RequestMapping("/courts")
@RequiredArgsConstructor
public class CourtController {
    
    private final CourtService courtService;
    
    @Operation(summary = "场地列表")
    @GetMapping
    public Result<Page<Court>> list(
            @RequestParam(defaultValue = "1") Integer page,
            @RequestParam(defaultValue = "10") Integer size,
            @RequestParam(required = false) Long venueId,
            @RequestParam(required = false) String sportType) {
        
        LambdaQueryWrapper<Court> wrapper = new LambdaQueryWrapper<>();
        if (venueId != null) {
            wrapper.eq(Court::getVenueId, venueId);
        }
        if (sportType != null && !sportType.isEmpty()) {
            wrapper.eq(Court::getSportType, sportType);
        }
        wrapper.orderByDesc(Court::getCreatedAt);
        
        return Result.success(courtService.page(new Page<>(page, size), wrapper));
    }
    
    @Operation(summary = "场地详情")
    @GetMapping("/{id}")
    public Result<Court> detail(@PathVariable Long id) {
        return Result.success(courtService.getById(id));
    }
    
    @Operation(summary = "创建场地")
    @PostMapping
    public Result<Void> create(@RequestBody Court court) {
        courtService.save(court);
        return Result.success();
    }
    
    @Operation(summary = "更新场地")
    @PutMapping("/{id}")
    public Result<Void> update(@PathVariable Long id, @RequestBody Court court) {
        court.setId(id);
        courtService.updateById(court);
        return Result.success();
    }
    
    @Operation(summary = "删除场地")
    @DeleteMapping("/{id}")
    public Result<Void> delete(@PathVariable Long id) {
        courtService.removeById(id);
        return Result.success();
    }
}
