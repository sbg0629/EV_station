package com.boot.Main_Page.dto;

import lombok.Data;

@Data
public class ElecDTO {
    // --- 기존 필드 유지 ---
    private String apiStatId;
    private int id;
    private String stationName;
    private String address;
    private String city;
    private String district;
    
    private String operator;
    private String busiCall;
    private String useTime;
    private String parkingFree;
    private String note;
    private String lastUpdated;

    private String fastChargeCapacity;
    // chargerModelSmall은 이제 타입별 상세 카운트로 대체되므로 굳이 안 써도 되지만 유지
    private String chargerModelSmall; 
    
 // [필수 추가] 이 두 줄이 없어서 에러가 났습니다!
    private String facilityTypeLarge; // 시설구분 (대분류)
    private String facilityTypeSmall; // 시설구분 (상세)

    private double latitude;
    private double longitude;
    private double distanceM;

    // --- [통계] 전체 요약 ---
    private int chargerCount;          // 전체 수
    private int fastChargerCount;      // 급속 합계 (01,03,04,05,06,07,09,10)
    private int slowChargerCount;      // 완속 합계 (02,08)
    private int availableChargerCount; // 대기중 수

    // --- [NEW] 타입 코드별 상세 개수 (01~10) ---
    private int countType01; // DC차데모
    private int countType02; // AC완속
    private int countType03; // DC차데모+AC3상
    private int countType04; // DC콤보
    private int countType05; // DC차데모+DC콤보
    private int countType06; // DC차데모+AC3상+DC콤보
    private int countType07; // AC3상
    private int countType08; // DC콤보(완속)
    private int countType09; // NACS
    private int countType10; // DC콤보+NACS
}