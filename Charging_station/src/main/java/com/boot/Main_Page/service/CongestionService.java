package com.boot.Main_Page.service;

import org.springframework.stereotype.Service;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.time.DayOfWeek;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.time.temporal.ChronoUnit;
import java.util.Random;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class CongestionService {

    private static final double INTERCEPT = -3.0;       
    private static final double COEF_HOUR_PEAK = 1.5;   
    private static final double COEF_FAST_CHARGER = 0.8; 
    private static final double COEF_WEEKEND = 0.5; 
    private static final double COEF_CURRENTLY_CHARGING = 3.0; // 충전중일 때 기본 가중치를 더 높임

    /**
     * 혼잡도 예측 (시간 경과 반영)
     */
    public double predictCongestion(String chargerType, int stat, String statUpdDt) {
        
        // 1. 기본 변수 설정
        int currentHour = LocalTime.now().getHour();
        DayOfWeek dayOfWeek = LocalDate.now().getDayOfWeek();
        boolean isWeekend = (dayOfWeek == DayOfWeek.SATURDAY || dayOfWeek == DayOfWeek.SUNDAY);
        boolean isFast = !("02".equals(chargerType) || "08".equals(chargerType));
        boolean isPeak = (currentHour >= 11 && currentHour <= 18);
        boolean isChargingNow = (stat == 3);

        // 2. 로지스틱 회귀 기본 점수 계산
        double z = INTERCEPT 
                 + (isPeak ? COEF_HOUR_PEAK : 0)
                 + (isFast ? COEF_FAST_CHARGER : 0)
                 + (isWeekend ? COEF_WEEKEND : 0)
                 + (isChargingNow ? COEF_CURRENTLY_CHARGING : 0);

        // 3. 확률 변환 (0~100%)
        double probability = 1.0 / (1.0 + Math.exp(-z));
        double score = probability * 100.0;

        // =========================================================
        // 🌟 [핵심 로직] 충전 시작 후 경과 시간에 따른 점수 차감 (Time Decay)
        // =========================================================
        if (isChargingNow && statUpdDt != null && !statUpdDt.isEmpty()) {
            try {
                // DB 시간 포맷 (YYYY-MM-DD HH:mm:ss) 파싱
                DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
                LocalDateTime lastUpdate = LocalDateTime.parse(statUpdDt, formatter);
                LocalDateTime now = LocalDateTime.now();

                // 경과 시간(분) 계산
                long minutesElapsed = ChronoUnit.MINUTES.between(lastUpdate, now);
                
                // 차감 로직 (급속은 빨리 빠지므로 감소폭을 크게, 완속은 작게)
                double decayRate = isFast ? 1.5 : 0.2; // 급속: 1분에 1.5점 감소, 완속: 1분에 0.2점 감소
                
                double reduction = minutesElapsed * decayRate;
                
                // 점수 차감 적용
                score -= reduction;
                
                // (디버깅용 로그 - 나중에 주석 처리)
                // log.info("충전중 경과시간: {}분, 차감점수: -{}", minutesElapsed, reduction);

            } catch (Exception e) {
                // 날짜 파싱 에러 시 그냥 통과
            }
        }

        // 4. 랜덤 노이즈 (생동감)
        Random random = new Random();
        long seed = (long) (chargerType.hashCode() + System.currentTimeMillis() / 60000); 
        random.setSeed(seed);
        double noise = (random.nextDouble() * 5) - 2.5; // ±2.5% 변동
        score += noise;

        // 5. 범위 보정 (0~100 사이 유지)
        if (score < 0) score = 0; // 너무 오래돼서 음수가 되면 0으로
        if (score > 100) score = 100;

        return Math.round(score * 10.0) / 10.0;
    }
    
    public String getAnalysisMessage(String chargerType, int stat, String statUpdDt) {
        if (stat != 3 || statUpdDt == null || statUpdDt.isEmpty()) {
            return ""; // 충전 중 아니면 메시지 없음
        }

        try {
            DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
            LocalDateTime lastUpdate = LocalDateTime.parse(statUpdDt, formatter);
            LocalDateTime now = LocalDateTime.now();

            long minutes = ChronoUnit.MINUTES.between(lastUpdate, now);
            boolean isFast = !("02".equals(chargerType) || "08".equals(chargerType));

            // 1. 24시간(1440분) 넘게 충전 중 -> 고장 의심
            if (minutes > 1440) {
                return "(점검필요)";
            }
            
            // 2. 급속인데 1시간(60분) 넘음 -> 장기 주차
            if (isFast && minutes > 60) {
                return "(장기주차)";
            }
            
            // 3. 완속인데 12시간(720분) 넘음 -> 장기 주차
            if (!isFast && minutes > 720) {
                return "(장기주차)";
            }

        } catch (Exception e) {
            return "";
        }
        return ""; // 정상 범위
    }
}