package com.gym;

import org.mybatis.spring.annotation.MapperScan;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication
@MapperScan("com.gym.mapper")
public class GymReservationApplication {
    public static void main(String[] args) {
        SpringApplication.run(GymReservationApplication.class, args);
    }
}
