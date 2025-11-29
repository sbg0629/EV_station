package com.boot.Reservation.dao;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.boot.Reservation.dto.ReservationDTO;

@Mapper
public interface ReservationDAO {

    int insertReservation(ReservationDTO dto);

    List<ReservationDTO> selectReservationsByMemberId(String memberId);

    List<ReservationDTO> selectReservationsByStationId(String stationRowId);

    int updateReservationStatusToCancelled(
            @Param("reservationId") long reservationId, 
            @Param("memberId") String memberId
    );

    int countConflictReservations(
            @Param("stationRowId") String stationRowId, 
            @Param("start") LocalDateTime start, 
            @Param("end") LocalDateTime end
    );
    
    int countConflictReservationsByType(
            @Param("stationRowId") String stationRowId,
            @Param("chargerType") String chargerType,
            @Param("start") LocalDateTime start, 
            @Param("end") LocalDateTime end
    );
    
    int getChargerCountByType(
            @Param("stationRowId") String stationRowId,
            @Param("chargerType") String chargerType
    );
    
    /**
     * 특정 충전소의 특정 시간대에 예약된 충전기 개수 조회
     */
    int countReservationsByHour(
            @Param("stationRowId") String stationRowId,
            @Param("targetDate") LocalDateTime targetDate,
            @Param("hour") int hour,
            @Param("chargerType") String chargerType
    );
    
    /**
     * 특정 충전소의 특정 날짜의 시간대별 예약 개수 조회 (0~23시)
     */
    List<Map<String, Object>> countReservationsByHourRange(
            @Param("stationRowId") String stationRowId,
            @Param("targetDate") LocalDateTime targetDate,
            @Param("chargerType") String chargerType
    );
}
