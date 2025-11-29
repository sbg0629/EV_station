package com.boot.fix.service;

import com.boot.fix.dao.FixDAO;
import com.boot.fix.dto.FixDTO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.HashMap;
import java.util.List;

@Service
public class FixServiceImpl implements FixService {

    private final FixDAO fixDAO;

    @Autowired
    public FixServiceImpl(FixDAO fixDAO) {
        this.fixDAO = fixDAO;
    }

    @Override
    public void registerReport(FixDTO fixDTO) {
        fixDAO.insertReport(fixDTO);
    }

    @Override
    public List<FixDTO> getAllReports() {
        return fixDAO.getAllReports();
    }

    @Override
    public FixDTO getReportById(Long reportId) {
        return fixDAO.getReportById(reportId);
    }

    @Override
    public void updateReport(FixDTO fixDTO) {
        // 상태가 '처리완료'로 변경될 때 processedAt을 현재 시스템 시간으로 자동 설정
        if ("처리완료".equals(fixDTO.getStatus()) && fixDTO.getProcessedAt() == null) {
            fixDTO.setProcessedAt(new java.util.Date());
        }
        fixDAO.updateReport(fixDTO);
    }

    @Override
    public void deleteReport(Long reportId) {
        fixDAO.deleteReport(reportId);
    }

    @Override
    public List<FixDTO> getReportsByMemberId(String memberId) {
        return fixDAO.getReportsByMemberId(memberId);
    }

    @Override
    public List<FixDTO> getAllReportsWithPaging(HashMap<String, Object> param) {
        convertPagingParams(param);
        return fixDAO.getAllReportsWithPaging(param);
    }

    @Override
    public int getTotalCount() {
        return fixDAO.getTotalCount();
    }

    /**
     * Oracle 방식의 페이징 파라미터를 MySQL 방식으로 변환
     * startRow, endRow -> offset, pageSize
     */
    private void convertPagingParams(java.util.Map<String, Object> param) {
        if (param.containsKey("startRow") && param.containsKey("pageSize")) {
            int startRow = ((Number) param.get("startRow")).intValue();
            int pageSize = ((Number) param.get("pageSize")).intValue();
            
            // MySQL LIMIT는 0부터 시작하므로 startRow를 offset으로 사용
            int offset = startRow;
            
            param.put("startRow", offset);  // LIMIT의 offset
            param.put("pageSize", pageSize); // LIMIT의 개수
        }
    }
}
