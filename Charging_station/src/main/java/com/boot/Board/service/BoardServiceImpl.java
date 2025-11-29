package com.boot.Board.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.boot.Board.dao.BoardDAO;
import com.boot.Board.dto.BoardDTO;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class BoardServiceImpl implements BoardService {
    
    @Autowired
    private BoardDAO boardDAO;
    
    @Override
    public List<BoardDTO> list() {
        log.info("@# BoardServiceImpl.list()");
        return boardDAO.list();
    }
    
    @Override
    public List<BoardDTO> search(HashMap<String, String> param) {
        log.info("@# BoardServiceImpl.search() param={}", param);
        return boardDAO.search(param);
    }
    
    @Override
    public BoardDTO getBoard(int boardId) {
        log.info("@# BoardServiceImpl.getBoard() boardId={}", boardId);
        // 조회수 증가
        boardDAO.increaseViewCount(boardId);
        return boardDAO.getBoard(boardId);
    }
    
    @Override
    public void write(HashMap<String, String> param) {
        log.info("@# BoardServiceImpl.write() param={}", param);
        boardDAO.write(param);
    }
    
    @Override
    public void modify(HashMap<String, String> param) {
        log.info("@# BoardServiceImpl.modify() param={}", param);
        boardDAO.modify(param);
    }
    
    @Override
    public void delete(int boardId) {
        log.info("@# BoardServiceImpl.delete() boardId={}", boardId);
        boardDAO.delete(boardId);
    }
    
    @Override
    public BoardDTO getBoardWithoutViewCount(int boardId) {
        log.info("@# BoardServiceImpl.getBoardWithoutViewCount() boardId={}", boardId);
        return boardDAO.getBoard(boardId);
    }
    
    @Override
    public List<BoardDTO> listPaged(Map<String, Object> param) {
        log.info("@# BoardServiceImpl.listPaged() param={}", param);
        
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
        
        return boardDAO.listPaged(param);
    }
    
    @Override
    public int getBoardCount(Map<String, Object> param) {
        log.info("@# BoardServiceImpl.getBoardCount() param={}", param);
        return boardDAO.getBoardCount(param);
    }
}