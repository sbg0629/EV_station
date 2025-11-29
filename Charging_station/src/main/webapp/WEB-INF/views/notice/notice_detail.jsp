<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page session="true" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>공지사항 상세</title>
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
        .notice-detail {
            background: white;
            border-radius: 8px;
            padding: 30px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }
        .category-badge {
            display: inline-block;
            padding: 5px 12px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: bold;
            margin-right: 10px;
        }
        .category-운영 { background-color: #007bff; color: white; }
        .category-신규 { background-color: #28a745; color: white; }
        .category-점검 { background-color: #ffc107; color: black; }
        .category-요금 { background-color: #dc3545; color: white; }
        .category-혜택 { background-color: #e83e8c; color: white; }
        .category-안내 { background-color: #6c757d; color: white; }
        .content-area {
            min-height: 200px;
            padding: 20px 0;
            border-top: 1px solid #eee;
            border-bottom: 1px solid #eee;
            margin: 20px 0;
        }
    </style>
</head>
<body>
	<jsp:include page="/WEB-INF/views/common/header.jsp"/>    
    <div class="notice-container">
        <div class="notice-detail">
            <div class="mb-3">
                <span class="category-badge category-${notice.category}">${notice.category}</span>
                <c:if test="${notice.isFixed == 1}">
                    <span class="badge bg-danger">고정</span>
                </c:if>
            </div>
            
            <h2 class="mb-3">${notice.title}</h2>
            
            <div class="text-muted mb-4">
                <small>작성자: ${notice.memberName}</small> | 
                <small>작성일: ${notice.createdAt}</small> | 
                <small>조회수: ${notice.viewCount}</small>
                <c:if test="${notice.updatedAt != notice.createdAt}">
                    | <small>수정일: ${notice.updatedAt}</small>
                </c:if>
            </div>
            
            <div class="content-area">
                ${notice.content}
            </div>
            
            <div class="d-flex justify-content-between mt-4">
                <a href="/notice" class="btn btn-secondary">목록으로</a>
                
                <!-- 관리자만 수정/삭제 버튼 표시 -->
                <c:if test="${sessionScope.admin == 1}">
                    <div>
                        <a href="/notice/modify?noticeId=${notice.noticeId}" class="btn btn-warning">수정</a>
                        <button onclick="deleteNotice(${notice.noticeId})" class="btn btn-danger">삭제</button>
                    </div>
                </c:if>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function deleteNotice(noticeId) {
            if (confirm('정말 삭제하시겠습니까?')) {
                var form = document.createElement('form');
                form.method = 'POST';
                form.action = '/notice/delete';
                
                var input = document.createElement('input');
                input.type = 'hidden';
                input.name = 'noticeId';
                input.value = noticeId;
                form.appendChild(input);
                
                document.body.appendChild(form);
                form.submit();
            }
        }
    </script>
	<jsp:include page="/WEB-INF/views/common/footer.jsp"/>
</body>
</html>

