<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page session="true" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>공지사항 수정</title>
	<link href="${pageContext.request.contextPath}/css/header.css" rel="stylesheet" type="text/css">
	<link href="${pageContext.request.contextPath}/css/footer.css" rel="stylesheet" type="text/css">

	<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
	<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/font-awesome/4.6.3/css/font-awesome.min.css">
    <style>
        body {
            background-color: #f5f5f5;
        }
        .notice-container {
            max-width: 1000px;
            margin: 50px auto;
            padding: 20px;
        }
        .notice-form {
            background: white;
            border-radius: 8px;
            padding: 30px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }
    </style>
</head>
<body>
	<jsp:include page="/WEB-INF/views/common/header.jsp"/>    
    <div class="notice-container">
        <div class="notice-form">
            <h2 class="mb-4">공지사항 수정</h2>
            
            <form action="/notice/modify" method="post" id="modifyForm">
                <input type="hidden" name="notice_id" value="${notice.noticeId}">
                
                <div class="mb-3">
                    <label for="category" class="form-label">카테고리</label>
                    <select name="category" id="category" class="form-select" required>
                        <option value="운영" <c:if test="${notice.category == '운영'}">selected</c:if>>운영</option>
                        <option value="신규" <c:if test="${notice.category == '신규'}">selected</c:if>>신규</option>
                        <option value="점검" <c:if test="${notice.category == '점검'}">selected</c:if>>점검</option>
                        <option value="요금" <c:if test="${notice.category == '요금'}">selected</c:if>>요금</option>
                        <option value="혜택" <c:if test="${notice.category == '혜택'}">selected</c:if>>혜택</option>
                        <option value="안내" <c:if test="${notice.category == '안내'}">selected</c:if>>안내</option>
                    </select>
                </div>
                
                <div class="mb-3">
                    <label for="title" class="form-label">제목</label>
                    <input type="text" name="title" id="title" class="form-control" value="${notice.title}" required>
                </div>
                
                <div class="mb-3">
                    <label for="content" class="form-label">내용</label>
                    <textarea name="content" id="content" class="form-control" rows="10" required>${notice.content}</textarea>
                </div>
                
                <div class="mb-3 form-check">
                    <!-- hidden input: 체크박스가 해제되면 0을 전송 -->
                    <input type="hidden" name="is_fixed" id="is_fixed_hidden" value="0">
                    <input type="checkbox" name="is_fixed" id="is_fixed" value="1" class="form-check-input"
                           <c:if test="${notice.isFixed == 1}">checked</c:if>>
                    <label for="is_fixed" class="form-check-label">상단 고정</label>
                </div>
                
                <div class="d-flex justify-content-end">
                    <a href="/notice/detail?noticeId=${notice.noticeId}" class="btn btn-secondary me-2">취소</a>
                    <button type="submit" class="btn btn-primary">수정하기</button>
                </div>
            </form>
            
            <script>
                document.getElementById('modifyForm').addEventListener('submit', function(e) {
                    var checkbox = document.getElementById('is_fixed');
                    var hidden = document.getElementById('is_fixed_hidden');
                    
                    // 체크박스가 체크되어 있으면 hidden을 비활성화하여 체크박스 값(1) 사용
                    // 체크박스가 해제되어 있으면 hidden을 활성화하여 hidden 값(0) 사용
                    if (checkbox.checked) {
                        hidden.disabled = true; // 체크박스의 value="1" 사용
                    } else {
                        hidden.disabled = false; // hidden의 value="0" 사용
                    }
                });
            </script>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
	<jsp:include page="/WEB-INF/views/common/footer.jsp"/>
</body>
</html>

