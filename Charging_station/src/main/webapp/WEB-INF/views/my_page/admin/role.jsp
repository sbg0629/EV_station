<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>관리자 | 전체 회원 목록 - 요리조리</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" />
	<link href="${pageContext.request.contextPath}/css/header.css" rel="stylesheet" type="text/css">
	<link href="${pageContext.request.contextPath}/css/footer.css" rel="stylesheet" type="text/css">
		
	<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/font-awesome/4.6.3/css/font-awesome.min.css">
    <style>
        /* 간단한 추가 스타일 */
        body {
            background-color: #f8f9fa;
            /* [수정] body에 flex/height를 주면 
               푸터가 이상하게 나올 수 있어 해당 스타일은 제거합니다. */
        }
        
        /* [추가] 푸터가 하단에 붙도록 최소 높이 설정 */
        html {
            height: 100%;
        }
        body {
            min-height: 100%;
            display: flex;
            flex-direction: column;
        }
        /* [추가] 메인 콘텐츠 영역이 남은 공간을 채우도록 설정 */
        .container {
            flex-grow: 1;
        }
    </style>
</head>
<body>
	<jsp:include page="/WEB-INF/views/common/header.jsp"/>


<div class="container mt-5">
    <div class="row">
        <div class="col-md-12">
            
            <h2 class="mb-4">
                <i class="bi bi-people-fill" style="margin-right: 10px;"></i> 전체 회원 목록
            </h2>

            <div class="list-group mb-4">
                <a href="${pageContext.request.contextPath}/fixlist" class="list-group-item list-group-item-action">
                    <i class="bi bi-gear-fill" style="margin-right: 10px;"></i> 고장 신고 접수 확인
                </a>
            </div>

            <div class="card shadow-sm">
                <div class="card-body">
                    <table class="table table-hover align-middle">
                        <thead class="table-dark">
                            <tr>
                                <th>회원 ID</th>
                                <th>닉네임</th>
                                <th>이름</th>
                                <th>이메일</th>
                                <th>전화번호</th>
                                <th>가입일</th>
                                <th>관리</th>
                            </tr>
                        </thead>
                        <tbody>
                           <c:forEach var="user" items="${userData}">
                                <tr>
                                    <td>${user.memberId}</td> 
                                    <td>${user.nickname}</td>
                                    <td>${user.name}</td>
                                    <td>${user.email}</td>
                                    <td>${user.phoneNumber}</td>
                                    <td>${user.joinDate}</td>
                                    <td>
                                        <button type="button" class="btn btn-sm btn-danger delete-btn" 
                                                data-bs-toggle="modal" 
                                                data-bs-target="#deleteModal"
                                                data-bs-id="${user.memberId}"
                                                data-bs-name="${user.nickname}">
                                            삭제
                                        </button>
                                    </td>
                                </tr>
                           </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>

        </div>
    </div>
</div>

<div class="modal fade" id="deleteModal" tabindex="-1" aria-labelledby="modalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="modalLabel">회원 삭제 확인</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <p id="deleteModalText">정말 삭제하시겠습니까?</p>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">취소</button>
                <form action="delete2" method="post" style="margin:0;">
                    <input type="hidden" id="deleteMemberId" name="memberId" value="" />
                    <button type="submit" class="btn btn-danger">삭제 실행</button>
                </form>
            </div>
        </div>
    </div>
</div>


<jsp:include page="/WEB-INF/views/common/footer.jsp"/>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

<script>
    // 부트스트랩 모달 이벤트 리스너
    var deleteModal = document.getElementById('deleteModal');
    deleteModal.addEventListener('show.bs.modal', function (event) {
        
        // 모달을 연 버튼(삭제 버튼)을 가져옵니다.
        var button = event.relatedTarget;
        
        // data-bs-* 속성에서 회원 ID와 닉네임을 추출합니다.
        var memberId = button.getAttribute('data-bs-id');
        var memberName = button.getAttribute('data-bs-name');

        // 모달 내부의 텍스트 영역과 숨겨진 input을 찾습니다.
        var modalText = deleteModal.querySelector('#deleteModalText');
        var deleteInput = deleteModal.querySelector('#deleteMemberId');

        // 모달 내용을 설정합니다.
        modalText.textContent = '정말 "' + memberName + '" (ID: ' + memberId + ') 회원을 삭제하시겠습니까?';
        
        // 폼의 input(hidden)에 삭제할 ID 값을 설정합니다.
        deleteInput.value = memberId;
    });
</script>

</body>
</html>