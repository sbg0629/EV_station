<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %> 
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8" />
    <title>정보 수정 </title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/css/header.css" rel="stylesheet" type="text/css">
    <link href="${pageContext.request.contextPath}/css/footer.css" rel="stylesheet" type="text/css">
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/font-awesome/4.6.3/css/font-awesome.min.css">
    <style>
        body {
            background-color: #f8f9fa;
        }
        .container {
            max-width: 600px;
            margin-top: 80px; /* 상단 여백 */
            background: white;
            padding: 40px;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }

        /* --- mypage_edit.jsp 고유 스타일 --- */
        .container h2 {
            text-align: center;
            margin-bottom: 30px;
        }
        .container button, .container input[type="submit"] {
            width: 100%;
            margin-top: 10px;
        }
        .form-label {
            margin-bottom: .25rem;
            font-weight: 500;
        }
        .validation-msg {
            font-size: 0.875rem;
            margin-top: 5px;
        }
        .validation-msg.success {
            color: green;
        }
        .validation-msg.fail {
            color: red;
        }
    </style>
</head>
<body>
	<jsp:include page="/WEB-INF/views/common/header.jsp"/>
    <div class="container">
        <h2>정보 수정</h2>
        
        <form id="registerForm" action="modify" method="post">
            <input type="hidden" name="memberId" value="${user.memberId}" />

            <div class="mb-3">
                <label for="nickname" class="form-label">닉네임</label>
                <input type="text" class="form-control" id="nickname" name="nickname" value="${user.nickname}">
				<span id="nicknameMsg" class="validation-msg"></span>
            </div>

            <div class="mb-3">
                <label for="name" class="form-label">이름</label>
                <input type="text" class="form-control" id="name" name="name" value="${user.name}">
            </div>
			
            <div class="mb-3">
                <label for="password" class="form-label">비밀번호</label>
                <input type="password" class="form-control" id="password" name="password" value="${user.password}">
            </div>

            <div class="mb-3">
                <label for="email" class="form-label">이메일</label>
                <input type="email" class="form-control" id="email" name="email" value="${user.email}">
				<span id="emailMsg" class="validation-msg"></span>
            </div>

            <div class="mb-3">
                <label for="phoneNumber" class="form-label">전화번호</label>
                <input type="text" class="form-control" id="phoneNumber" name="phoneNumber" value="${user.phoneNumber}">
				<span id="phoneMsg" class="validation-msg"></span>
            </div>
            
			<div class="mb-3">
			    <label for="birthdate" class="form-label">생년월일</label>
			    <input type="date" class="form-control" id="birthdate" name="birthdate"
			           value="<fmt:formatDate value='${user.birthdate}' pattern='yyyy-MM-dd'/>" />
			</div>

            <input type="submit" class="btn btn-primary" value="수정 완료" />
            
            <button type="button" class="btn btn-secondary" onclick="location.href='list'">취소</button>
        </form>
    </div>

	<script>
			// 1. [수정됨] 페이지 로드 시 원본 값을 JS 변수에 저장
	        const originalValues = {
	            nickname: "${user.nickname}",
	            email: "${user.email}",
	            phone: "${user.phoneNumber}"
	        };

	        // 2. [수정됨] 유효성 상태를 true(유효함)로 초기화
	        const validationStatus = {
	            nickname: true,
	            email: true,
	            phone: true
	        };

			// 3. [수정됨] checkDuplicate 함수 로직 전체 수정
	        async function checkDuplicate(fieldType, value) {
	            const msgElement = document.getElementById(fieldType + 'Msg');
	            const memberId = document.getElementsByName("memberId")[0].value;
				const originalValue = originalValues[fieldType]; // 원본 값 가져오기

	            // 메시지 초기화
	            msgElement.textContent = ''; 

	            // 3-1. 값이 비어있으면 (필수 입력 항목)
	            if (!value.trim()) {
	                msgElement.className = 'validation-msg fail';
	                msgElement.textContent = '필수 입력 항목입니다.';
	                validationStatus[fieldType] = false;
	                return;
	            }

	            // 3-2. [핵심] 값이 원본 값과 동일하면, 검사 불필요 (무조건 통과)
	            if (value === originalValue) {
	                validationStatus[fieldType] = true;
	                return; // fetch 요청 안 함
	            }

	            // 3-3. 값이 변경되었을 때만 fetch로 중복 검사
	            const formData = new URLSearchParams({ fieldType, value, memberId });

	            try {
	                const response = await fetch('checkDuplicate', {
	                    method: 'POST',
	                    body: formData
	                });
	                const result = await response.text();

	                let message = '';
	                if (result === 'SUCCESS') {
	                    validationStatus[fieldType] = true;
	                    msgElement.className = 'validation-msg success';
	                    message = fieldType === 'nickname' ? '멋진 닉네임이네요!' :
	                              fieldType === 'email' ? '사용 가능한 이메일입니다.' :
	                              '사용 가능한 전화번호입니다.';
	                } else {
	                    validationStatus[fieldType] = false;
	                    msgElement.className = 'validation-msg fail';
	                    message = fieldType === 'nickname' ? '이미 사용 중인 닉네임입니다.' :
	                              fieldType === 'email' ? '이미 등록된 이메일입니다.' :
	                              '이미 등록된 전화번호입니다.';
	                }
	                msgElement.textContent = message;
	            } catch (error) {
	                console.error('Error:', error);
	                msgElement.className = 'validation-msg fail';
	                msgElement.textContent = '확인 중 오류가 발생했습니다.';
	F        }
	        }

	        // (이하 이벤트 리스너들은 수정할 필요 없음)
	        document.getElementById('nickname').addEventListener('blur', (e) => checkDuplicate('nickname', e.target.value));
	        document.getElementById('email').addEventListener('blur', (e) => checkDuplicate('email', e.target.value));
	        document.getElementById('phoneNumber').addEventListener('blur', (e) => checkDuplicate('phone', e.target.value));

	        document.getElementById('registerForm').addEventListener('submit', function(e) {
	            const checks = [
	                {key: 'nickname', name: '닉네임', element: 'nickname'},
	                {key: 'email', name: '이메일', element: 'email'},
	                {key: 'phone', name: '전화번호', element: 'phoneNumber'}
	            ];

	            for (const check of checks) {
	                if (!validationStatus[check.key]) {
	                    e.preventDefault();
	                    alert(`${check.name} 중복 확인이 필요하거나, 사용할 수 없는 값입니다.`);
	                    document.getElementById(check.element).focus();
	                    return;
	                }
	            }
	        });
	    </script>
	<jsp:include page="/WEB-INF/views/common/footer.jsp"/>
</body>
</html>
