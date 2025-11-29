package com.boot.login.service;

import java.util.ArrayList;
import java.util.HashMap;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;

import com.boot.login.dao.MemDAO;
import com.boot.login.dto.MemDTO;

import lombok.extern.slf4j.Slf4j;

@Service
@Slf4j
public class MemServiceImpl implements MemService {

	@Autowired
	private BCryptPasswordEncoder passwordEncoder;
	
	
   
    @Autowired
    private MemDAO memDAO;

    MemServiceImpl(BCryptPasswordEncoder passwordEncoder) {
        this.passwordEncoder = passwordEncoder;
    }
    
    @Override
    public ArrayList<MemDTO> loginYn(HashMap<String, String> param) {
        log.info("@# MemServiceImpl.loginYn() start");
        return memDAO.loginYn(param);
    }
    
    @Override
    public void write(HashMap<String, String> param) {
        log.info("@# MemServiceImpl.write() start");
        
     // 1. 비밀번호 해시
        String rawPassword = param.get("PASSWORD"); // 폼에서 넘어온 평문
        String encodedPassword = passwordEncoder.encode(rawPassword);
        param.put("PASSWORD", encodedPassword); // 해시값으로 덮어쓰기
        
        param.putIfAbsent("PROFILE_IMAGE", "default_profile.jpg");
        memDAO.write(param);
        log.info("@# MemServiceImpl.write() end");
    }

    @Override
    public MemDTO getMemberInfo(String memberId) {
        log.info("@# MemServiceImpl.getMemberInfo() start for ID: " + memberId);
        return memDAO.getMemberInfo(memberId);
    }
    
    // ===== 중복 확인 서비스 구현 추가 =====
    @Override
    public int idCheck(String memberId) {
        log.info("@# MemServiceImpl.idCheck() for ID: " + memberId);
        return memDAO.idCheck(memberId);
    }

    @Override
    public int nicknameCheck(String nickname) {
        log.info("@# MemServiceImpl.nicknameCheck() for Nickname: " + nickname);
        return memDAO.nicknameCheck(nickname);
    }

    @Override
    public int emailCheck(String email) {
        log.info("@# MemServiceImpl.emailCheck() for Email: " + email);
        return memDAO.emailCheck(email);
    }

    @Override
    public int phoneCheck(String phoneNumber) {
        log.info("@# MemServiceImpl.phoneCheck() for Phone: " + phoneNumber);
        return memDAO.phoneCheck(phoneNumber);
    }
    
    
    @Override
    public MemDTO loginCheck(String memberId, String rawPassword) {
        log.info("@# MemServiceImpl.loginCheck() start for ID: " + memberId);

        // 1. 아이디로 회원 정보 조회 (DB에서 해시된 비밀번호를 가져옴)
        MemDTO dto = memDAO.getMemberInfo(memberId);

        // 2. 회원 존재 여부 + 비밀번호 검증 (평문 비밀번호와 해시 비밀번호 비교)
        if (dto != null && passwordEncoder.matches(rawPassword, dto.getPassword())) {
            return dto; // 로그인 성공
        }

        return null; // 로그인 실패
    }

    @Override
    public MemDTO findOrCreateMember(HashMap<String, String> socialUserInfo) {
        HashMap<String, String> findParam = new HashMap<>();
        findParam.put("socialType", socialUserInfo.get("socialType"));
        findParam.put("socialId", socialUserInfo.get("socialId"));
        
        MemDTO member = memDAO.findMemberBySocial(findParam);
        
        // 1. [Case 1: 신규 회원] member가 null일 때 회원가입 로직 수행
        if (member == null) {
            log.info("@# 신규 소셜 회원 자동 회원가입");
            
            String socialEmail = socialUserInfo.get("EMAIL"); 
            
            // 이메일 중복 체크 (일반 가입자)
            if(socialEmail != null && !socialEmail.isEmpty() && memDAO.emailCheck(socialEmail) > 0) {
                log.warn("@# 소셜 로그인 실패: 이미 등록된 이메일 {}", socialEmail);
                return null;
            }
            
            String newNickname = socialUserInfo.get("NICKNAME");
            if(newNickname == null || newNickname.isEmpty()) {
                newNickname = socialUserInfo.get("NAME") + (System.currentTimeMillis() % 1000); 
            }
            
            if(memDAO.nicknameCheck(newNickname) > 0) {
                newNickname = newNickname + "_" + (System.currentTimeMillis() % 1000); 
            }
            
            String newMemberId = socialUserInfo.get("socialType") + "_" + socialUserInfo.get("socialId");
            
            if(newMemberId.length() > 100) { 
                newMemberId = newMemberId.substring(0, 100);
            }
            
            // ===== 회원가입 로직 시작 =====
            HashMap<String, String> registerParam = new HashMap<>();
            registerParam.put("MEMBER_ID", newMemberId);
            registerParam.put("NAME", socialUserInfo.get("NAME"));
            registerParam.put("NICKNAME", newNickname);
            registerParam.put("EMAIL", socialEmail);
            registerParam.put("SOCIAL_TYPE", socialUserInfo.get("socialType"));
            registerParam.put("SOCIAL_ID", socialUserInfo.get("socialId"));
            
            // ### 소셜 회원용 랜덤 패스워드 추가 ###
            String randomPassword = new org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder()
                                        .encode(System.currentTimeMillis() + "_" + socialUserInfo.get("socialId"));
            registerParam.put("PASSWORD", randomPassword);
            
            this.write(registerParam);
            
            // 방금 가입한 회원 정보를 다시 조회
            member = memDAO.findMemberBySocial(findParam);
            // ===== 회원가입 로직 끝 =====
            
        } 
        // 2. [Case 2: 기존 회원] member가 null이 아닐 때
        else {
            log.info("@# 기존 소셜 회원 로그인 " + member.getMemberId());
        }
        
        // 3. 최종적으로 회원 정보 반환
        return member;
    }

	@Override
	public MemDTO findUserByIdAndEmail(HashMap<String, String> param) {
		return memDAO.findUserByIdAndEmail(param);
	}

	@Override
	public void updatePassword(HashMap<String, String> param) {
		memDAO.updatePassword(param);
	}

	@Override
	public MemDTO findUserIdByEmail(String email) {
		return memDAO.findUserIdByEmail(email);
	}
}