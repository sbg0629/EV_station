package com.boot.Board.dao;


import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

import com.boot.Board.dto.BoardDTO;


@Mapper
public interface BoardDAO {
    
    // 게시글 목록 조회
    List<BoardDTO> list();
    
    // 게시글 검색
    List<BoardDTO> search(HashMap<String, String> param);
    
    // 페이징 게시글 조회
    List<BoardDTO> listPaged(Map<String, Object> param);
    
    // 게시글 개수 조회 (검색 포함)
    int getBoardCount(Map<String, Object> param);
    
    // 게시글 상세 조회
    BoardDTO getBoard(int boardId);
    
    // 게시글 작성
    void write(HashMap<String, String> param);
    
    // 게시글 수정
    void modify(HashMap<String, String> param);
    
    // 게시글 삭제
    void delete(int boardId);
    
    // 조회수 증가
    void increaseViewCount(int boardId);
}

