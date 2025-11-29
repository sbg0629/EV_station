package com.boot.fix.dao;

import com.boot.fix.dto.FixDTO;
import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import java.util.HashMap;
import java.util.List;

@Repository
public class FixDAOImpl implements FixDAO {

    private final SqlSession sqlSession;

    @Autowired
    public FixDAOImpl(SqlSession sqlSession) {
        this.sqlSession = sqlSession;
    }

    @Override
    public void insertReport(FixDTO fixDTO) {
        sqlSession.insert("FixMapper.insertReport", fixDTO);
    }

    @Override
    public List<FixDTO> getAllReports() {
        return sqlSession.selectList("FixMapper.getAllReports");
    }

    @Override
    public FixDTO getReportById(Long reportId) {
        return sqlSession.selectOne("FixMapper.getReportById", reportId);
    }

    @Override
    public void updateReport(FixDTO fixDTO) {
        sqlSession.update("FixMapper.updateReport", fixDTO);
    }

    @Override
    public void deleteReport(Long reportId) {
        sqlSession.delete("FixMapper.deleteReport", reportId);
    }

    @Override    public List<FixDTO> getReportsByMemberId(String memberId) {
        return sqlSession.selectList("FixMapper.getReportsByMemberId", memberId);
    }

    @Override
    public List<FixDTO> getAllReportsWithPaging(HashMap<String, Object> param) {
        return sqlSession.selectList("FixMapper.getAllReportsWithPaging", param);
    }

    @Override
    public int getTotalCount() {
        return sqlSession.selectOne("FixMapper.getTotalCount");
    }
}
