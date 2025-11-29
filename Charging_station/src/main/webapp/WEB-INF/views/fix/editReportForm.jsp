<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>고장 신고 수정</title>
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
        .form-group {
            margin-bottom: 20px;
        }
        .form-group label {
            display: block;
            margin-bottom: 8px;
            font-weight: bold;
            color: #555;
        }
        .form-group input[type="text"],
        .form-group input[type="file"],
        .form-group textarea,
        .form-group select {
            width: calc(100% - 20px);
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 4px;
            font-size: 16px;
        }
        .form-group textarea {
            resize: vertical;
            min-height: 100px;
        }
        .form-group select {
            width: 100%;
        }
        .button-group {
            text-align: center;
            margin-top: 30px;
        }
        .button-group button {
            background-color: #007bff;
            color: white;
            padding: 12px 20px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-size: 16px;
            transition: background-color 0.3s ease;
        }
        .button-group button:hover {
            background-color: #0056b3;
        }
        .error-message {
            color: red;
            font-size: 14px;
            margin-top: 5px;
        }
    </style>
</head>
<body>
    <jsp:include page="/WEB-INF/views/common/header.jsp"/>
    <div class="container">
        <h1>고장 신고 수정</h1>
        <form:form action="${pageContext.request.contextPath}/edit" method="post" modelAttribute="fixDTO" enctype="multipart/form-data">
            <form:hidden path="reportId"/>
            <form:hidden path="memberId"/>
            <form:hidden path="apiStatId"/>
            <form:hidden path="chargerId"/>
            <form:hidden path="reportedAt"/>

            <div class="form-group">
                <label for="malfunctionType">신고 유형:</label>
                <form:select path="malfunctionType" id="malfunctionType">
                    <form:option value="고장" label="고장"/>
                    <form:option value="사용불가" label="사용불가"/>
                    <form:option value="결제오류" label="결제오류"/>
                    <form:option value="기타" label="기타"/>
                </form:select>
                <form:errors path="malfunctionType" cssClass="error-message"/>
            </div>
            <div class="form-group">
                <label for="detailContent">상세 내용:</label>
                <form:textarea path="detailContent" id="detailContent" rows="5"></form:textarea>
                <form:errors path="detailContent" cssClass="error-message"/>
            </div>
            <div class="form-group">
                <label for="imageUrl">첨부 이미지 (URL 또는 파일):</label>
                <form:input path="imageUrl" type="text" id="imageUrl" placeholder="이미지 URL을 입력하거나 파일을 업로드하세요."/>
            </div>
            <div class="form-group">
                <label for="status">처리 상태:</label>
                <form:select path="status" id="status">
                    <form:option value="접수" label="접수"/>
                    <form:option value="처리중" label="처리중"/>
                    <form:option value="처리완료" label="처리완료"/>
                    <form:option value="반려" label="반려"/>
                </form:select>
                <form:errors path="status" cssClass="error-message"/>
            </div>
            <div class="form-group">
                <label for="adminComment">관리자 코멘트:</label>
                <form:textarea path="adminComment" id="adminComment" rows="3"></form:textarea>
            </div>
             <div class="form-group">
                <label for="processedAt">처리 완료일 (YYYY-MM-DD HH:MM:SS):</label>
                <c:set var="formattedProcessedAt" value="" />
                <c:if test="${not empty fixDTO.processedAt}">
                    <fmt:formatDate value="${fixDTO.processedAt}" pattern="yyyy-MM-dd HH:mm:ss" var="formattedProcessedAt"/>
                </c:if>
                <form:input path="processedAt" type="text" id="processedAt" placeholder="예: 2023-10-27 15:30:00" value="${formattedProcessedAt}" readonly="true"/>
            </div>
            <div class="button-group">
                <button type="submit">신고 수정</button>
            </div>
        </form:form>
    </div>
    <jsp:include page="/WEB-INF/views/common/footer.jsp"/>
</body>
</html>
