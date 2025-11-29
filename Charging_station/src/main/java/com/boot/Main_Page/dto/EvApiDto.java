package com.boot.Main_Page.dto;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import lombok.Data;
import java.util.List;

@Data
@JsonIgnoreProperties(ignoreUnknown = true)
public class EvApiDto {

    // [수정] response, body 껍질 제거 -> 바로 필드 선언
    private String resultMsg;
    private Integer totalCount;
    private Integer pageNo;
    private Integer numOfRows;
    
    private Items items; // JSON의 "items" 객체

    @Data
    @JsonIgnoreProperties(ignoreUnknown = true)
    public static class Items {
        private List<Item> item; // JSON의 "item" 배열
    }

    @Data
    @JsonIgnoreProperties(ignoreUnknown = true)
    public static class Item {
        // 이 부분은 기존과 동일
        private String statId;
        private String chgerId;
        private String statNm;
        private String addr;
        private String lat;
        private String lng;
        private String useTime;
        private String busiNm;
        private String busiCall;
        private String stat;
        private String statUpdDt;
        private String lastTsdt;
        private String lastTedt;
        private String nowTsdt;
        private String output;
        private String method;
        private String parkingFree;
        private String chgerType;
        private String note;
        
        private String kind;       // API의 "kind" -> 나중에 DB의 facility_type_large로 들어감
        private String kindDetail; // API의 "kindDetail" -> 나중에 DB의 facility_type_small로 들어감
    }
}