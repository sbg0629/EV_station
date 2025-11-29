package com.boot.Board.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.boot.Board.dao.BoardCommentDAO;
import com.boot.Board.dto.BoardCommentDTO;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class BoardCommentServiceImpl implements BoardCommentService {
    
    @Autowired
    private BoardCommentDAO boardCommentDAO;
    
    @Override
    public List<BoardCommentDTO> getComments(int boardId) {
        log.info("@# BoardCommentServiceImpl.getComments() boardId={}", boardId);
        return boardCommentDAO.getComments(boardId);
    }
    
    @Override
    public void writeComment(HashMap<String, String> param) {
        log.info("@# BoardCommentServiceImpl.writeComment() param={}", param);
        boardCommentDAO.writeComment(param);
    }
    
    @Override
    public void modifyComment(HashMap<String, String> param) {
        log.info("@# BoardCommentServiceImpl.modifyComment() param={}", param);
        boardCommentDAO.modifyComment(param);
    }
    
    @Override
    public void deleteComment(int commentId) {
        log.info("@# BoardCommentServiceImpl.deleteComment() commentId={}", commentId);
        boardCommentDAO.deleteComment(commentId);
    }
    
    @Override
    public BoardCommentDTO getComment(int commentId) {
        log.info("@# BoardCommentServiceImpl.getComment() commentId={}", commentId);
        return boardCommentDAO.getComment(commentId);
    }
    
    @Override
    public List<BoardCommentDTO> getCommentsPaged(Map<String, Object> param) {
        log.info("@# BoardCommentServiceImpl.getCommentsPaged() param={}", param);
        
        // MySQL용 파라미터 변환 (startRow, endRow -> startRow, pageSize)
        if (param.containsKey("startRow") && param.containsKey("endRow")) {
            int startRow = (int) param.get("startRow");
            int endRow = (int) param.get("endRow");
            
            // MySQL LIMIT는 0부터 시작하므로 startRow - 1
            int offset = startRow - 1;
            int pageSize = endRow - startRow + 1;
            
            param.put("startRow", offset);  // LIMIT의 첫 번째 파라미터 (offset)
            param.put("pageSize", pageSize); // LIMIT의 두 번째 파라미터 (개수)
        }
        
        return boardCommentDAO.getCommentsPaged(param);
    }
    
    @Override
    public int getCommentCount(int boardId) {
        log.info("@# BoardCommentServiceImpl.getCommentCount() boardId={}", boardId);
        return boardCommentDAO.getCommentCount(boardId);
    }
}