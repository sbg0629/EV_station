<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page session="true" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>공지사항</title>
    <link href="${pageContext.request.contextPath}/css/header.css" rel="stylesheet" type="text/css">
    <link href="${pageContext.request.contextPath}/css/footer.css" rel="stylesheet" type="text/css">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/font-awesome/4.6.3/css/font-awesome.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" />
    <link href="${pageContext.request.contextPath}/css/notice.css" rel="stylesheet" type="text/css">
    
<!--    <style>-->
<!--        /* 페이징 컨테이너 */-->
<!--        .pagination-container {-->
<!--            margin-top: 60px;-->
<!--            padding-top: 40px;-->
<!--            border-top: 2px solid #f0f0f0;-->
<!--        }-->

<!--        /* 페이징 UI */-->
<!--        .pagination {-->
<!--            display: flex;-->
<!--            justify-content: center;-->
<!--            align-items: center;-->
<!--            gap: 10px;-->
<!--            margin-bottom: 25px;-->
<!--            background: white;-->
<!--            padding: 15px 20px;-->
<!--            border-radius: 16px;-->
<!--            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.06);-->
<!--        }-->

<!--        /* 페이지 버튼 공통 스타일 */-->
<!--        .page-btn, .page-number {-->
<!--            display: inline-flex;-->
<!--            align-items: center;-->
<!--            justify-content: center;-->
<!--            min-width: 42px;-->
<!--            height: 42px;-->
<!--            padding: 0 14px;-->
<!--            border-radius: 10px;-->
<!--            font-size: 0.95rem;-->
<!--            font-weight: 600;-->
<!--            text-decoration: none;-->
<!--            transition: all 0.3s ease;-->
<!--            cursor: pointer;-->
<!--            background: white;-->
<!--            border: 2px solid #e0e0e0;-->
<!--            color: #555;-->
<!--        }-->

<!--        /* 이전/다음 버튼 */-->
<!--        .page-btn {-->
<!--            background: linear-gradient(135deg, #ffffff 0%, #f8f9fa 100%);-->
<!--        }-->

<!--        .page-btn:hover {-->
<!--            background: linear-gradient(135deg, #ff6b6b 0%, #ee5a6f 100%);-->
<!--            border-color: #ff6b6b;-->
<!--            color: white;-->
<!--            transform: translateY(-2px);-->
<!--            box-shadow: 0 4px 12px rgba(255, 107, 107, 0.3);-->
<!--        }-->

<!--        .page-btn:disabled {-->
<!--            background: #f5f5f5;-->
<!--            border-color: #e0e0e0;-->
<!--            color: #ccc;-->
<!--            cursor: not-allowed;-->
<!--            opacity: 0.5;-->
<!--        }-->

<!--        /* 페이지 번호 */-->
<!--        .page-number {-->
<!--            font-size: 0.9rem;-->
<!--        }-->

<!--        .page-number:hover {-->
<!--            background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%);-->
<!--            border-color: #ff6b6b;-->
<!--            color: #ff6b6b;-->
<!--            transform: translateY(-2px);-->
<!--        }-->

<!--        /* 활성 페이지 */-->
<!--        .page-number.active {-->
<!--            background: linear-gradient(135deg, #ff6b6b 0%, #ee5a6f 100%);-->
<!--            border-color: #ff6b6b;-->
<!--            color: white;-->
<!--            box-shadow: 0 4px 15px rgba(255, 107, 107, 0.3);-->
<!--            cursor: default;-->
<!--            pointer-events: none;-->
<!--        }-->

<!--        /* 페이지 정보 */-->
<!--        .page-info {-->
<!--            text-align: center;-->
<!--            padding: 15px 20px;-->
<!--            background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%);-->
<!--            border-radius: 12px;-->
<!--            font-size: 0.95rem;-->
<!--            color: #666;-->
<!--            font-weight: 600;-->
<!--        }-->

<!--        /* 반응형 디자인 */-->
<!--        @media (max-width: 768px) {-->
<!--            .pagination {-->
<!--                gap: 6px;-->
<!--                padding: 12px 15px;-->
<!--            }-->
            
<!--            .page-btn, .page-number {-->
<!--                min-width: 38px;-->
<!--                height: 38px;-->
<!--                font-size: 0.85rem;-->
<!--            }-->
<!--        }-->

<!--        @media (max-width: 480px) {-->
<!--            .pagination-container {-->
<!--                margin-top: 40px;-->
<!--                padding-top: 25px;-->
<!--            }-->
            
<!--            .page-btn, .page-number {-->
<!--                min-width: 34px;-->
<!--                height: 34px;-->
<!--                font-size: 0.8rem;-->
<!--                padding: 0 10px;-->
<!--            }-->
            
<!--            .page-info {-->
<!--                font-size: 0.85rem;-->
<!--                padding: 12px 15px;-->
<!--            }-->
<!--        }-->

<!--        /* 애니메이션 */-->
<!--        @keyframes fadeIn {-->
<!--            from {-->
<!--                opacity: 0;-->
<!--                transform: translateY(10px);-->
<!--            }-->
<!--            to {-->
<!--                opacity: 1;-->
<!--                transform: translateY(0);-->
<!--            }-->
<!--        }-->

<!--        .pagination-container {-->
<!--            animation: fadeIn 0.5s ease-out;-->
<!--        }-->
<!--    </style>-->
</head>
<body>
    <jsp:include page="/WEB-INF/views/common/header.jsp"/>
    
    <div class="notice-container">
        <div class="notice-header">
            <div class="d-flex justify-content-between align-items-center mb-3">
                <h1>공지사항</h1>
          
                <c:choose>
                    <c:when test="${(sessionScope.admin != null && sessionScope.admin == 1) || (adminCheck != null && adminCheck == 1)}">
                        <a href="/notice/write" class="btn btn-primary btn-md">
                           <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" fill="currentColor" class="bi bi-pencil-square" viewBox="0 0 16 16" style="margin-right: 8px; vertical-align: middle;">
                                <path d="M15.502 1.94a.5.5 0 0 1 0 .706L14.459 3.69l-2-2L13.502.646a.5.5 0 0 1 .707 0l1.293 1.293zm-1.75 2.456-2-2L4.939 9.21a.5.5 0 0 0-.121.196l-.805 2.414a.25.25 0 0 0 .316.316l2.414-.805a.5.5 0 0 0 .196-.12l6.813-6.814z"/>
                                <path fill-rule="evenodd" d="M1 13.5A1.5 1.5 0 0 0 2.5 15h11a1.5 1.5 0 0 0 1.5-1.5v-6a.5.5 0 0 0-1 0v6a.5.5 0 0 1-.5.5h-11a.5.5 0 0 1-.5-.5v-11a.5.5 0 0 1 .5-.5H9a.5.5 0 0 0 0-1H2.5A1.5 1.5 0 0 0 1 2.5v11z"/>
                            </svg>
                           공지사항 작성
                        </a>
                    </c:when>
                    <c:otherwise>
                    </c:otherwise>
                </c:choose>
            </div>
            <div class="search-box mb-4">
                <form action="/notice" method="get" class="d-flex justify-content-end"> 
                    <input type="text" name="keyword" class="form-control me-2" 
                           placeholder="검색어를 입력하세요" value="${param.keyword}" style="max-width: 300px;">
                    <button type="submit" class="btn btn-secondary">검색</button>
                </form>
            </div>
        </div>

        <!-- 고정 공지사항 -->
        <c:if test="${not empty fixedNotices}">
            <h3 class="mb-3" style="font-size: 1.3rem;">📌 고정 공지사항</h3>
            <c:forEach var="notice" items="${fixedNotices}">
                <div class="notice-item" onclick="location.href='/notice/detail?noticeId=${notice.noticeId}'" style="border-left: 5px solid #dc3545; background-color: #fff0f2;">
                    <div class="title-content">
                        <span class="category-badge category-${notice.category}">${notice.category}</span>
                        <strong class="title_n">${notice.title}</strong>
                    </div>
                    <div class="notice-info">
                        <span class="text-muted">${notice.createdAt}</span>
                        <span class="text-muted">조회수: ${notice.viewCount}</span>
                    </div>
                </div>
            </c:forEach>
        </c:if>

        <!-- 일반 공지사항 -->
        <h3 class="mb-3 mt-4" style="font-size: 1.3rem;">📋 일반 공지사항</h3>
        <c:choose>
            <c:when test="${not empty notices}">
                <c:forEach var="notice" items="${notices}">
                   <div class="notice-item" onclick="location.href='/notice/detail?noticeId=${notice.noticeId}'">
                        <div class="title-content">
                            <span class="category-badge category-${notice.category}">${notice.category}</span>
                            <strong class="title_n">${notice.title}</strong>
                        </div>
                        <div class="notice-info">
                            <span class="text-muted">${notice.createdAt}</span>
                            <span class="text-muted">조회수: ${notice.viewCount}</span>
                        </div>
                   </div>
                </c:forEach>
            </c:when>
            <c:otherwise>
                <div class="alert alert-info mt-3">
                    검색 결과 또는 등록된 일반 공지사항이 없습니다.
                </div>
            </c:otherwise>
        </c:choose>
        
        <!-- 페이징 UI -->
        <c:if test="${not empty pageDTO && pageDTO.totalCount > 0}">
            <div class="pagination-container">
                <div class="pagination">
                    <!-- 이전 페이지 -->
                    <c:choose>
                        <c:when test="${pageDTO.hasPrev}">
                            <a href="?page=${pageDTO.prevPage}<c:if test='${not empty category}'>&category=${category}</c:if><c:if test='${not empty keyword}'>&keyword=${keyword}</c:if>" 
                               class="page-btn">
                                <i class="bi bi-chevron-left"></i>
                            </a>
                        </c:when>
                        <c:otherwise>
                            <button class="page-btn" disabled>
                                <i class="bi bi-chevron-left"></i>
                            </button>
                        </c:otherwise>
                    </c:choose>
                    
                    <!-- 페이지 번호 -->
                    <c:forEach begin="${pageDTO.startPage}" end="${pageDTO.endPage}" var="pageNum">
                        <c:choose>
                            <c:when test="${pageNum == pageDTO.currentPage}">
                                <span class="page-number active">${pageNum}</span>
                            </c:when>
                            <c:otherwise>
                                <a href="?page=${pageNum}<c:if test='${not empty category}'>&category=${category}</c:if><c:if test='${not empty keyword}'>&keyword=${keyword}</c:if>" 
                                   class="page-number">${pageNum}</a>
                            </c:otherwise>
                        </c:choose>
                    </c:forEach>
                    
                    <!-- 다음 페이지 -->
                    <c:choose>
                        <c:when test="${pageDTO.hasNext}">
                            <a href="?page=${pageDTO.nextPage}<c:if test='${not empty category}'>&category=${category}</c:if><c:if test='${not empty keyword}'>&keyword=${keyword}</c:if>" 
                               class="page-btn">
                                <i class="bi bi-chevron-right"></i>
                            </a>
                        </c:when>
                        <c:otherwise>
                            <button class="page-btn" disabled>
                                <i class="bi bi-chevron-right"></i>
                            </button>
                        </c:otherwise>
                    </c:choose>
                </div>
                
                <!-- 페이지 정보 -->
                <div class="page-info">
                    <span>총 ${pageDTO.totalCount}개 | ${pageDTO.currentPage} / ${pageDTO.totalPage} 페이지</span>
                </div>
            </div>
        </c:if>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    
    <script>
    // 페이지 이동 시 스크롤을 상단으로 부드럽게 이동
    document.addEventListener('DOMContentLoaded', function() {
        const pageLinks = document.querySelectorAll('.page-btn:not([disabled]), .page-number:not(.active)');
        pageLinks.forEach(link => {
            link.addEventListener('click', function(e) {
                window.scrollTo({
                    top: 0,
                    behavior: 'smooth'
                });
            });
        });
    });
    </script>
    
    <jsp:include page="/WEB-INF/views/common/footer.jsp"/>
</body>
</html>