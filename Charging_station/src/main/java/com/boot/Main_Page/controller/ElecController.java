package com.boot.Main_Page.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.boot.Main_Page.dao.ElecDAO;
import com.boot.Main_Page.dto.ChargerInfoDTO;
import com.boot.Main_Page.dto.ElecDTO;
import com.boot.Main_Page.service.CongestionService;
import com.boot.Main_Page.service.ElecService;
import com.boot.Main_Page.service.EvLoadService;
import com.boot.Main_Page.service.ReservationBasedCongestionService;

import lombok.extern.slf4j.Slf4j;

@Controller
@Slf4j
public class ElecController {
	
	@Autowired
    private CongestionService congestionService; // 주입
	
	@Autowired
	private ElecService elecService;
    
    @Autowired
    private EvLoadService evLoadService; // [추가] 실시간/스마트 갱신 서비스
    
    @Autowired
    private ElecDAO elecDAO; // [추가] 개별 충전기 조회용 (단순 조회라 DAO 직접 호출)
    
    @Autowired
    private ReservationBasedCongestionService reservationBasedCongestionService; // 예약 기반 혼잡도 예측 서비스 (히스토리 테이블 불필요)
	
    // ==========================================
    // 1. 페이지 이동
    // ==========================================
    
	@GetMapping("/map_kakao")
	public String kakao_map() {
		return "kakao_map";
	}
	
	@GetMapping("/map")
	public String showMapPage() {
		return "map";
	}
     
    // ==========================================
    // 2. 충전소 검색 (목록/마커용)
    // ==========================================

    /**
     * 반경 검색 엔드포인트
     */
    @GetMapping("/searchByRadius")
    @ResponseBody 
    public List<ElecDTO> searchByRadius(
            @RequestParam("lat") double latitude,
            @RequestParam("lng") double longitude,
            @RequestParam(value = "radius", defaultValue = "2000") double radius) {
       
        log.info("--- [Controller] 반경 검색 시작 (Lat: {}, Lng: {}, Radius: {}) ---", latitude, longitude, radius);
        
        Map<String, Object> params = new HashMap<>();
        params.put("targetLat", latitude);
        params.put("targetLng", longitude);
        params.put("radius", radius);
        
        List<ElecDTO> stations = elecService.findStationsByRadius(params); 
        return stations;
    }

    /**
     * 키워드 검색 엔드포인트
     */
    @GetMapping("/searchByKeyword")
    @ResponseBody
    public List<ElecDTO> searchByKeyword(@RequestParam("keyword") String keyword) {
        log.info("--- [Controller] 키워드 검색 시작 (Keyword: {}) ---", keyword);
        
        Map<String, Object> params = new HashMap<>();
        params.put("keyword", keyword);

        List<ElecDTO> stations = elecService.findStationsByKeyword(params);
        return stations;
    }
    
    /**
     * 지도 영역 검색 엔드포인트
     */
    @GetMapping("/searchByBounds")
    @ResponseBody
    public List<ElecDTO> searchByBounds(
            @RequestParam("minLat") double minLat,
            @RequestParam("maxLat") double maxLat,
            @RequestParam("minLng") double minLng,
            @RequestParam("maxLng") double maxLng) {
        
        log.info("--- [Controller] 영역 검색 시작 ---");
        
        Map<String, Object> params = new HashMap<>();
        params.put("minLat", minLat);
        params.put("maxLat", maxLat);
        params.put("minLng", minLng);
        params.put("maxLng", maxLng);
        
        List<ElecDTO> stations = elecService.findStationsByBounds(params);
        return stations;
    }

    // ==========================================
    // 3. 개별 충전기 상태 조회 (Drill-down)
    // ==========================================

    /**
     * 특정 충전소의 충전기 상세 목록 조회
     * 🚀 [스마트 갱신 적용]: 데이터가 10분 이상 오래된 경우에만 API를 호출하여 갱신
     */
    @GetMapping("/station/chargers")
    @ResponseBody
    public List<ChargerInfoDTO> getChargerList(@RequestParam("statId") String statId) {
        
        // ❌ 기존 로직: 수동 10분 체크 로직 제거
        // evLoadService.refreshStationStatusSmart(statId, 10); 
        
        // ✅ Redis 캐시 로직 적용: 캐시가 적용된 Service 메서드 호출
        // 10분 이내: Redis Hit -> DB/API 호출 없이 바로 list 획득
        // 10분 이후: Redis Miss -> Service 내부의 refreshStationStatus(API 호출) 실행 후 list 획득
        List<ChargerInfoDTO> list = evLoadService.getChargerListWithCache(statId); 
        
        if (list != null) {
            for (ChargerInfoDTO charger : list) {
                // ... (기존 혼잡도/상태 메시지 계산 로직 유지)
                double score = congestionService.predictCongestion(
                        charger.getChargerType(), 
                        charger.getStat(),
                        charger.getStatUpdDt()
                );
                charger.setCongestionScore(score);
                
                String msg = congestionService.getAnalysisMessage(
                        charger.getChargerType(),
                        charger.getStat(),
                        charger.getStatUpdDt()
                );
                charger.setStatusMsg(msg);
            }
        }
        return list;
    }

    /**
     * 시간대별 혼잡도 예측 (예약 데이터 기반만 사용)
     * 히스토리 테이블 없이 현재 가능한 기능(예약 데이터)만으로 혼잡도 예측
     */
    @GetMapping("/station/congestion/predict")
    @ResponseBody
    public Map<String, Object> predictCongestionByHour(
            @RequestParam(value = "statId", required = false) String statId,
            @RequestParam(value = "chargerType", required = false) String chargerType) {
        
        log.info(">>> [혼잡도 예측] 요청 시작 - statId: {}, chargerType: {}", statId, chargerType);
        Map<String, Object> result = new HashMap<>();
        
        try {
            int currentHour = java.time.LocalTime.now().getHour();
            log.info(">>> [혼잡도 예측] 현재 시간: {}시", currentHour);
            
            // statId가 필수: 예약 데이터 기반 혼잡도 예측
            if (statId != null && !statId.isEmpty()) {
                log.info(">>> [혼잡도 예측] 현재 혼잡도 계산 시작...");
                double currentCongestion = reservationBasedCongestionService.predictCurrentCongestion(statId, chargerType);
                log.info(">>> [혼잡도 예측] 현재 혼잡도: {}%", currentCongestion);
                
                log.info(">>> [혼잡도 예측] 시간대별 혼잡도 계산 시작...");
                Map<Integer, Double> hourlyCongestion = reservationBasedCongestionService.predictHourlyCongestion(statId, chargerType);
                log.info(">>> [혼잡도 예측] 시간대별 혼잡도 계산 완료 - {}개 시간대", hourlyCongestion.size());
                
                // probabilities는 0~1 범위로 변환 (프론트엔드 호환성)
                Map<Integer, Double> probabilities = new HashMap<>();
                for (Map.Entry<Integer, Double> entry : hourlyCongestion.entrySet()) {
                    probabilities.put(entry.getKey(), entry.getValue() / 100.0);
                }
                
                // 예약 데이터 존재 여부 확인
                boolean hasReservationData = false;
                for (Double prob : probabilities.values()) {
                    if (prob != null && prob > 0) {
                        hasReservationData = true;
                        break;
                    }
                }
                
                result.put("success", true);
                result.put("currentHour", currentHour);
                result.put("currentCongestion", currentCongestion);
                result.put("probabilities", probabilities); // 0~1 범위
                result.put("currentProbability", probabilities.getOrDefault(currentHour, 0.5));
                result.put("method", "reservation-based");
                result.put("hasData", hasReservationData || currentCongestion > 0);
                result.put("dataInfo", !hasReservationData && currentCongestion == 0 
                    ? "예약 데이터와 사용 중인 충전기가 없어 혼잡도가 0%입니다. 예약 데이터가 쌓이면 정확한 혼잡도 예측이 가능합니다."
                    : hasReservationData 
                        ? "예약 데이터를 기반으로 혼잡도를 계산했습니다."
                        : "현재 충전기 상태만 반영된 혼잡도입니다.");
                log.info(">>> [혼잡도 예측] 응답 데이터 준비 완료 - success: true, probabilities: {}개, hasData: {}", 
                        probabilities.size(), hasReservationData || currentCongestion > 0);
            } else {
                log.info(">>> [혼잡도 예측] statId 없음 - 기본 패턴 반환");
                // statId가 없을 때는 기본 패턴 반환 (예약 데이터 없음)
                Map<Integer, Double> hourProbabilities = getDefaultHourProbabilities(chargerType);
                
                result.put("success", true);
                result.put("currentHour", currentHour);
                result.put("probabilities", hourProbabilities);
                result.put("currentProbability", hourProbabilities.getOrDefault(currentHour, 0.5));
                result.put("method", "default-pattern");
                result.put("message", "statId를 제공하면 예약 데이터 기반의 더 정확한 혼잡도 예측이 가능합니다.");
                log.info(">>> [혼잡도 예측] 기본 패턴 응답 완료");
            }
            
        } catch (Exception e) {
            log.error(">>> [혼잡도 예측] 오류 발생: {}", e.getMessage(), e);
            result.put("success", false);
            result.put("message", "혼잡도 예측 중 오류가 발생했습니다.");
        }
        
        log.info(">>> [혼잡도 예측] 요청 완료 - success: {}", result.get("success"));
        return result;
    }
    
    /**
     * 기본 시간대별 혼잡도 패턴 (statId 없을 때 사용)
     */
    private Map<Integer, Double> getDefaultHourProbabilities(String chargerType) {
        Map<Integer, Double> probabilities = new HashMap<>();
        boolean isFast = chargerType != null && 
                        (chargerType.equals("급속") || chargerType.equalsIgnoreCase("fast") ||
                         !chargerType.equals("완속") && !chargerType.equalsIgnoreCase("slow"));
        
        // 기본 패턴: 오전 8-10시, 오후 5-8시 피크
        for (int hour = 0; hour < 24; hour++) {
            double baseProb = 0.3; // 기본 30%
            
            // 오전 출근 시간대 (8-10시)
            if (hour >= 8 && hour <= 10) {
                baseProb = 0.7; // 70%
            }
            // 점심 시간대 (12-14시)
            else if (hour >= 12 && hour <= 14) {
                baseProb = 0.6; // 60%
            }
            // 오후 퇴근 시간대 (17-20시)
            else if (hour >= 17 && hour <= 20) {
                baseProb = 0.75; // 75%
            }
            // 심야 시간대 (0-6시)
            else if (hour >= 0 && hour <= 6) {
                baseProb = 0.2; // 20%
            }
            
            // 급속 충전기는 일반적으로 더 혼잡
            if (isFast) {
                baseProb += 0.1;
            }
            
            // 범위 조정
            if (baseProb > 1.0) baseProb = 1.0;
            if (baseProb < 0.0) baseProb = 0.0;
            
            probabilities.put(hour, baseProb);
        }
        
        return probabilities;
    }
    
    /**
     * 특정 충전소의 예약 데이터 기반 혼잡도 예측
     * 현재 가능한 기능을 활용하여 실용적인 혼잡도 예측 제공
     */
    @GetMapping("/station/congestion/predict-by-reservation")
    @ResponseBody
    public Map<String, Object> predictCongestionByReservation(
            @RequestParam("statId") String statId,
            @RequestParam(value = "chargerType", required = false) String chargerType) {
        
        Map<String, Object> result = new HashMap<>();
        
        try {
            // 현재 혼잡도
            double currentCongestion = reservationBasedCongestionService.predictCurrentCongestion(statId, chargerType);
            
            // 시간대별 혼잡도
            Map<Integer, Double> hourlyCongestion = reservationBasedCongestionService.predictHourlyCongestion(statId, chargerType);
            
            int currentHour = java.time.LocalTime.now().getHour();
            
            result.put("success", true);
            result.put("currentHour", currentHour);
            result.put("currentCongestion", currentCongestion);
            result.put("hourlyCongestion", hourlyCongestion);
            
            // 현재 시간대의 혼잡도
            result.put("currentHourCongestion", hourlyCongestion.getOrDefault(currentHour, 50.0));
            
        } catch (Exception e) {
            log.error(">>> [예약 기반 혼잡도 예측] 오류 발생: {}", e.getMessage(), e);
            result.put("success", false);
            result.put("message", "혼잡도 예측 중 오류가 발생했습니다.");
        }
        
        return result;
    }
}