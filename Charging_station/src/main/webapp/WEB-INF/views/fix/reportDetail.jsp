<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>고장 신고 상세</title>
    <link rel="stylesheet" type="text/css" href="<c:url value='/css/header.css'/>">
    <link rel="stylesheet" type="text/css" href="<c:url value='/css/footer.css'/>">
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f4f4;
            margin: 0;
            padding: 0;
            display: flex;
            flex-direction: column;
            min-height: 100vh;
        }
        .container {
            max-width: 800px;
            margin: 50px auto;
            background-color: #fff;
            padding: 30px;
            border-radius: 8px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
            flex: 1;
        }
        h1 {
            text-align: center;
            color: #333;
            margin-bottom: 30px;
        }
        .detail-item {
            margin-bottom: 15px;
            border-bottom: 1px solid #eee;
            padding-bottom: 15px;
        }
        .detail-item:last-child {
            border-bottom: none;
            padding-bottom: 0;
        }
        .detail-item label {
            font-weight: bold;
            color: #555;
            display: inline-block;
            width: 150px; /* 라벨 너비 고정 */
        }
        .detail-item span {
            color: #333;
        }
        .detail-content {
            white-space: pre-wrap;
            background-color: #f9f9f9;
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 4px;
            margin-top: 10px;
        }
        .status-badge {
            display: inline-block;
            padding: 5px 10px;
            border-radius: 15px;
            color: white;
            font-size: 14px;
            font-weight: bold;
        }
        .status-badge.접수 {
            background-color: #007bff;
        }
        .status-badge.처리중 {
            background-color: #ffc107;
            color: #333;
        }
        .status-badge.처리완료 {
            background-color: #28a745;
        }
        .status-badge.반려 {
            background-color: #dc3545;
        }
        .button-group {
            text-align: center;
            margin-top: 30px;
        }
        .button-group a,
        .button-group button {
            background-color: #6c757d;
            color: white;
            padding: 10px 15px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-size: 14px;
            text-decoration: none;
            transition: background-color 0.3s ease;
            margin: 0 5px;
        }
        .button-group a.edit-btn {
            background-color: #ffc107;
            color: #333;
        }
        .button-group a.edit-btn:hover {
            background-color: #e0a800;
        }
        .button-group button.delete-btn {
            background-color: #dc3545;
        }
        .button-group button.delete-btn:hover {
            background-color: #c82333;
        }
        .button-group a:hover,
        .button-group button:hover {
            opacity: 0.9;
        }
    </style>
</head>
<body>
    <jsp:include page="/WEB-INF/views/common/header.jsp"/>
    <div class="container">
        <h1>고장 신고 상세 보기</h1>

        <c:if test="${empty report}">
            <p style="text-align: center; font-size: 1.2em; color: #dc3545;">해당하는 고장 신고를 찾을 수 없습니다.</p>
        </c:if>
        <c:if test="${not empty report}">
            <div class="detail-item">
                <label>신고 ID:</label><span>${report.reportId}</span>
            </div>
            <div class="detail-item">
                <label>회원 ID:</label><span>${report.memberId}</span>
            </div>
            <div class="detail-item">
                <label>충전소 ID:</label><span>${report.apiStatId}</span>
            </div>
            <div class="detail-item">
                <label>충전기 ID:</label><span>${report.chargerId}</span>
            </div>
            <div class="detail-item">
                <label>신고 유형:</label><span>${report.malfunctionType}</span>
            </div>
            <div class="detail-item">
                <label>상태:</label>
                <span class="status-badge ${report.status}">${report.status}</span>
            </div>
            <div class="detail-item">
                <label>접수일:</label><span><fmt:formatDate value="${report.reportedAt}" pattern="yyyy-MM-dd HH:mm"/></span>
            </div>
            <div class="detail-item">
                <label>처리일:</label>
                <span>
                    <c:if test="${not empty report.processedAt}">
                        <fmt:formatDate value="${report.processedAt}" pattern="yyyy-MM-dd HH:mm"/>
                    </c:if>
                    <c:if test="${empty report.processedAt}">
                        -
                    </c:if>
                </span>
            </div>
            <div class="detail-item">
                <label>상세 내용:</label><br>
                <div class="detail-content">${report.detailContent}</div>
            </div>
            <c:if test="${not empty report.imageUrl}">
                <div class="detail-item">
                    <label>첨부 이미지:</label><br>
                    <img src="${report.imageUrl}" alt="첨부 이미지" style="max-width: 100%; height: auto; margin-top: 10px;">
                </div>
            </c:if>
            <c:if test="${not empty report.adminComment}">
                <div class="detail-item">
                    <label>관리자 코멘트:</label><br>
                    <div class="detail-content">${report.adminComment}</div>
                </div>
            </c:if>

            <div class="button-group">
                <a href="${pageContext.request.contextPath}/fixlist">목록으로</a>
                <a href="${pageContext.request.contextPath}/edit/${report.reportId}" class="edit-btn">수정</a>
                <button type="button" class="delete-btn" onclick="confirmDelete(${report.reportId})">삭제</button>
            </div>
        </c:if>
    </div>
    <jsp:include page="/WEB-INF/views/common/footer.jsp"/>

    <script>
        function confirmDelete(reportId) {
            if (confirm("정말로 이 신고를 삭제하시겠습니까?")) {
                var form = document.createElement('form');
                form.setAttribute('method', 'post');
                form.setAttribute('action', '${pageContext.request.contextPath}/delete/' + reportId);
                document.body.appendChild(form);
                form.submit();
            }
        }
    </script>
</body>
</html>
