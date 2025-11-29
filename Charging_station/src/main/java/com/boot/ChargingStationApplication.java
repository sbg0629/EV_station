package com.boot;

import org.mybatis.spring.annotation.MapperScan;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.cache.annotation.EnableCaching;

@SpringBootApplication
@EnableCaching
@MapperScan(basePackages = {
    "com.boot.login.dao",
    "com.boot.Main_Page.dao",
    "com.boot.MY_Page.dao",
    "com.boot.Notice.dao",
    "com.boot.Board.dao",
    "com.boot.Favorite.dao", // 🌟 새로 추가된 즐겨찾기 DAO 패키지를 명시적으로 추가
    "com.boot.Reservation.dao"
})
public class ChargingStationApplication {

	public static void main(String[] args) {
		SpringApplication.run(ChargingStationApplication.class, args);
	}

}
