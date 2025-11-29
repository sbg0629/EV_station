package com.boot.login.dao;

import java.util.ArrayList;
import java.util.HashMap;
import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.boot.login.dto.MemDTO;

@Repository
public class MemDAOImpl implements MemDAO {

    @Autowired
    private SqlSession sqlSession;

    private static final String NAMESPACE = "com.boot.login.dao.MemDAO";

    @Override
    public ArrayList<MemDTO> loginYn(HashMap<String, String> param) {
        return new ArrayList<>(sqlSession.selectList(NAMESPACE + ".loginYn", param));
    }

    @Override
    public void write(HashMap<String, String> param) {
        sqlSession.insert(NAMESPACE + ".write", param);
    }

    @Override
    public MemDTO getMemberInfo(String memberId) {
        return sqlSession.selectOne(NAMESPACE + ".getMemberInfo", memberId);
    }
    
    // ===== 중복 확인 메소드 구현 추가 =====
    @Override
    public int idCheck(String memberId) {
        return sqlSession.selectOne(NAMESPACE + ".idCheck", memberId);
    }

    @Override
    public int nicknameCheck(String nickname) {
        return sqlSession.selectOne(NAMESPACE + ".nicknameCheck", nickname);
    }

    @Override
    public int emailCheck(String email) {
        return sqlSession.selectOne(NAMESPACE + ".emailCheck", email);
    }

    @Override
    public int phoneCheck(String phoneNumber) {
        return sqlSession.selectOne(NAMESPACE + ".phoneCheck", phoneNumber);
    }

	@Override
	public MemDTO findMemberBySocial(HashMap<String, String> param) {
		return sqlSession.selectOne(NAMESPACE+".findMemberBySocial", param);
	}

	@Override
	public MemDTO findUserByIdAndEmail(HashMap<String, String> param) {
		return sqlSession.selectOne(NAMESPACE + ".findUserByIdAndEmail", param);
	}

	@Override
	public void updatePassword(HashMap<String, String> param) {
		sqlSession.update(NAMESPACE + ".updatePassword", param);
		
	}

	@Override
	public MemDTO findUserIdByEmail(String email) {
		return sqlSession.selectOne(NAMESPACE + ".findUserIdByEmail", email);
	}
}
