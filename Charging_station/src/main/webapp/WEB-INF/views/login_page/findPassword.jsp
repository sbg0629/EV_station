<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>아이디/비밀번호 찾기</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
	<link href="${pageContext.request.contextPath}/css/header.css" rel="stylesheet" type="text/css">
	<link href="${pageContext.request.contextPath}/css/footer.css" rel="stylesheet" type="text/css">
	<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/font-awesome/4.6.3/css/font-awesome.min.css">
    
    <style>
        body {
            background-image: url('https://images.unsplash.com/photo-1593941707882-65c6405f5a24?q=80&w=1974&auto=format&fit=crop');
            background-size: cover;
            background-position: center center;
            background-attachment: fixed;
            
            display: flex;
            flex-direction: column;
            min-height: 100vh;
            margin: 0;
            font-family: 'Noto Sans KR', sans-serif;
        }
        
        .login-container {
            flex-grow: 1;
            display: flex;
            justify-content: center;
            align-items: center;
            padding: 40px 20px;
        }

        .login-box {
            width: 400px;
            max-width: 100%;
            
            background-color: rgba(255, 255, 255, 0.9);
            backdrop-filter: blur(10px);
            -webkit-backdrop-filter: blur(10px);
            
            padding: 40px;
            border-radius: 12px;
            box-shadow: 0 8px 32px 0 rgba(0, 0, 0, 0.15);
            border: 1px solid rgba(255, 255, 255, 0.18);
        }
        
        .login-box h2 {
            text-align: center;
            margin-bottom: 20px;
            font-weight: 700;
            color: #222;
        }
        
        .tab-buttons {
            display: flex;
            margin-bottom: 25px;
            border-bottom: 2px solid #e0e0e0;
        }
        
        .tab-button {
            flex: 1;
            padding: 12px;
            background: none;
            border: none;
            cursor: pointer;
            font-size: 1rem;
            font-weight: 500;
            color: #666;
            border-bottom: 3px solid transparent;
            transition: all 0.3s;
        }
        
        .tab-button.active {
            color: #007bff;
            border-bottom-color: #007bff;
            font-weight: 600;
        }
        
        .tab-button:hover {
            color: #007bff;
        }
        
        .tab-content {
            display: none;
        }
        
        .tab-content.active {
            display: block;
        }
        
        .login-box .btn-primary {
            width: 100%;
            padding: 12px;
            font-size: 1.1rem;
            font-weight: 500;
            background-color: #007bff;
            border: none;
        }
        .login-box .btn-primary:hover {
            background-color: #0056b3;
        }

        .register-link {
            text-align: center;
            margin-top: 20px;
        }
        .register-link a {
            color: #007bff;
            text-decoration: none;
            font-weight: 500;
        }
        .register-link a:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>
	<jsp:include page="/WEB-INF/views/common/header.jsp"/>

    <main class="login-container">
        <div class="login-box">
            <h2>아이디/비밀번호 찾기</h2>
            
            <div class="tab-buttons">
                <button type="button" class="tab-button ${type == 'id' ? 'active' : ''}" onclick="switchTab('id')">아이디 찾기</button>
                <button type="button" class="tab-button ${type == 'password' || type == '' ? 'active' : ''}" onclick="switchTab('password')">비밀번호 찾기</button>
            </div>
            
            <!-- 아이디 찾기 폼 -->
            <div id="idTab" class="tab-content ${type == 'id' ? 'active' : ''}">
                <p style="text-align: center; color: #666; margin-bottom: 25px;">
                    가입 시 사용한 이메일을 입력하세요.<br>
                    아이디가 이메일로 발송됩니다.
                </p>
            
                <form action="findIdAction" method="post">
                    <div class="mb-3">
                        <label for="email_id" class="form-label">이메일</label>
                        <input type="email" class="form-control" id="email_id" name="email" placeholder="이메일 입력 (예: user@example.com)" required>
                    </div>
            
                    <button type="submit" class="btn btn-primary">아이디 찾기</button>
                </form>
            </div>
            
            <!-- 비밀번호 찾기 폼 -->
            <div id="passwordTab" class="tab-content ${type == 'password' || type == '' ? 'active' : ''}">
                <p style="text-align: center; color: #666; margin-bottom: 25px;">
                    가입 시 사용한 아이디와 이메일을 입력하세요.<br>
                    임시 비밀번호가 이메일로 발송됩니다.
                </p>
            
                <form action="findPasswordAction" method="post">
                    <div class="mb-3">
                        <label for="MEMBER_ID" class="form-label">아이디</label>
                        <input type="text" class="form-control" id="MEMBER_ID" name="MEMBER_ID" placeholder="아이디 입력" required>
                    </div>
            
                    <div class="mb-3">
                        <label for="email_pw" class="form-label">이메일</label>
                        <input type="email" class="form-control" id="email_pw" name="email" placeholder="이메일 입력 (예: user@example.com)" required>
                    </div>
            
                    <button type="submit" class="btn btn-primary">임시 비밀번호 발송</button>
                </form>
            </div>
        
            <div class="register-link">
                <p><a href="login">로그인 페이지로 돌아가기</a></p>
            </div>
        </div>
    </main>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function switchTab(type) {
            // 탭 버튼 활성화
            document.querySelectorAll('.tab-button').forEach(btn => {
                btn.classList.remove('active');
            });
            document.querySelectorAll('.tab-content').forEach(content => {
                content.classList.remove('active');
            });
            
            if (type === 'id') {
                document.querySelector('.tab-button:first-child').classList.add('active');
                document.getElementById('idTab').classList.add('active');
            } else {
                document.querySelector('.tab-button:last-child').classList.add('active');
                document.getElementById('passwordTab').classList.add('active');
            }
        }
    </script>
    
<jsp:include page="/WEB-INF/views/common/footer.jsp"/>
</body>
</html>
