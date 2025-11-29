package com.boot.Reservation.service;

import java.time.LocalDateTime;
import java.util.List;
import com.boot.Reservation.dto.ReservationDTO;

public interface ReservationService {
    
    int createReservation(ReservationDTO dto);
    
    List<ReservationDTO> getReservationsByMemberId(String memberId);
    List<ReservationDTO> getReservationsByStationId(String stationRowId);

    int cancelReservation(long reservationId, String memberId);

    boolean isReservationTimeAvailable(String stationRowId, LocalDateTime start, LocalDateTime end);
    
    boolean isReservationTimeAvailableByType(String stationRowId, String chargerType, LocalDateTime start, LocalDateTime end);

}
