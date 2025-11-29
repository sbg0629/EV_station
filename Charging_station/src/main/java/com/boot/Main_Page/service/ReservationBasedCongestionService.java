package com.boot.Main_Page.service;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.boot.Main_Page.dao.ElecDAO;
import com.boot.Main_Page.dto.ChargerInfoDTO;
import com.boot.Reservation.dao.ReservationDAO;

import lombok.extern.slf4j.Slf4j;

/**
 * 예약 데이터 기반 혼잡도 예측 서비스
 * 현재 가능한 기능을 활용하여 실용적인 혼잡도 예측 제공
 */
@Slf4j
@Service
public class ReservationBasedCongestionService {
    
    @Autowired
    private ReservationDAO reservationDAO;
    
    @Autowired
    private ElecDAO elecDAO;
    
    /**
     * 특정 충전소의 현재 혼잡도 예측 (예약 데이터 + 현재 상태)
     * 
     * @param stationId 충전소 ID
     * @param chargerType 충전기 타입 (선택사항)
     * @return 혼잡도 점수 (0~100)
     */
    public double predictCurrentCongestion(String stationId, String chargerType) {
        log.info(">>> [현재 혼잡도] 시작 - stationId: {}, chargerType: {}", stationId, chargerType);
        try {
            // 1. 현재 시간대
            int currentHour = LocalTime.now().getHour();
            LocalDate today = LocalDate.now();
            LocalDateTime now = LocalDateTime.now();
            log.info(">>> [현재 혼잡도] 현재 시간: {}시", currentHour);
            
            // 2. 현재 시간대에 예약된 충전기 개수 조회
            log.info(">>> [현재 혼잡도] 예약 개수 조회 중...");
            int reservedCount = reservationDAO.countReservationsByHour(
                stationId, 
                now, 
                currentHour,
                chargerType != null ? convertChargerType(chargerType) : null
            );
            log.info(">>> [현재 혼잡도] 예약된 충전기 개수: {}", reservedCount);
            
            // 3. 현재 사용 중인 충전기 개수 조회
            log.info(">>> [현재 혼잡도] 충전기 목록 조회 중...");
            List<ChargerInfoDTO> chargers = elecDAO.getChargerList(stationId);
            log.info(">>> [현재 혼잡도] 충전기 목록 조회 완료 - {}개", chargers != null ? chargers.size() : 0);
            int totalChargers = 0;
            int chargingCount = 0;
            
            for (ChargerInfoDTO charger : chargers) {
                // 충전기 타입 필터링 (선택된 경우)
                if (chargerType != null && !isMatchingType(charger.getChargerType(), chargerType)) {
                    continue;
                }
                
                totalChargers++;
                if (charger.getStat() == 3) { // 충전 중
                    chargingCount++;
                }
            }
            
            log.info(">>> [현재 혼잡도] 충전기 상태 - 전체: {}, 사용중: {}", totalChargers, chargingCount);
            
            if (totalChargers == 0) {
                log.warn(">>> [현재 혼잡도] 충전기가 없는 충전소: {}", stationId);
                return 50.0; // 기본값
            }
            
            // 4. 혼잡도 계산
            // 현재 사용 중인 비율
            double currentUsageRatio = (double) chargingCount / totalChargers;
            
            // 예약 비율 (예약된 개수 / 전체 충전기 수)
            // 예약이 전체 충전기 수보다 많을 수 있으므로 최대 1.0으로 제한
            double reservationRatio = Math.min((double) reservedCount / totalChargers, 1.0);
            
            // 혼잡도 계산: 현재 사용 중인 충전기와 예약된 충전기의 합
            // 단, 같은 충전기가 사용 중이면서 예약되어 있을 수 있으므로 최대 100%로 제한
            // 예: 충전기 5개 중 3개 사용 중 + 4개 예약 = 최대 5개까지만 가능
            double totalUsedRatio = currentUsageRatio + reservationRatio;
            
            // 예약이 전체 충전기를 초과하는 경우, 남은 충전기 기준으로 재계산
            // 예: 충전기 5개, 사용 중 3개, 예약 4개 → 실제 가능한 예약은 2개만
            double availableForReservation = Math.max(0, 1.0 - currentUsageRatio);
            double adjustedReservationRatio = Math.min(reservationRatio, availableForReservation);
            
            // 최종 혼잡도: 사용 중 비율 + 조정된 예약 비율
            double finalRatio = currentUsageRatio + adjustedReservationRatio;
            double congestionScore = Math.min(finalRatio * 100, 100.0);
            
            // 최소값 보장 (0 이상)
            if (congestionScore < 0) congestionScore = 0;
            
            log.info(">>> [현재 혼잡도] 계산 완료 - 충전기: {}개, 현재사용: {}개 ({}%), 예약: {}개 ({}%, 조정: {}%), 최종 점수: {}%", 
                    totalChargers, chargingCount, Math.round(currentUsageRatio * 100), 
                    reservedCount, Math.round(reservationRatio * 100), 
                    Math.round(adjustedReservationRatio * 100),
                    Math.round(congestionScore * 10.0) / 10.0);
            
            // 데이터 부족 경고
            if (reservedCount == 0 && chargingCount == 0) {
                log.info(">>> [현재 혼잡도] 예약 데이터와 사용 중인 충전기 없음 - 기본 혼잡도 0%");
            } else if (reservedCount == 0) {
                log.info(">>> [현재 혼잡도] 예약 데이터 없음 - 현재 충전기 상태만 반영");
            }
            
            return Math.round(congestionScore * 10.0) / 10.0;
            
        } catch (Exception e) {
            log.error(">>> [현재 혼잡도] 오류 발생 - 충전소: {}", stationId, e);
            return 50.0; // 기본값
        }
    }
    
    /**
     * 특정 충전소의 시간대별 혼잡도 예측 (오늘 날짜 기준)
     * 
     * @param stationId 충전소 ID
     * @param chargerType 충전기 타입 (선택사항)
     * @return 시간대별 혼잡도 맵 (hour -> congestion score)
     */
    public Map<Integer, Double> predictHourlyCongestion(String stationId, String chargerType) {
        log.info(">>> [시간대별 혼잡도] 시작 - stationId: {}, chargerType: {}", stationId, chargerType);
        Map<Integer, Double> hourlyCongestion = new HashMap<>();
        
        try {
            LocalDate today = LocalDate.now();
            LocalDateTime targetDate = today.atStartOfDay();
            log.info(">>> [시간대별 혼잡도] 대상 날짜: {}", targetDate);
            
            // 시간대별 예약 개수 조회
            log.info(">>> [시간대별 혼잡도] 예약 데이터 조회 중... stationId: {}, targetDate: {}, chargerType: {}", 
                    stationId, targetDate, chargerType);
            List<Map<String, Object>> reservationCounts = reservationDAO.countReservationsByHourRange(
                stationId,
                targetDate,
                chargerType != null ? convertChargerType(chargerType) : null
            );
            log.info(">>> [시간대별 혼잡도] 예약 데이터 조회 완료 - {}개 시간대 데이터", reservationCounts != null ? reservationCounts.size() : 0);
            if (reservationCounts != null && !reservationCounts.isEmpty()) {
                log.info(">>> [시간대별 혼잡도] 예약 데이터 샘플 (처음 5개): {}", 
                        reservationCounts.stream().limit(5).collect(java.util.stream.Collectors.toList()));
            }
            
            // 현재 충전기 상태 조회
            log.info(">>> [시간대별 혼잡도] 충전기 상태 조회 중...");
            List<ChargerInfoDTO> chargers = elecDAO.getChargerList(stationId);
            log.info(">>> [시간대별 혼잡도] 충전기 상태 조회 완료 - {}개", chargers != null ? chargers.size() : 0);
            int totalChargers = 0;
            int currentChargingCount = 0;
            
            for (ChargerInfoDTO charger : chargers) {
                if (chargerType != null && !isMatchingType(charger.getChargerType(), chargerType)) {
                    continue;
                }
                totalChargers++;
                if (charger.getStat() == 3) {
                    currentChargingCount++;
                }
            }
            
            log.info(">>> [시간대별 혼잡도] 충전기 상태 - 전체: {}, 사용중: {}", totalChargers, currentChargingCount);
            
            if (totalChargers == 0) {
                log.warn(">>> [시간대별 혼잡도] 충전기가 없는 충전소: {}", stationId);
                // 기본값으로 채우기
                for (int hour = 0; hour < 24; hour++) {
                    hourlyCongestion.put(hour, 50.0);
                }
                return hourlyCongestion;
            }
            
            // 현재 사용 중인 비율
            double currentUsageRatio = (double) currentChargingCount / totalChargers;
            
            // 시간대별 혼잡도 계산
            int currentHour = LocalTime.now().getHour();
            log.info(">>> [시간대별 혼잡도] 시간대별 계산 시작 - 현재 시간: {}시", currentHour);
            
            for (int hour = 0; hour < 24; hour++) {
                // 해당 시간대의 예약 개수 찾기
                int reservedCount = 0;
                for (Map<String, Object> row : reservationCounts) {
                    Integer rowHour = ((Number) row.get("hour")).intValue();
                    if (rowHour != null && rowHour == hour) {
                        reservedCount = ((Number) row.get("reservation_count")).intValue();
                        break;
                    }
                }
                
                // 예약 비율 (최대 1.0으로 제한)
                double reservationRatio = Math.min((double) reservedCount / totalChargers, 1.0);
                
                // 시간대별 혼잡도 계산
                double score;
                
                if (hour < currentHour) {
                    // 과거 시간대: 예약 비율만 사용 (이미 지난 시간이므로)
                    score = reservationRatio * 100;
                } else if (hour == currentHour) {
                    // 현재 시간대: 현재 사용 중 + 예약된 충전기 합산
                    // 예약이 남은 충전기 수를 초과하지 않도록 조정
                    double availableForReservation = Math.max(0, 1.0 - currentUsageRatio);
                    double adjustedReservationRatio = Math.min(reservationRatio, availableForReservation);
                    double finalRatio = currentUsageRatio + adjustedReservationRatio;
                    score = Math.min(finalRatio * 100, 100.0);
                } else {
                    // 미래 시간대: 예약 비율 위주로 예측
                    // 현재 상태도 일부 반영 (현재 사용 중인 충전기가 아직 끝나지 않았을 가능성)
                    double futureRatio = reservationRatio;
                    if (currentUsageRatio > 0) {
                        // 현재 사용 중인 충전기가 일부는 계속 사용될 가능성 고려
                        futureRatio += currentUsageRatio * 0.3;
                    }
                    score = Math.min(futureRatio * 100, 100.0);
                }
                
                // 범위 보정
                if (score < 0) score = 0;
                if (score > 100) score = 100;
                
                hourlyCongestion.put(hour, Math.round(score * 10.0) / 10.0);
            }
            
            // 전체 예약 개수 확인
            int totalReservations = 0;
            for (Map<String, Object> row : reservationCounts) {
                Integer count = ((Number) row.get("reservation_count")).intValue();
                totalReservations += count != null ? count : 0;
            }
            
            log.info(">>> [시간대별 혼잡도] 계산 완료 - {}개 시간대 데이터 생성, 총 예약: {}개", 
                    hourlyCongestion.size(), totalReservations);
            
            // 데이터 부족 경고
            if (totalReservations == 0 && currentChargingCount == 0) {
                log.info(">>> [시간대별 혼잡도] 예약 데이터와 사용 중인 충전기 없음 - 모든 시간대 혼잡도 0%");
            } else if (totalReservations == 0) {
                log.info(">>> [시간대별 혼잡도] 예약 데이터 없음 - 현재 충전기 상태만 반영된 혼잡도");
            } else {
                log.info(">>> [시간대별 혼잡도] 예약 데이터 있음 - {}개 예약으로 혼잡도 계산", totalReservations);
            }
            
        } catch (Exception e) {
            log.error(">>> [시간대별 혼잡도] 오류 발생 - 충전소: {}", stationId, e);
            // 기본값으로 채우기
            for (int hour = 0; hour < 24; hour++) {
                hourlyCongestion.put(hour, 50.0);
            }
        }
        
        log.info(">>> [시간대별 혼잡도] 완료 - stationId: {}", stationId);
        return hourlyCongestion;
    }
    
    /**
     * 충전기 타입 변환 (한글 -> 코드)
     */
    private String convertChargerType(String chargerType) {
        if (chargerType == null) return null;
        
        if (chargerType.equals("급속") || chargerType.equalsIgnoreCase("fast")) {
            return "급속";
        } else if (chargerType.equals("완속") || chargerType.equalsIgnoreCase("slow")) {
            return "완속";
        }
        return chargerType;
    }
    
    /**
     * 충전기 타입 매칭 확인
     */
    private boolean isMatchingType(String chargerTypeCode, String targetType) {
        if (targetType == null || chargerTypeCode == null) return true;
        
        boolean isFastCharger = !("02".equals(chargerTypeCode) || "08".equals(chargerTypeCode));
        
        if (targetType.equals("급속") || targetType.equalsIgnoreCase("fast")) {
            return isFastCharger;
        } else if (targetType.equals("완속") || targetType.equalsIgnoreCase("slow")) {
            return !isFastCharger;
        }
        
        return true;
    }
}

