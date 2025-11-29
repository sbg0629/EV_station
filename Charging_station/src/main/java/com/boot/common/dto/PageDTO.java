package com.boot.common.dto;

import lombok.Data;

@Data
public class PageDTO {
    private int currentPage;      // 현재 페이지
    private int totalCount;       // 전체 데이터 개수
    private int pageSize;         // 한 페이지에 보여줄 데이터 개수
    private int totalPage;        // 전체 페이지 수
    private int startPage;        // 시작 페이지 번호
    private int endPage;          // 끝 페이지 번호
    private int startRow;         // 시작 행 번호 (DB 쿼리용)
    private int endRow;           // 끝 행 번호 (DB 쿼리용)
    private boolean hasPrev;      // 이전 페이지 존재 여부
    private boolean hasNext;      // 다음 페이지 존재 여부
    private int prevPage;         // 이전 페이지 번호
    private int nextPage;         // 다음 페이지 번호
    private int pageBlock;        // 페이지 블록 크기 (보통 10)
    
    public PageDTO() {
        this.currentPage = 1;
        this.pageSize = 10;
        this.pageBlock = 10;
    }
    
    public PageDTO(int currentPage, int totalCount, int pageSize) {
        this.currentPage = currentPage;
        this.totalCount = totalCount;
        this.pageSize = pageSize;
        this.pageBlock = 10;
        calculate();
    }
    
    public PageDTO(int currentPage, int totalCount, int pageSize, int pageBlock) {
        this.currentPage = currentPage;
        this.totalCount = totalCount;
        this.pageSize = pageSize;
        this.pageBlock = pageBlock;
        calculate();
    }
    
    private void calculate() {
        // 전체 페이지 수 계산
        totalPage = (int) Math.ceil((double) totalCount / pageSize);
        
        // 현재 페이지가 전체 페이지보다 크면 전체 페이지로 설정
        if (currentPage > totalPage) {
            currentPage = totalPage;
        }
        if (currentPage < 1) {
            currentPage = 1;
        }
        
        // 시작 행과 끝 행 계산 (Oracle 기준)
        startRow = (currentPage - 1) * pageSize + 1;
        endRow = currentPage * pageSize;
        
        // 시작 페이지와 끝 페이지 계산
        startPage = ((currentPage - 1) / pageBlock) * pageBlock + 1;
        endPage = startPage + pageBlock - 1;
        
        // 끝 페이지가 전체 페이지보다 크면 전체 페이지로 설정
        if (endPage > totalPage) {
            endPage = totalPage;
        }
        
        // 이전/다음 페이지 존재 여부
        hasPrev = currentPage > 1;
        hasNext = currentPage < totalPage;
        
        // 이전/다음 페이지 번호
        prevPage = hasPrev ? currentPage - 1 : 1;
        nextPage = hasNext ? currentPage + 1 : totalPage;
    }
}


