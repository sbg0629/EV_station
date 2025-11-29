package com.boot.Main_Page.dto;

import java.sql.Timestamp;
import lombok.Data;

@Data
public class FavoriteDTO {
    private int favoriteId;       // PK
    private String memberId;      // 회원 ID
    private String stationId;     // (Change) int -> String (api_stat_id 저장)
    private String stationName;   // (Add) 목록 보여줄 때 편의상 추가
    private Timestamp createdAt;
}