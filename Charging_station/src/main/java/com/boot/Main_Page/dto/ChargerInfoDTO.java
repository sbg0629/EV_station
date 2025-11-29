package com.boot.Main_Page.dto;

import lombok.Data;

@Data
public class ChargerInfoDTO {
    private String chargerId;    // 충전기 ID (01, 02...)
    private String chargerType;  // 충전기 타입 코드 (01, 02...)
    private String typeName;     // 타입 한글명 (SQL Case문 처리 예정)
    private int stat;            // 상태 (2:대기, 3:충전중...)
    private String output;       // 용량 (50kW)
    private String method;       // 방식 (단독/동시)
    private String statUpdDt;    // 상태 갱신 시간
    private String lastSyncedAt;
    
    private double congestionScore; //혼잡도
    
    private String statusMsg;
}