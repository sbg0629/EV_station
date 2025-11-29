package com.boot.Main_Page.dto;

import lombok.Data;
import java.time.LocalDateTime;

@Data
public class ChargingStationHistoryDTO {
    private Long id;                    // 내부 관리용 고유번호
    private String apiStatId;           // 충전소 ID
    private String chargerId;           // 충전기 ID
    private String chargerType;        // 충전기 타입 (01, 02, ...)
    private Integer stat;               // 충전기 상태 (2:대기, 3:충전중)
    private String statUpdatedAt;       // 상태 갱신 시간
    private String nowStartDt;          // 현재 충전 시작
    private String lastStartDt;         // 마지막 충전 시작
    private String lastEndDt;           // 마지막 충전 종료
    private Integer hourOfDay;          // 시간대 (0~23)
    private Double congestionLevel;      // 혼잡도 (0~1 또는 %)
    private LocalDateTime recordedAt;   // 기록 시각
}

