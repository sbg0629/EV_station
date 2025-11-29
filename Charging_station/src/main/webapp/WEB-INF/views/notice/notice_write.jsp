<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page session="true" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>공지사항 작성</title>
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
            <h2 class="mb-4">공지사항 작성</h2>
            
            <form action="/notice/write" method="post">
                <div class="mb-3">
                    <label for="category" class="form-label">카테고리</label>
                    <select name="category" id="category" class="form-select" required>
                        <option value="">선택하세요</option>
                        <option value="운영">운영</option>
                        <option value="신규">신규</option>
                        <option value="점검">점검</option>
                        <option value="요금">요금</option>
                        <option value="혜택">혜택</option>
                        <option value="안내">안내</option>
                    </select>
                </div>
                
                <div class="mb-3">
                    <label for="title" class="form-label">제목</label>
                    <input type="text" name="title" id="title" class="form-control" required>
                </div>
                
                <div class="mb-3">
                    <label for="content" class="form-label">내용</label>
                    <textarea name="content" id="content" class="form-control" rows="10" required></textarea>
                </div>
                
                <div class="mb-3 form-check">
                    <input type="checkbox" name="is_fixed" id="is_fixed" value="1" class="form-check-input">
                    <label for="is_fixed" class="form-check-label">상단 고정</label>
                </div>
                
                <div class="d-flex justify-content-end">
                    <a href="/notice" class="btn btn-secondary me-2">취소</a>
                    <button type="submit" class="btn btn-primary">작성하기</button>
                </div>
            </form>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
	<jsp:include page="/WEB-INF/views/common/footer.jsp"/>
</body>
</html>

