package com.boot.Reservation.service;

import java.time.LocalDateTime;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.boot.Reservation.dao.ReservationDAO;
import com.boot.Reservation.dto.ReservationDTO;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class ReservationServiceImpl implements ReservationService {

    @Autowired
    private ReservationDAO reservationDao;

    @Override
    public int createReservation(ReservationDTO dto) {
        log.info("예약 생성 요청 DTO: {}", dto);

        LocalDateTime start = dto.getReservationStart();
        LocalDateTime end = dto.getReservationEnd();

        LocalDateTime earliestStartTime = LocalDateTime.now().plusMinutes(5);
        if (start.isBefore(earliestStartTime)) {
            throw new RuntimeException("예약 시작 시간은 최소 5분 이후여야 합니다.");
        }

        // 충전기 타입이 있으면 타입별로 체크, 없으면 전체 체크
        boolean available;
        if (dto.getChargerType() != null && !dto.getChargerType().isEmpty()) {
            // 충전기 대수 확인
            int chargerCount = reservationDao.getChargerCountByType(dto.getStationRowId(), dto.getChargerType());
            
            if (chargerCount <= 0) {
                String chargerTypeName = dto.getChargerType().equals("급속") || dto.getChargerType().equals("FAST") || dto.getChargerType().equals("fast") ? "급속" : "완속";
                throw new RuntimeException(chargerTypeName + " 충전기가 없습니다.");
            }
            
            // 같은 타입의 충돌 예약 개수 확인
            int conflictCount = reservationDao.countConflictReservationsByType(dto.getStationRowId(), dto.getChargerType(), start, end);
            
            // 충전기 대수보다 충돌 예약이 적으면 예약 가능
            available = conflictCount < chargerCount;
        } else {
            available = isReservationTimeAvailable(dto.getStationRowId(), start, end);
        }
        
        if (!available) {
            throw new RuntimeException("해당 시간에는 예약 가능한 충전기가 없습니다. (모든 충전기가 예약됨)");
        }

        int result = reservationDao.insertReservation(dto);

        if (result == 0) {
            throw new RuntimeException("DB 등록 실패");
        }

        return result;
    }

    @Override
    public List<ReservationDTO> getReservationsByMemberId(String memberId) {
        return reservationDao.selectReservationsByMemberId(memberId);
    }

    @Override
    public List<ReservationDTO> getReservationsByStationId(String stationRowId) {
        return reservationDao.selectReservationsByStationId(stationRowId);
    }

    @Override
    public int cancelReservation(long reservationId, String memberId) {
        int result = reservationDao.updateReservationStatusToCancelled(reservationId, memberId);

        if (result == 0) {
            throw new RuntimeException("예약 취소 실패 또는 권한 없음");
        }

        return result;
    }

    @Override
    public boolean isReservationTimeAvailable(String stationRowId, LocalDateTime start, LocalDateTime end) {
        int conflictCount = reservationDao.countConflictReservations(stationRowId, start, end);
        return conflictCount == 0;
    }
    
    @Override
    public boolean isReservationTimeAvailableByType(String stationRowId, String chargerType, LocalDateTime start, LocalDateTime end) {
        int conflictCount = reservationDao.countConflictReservationsByType(stationRowId, chargerType, start, end);
        return conflictCount == 0;
    }
}
