package com.boot.Board.dto;

import lombok.Data;

@Data
public class BoardCommentDTO {
    
    private int commentId;                // 댓글 ID
    private int boardId;                   // 게시글 ID
    private String memberId;              // 작성자 ID
    private Integer parentCommentId;      // 부모 댓글 ID (대댓글용)
    private String content;               // 댓글 내용
    private String createdAt;             // 생성일
    private String updatedAt;             // 수정일
    
    // 작성자 정보
    private String memberName;
    private String nickname;              // 작성자 닉네임
    
    // 대댓글 표시용
    private int depth;                    // 댓글 깊이 (0: 댓글, 1: 대댓글)
}

