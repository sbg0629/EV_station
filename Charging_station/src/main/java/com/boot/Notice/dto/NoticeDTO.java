package com.boot.Notice.dto;

import java.sql.Timestamp;
import lombok.Data;

@Data
public class NoticeDTO {
    
    private int noticeId;                   // 공지사항 ID
    private String memberId;                // 작성자 (관리자)
    private String category;                // 카테고리 (운영, 신규, 점검, 요금, 혜택, 안내)
    private String title;                   // 제목
    private String content;                 // 내용
    private int viewCount;                  // 조회수
    private int isFixed;                   // 상단 고정 여부 (0=일반, 1=고정)
    private String createdAt;            // 생성일
    private String updatedAt;            // 수정일
    
    // 작성자 이름 (JOIN으로 가져올 경우)
    private String memberName;
}

