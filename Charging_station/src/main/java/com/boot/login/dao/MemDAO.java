package com.boot.login.dao;

import java.util.ArrayList;
import java.util.HashMap;

import com.boot.login.dto.MemDTO;

public interface MemDAO {
    // 기존 메소드
    ArrayList<MemDTO> loginYn(HashMap<String, String> param);
    void write(HashMap<String, String> param);
    MemDTO getMemberInfo(String memberId);

    // 중복 확인을 위한 메소드 추가
    int idCheck(String memberId);
    int nicknameCheck(String nickname);
    int emailCheck(String email);
    int phoneCheck(String phoneNumber);

    //소셜 로그인 메소드
    MemDTO findMemberBySocial(HashMap<String, String> param);
	MemDTO findUserByIdAndEmail(HashMap<String, String> param);
	void updatePassword(HashMap<String, String> param);
	
	// 아이디 찾기
	MemDTO findUserIdByEmail(String email);
}
