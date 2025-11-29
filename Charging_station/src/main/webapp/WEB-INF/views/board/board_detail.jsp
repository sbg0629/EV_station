<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page session="true" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>게시글 상세</title>
	<link href="${pageContext.request.contextPath}/css/header.css" rel="stylesheet" type="text/css">
	<link href="${pageContext.request.contextPath}/css/footer.css" rel="stylesheet" type="text/css">

	<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
	<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/font-awesome/4.6.3/css/font-awesome.min.css">
    <link href="${pageContext.request.contextPath}/css/board.css" rel="stylesheet" type="text/css">
</head>
<body>
	<jsp:include page="/WEB-INF/views/common/header.jsp"/>    
    <div class="board-container">
        <c:url var="boardListUrl" value="/board">
            <c:if test="${param.page != null}">
                <c:param name="page" value="${param.page}" />
            </c:if>
            <c:if test="${not empty keyword}">
                <c:param name="keyword" value="${keyword}" />
            </c:if>
        </c:url>
        <c:url var="detailBaseUrl" value="/board/detail">
            <c:param name="boardId" value="${board.boardId}" />
            <c:if test="${not empty keyword}">
                <c:param name="keyword" value="${keyword}" />
            </c:if>
        </c:url>
        <c:set var="currentCommentPage" value="${pageDTO != null ? pageDTO.currentPage : (param.page != null ? param.page : 1)}" />
        <c:set var="commentTotalCount" value="${pageDTO != null ? pageDTO.totalCount : (comments != null ? comments.size() : 0)}" />
        <div class="board-detail">
            <h2 class="mb-3">${board.title}</h2>
            
            <div class="text-muted mb-4">
                <small>작성자: ${board.nickname}</small> |
                <small>작성일: ${board.createdAt}</small> | 
                <small>조회수: ${board.viewCount}</small>
                <c:if test="${board.updatedAt != board.createdAt}">
                    |
                    <small>수정일: ${board.updatedAt}</small>
                </c:if>
            </div>
            
            <div class="content-area">
                ${board.content}
            </div>
            
            <div class="d-flex justify-content-between mt-4">
       
                <a href="${boardListUrl}" class="btn btn-secondary">목록으로</a>
                
                <c:if test="${memberId == board.memberId}">
                    <div>
            
                        <a href="${pageContext.request.contextPath}/board/modify?boardId=${board.boardId}" class="btn btn-warning">수정</a>
                        <button onclick="deleteBoard(${board.boardId})" class="btn btn-danger">삭제</button>
                    </div>
                </c:if>
            </div>
        </div>

  
        <div class="comment-area">
            <h4>댓글 (${commentTotalCount})</h4>
            
            <c:forEach var="comment" items="${comments}">
                <div class="comment-item <c:if test="${comment.depth == 1}">reply</c:if>">
       
                    <div class="comment-header">
                        <div>
                            <strong>${comment.nickname}</strong>
                            <span class="comment-meta">${comment.createdAt}</span>
     
                        </div>
                        <c:if test="${memberId == comment.memberId}">
                            <div>
                          
                                <button onclick="editComment(${comment.commentId}, '${comment.content}', ${board.boardId})" class="btn btn-sm btn-outline-warning">수정</button>
                                <button onclick="deleteComment(${comment.commentId}, ${board.boardId})" class="btn btn-sm btn-outline-danger">삭제</button>
                            </div>
                       
                        </c:if>
                    </div>
                    <div class="comment-content" id="comment-content-${comment.commentId}">
                        ${comment.content}
                    </div>
             
                    <c:if test="${comment.depth == 0 && not empty memberId}">
                        <button onclick="showReplyForm(${comment.commentId})" class="btn btn-sm btn-outline-primary mt-2">답글</button>
                    </c:if>
                </div>
                
     
                <c:if test="${comment.depth == 0 && not empty memberId}">
                    <div id="reply-form-${comment.commentId}" class="reply-form-hidden" style="display: none; margin-left: 40px; margin-bottom: 10px;">
                        <form action="${pageContext.request.contextPath}/board/comment/write" method="post" class="d-flex">
                            <input type="hidden" name="board_id" value="${board.boardId}">
                            <input type="hidden" name="parent_comment_id" value="${comment.commentId}">
                            <input type="hidden" name="page" value="${currentCommentPage}">
        
                            <input type="text" name="content" class="form-control me-2" placeholder="답글을 입력하세요" required>
                            <button type="submit" class="btn btn-primary btn-sm">등록</button>
                            <button type="button" onclick="hideReplyForm(${comment.commentId})" class="btn btn-secondary btn-sm ms-2">취소</button>
       
                        </form>
                    </div>
                </c:if>
            </c:forEach>
            
            <c:if test="${not empty pageDTO && pageDTO.totalPage > 0}">
                <nav class="mt-4">
                    <ul class="pagination justify-content-center">
                        <li class="page-item ${pageDTO.hasPrev ? '' : 'disabled'}">
                            <a class="page-link" href="javascript:void(0);" onclick="changeCommentPage(${pageDTO.prevPage});">이전</a>
                        </li>
                        <c:forEach var="i" begin="${pageDTO.startPage}" end="${pageDTO.endPage}">
                            <li class="page-item ${i == pageDTO.currentPage ? 'active' : ''}">
                                <a class="page-link" href="javascript:void(0);" onclick="changeCommentPage(${i});">${i}</a>
                            </li>
                        </c:forEach>
                        <li class="page-item ${pageDTO.hasNext ? '' : 'disabled'}">
                            <a class="page-link" href="javascript:void(0);" onclick="changeCommentPage(${pageDTO.nextPage});">다음</a>
                        </li>
                    </ul>
                </nav>
            </c:if>
            
            <c:if test="${not empty memberId}">
                <div class="mt-4">
                    <h5>댓글 작성</h5>
                    <form action="${pageContext.request.contextPath}/board/comment/write" method="post">
                        <input type="hidden" name="board_id" value="${board.boardId}">
                        <input type="hidden" name="page" value="${currentCommentPage}">
     
                        <div class="d-flex">
                            <textarea name="content" class="form-control me-2" rows="3" placeholder="댓글을 입력하세요" required></textarea>
                            <button type="submit" class="btn btn-primary">등록</button>
              
                        </div>
                    </form>
                </div>
            </c:if>
            <c:if test="${empty memberId}">
                <div class="alert alert-info mt-3">
         
                    댓글을 작성하려면 <a href="${pageContext.request.contextPath}/login">로그인</a>이 필요합니다.
                </div>
            </c:if>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        var detailBaseUrl = '${detailBaseUrl}';
        var currentCommentPageValue = '${currentCommentPage}';
        
        function deleteBoard(boardId) {
            if (confirm('정말 삭제하시겠습니까?')) {
                var form = document.createElement('form');
                form.method = 'POST';
                form.action = '${pageContext.request.contextPath}/board/delete';
                
                var input = document.createElement('input');
                input.type = 'hidden';
                input.name = 'boardId';
                input.value = boardId;
                form.appendChild(input);
                document.body.appendChild(form);
                form.submit();
            }
        }

        function showReplyForm(commentId) {
            document.getElementById('reply-form-' + commentId).style.display = 'block';
        }

        function hideReplyForm(commentId) {
            document.getElementById('reply-form-' + commentId).style.display = 'none';
        }

        function editComment(commentId, content, boardId) {
            var contentDiv = document.getElementById('comment-content-' + commentId);
            var editForm = '<form action="${pageContext.request.contextPath}/board/comment/modify" method="post" class="d-flex mt-2">' +
                '<input type="hidden" name="comment_id" value="' + commentId + '">' +
                '<input type="hidden" name="board_id" value="' + boardId + '">' +
                '<input type="hidden" name="page" value="' + currentCommentPageValue + '">' +
                '<input type="text" name="content" class="form-control me-2" value="' + content.replace(/"/g, '&quot;') + '" required>' +
                
                '<button type="submit" class="btn btn-primary btn-sm">수정</button>' +
                '<button type="button" onclick="location.reload()" class="btn btn-secondary btn-sm ms-2">취소</button>' +
                '</form>';
            contentDiv.innerHTML = editForm;
        }

        function deleteComment(commentId, boardId) {
            if (confirm('정말 삭제하시겠습니까?')) {
        
                var form = document.createElement('form');
                form.method = 'POST';
                form.action = '${pageContext.request.contextPath}/board/comment/delete';
                var input1 = document.createElement('input');
                input1.type = 'hidden';
                input1.name = 'commentId';
                input1.value = commentId;
                form.appendChild(input1);
                
                var input2 = document.createElement('input');
                input2.type = 'hidden';
                input2.name = 'boardId';
                input2.value = boardId;
                form.appendChild(input2);
                
                var input3 = document.createElement('input');
                input3.type = 'hidden';
                input3.name = 'page';
                input3.value = currentCommentPageValue;
                form.appendChild(input3);
                
                document.body.appendChild(form);
                form.submit();
            }
        }
        
        function changeCommentPage(page) {
            var separator = detailBaseUrl.indexOf('?') > -1 ? '&' : '?';
            window.location.href = detailBaseUrl + separator + 'page=' + page;
        }
    </script>
	<jsp:include page="/WEB-INF/views/common/footer.jsp"/>
</body>
</html>