<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>고장 신고 목록</title>
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
        }
        .button-group a:hover {
            background-color: #0056b3;
        }
        .no-reports {
            text-align: center;
            padding: 20px;
            font-size: 1.1em;
            color: #666;
        }
        .pagination-container {
            margin-top: 30px;
            padding-top: 20px;
            border-top: 2px solid #f0f0f0;
            text-align: center;
        }
        .pagination {
            display: inline-flex;
            justify-content: center;
            align-items: center;
            gap: 8px;
            margin-bottom: 15px;
        }
        .page-btn, .page-number {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            min-width: 36px;
            height: 36px;
            padding: 0 12px;
            border-radius: 8px;
            text-decoration: none;
            color: #333;
            background-color: #fff;
            border: 1px solid #ddd;
            cursor: pointer;
            transition: all 0.3s ease;
        }
        .page-btn:hover:not([disabled]), .page-number:hover {
            background-color: #007bff;
            color: #fff;
            border-color: #007bff;
        }
        .page-btn[disabled] {
            opacity: 0.5;
            cursor: not-allowed;
        }
        .page-number.active {
            background-color: #007bff;
            color: #fff;
            border-color: #007bff;
            font-weight: bold;
        }
        .page-info {
            text-align: center;
            color: #666;
            font-size: 14px;
        }
    </style>
</head>
<body>
    <jsp:include page="/WEB-INF/views/common/header.jsp"/>
    <div class="container">
        <h1>고장 신고 목록</h1>
        

        <c:if test="${empty reports}">
            <p class="no-reports">등록된 고장 신고가 없습니다.</p>
        </c:if>
        <c:if test="${not empty reports}">
            <table>
                <thead>
                    <tr>
                        <th>신고 ID</th>
                        <th>회원 ID</th>
                        <th>충전소 ID</th>
                        <th>충전기 ID</th>
                        <th>유형</th>
                        <th>상태</th>
                        <th>접수일</th>
                        <th>처리일</th>
                        <th>상세</th>
                        <th>처리 액션</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="report" items="${reports}">
                        <tr>
                            <td>${report.reportId}</td>
                            <td>${report.memberId}</td>
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
                            <td><a href="${pageContext.request.contextPath}/detail/${report.reportId}">보기</a></td>
                            <td>
                                <c:if test="${report.status ne '처리완료'}">
                                    <form action="${pageContext.request.contextPath}/process/${report.reportId}" method="post" style="display:inline;">
                                        <button type="submit" class="btn btn-success btn-sm">처리 완료</button>
                                    </form>
                                </c:if>
                                <c:if test="${report.status eq '처리완료'}">
                                    <button type="button" class="btn btn-secondary btn-sm" disabled>처리 완료됨</button>
                                </c:if>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
            
            <!-- 페이징 UI -->
            <c:if test="${not empty pageDTO && pageDTO.totalCount > 0}">
                <div class="pagination-container">
                    <div class="pagination">
                        <!-- 이전 페이지 -->
                        <c:choose>
                            <c:when test="${pageDTO.hasPrev}">
                                <a href="?page=${pageDTO.prevPage}" class="page-btn">
                                    ◀
                                </a>
                            </c:when>
                            <c:otherwise>
                                <button class="page-btn" disabled>◀</button>
                            </c:otherwise>
                        </c:choose>
                        
                        <!-- 페이지 번호 -->
                        <c:forEach begin="${pageDTO.startPage}" end="${pageDTO.endPage}" var="pageNum">
                            <c:choose>
                                <c:when test="${pageNum == pageDTO.currentPage}">
                                    <span class="page-number active">${pageNum}</span>
                                </c:when>
                                <c:otherwise>
                                    <a href="?page=${pageNum}" class="page-number">${pageNum}</a>
                                </c:otherwise>
                            </c:choose>
                        </c:forEach>
                        
                        <!-- 다음 페이지 -->
                        <c:choose>
                            <c:when test="${pageDTO.hasNext}">
                                <a href="?page=${pageDTO.nextPage}" class="page-btn">
                                    ▶
                                </a>
                            </c:when>
                            <c:otherwise>
                                <button class="page-btn" disabled>▶</button>
                            </c:otherwise>
                        </c:choose>
                    </div>
                    
                    <!-- 페이지 정보 -->
                    <div class="page-info">
                        <span>총 ${pageDTO.totalCount}개 | ${pageDTO.currentPage} / ${pageDTO.totalPage} 페이지</span>
                    </div>
                </div>
            </c:if>
        </c:if>
    </div>
    <jsp:include page="/WEB-INF/views/common/footer.jsp"/>
</body>
</html>
