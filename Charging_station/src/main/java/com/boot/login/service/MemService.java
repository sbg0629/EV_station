package com.boot.login.service;

import java.util.ArrayList;
import java.util.HashMap;

import com.boot.login.dto.MemDTO;

public interface MemService {
    
    // 기존 메소드
    ArrayList<MemDTO> loginYn(HashMap<String, String> param);
    void write(HashMap<String, String> param);

    // [추가] 마이페이지를 위한 회원 정보 조회 업무를 지시서에 추가
    MemDTO getMemberInfo(String memberId); 
    
    // 중복 확인 서비스 메소드 추가
    int idCheck(String memberId);
    int nicknameCheck(String nickname);
    int emailCheck(String email);
    int phoneCheck(String phoneNumber);
    
    //소셜 로그인 처리 조회/가입 
    MemDTO findOrCreateMember(HashMap<String, String> socialUserInfo);
    
    //이메일 인증
	MemDTO findUserByIdAndEmail(HashMap<String, String> param);
	void updatePassword(HashMap<String, String> param);
	
	// 아이디 찾기
	MemDTO findUserIdByEmail(String email);
	
	 MemDTO loginCheck(String memberId, String rawPassword);
}
