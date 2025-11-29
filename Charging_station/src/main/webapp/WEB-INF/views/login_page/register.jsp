<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>회원가입</title>
    <link href="${pageContext.request.contextPath}/css/header.css" rel="stylesheet" type="text/css">
    <link href="${pageContext.request.contextPath}/css/footer.css" rel="stylesheet" type="text/css">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/font-awesome/4.6.3/css/font-awesome.min.css">
    <style>
        body {
            background-color: #f8f9fa;
        }
        .container {
            max-width: 600px;
            margin-top: 80px;
            background: white;
            padding: 40px;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
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
        <h2 class="text-center mb-4">회원가입</h2>
        <form id="registerForm" action="registerOk" method="post">
            <div class="mb-3">
                <label class="form-label">아이디</label>
                <input type="text" class="form-control" id="memberId" name="MEMBER_ID" required>
                <span id="idMsg" class="validation-msg"></span>
            </div>
            <div class="mb-3">
                <label class="form-label">비밀번호</label>
                <input type="password" class="form-control" name="PASSWORD" required>
            </div>
            <div class="mb-3">
                <label class="form-label">이름</label>
                <input type="text" class="form-control" name="NAME" required>
            </div>
            <div class="mb-3">
                <label class="form-label">닉네임</label>
                <input type="text" class="form-control" id="nickname" name="NICKNAME" required>
                <span id="nicknameMsg" class="validation-msg"></span>
            </div>
            <div class="mb-3">
                <label class="form-label">이메일</label>
                <input type="email" class="form-control" id="email" name="EMAIL" required>
                <span id="emailMsg" class="validation-msg"></span>
            </div>
            <div class="mb-3">
                <label class="form-label">전화번호</label>
                <input type="text" class="form-control" id="phoneNumber" name="PHONE_NUMBER" placeholder="-없이 입력해주세요">
                <span id="phoneMsg" class="validation-msg"></span>
            </div>
            <div class="mb-3">
                <label class="form-label">생년월일</label>
                <input type="date" class="form-control" name="BIRTHDATE">
            </div>
            <button type="submit" class="btn btn-success w-100">회원가입</button>
        </form>

        <div class="text-center mt-3">
            <a href="login">이미 계정이 있으신가요? 로그인</a>
        </div>
    </div>

    <script>
        const validationStatus = {
            id: false,
            nickname: false,
            email: false,
            phone: false
        };

        async function checkDuplicate(fieldType, value) {
            const msgElement = document.getElementById(fieldType + 'Msg');
            if (!value.trim()) {
                msgElement.textContent = '';
                validationStatus[fieldType] = false;
                return;
            }

            const formData = new URLSearchParams({ fieldType, value });

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
                    if (fieldType === 'id') message = '사용 가능한 아이디입니다.';
                    else if (fieldType === 'nickname') message = '멋진 닉네임이네요!';
                    else if (fieldType === 'email') message = '사용 가능한 이메일입니다.';
                    else if (fieldType === 'phone') message = '사용 가능한 전화번호입니다.';
                } else {
                    validationStatus[fieldType] = false;
                    msgElement.className = 'validation-msg fail';
                    if (fieldType === 'id') message = '이미 사용 중인 아이디입니다.';
                    else if (fieldType === 'nickname') message = '이미 사용 중인 닉네임입니다.';
                    else if (fieldType === 'email') message = '이미 등록된 이메일입니다.';
                    else if (fieldType === 'phone') message = '이미 등록된 전화번호입니다.';
                }
                msgElement.textContent = message;
            } catch (error) {
                console.error('Error:', error);
                msgElement.className = 'validation-msg fail';
                msgElement.textContent = '확인 중 오류가 발생했습니다.';
            }
        }

        document.getElementById('memberId').addEventListener('blur', (e) => checkDuplicate('id', e.target.value));
        document.getElementById('nickname').addEventListener('blur', (e) => checkDuplicate('nickname', e.target.value));
        document.getElementById('email').addEventListener('blur', (e) => checkDuplicate('email', e.target.value));
        document.getElementById('phoneNumber').addEventListener('blur', (e) => checkDuplicate('phone', e.target.value));

        document.getElementById('registerForm').addEventListener('submit', function(e) {
            const checks = [
                {key: 'id', name: '아이디', element: 'memberId'}, 
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
