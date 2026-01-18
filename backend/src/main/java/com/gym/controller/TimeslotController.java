package com.gym.controller;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.gym.common.Result;
import com.gym.entity.Timeslot;
import com.gym.service.TimeslotService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDate;
import java.util.List;

@Tag(name = "时间段管理")
@RestController
@RequestMapping("/timeslots")
@RequiredArgsConstructor
public class TimeslotController {
    
    private final TimeslotService timeslotService;
    
    @Operation(summary = "查询场地可用时间段")
    @GetMapping
    public Result<List<Timeslot>> list(
            @RequestParam Long courtId,
            @RequestParam String date) {
        
        LocalDate slotDate = LocalDate.parse(date);
        
        // 先尝试生成时间段（如果不存在）
        List<Timeslot> timeslots = timeslotService.generateTimeslots(courtId, slotDate);
        
        // 按开始时间排序返回
        LambdaQueryWrapper<Timeslot> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(Timeslot::getCourtId, courtId)
               .eq(Timeslot::getSlotDate, slotDate)
               .orderByAsc(Timeslot::getStartTime);
        
        return Result.success(timeslotService.list(wrapper));
    }
    
    @Operation(summary = "批量生成时间段")
    @PostMapping("/generate")
    public Result<Void> generate(
            @RequestParam(defaultValue = "7") Integer days) {
        
        timeslotService.generateTimeslotsForAllCourts(days);
        return Result.success();
    }
    
    @Operation(summary = "更新时间段状态")
    @PutMapping("/{id}")
    public Result<Void> update(@PathVariable Long id, @RequestBody Timeslot timeslot) {
        timeslot.setId(id);
        timeslotService.updateById(timeslot);
        return Result.success();
    }
}
