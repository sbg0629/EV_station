package com.boot.login.dto;

import java.sql.Date;
import lombok.Data;

@Data
public class MemDTO {

    private String memberId;      // 회원 ID (PK)
    private String name;          // 이름
    private String password;      // 비밀번호
    private String nickname;      // 닉네임
    private String email;         // 이메일
    private String phoneNumber;   // 전화번호
    private Date birthdate;       // 생년월일
    private Date joinDate;        // 가입일
    private int adminck;          // 관리자 여부 (0=일반, 1=관리자)
    private String socialType;    // 소셜 로그인 타입 (예: google, kakao 등)
    private String socialId;      // 소셜 로그인 ID
    
    
    
}
