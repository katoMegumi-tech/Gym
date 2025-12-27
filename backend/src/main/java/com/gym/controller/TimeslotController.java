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
        
        LambdaQueryWrapper<Timeslot> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(Timeslot::getCourtId, courtId)
               .eq(Timeslot::getSlotDate, slotDate)
               .orderByAsc(Timeslot::getStartTime);
        
        return Result.success(timeslotService.list(wrapper));
    }
}
