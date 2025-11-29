package com.boot.Notice.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.boot.Notice.dao.NoticeDAO;
import com.boot.Notice.dto.NoticeDTO;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class NoticeServiceImpl implements NoticeService {
    
    @Autowired
    private NoticeDAO noticeDAO;
    
    @Override
    public List<NoticeDTO> list() {
        log.info("@# NoticeServiceImpl.list()");
        return noticeDAO.list();
    }
    
    @Override
    public List<NoticeDTO> listByCategory(String category) {
        log.info("@# NoticeServiceImpl.listByCategory() category={}", category);
        return noticeDAO.listByCategory(category);
    }
    
    @Override
    public List<NoticeDTO> search(HashMap<String, String> param) {
        log.info("@# NoticeServiceImpl.search() param={}", param);
        return noticeDAO.search(param);
    }
    
    @Override
    public NoticeDTO getNotice(int noticeId) {
        log.info("@# NoticeServiceImpl.getNotice() noticeId={}", noticeId);
        // 조회수 증가
        noticeDAO.increaseViewCount(noticeId);
        return noticeDAO.getNotice(noticeId);
    }
    
    @Override
    public void write(HashMap<String, String> param) {
        log.info("@# NoticeServiceImpl.write() param={}", param);
        noticeDAO.write(param);
    }
    
    @Override
    public void modify(HashMap<String, String> param) {
        log.info("@# NoticeServiceImpl.modify() param={}", param);
        noticeDAO.modify(param);
    }
    
    @Override
    public void delete(int noticeId) {
        log.info("@# NoticeServiceImpl.delete() noticeId={}", noticeId);
        noticeDAO.delete(noticeId);
    }
    
    @Override
    public List<NoticeDTO> getFixedNotices() {
        log.info("@# NoticeServiceImpl.getFixedNotices()");
        return noticeDAO.getFixedNotices();
    }
    
    @Override
    public NoticeDTO notgetNotice(int noticeId) {
        log.info("@# NoticeServiceImpl.notgetNotice() noticeId={}", noticeId);
        // 조회수 증가 없이 조회
        return noticeDAO.getNotice(noticeId);
    }
    
    // 페이징 관련 메서드 구현 추가
    @Override
    public List<NoticeDTO> listWithPaging(HashMap<String, Object> param) {
        log.info("@# NoticeServiceImpl.listWithPaging() param={}", param);
        convertPagingParams(param);
        return noticeDAO.listWithPaging(param);
    }
    
    @Override
    public List<NoticeDTO> listByCategoryWithPaging(HashMap<String, Object> param) {
        log.info("@# NoticeServiceImpl.listByCategoryWithPaging() param={}", param);
        convertPagingParams(param);
        return noticeDAO.listByCategoryWithPaging(param);
    }
    
    @Override
    public List<NoticeDTO> searchWithPaging(HashMap<String, Object> param) {
        log.info("@# NoticeServiceImpl.searchWithPaging() param={}", param);
        convertPagingParams(param);
        return noticeDAO.searchWithPaging(param);
    }
    
    @Override
    public int getTotalCount() {
        log.info("@# NoticeServiceImpl.getTotalCount()");
        return noticeDAO.getTotalCount();
    }
    
    @Override
    public int getCategoryCount(String category) {
        log.info("@# NoticeServiceImpl.getCategoryCount() category={}", category);
        return noticeDAO.getCategoryCount(category);
    }
    
    @Override
    public int getSearchCount(HashMap<String, Object> param) {
        log.info("@# NoticeServiceImpl.getSearchCount() param={}", param);
        return noticeDAO.getSearchCount(param);
    }
    
    /**
     * Oracle 방식의 페이징 파라미터를 MySQL 방식으로 변환
     * startRow, endRow -> offset, pageSize
     */
    private void convertPagingParams(Map<String, Object> param) {
        if (param.containsKey("startRow") && param.containsKey("endRow")) {
            int startRow = ((Number) param.get("startRow")).intValue();
            int endRow = ((Number) param.get("endRow")).intValue();
            
            // MySQL LIMIT는 0부터 시작하므로 startRow - 1
            int offset = startRow - 1;
            int pageSize = endRow - startRow + 1;
            
            param.put("startRow", offset);  // LIMIT의 offset
            param.put("pageSize", pageSize); // LIMIT의 개수
            
            log.debug("@# Converted paging params: offset={}, pageSize={}", offset, pageSize);
        }
    }
}