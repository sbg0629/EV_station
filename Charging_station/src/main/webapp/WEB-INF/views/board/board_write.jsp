<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page session="true" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>게시글 작성</title>
	<link href="${pageContext.request.contextPath}/css/header.css" rel="stylesheet" type="text/css">
	<link href="${pageContext.request.contextPath}/css/footer.css" rel="stylesheet" type="text/css">

	<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
	<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/font-awesome/4.6.3/css/font-awesome.min.css">
    <link href="${pageContext.request.contextPath}/css/board.css" rel="stylesheet" type="text/css">
    
</head>
<body>
	<jsp:include page="/WEB-INF/views/common/header.jsp"/>    
    <div class="board-container">
        <div class="board-form">
            <h2 class="mb-4">게시글 작성</h2>
            
            <form action="${pageContext.request.contextPath}/board/write" method="post">
                <div class="mb-3">
           
                    <label for="title" class="form-label">제목</label>
                    <input type="text" name="title" id="title" class="form-control" required>
                </div>
                
                <div class="mb-3">
               
                    <label for="content" class="form-label">내용</label>
                    <textarea name="content" id="content" class="form-control" rows="10" required></textarea>
                </div>
                
                <div class="d-flex justify-content-end">
                  
                    <a href="${pageContext.request.contextPath}/board" class="btn btn-secondary me-2">취소</a>
                    <button type="submit" class="btn btn-primary">작성하기</button>
                </div>
            </form>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
	<jsp:include page="/WEB-INF/views/common/footer.jsp"/>
</body>
</html>