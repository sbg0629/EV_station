package com.boot.fix.dto;

import java.time.LocalDateTime;
import java.util.Date; // Date import 추가

import org.springframework.format.annotation.DateTimeFormat; // DateTimeFormat import 추가

import lombok.Data;

@Data
public class FixDTO {
    private Long reportId;
    private String memberId;
    private String apiStatId;
    private String chargerId;
    private String malfunctionType;
    private String detailContent;
    private String imageUrl;
    private String status;
    private String adminComment;
    @DateTimeFormat(pattern = "yyyy-MM-dd HH:mm:ss") // 추가
    private Date reportedAt; // LocalDateTime -> Date로 변경
    @DateTimeFormat(pattern = "yyyy-MM-dd HH:mm:ss") // 추가
    private Date processedAt; // LocalDateTime -> Date로 변경

  
    @Override
    public String toString() {
        return "FixDTO{" +
               "reportId=" + reportId +
               ", memberId='" + memberId + '\'' + // '\'를 사용하여 작은따옴표를 문자열 안에 삽입
               ", apiStatId='" + apiStatId + '\'' +
               ", chargerId='" + chargerId + '\'' +
               ", malfunctionType='" + malfunctionType + '\'' +
               ", detailContent='" + detailContent + '\'' +
               ", imageUrl='" + imageUrl + '\'' +
               ", status='" + status + '\'' +
               ", adminComment='" + adminComment + '\'' +
               ", reportedAt=" + reportedAt +
               ", processedAt=" + processedAt +
               '}';
    }
}