package com.boot.fix.service;

import com.boot.fix.dto.FixDTO;
import java.util.HashMap;
import java.util.List;

public interface FixService {
    void registerReport(FixDTO fixDTO);
    List<FixDTO> getAllReports();
    FixDTO getReportById(Long reportId);
    void updateReport(FixDTO fixDTO);
    void deleteReport(Long reportId);
    List<FixDTO> getReportsByMemberId(String memberId);
    // 페이징 관련 메서드
    List<FixDTO> getAllReportsWithPaging(HashMap<String, Object> param);
    int getTotalCount();
}
