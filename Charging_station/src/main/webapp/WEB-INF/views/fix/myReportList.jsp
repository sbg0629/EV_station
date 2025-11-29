
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>나의 고장 신고 목록</title>
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
            max-width: 1200px;
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
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }
        th, td {
            border: 1px solid #ddd;
            padding: 12px;
            text-align: left;
        }
        th {
            background-color: #f2f2f2;
            font-weight: bold;
            color: #333;
        }
        tr:nth-child(even) {
            background-color: #f9f9f9;
        }
        tr:hover {
            background-color: #f1f1f1;
        }
        .status-badge {
            display: inline-block;
            padding: 5px 10px;
            border-radius: 15px;
            color: white;
            font-size: 12px;
            font-weight: bold;
        }
        .status-badge.접수 {
            background-color: #007bff; /* Blue */
        }
        .status-badge.처리중 {
            background-color: #ffc107; /* Yellow */
            color: #333;
        }
        .status-badge.처리완료 {
            background-color: #28a745; /* Green */
        }
        .status-badge.반려 {
            background-color: #dc3545; /* Red */
        }
        .button-group {
            text-align: right;
            margin-top: 20px;
        }
        .button-group a {
            background-color: #007bff;
            color: white;
            padding: 10px 15px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-size: 14px;
            text-decoration: none;
            transition: background-color 0.3s ease;
            margin-left: 5px;
        }
        .button-group a:hover {
            background-color: #0056b3;
        }
        .button-group button {
            padding: 8px 12px;
            border-radius: 5px;
            cursor: pointer;
            font-size: 13px;
            margin-left: 5px;
        }
        .btn-edit {
            background-color: #ffc107;
            color: #333;
            border: none;
        }
        .btn-delete {
            background-color: #dc3545;
            color: white;
            border: none;
        }
        .no-reports {
            text-align: center;
            padding: 20px;
            font-size: 1.1em;
            color: #666;
        }
    </style>
</head>
<body>
    <jsp:include page="/WEB-INF/views/common/header.jsp"/>
    <div class="container">
        <h1>나의 고장 신고 목록</h1>

        <c:if test="${empty reports}">
            <p class="no-reports">등록된 고장 신고가 없습니다.</p>
        </c:if>
        <c:if test="${not empty reports}">
            <table>
                <thead>
                    <tr>
                        <th>신고 ID</th>
                        <th>충전소 ID</th>
                        <th>충전기 ID</th>
                        <th>유형</th>
                        <th>상태</th>
                        <th>접수일</th>
                        <th>처리일</th>
                        <th>액션</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="report" items="${reports}">
                        <tr>
                            <td>${report.reportId}</td>
                            <td>${report.apiStatId}</td>
                            <td>${report.chargerId}</td>
                            <td>${report.malfunctionType}</td>
                            <td>
                                <span class="status-badge ${report.status}">
                                    ${report.status}
                                </span>
                            </td>
                            <td><fmt:formatDate value="${report.reportedAt}" pattern="yyyy-MM-dd HH:mm"/></td>
                            <td>
                                <c:if test="${not empty report.processedAt}">
                                    <fmt:formatDate value="${report.processedAt}" pattern="yyyy-MM-dd HH:mm"/>
                                </c:if>
                                <c:if test="${empty report.processedAt}">
                                    -
                                </c:if>
                            </td>
                            <td>
                                <a href="${pageContext.request.contextPath}/myDetail/${report.reportId}" class="btn btn-sm btn-info">보기</a>
                                <c:if test="${report.status eq '접수'}">
                                    <a href="${pageContext.request.contextPath}/myDetail/${report.reportId}" class="btn btn-sm btn-warning btn-edit">수정</a>
                                    <form action="${pageContext.request.contextPath}/myDelete/${report.reportId}" method="post" style="display:inline;">
                                        <button type="submit" class="btn btn-sm btn-danger btn-delete" onclick="return confirm('정말 이 신고를 삭제하시겠습니까?');">삭제</button>
                                    </form>
                                </c:if>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </c:if>
    </div>
    <jsp:include page="/WEB-INF/views/common/footer.jsp"/>
</body>
</html>
