package com.gym.service;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.gym.entity.Court;
import com.gym.entity.Timeslot;
import com.gym.entity.Venue;
import com.gym.mapper.CourtMapper;
import com.gym.mapper.TimeslotMapper;
import com.gym.mapper.VenueMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalTime;
import java.util.ArrayList;
import java.util.List;

@Service
@RequiredArgsConstructor
public class TimeslotService extends ServiceImpl<TimeslotMapper, Timeslot> {
    
    private final CourtMapper courtMapper;
    private final VenueMapper venueMapper;
    
    /**
     * 为指定场地生成指定日期的时间段
     */
    @Transactional
    public List<Timeslot> generateTimeslots(Long courtId, LocalDate date) {
        // 检查是否已存在
        LambdaQueryWrapper<Timeslot> existWrapper = new LambdaQueryWrapper<>();
        existWrapper.eq(Timeslot::getCourtId, courtId)
                    .eq(Timeslot::getSlotDate, date);
        if (this.count(existWrapper) > 0) {
            return this.list(existWrapper);
        }
        
        Court court = courtMapper.selectById(courtId);
        if (court == null) {
            throw new RuntimeException("场地不存在");
        }
        
        Venue venue = venueMapper.selectById(court.getVenueId());
        if (venue == null) {
            throw new RuntimeException("场馆不存在");
        }
        
        List<Timeslot> timeslots = new ArrayList<>();
        LocalTime openTime = venue.getOpenTime();
        LocalTime closeTime = venue.getCloseTime();
        
        // 每小时一个时间段
        LocalTime currentTime = openTime;
        while (currentTime.isBefore(closeTime)) {
            LocalTime endTime = currentTime.plusHours(1);
            if (endTime.isAfter(closeTime)) {
                break;
            }
            
            Timeslot slot = new Timeslot();
            slot.setCourtId(courtId);
            slot.setSlotDate(date);
            slot.setStartTime(currentTime);
            slot.setEndTime(endTime);
            slot.setStatus("AVAILABLE");
            slot.setQuota(court.getCapacity());
            slot.setBookedCount(0);
            
            // 根据运动类型和时间设置价格
            BigDecimal basePrice = getBasePrice(court.getSportType());
            boolean isPeak = isPeakTime(currentTime);
            slot.setIsPeak(isPeak);
            slot.setPrice(isPeak ? basePrice.multiply(new BigDecimal("1.5")) : basePrice);
            
            timeslots.add(slot);
            currentTime = endTime;
        }
        
        if (!timeslots.isEmpty()) {
            this.saveBatch(timeslots);
        }
        
        return timeslots;
    }
    
    /**
     * 为所有场地生成未来N天的时间段
     */
    @Transactional
    public void generateTimeslotsForAllCourts(int days) {
        List<Court> courts = courtMapper.selectList(null);
        LocalDate today = LocalDate.now();
        
        for (Court court : courts) {
            if (!"AVAILABLE".equals(court.getStatus())) {
                continue;
            }
            for (int i = 0; i < days; i++) {
                LocalDate date = today.plusDays(i);
                try {
                    generateTimeslots(court.getId(), date);
                } catch (Exception e) {
                    // 忽略已存在的时间段
                }
            }
        }
    }
    
    /**
     * 获取基础价格
     */
    private BigDecimal getBasePrice(String sportType) {
        return switch (sportType) {
            case "BASKETBALL" -> new BigDecimal("50");
            case "BADMINTON" -> new BigDecimal("30");
            case "TENNIS" -> new BigDecimal("80");
            case "FITNESS" -> new BigDecimal("25");
            case "YOGA" -> new BigDecimal("40");
            case "SWIMMING" -> new BigDecimal("35");
            default -> new BigDecimal("30");
        };
    }
    
    /**
     * 判断是否高峰时段（18:00-21:00 和周末）
     */
    private boolean isPeakTime(LocalTime time) {
        int hour = time.getHour();
        return hour >= 18 && hour < 21;
    }
}
