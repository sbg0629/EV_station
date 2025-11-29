package com.boot.login.controller;

import java.util.ArrayList;
import java.util.HashMap;

import javax.mail.internet.MimeMessage;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper; // [1] MimeMessageHelper Import 추가
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.boot.login.dto.MemDTO;
import com.boot.login.google.dto.GoogleUserInfo;
import com.boot.login.google.service.GoogleOAuthService;
import com.boot.login.kakao.dto.KakaoUserInfo;
import com.boot.login.kakao.service.KakaoOAuthService;
import com.boot.login.naver.dto.NaverUserInfo;
import com.boot.login.naver.service.NaverOAuthService;
import com.boot.login.service.MemService;


import lombok.extern.slf4j.Slf4j;

@Controller
@Slf4j
public class MemController {

    @Autowired
    private MemService memService;

	@Autowired
	private NaverOAuthService naverOAuthService;

	@Autowired
	private GoogleOAuthService googleOAuthService;

    // 카카오 서비스 주입 추가
    @Autowired
    private KakaoOAuthService kakaoOAuthService;

    @Autowired
    private JavaMailSender mailSender; // JavaMailSender 주입
    
    @Value("${spring.mail.username}")
    private String mailFrom; // 발신자 이메일 주소

    // 로그인 화면
    @RequestMapping("/login")
    public String login() {
        log.info("@# GET /login");
        return "login_page/login"; 
    }
    
    @RequestMapping("/home")
    public String home() {
        return "home"; // home.jsp를 리턴
    }

    // 로그인 확인
    @RequestMapping("/login_yn")
    public String login_yn(HttpServletRequest request) { 
        String id = request.getParameter("MEMBER_ID"); 
        String pw = request.getParameter("PASSWORD"); 

        log.info("@# POST /login_yn: MEMBER_ID={}, PASSWORD={}", id, pw);
        
        // ⚠️ HashMap 사용 중단 및 올바른 서비스 메서드 호출
        // HashMap<String, String> param = new HashMap<>(); 
        // param.put("MEMBER_ID", id);
        // param.put("PASSWORD", pw);
        
        // ✅ 1. BCrypt 검증 로직이 포함된 서비스 메서드 호출
        MemDTO loginUser = memService.loginCheck(id, pw);

        // ✅ 2. 반환 타입에 맞게 조건문 수정
        if (loginUser == null) {
            request.setAttribute("msg", "아이디 또는 비밀번호가 잘못 되었습니다.");
            request.setAttribute("url", "login"); 
            return "login_page/alert"; 
        } else {
            HttpSession session = request.getSession();
            
            session.setAttribute("id", loginUser.getMemberId());
            session.setAttribute("name", loginUser.getName());
            session.setAttribute("admin", loginUser.getAdminck());

            return "redirect:/home"; 
        }
    }

    // 로그인 성공 페이지
    @RequestMapping("/login_ok")
    public String login_ok(HttpSession session) {
        log.info("@# GET /login_ok, session ID: " + session.getAttribute("id"));
        if (session.getAttribute("id") == null) {
            return "redirect:/login";
        }
        return "login_page/login_ok"; 
    }

    // 회원가입 화면
    @RequestMapping("/register")
    public String register() {
        log.info("@# GET /register");
        return "login_page/register"; 
    }

    @PostMapping("/checkDuplicate")
    @ResponseBody 
    public String checkDuplicate(@RequestParam("fieldType") String fieldType, @RequestParam("value") String value) {
        log.info("@# POST /checkDuplicate: fieldType={}, value={}", fieldType, value);
        int count = 0;

        switch (fieldType) {
            case "id": count = memService.idCheck(value); break;
            case "nickname": count = memService.nicknameCheck(value); break;
            case "email": count = memService.emailCheck(value); break;
            case "phone": count = memService.phoneCheck(value); break;
        }

        return (count == 0) ? "SUCCESS" : "FAIL";
    }

    @RequestMapping("/registerOk")
    public String registerOk(@RequestParam HashMap<String, String> param, HttpSession session, HttpServletRequest request) {
        log.info("@# POST /registerOk: " + param);

        if (memService.idCheck(param.get("MEMBER_ID")) > 0) {
            request.setAttribute("msg", "이미 사용 중인 아이디입니다.");
            request.setAttribute("url", "register");
            return "login_page/alert";
        }
        // ... (다른 중복 검사)

        memService.write(param); 

        session.setAttribute("id", param.get("MEMBER_ID"));
        session.setAttribute("name", param.get("NAME"));
        session.setAttribute("admin", 0); 
        
        return "redirect:/home"; // 회원가입 성공 시 이동할 페이지
    }

    @RequestMapping("/logout")
    public String logout(HttpServletRequest request) {
        log.info("@# GET /logout");
        HttpSession session = request.getSession(false);
        if (session != null) {
            session.invalidate();
        } 
        return "redirect:/home";
    }

 // 구글 소셜 로그인 콜백
	@RequestMapping("/login/oauth2/code/google")
	public String googleCallback(@RequestParam String code, HttpServletRequest request) {
		log.info("@# GET /login/oauth2/code/google, code={}", code);

		try {
			String accessToken = googleOAuthService.getGoogleAccessToken(code);
			GoogleUserInfo googleUserInfo = googleOAuthService.getGoogleUserInfo(accessToken);

			HashMap<String, String> userInfo = new HashMap<>();
			userInfo.put("socialType", "google");
			userInfo.put("socialId", googleUserInfo.getId());
			userInfo.put("EMAIL", googleUserInfo.getEmail());
			userInfo.put("NAME", googleUserInfo.getName());

			String nickname = googleUserInfo.getName();
			if (nickname == null || nickname.trim().isEmpty()) {
				nickname = googleUserInfo.getEmail().split("@")[0];
			}
			userInfo.put("NICKNAME", nickname);

			MemDTO socialMember = memService.findOrCreateMember(userInfo);

			if (socialMember == null) {
				request.setAttribute("msg", "이미 해당 이메일로 가입된 계정이 있습니다.");
				request.setAttribute("url", "login");
				return "login_page/alert";
			}

			HttpSession session = request.getSession();
			session.setAttribute("id", socialMember.getMemberId());
			session.setAttribute("name", socialMember.getName());
			session.setAttribute("admin", socialMember.getAdminck());

			return "redirect:/home";

		} catch (Exception e) {
			log.error("@# 구글 로그인 처리 중 예외 발생: {}", e.getMessage());
			request.setAttribute("msg", "소셜 로그인 중 오류가 발생했습니다. 관리자에게 문의하세요.");
			request.setAttribute("url", "login");
			return "login_page/alert";
		}
	}
	
	
	
	// 카카오 소셜 로그인 콜백 (최종 수정)
     @RequestMapping("/oauth2/callback/kakao")
     public String kakaoCallback(@RequestParam String code, HttpServletRequest request) {
         log.info("@# GET /login/oauth2/code/kakao, code={}", code);

         try {
             // 1. 카카오 액세스 토큰을 가져옴
             String accessToken = kakaoOAuthService.getKakaoAccessToken(code);
             
             // 2. 액세스 토큰으로 사용자 정보 요청
             KakaoUserInfo kakaoUserInfo = kakaoOAuthService.getKakaoUserInfo(accessToken); 

             // 3. 소셜 사용자 정보 저장 (DB에 전달할 데이터)
             HashMap<String, String> userInfo = new HashMap<>();
             userInfo.put("socialType", "kakao");
             
             // Long 타입의 ID를 String으로 변환
             userInfo.put("socialId", String.valueOf(kakaoUserInfo.getId())); 
             
             // ******************** EMAIL 처리 ********************
             // DB의 NOT NULL 제약조건을 제거했으므로, null 값을 그대로 전달합니다.
             // MyBatis에서 TypeException 방지를 위해 매퍼 파일에 jdbcType=VARCHAR 명시가 필요합니다.
             String email = kakaoUserInfo.getEmail();
             userInfo.put("EMAIL", email); 
             // ****************************************************
             
             userInfo.put("NAME", kakaoUserInfo.getName()); 
             
             // ******************** NICKNAME 로직 개선 ********************
             String nickname = kakaoUserInfo.getName(); 
             if (nickname == null || nickname.trim().isEmpty()) {
                 if (email != null && !email.trim().isEmpty()) {
                     // 이메일이 있을 경우 이메일 앞부분 사용
                     nickname = email.split("@")[0]; 
                 } else {
                     // 이메일도 null/empty일 경우 고유한 닉네임 생성 (충돌 방지)
                     nickname = "kakao_user_" + kakaoUserInfo.getId(); 
                 }
             }
             userInfo.put("NICKNAME", nickname);
             // ****************************************************

             // 4. 사용자 정보로 DB에 저장 또는 로그인 처리
             MemDTO socialMember = memService.findOrCreateMember(userInfo);

             // 이미 등록된 이메일이 있을 경우 (또는 로직상 오류 발생 시)
             if (socialMember == null) {
                 request.setAttribute("msg", "이미 해당 이메일로 가입된 계정이 있습니다.");
                 request.setAttribute("url", "login");
                 return "login_page/alert";
             }

             // 5. 세션에 사용자 정보 저장
             HttpSession session = request.getSession();
             session.setAttribute("id", socialMember.getMemberId());
             session.setAttribute("name", socialMember.getName());
             session.setAttribute("admin", socialMember.getAdminck());

             return "redirect:/home";

         } catch (Exception e) {
             log.error("@# 카카오 로그인 처리 중 예외 발생: {}", e.getMessage());
             request.setAttribute("msg", "소셜 로그인 중 오류가 발생했습니다. 관리자에게 문의하세요.");
             request.setAttribute("url", "login");
             return "login_page/alert";
         }
     }


	// 네이버 소셜 로그인 콜백
	@RequestMapping("/login/oauth2/code/naver")
	public String naverCallback(@RequestParam String code, HttpServletRequest request) {
		log.info("@# GET /login/oauth2/code/naver, code={}", code);

		try {
			// 1. 네이버 액세스 토큰을 가져옴
			String accessToken = naverOAuthService.getNaverAccessToken(code);

			// 2. 액세스 토큰으로 사용자 정보 요청
			NaverUserInfo naverUserInfo = naverOAuthService.getNaverUserInfo(accessToken);

			// 3. 소셜 사용자 정보 저장
			HashMap<String, String> userInfo = new HashMap<>();
			userInfo.put("socialType", "naver");
			userInfo.put("socialId", naverUserInfo.getId());
			userInfo.put("EMAIL", naverUserInfo.getEmail());
			userInfo.put("NAME", naverUserInfo.getName());

			// 닉네임이 비어있다면, 이메일에서 추출
			String nickname = naverUserInfo.getName();
			if (nickname == null || nickname.trim().isEmpty()) {
				nickname = naverUserInfo.getEmail().split("@")[0];
			}
			userInfo.put("NICKNAME", nickname);

			// 4. 사용자 정보로 DB에 저장 또는 로그인 처리
			MemDTO socialMember = memService.findOrCreateMember(userInfo);

			// 이미 등록된 이메일이 있을 경우
			if (socialMember == null) {
				request.setAttribute("msg", "이미 해당 이메일로 가입된 계정이 있습니다.");
				request.setAttribute("url", "login");
				return "login_page/alert";
			}

			// 5. 세션에 사용자 정보 저장
			HttpSession session = request.getSession();
			session.setAttribute("id", socialMember.getMemberId());
			session.setAttribute("name", socialMember.getName());
			session.setAttribute("admin", socialMember.getAdminck());

			return "redirect:/home"; // 홈으로 리디렉션

		} catch (Exception e) {
			log.error("@# 네이버 로그인 처리 중 예외 발생: {}", e.getMessage());
			request.setAttribute("msg", "소셜 로그인 중 오류가 발생했습니다. 관리자에게 문의하세요.");
			request.setAttribute("url", "login");
			return "login_page/alert";
		}
	}

    // [4] 아이디/비밀번호 찾기 기능
    
    /**
     * 아이디/비밀번호 찾기 페이지로 이동
     */
    @RequestMapping("/findPassword")
    public String findPassword(@RequestParam(value = "type", defaultValue = "password") String type, Model model) {
        log.info("@# GET /findPassword type={}", type);
        model.addAttribute("type", type);
        return "login_page/findPassword";
    }
    
    /**
     * 아이디 찾기 폼 처리 (이메일로 아이디 찾기)
     */
    @PostMapping("/findIdAction")
    public String findIdAction(@RequestParam("email") String email, HttpServletRequest request) {
        log.info("@# POST /findIdAction => Email: {}", email);
        
        MemDTO user = memService.findUserIdByEmail(email);
        
        if(user == null) {
            request.setAttribute("msg", "일치하는 회원 정보가 없습니다.\\n이메일을 확인해주세요.");
            request.setAttribute("url", "findPassword?type=id");
            return "login_page/alert";
        } else {
            // 이메일로 아이디 발송
            boolean emailSent = false;
            try {
                // [변경] SimpleMailMessage 대신 MimeMessage 사용 (HTML 전송을 위해)
                MimeMessage message = mailSender.createMimeMessage();
                MimeMessageHelper helper = new MimeMessageHelper(message, true, "UTF-8");
                
                helper.setTo(email);
                helper.setFrom(mailFrom);
                helper.setSubject("[아이디 안내] EV Charge 요청하신 회원 아이디입니다.");
                
                // EV 충전소 테마 HTML 콘텐츠
                String mailContentId =
                    "<div style='font-family: \"Noto Sans KR\", sans-serif; text-align: center; max-width: 600px; margin: 0 auto; padding: 40px; border: 1px solid #e0e0e0; border-radius: 12px; box-shadow: 0 4px 8px rgba(0,0,0,0.05); background-color: #ffffff;'>" +
                    "  <h1 style='color: #2a7fe6; font-size: 30px; margin-bottom: 5px;'>🔌 EV Charge</h1>" +
                    "  <h2 style='font-size: 22px; color: #333; margin-top: 10px; margin-bottom: 30px; border-bottom: 2px solid #2a7fe6; display: inline-block; padding-bottom: 5px;'>요청하신 회원 아이디 안내</h2>" +
                    "  <p style='font-size: 18px; color: #555; margin-top: 20px;'>회원님께서 요청하신 아이디 정보입니다.</p>" +
                    "  <p style='font-size: 18px; color: #555;'>아래 아이디로 로그인 후 서비스를 이용해주세요.</p>" +
                    "  <div style='background-color: #f7f9fc; padding: 25px 0; margin: 40px 0; border-radius: 10px; border: 1px solid #dcdcdc;'>" +
                    "    <p style='font-size: 18px; color: #888; margin: 0;'>회원 아이디</p>" +
                    "    <strong style='font-size: 28px; color: #000000; letter-spacing: 1px; display: block; margin-top: 5px;'>" + user.getMemberId() + "</strong>" +
                    "  </div>" +
                    "  <a href='/login' style='display: inline-block; padding: 12px 25px; margin-top: 20px; background-color: #2a7fe6; color: #ffffff; text-decoration: none; border-radius: 6px; font-weight: bold; font-size: 16px;'>로그인 페이지로 이동</a>" +
                    "  <p style='font-size: 14px; color: #888; margin-top: 30px;'>궁금한 점은 고객센터로 문의해주세요.</p>" +
                    "</div>";
                
                helper.setText(mailContentId, true); // 두 번째 인자를 true로 설정하여 HTML Content임을 명시
                
                mailSender.send(message);
                emailSent = true;
                log.info("아이디 이메일 발송 성공: {} -> {}", mailFrom, email);
                
            } catch (Exception e) {
                log.error("이메일 발송 중 오류 발생: {}", e.getMessage(), e);
                emailSent = false;
            }
            
            if (emailSent) {
                request.setAttribute("msg", "가입하신 이메일로 아이디가 발송되었습니다.");
                request.setAttribute("url", "login");
            } else {
                request.setAttribute("msg", "이메일 발송에 실패했습니다.\\n관리자에게 문의해주세요.\\n(아이디: " + user.getMemberId() + ")");
                request.setAttribute("url", "login");
            }
            return "login_page/alert";
        }
    }

    /**
     * 비밀번호 찾기 폼 처리 (메일 발송)
     */
    @PostMapping("/findPasswordAction")
    public String findPasswordAction(@RequestParam("MEMBER_ID") String memberId,
                                     @RequestParam("email") String email, HttpServletRequest request) {
        
        // (로그 형식 수정: {} 사용)
        log.info("@# POST /findPasswordAction => ID: {}, Email: {}", memberId, email);
        
        HashMap<String, String> params = new HashMap<>();
        params.put("MEMBER_ID", memberId);
        params.put("email", email);
        
        MemDTO user = memService.findUserByIdAndEmail(params);
        
        if(user == null) {
            // [수정] 자바스크립트 줄바꿈 오류 방지를 위해 \n 대신 \\n 사용
            request.setAttribute("msg", "일치 하는 회원 정보가 없습니다.\\n아이디 또는 이메일이 올바르지 않습니다.");
            request.setAttribute("url", "findPassword");
            return "login_page/alert";
            
        } else {
            // 1. 임시 비밀번호 생성
            String tempPassword = getTempPassword(8);
            
            // 2. DB에 임시 비밀번호로 업데이트
            HashMap<String , String> updateParams = new HashMap<>();
            updateParams.put("MEMBER_ID", memberId);
            updateParams.put("PASSWORD", tempPassword); // [보안] 추후 이 부분을 암호화해서 저장해야 합니다.
            
            memService.updatePassword(updateParams);
            
            // 3. 실제 이메일 발송
            boolean emailSent = false;
            try {
                // [변경] SimpleMailMessage 대신 MimeMessage 사용 (HTML 전송을 위해)
                MimeMessage message = mailSender.createMimeMessage();
                MimeMessageHelper helper = new MimeMessageHelper(message, true, "UTF-8");
                
                helper.setTo(email); // 수신자 이메일
                helper.setFrom(mailFrom); // 발신자 이메일 (application.properties에서 주입)
                helper.setSubject("[임시 비밀번호 안내] EV Charge 요청하신 임시 비밀번호입니다."); // 메일 제목
                
                // EV 충전소 테마 HTML 콘텐츠
                String mailContentTempPassword =
                    "<div style='font-family: \"Noto Sans KR\", sans-serif; text-align: center; max-width: 600px; margin: 0 auto; padding: 40px; border: 1px solid #e0e0e0; border-radius: 12px; box-shadow: 0 4px 8px rgba(0,0,0,0.05); background-color: #ffffff;'>" +
                    "  <h1 style='color: #2a7fe6; font-size: 30px; margin-bottom: 5px;'>🔋 EV Charge 보안 알림</h1>" +
                    "  <h2 style='font-size: 22px; color: #333; margin-top: 10px; margin-bottom: 30px; border-bottom: 2px solid #2a7fe6; display: inline-block; padding-bottom: 5px;'>임시 비밀번호 발급 안내</h2>" +
                    "  <p style='font-size: 18px; color: #555; margin-top: 20px;'>요청하신 임시 비밀번호가 발급되었습니다.</p>" +
                    "  <p style='font-size: 18px; color: #ff6f61; font-weight: bold; margin-bottom: 10px;'>🚨 보안을 위해 로그인 후 반드시 비밀번호를 변경해주세요! 🚨</p>" +
                    "  <div style='background-color: #fffaf7; padding: 25px 0; margin: 40px 0; border-radius: 10px; border: 1px solid #ff6f61;'>" +
                    "    <p style='font-size: 18px; color: #888; margin: 0;'>임시 비밀번호</p>" +
                    "    <strong style='font-size: 28px; color: #ff6f61; letter-spacing: 2px; display: block; margin-top: 5px;'>" + tempPassword + "</strong>" +
                    "  </div>" +
                    "  <a href='/login' style='display: inline-block; padding: 12px 25px; margin-top: 20px; background-color: #2a7fe6; color: #ffffff; text-decoration: none; border-radius: 6px; font-weight: bold; font-size: 16px;'>로그인하여 비밀번호 변경하기</a>" +
                    "  <p style='font-size: 14px; color: #888; margin-top: 30px;'>이 메일은 비밀번호 찾기를 요청하신 분께만 발송됩니다.</p>" +
                    "</div>";
                
                helper.setText(mailContentTempPassword, true); // HTML Content임을 명시

                mailSender.send(message); // 발송
                
                emailSent = true;
                log.info("임시 비밀번호 이메일 발송 성공: {} -> {}", mailFrom, email);

            } catch (Exception e) {
                log.error("이메일 발송 중 오류 발생: {}", e.getMessage(), e);
                emailSent = false;
            }
            
            // 4. 완료 알림
            if (emailSent) {
                // [수정] 자바스크립트 줄바꿈 오류 방지를 위해 \n 대신 \\n 사용
                request.setAttribute("msg", "가입하신 이메일로 임시 비밀번호가 발송되었습니다.\\n로그인 후 비밀번호를 변경해주세요.");
                request.setAttribute("url","login");
            } else {
                // 이메일 발송 실패 시 오류 메시지
                request.setAttribute("msg", "임시 비밀번호는 생성되었으나 이메일 발송에 실패했습니다.\\n관리자에게 문의해주세요.\\n(임시 비밀번호: " + tempPassword + ")");
                request.setAttribute("url","login");
            }
            return "login_page/alert";
        }
    }
    
    /**
     * 임시 비밀번호 생성기 (Helper Method)
     */
    private String getTempPassword(int length) {
        char[] charSet = new char[] {
                '0', '1', '2', '3', '4', '5', '6', '7', '8', '9',
                'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 
                'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z'};
        
        String str ="";
        int idx = 0;
        for(int i = 0; i < length; i++) {
            idx = (int)(charSet.length * Math.random());
            str += charSet[idx];
        }
        return str;
    }
}