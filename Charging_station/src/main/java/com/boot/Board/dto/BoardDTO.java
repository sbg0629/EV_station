package com.boot.Board.dto;

import lombok.Data;

@Data
public class BoardDTO {
    
    private int boardId;                  // 게시글 ID
    private String memberId;              // 작성자 ID
    private String title;                 // 제목
    private String content;               // 내용
    private int viewCount;                // 조회수
    private String createdAt;             // 생성일
    private String updatedAt;             // 수정일
    
    // 작성자 이름 (JOIN으로 가져올 경우)
    private String memberName;
    private String nickname;              // 작성자 닉네임
}

