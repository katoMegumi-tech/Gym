package com.gym.vo;

import com.gym.entity.Reservation;
import lombok.Data;
import lombok.EqualsAndHashCode;

@Data
@EqualsAndHashCode(callSuper = true)
public class ReservationVO extends Reservation {
    // 用户信息
    private String userName;
    private String userPhone;
    
    // 场地信息
    private String courtName;
    private String sportType;
    
    // 场馆信息
    private Long venueId;
    private String venueName;
}
