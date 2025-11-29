<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page session="true" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>자유게시판</title>
	<link href="${pageContext.request.contextPath}/css/header.css" rel="stylesheet" type="text/css">
	<link href="${pageContext.request.contextPath}/css/footer.css" rel="stylesheet" type="text/css">
<!--	<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" />-->
	<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
<!--	<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/font-awesome/4.6.3/css/font-awesome.min.css">-->
    <link href="${pageContext.request.contextPath}/css/board.css" rel="stylesheet" type="text/css">

</head>
<body>
	<jsp:include page="/WEB-INF/views/common/header.jsp"/>
    
    <div class="board-container">
        <div class="board-header">
            <div class="d-flex justify-content-between align-items-center mb-3">
                <h1>자유게시판</h1>
                <c:if test="${not empty sessionScope.id}">
                    <a href="${pageContext.request.contextPath}/board/write" class="btn btn-primary btn-md btn-board-write">
                        <i class="fa fa-pencil" style="margin-right: 8px;"></i> 글쓰기
                    </a>
                </c:if>
            </div>
            
			<div class="search-box">
			    <form id="boardSearchForm" action="${pageContext.request.contextPath}/board" method="get" class="d-flex justify-content-end align-items-center">
			        
                    <select id="visualType" class="form-select me-2" style="max-width: 120px;">
			            <option value=""  ${param.type == null or param.type == '' ? 'selected' : ''}>--</option>
			            <option value="T"  ${param.type == 'T' ? 'selected' : ''}>제목</option>
			            <option value="C"  ${param.type == 'C' ? 'selected' : ''}>내용</option>
			            <option value="W"  ${param.type == 'W' ? 'selected' : ''}>작성자</option>
			            <option value="TC"  ${param.type == 'TC' ? 'selected' : ''}>제목 or 내용</option>
			            <option value="TW"  ${param.type == 'TW' ? 'selected' : ''}>제목 or 작성자</option>
			            <option value="TCW"  ${param.type == 'TCW' ? 'selected' : ''}>제목 or 내용 or 작성자</option>
			        </select>

			        <input type="text" id="visualKeyword" class="form-control me-2" 
			               placeholder="검색어를 입력하세요" value="${param.keyword}" style="max-width: 300px;">
			        
                    <input type="hidden" name="type" id="hiddenType" value="${param.type}">
                    <input type="hidden" name="keyword" id="hiddenKeyword" value="${param.keyword}">
			        <input type="hidden" name="page" id="boardPageInput" value="${pageDTO != null ? pageDTO.currentPage : 1}">
			        
			        <button type="submit" class="btn btn-secondary">검색</button>
			    </form>
			</div>
            </div>
        </div>

        <c:choose>
        
            <c:when test="${not empty boards}">
                <c:forEach var="board" items="${boards}">
                    <c:url var="detailUrl" value="/board/detail">
                        <c:param name="boardId" value="${board.boardId}" />
                        <c:if test="${pageDTO != null}">
                            <c:param name="page" value="${pageDTO.currentPage}" />
                        </c:if>
                        <c:if test="${not empty param.type}">
                            <c:param name="type" value="${param.type}" />
                        </c:if>
                        <c:if test="${not empty param.keyword}">
                            <c:param name="keyword" value="${param.keyword}" />
                        </c:if>
                    </c:url>
                    <div class="board-item" onclick="location.href='${detailUrl}'">
                        
                        <div class="board-title-area">
                            <div class="board-title">${board.title}</div>
                        </div>

                        <div class="board-meta-info">
                            <span class="text-muted">작성자: ${board.nickname}</span>
                            <span class="text-muted">${board.createdAt} | 조회수: ${board.viewCount}</span>
                        </div>
               
                    </div>
                </c:forEach>
            </c:when>
            <c:otherwise>
                <div class="alert alert-info">
                    게시글이 없습니다.
                </div>
            </c:otherwise>
        </c:choose>
        
		<c:if test="${not empty pageDTO && pageDTO.totalPage > 0}">
		    <div class="pagination-container">
		        <div class="pagination">
		            <!-- 이전 페이지 -->
		            <c:choose>
		                <c:when test="${pageDTO.hasPrev}">
		                    <a href="javascript:void(0);" onclick="changeBoardPage(${pageDTO.prevPage});" class="page-btn">
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
		            <c:forEach var="i" begin="${pageDTO.startPage}" end="${pageDTO.endPage}">
		                <c:choose>
		                    <c:when test="${i == pageDTO.currentPage}">
		                        <span class="page-number active">${i}</span>
		                    </c:when>
		                    <c:otherwise>
		                        <a href="javascript:void(0);" onclick="changeBoardPage(${i});" class="page-number">${i}</a>
		                    </c:otherwise>
		                </c:choose>
		            </c:forEach>
		            
		            <!-- 다음 페이지 -->
		            <c:choose>
		                <c:when test="${pageDTO.hasNext}">
		                    <a href="javascript:void(0);" onclick="changeBoardPage(${pageDTO.nextPage});" class="page-btn">
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
		
        var boardSearchForm = document.getElementById('boardSearchForm');
        var boardPageInput = document.getElementById('boardPageInput');
        
        // 새로 추가된 요소들
        var visualType = document.getElementById('visualType');
        var visualKeyword = document.getElementById('visualKeyword');
        var hiddenType = document.getElementById('hiddenType');
        var hiddenKeyword = document.getElementById('hiddenKeyword');
        
        // 페이지 이동 시 호출되는 함수: hidden page input 값만 변경하고 폼 제출
        function changeBoardPage(page) {
            if (!boardPageInput || !boardSearchForm) return;
            
            // 페이지 이동 시에는 hiddenType/hiddenKeyword의 값이 그대로 유지됩니다.
            boardPageInput.value = page;
            boardSearchForm.dataset.pageChange = 'true';
            boardSearchForm.submit();
        }
        
        // 검색 버튼 클릭 시 (폼 제출 시) page를 1로 초기화하고 visual 값을 hidden에 복사
        if (boardSearchForm) {
            boardSearchForm.addEventListener('submit', function(event) {
                // 페이지 이동(changeBoardPage)에 의한 제출이면 초기화와 값 복사 건너뛰기
                if (boardSearchForm.dataset.pageChange === 'true') {
                    boardSearchForm.dataset.pageChange = '';
                    return;
                }
                
                // 일반적인 검색 버튼 클릭 시 (검색어/필터가 변경된 경우)
                
                // 1. visual input의 값을 hidden input에 복사하여 제출 파라미터 업데이트
                hiddenType.value = visualType.value;
                hiddenKeyword.value = visualKeyword.value;
                
                // 2. page=1로 초기화
                if (boardPageInput) {
                    boardPageInput.value = 1;
                }
            });
        }
    </script>
	<jsp:include page="/WEB-INF/views/common/footer.jsp"/>
</body>
</html>