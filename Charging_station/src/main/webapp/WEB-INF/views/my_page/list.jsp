<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8" />
    <title>마이페이지</title>
	<link href="${pageContext.request.contextPath}/css/header.css" rel="stylesheet" type="text/css">
	<link href="${pageContext.request.contextPath}/css/footer.css" rel="stylesheet" type="text/css">
		
	<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
	<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/font-awesome/4.6.3/css/font-awesome.min.css">
    
    <style>
        /* --- 1. 페이지 레이아웃 --- */
        body {
            background-image: url('https://images.unsplash.com/photo-1593941707882-65c6405f5a24?q=80&w=1974&auto=format&fit=crop');
            background-size: cover;
            background-position: center center;
            background-attachment: fixed;
            
            display: flex;
            flex-direction: column;
            min-height: 100vh;
            margin: 0;
            font-family: 'Noto Sans KR', sans-serif;
        }
        
        /* --- 2. 메인 컨테이너 --- */
        .main-container {
            flex-grow: 1;
            display: flex;
            justify-content: center;
            align-items: flex-start;
            padding: 40px 20px;
        }

        /* --- 3. 마이페이지 박스 (좌측 정보) --- */
        .mypage-box {
            width: 400px;
            max-width: 100%;
            background-color: rgba(255, 255, 255, 0.9);
            backdrop-filter: blur(10px);
            -webkit-backdrop-filter: blur(10px);
            padding: 40px;
            border-radius: 12px;
            box-shadow: 0 8px 32px 0 rgba(0, 0, 0, 0.15);
            border: 1px solid rgba(255, 255, 255, 0.18);
            
            margin-right: 30px;
            margin-bottom: 30px; 
        }
        
        .mypage-box h2 {
            text-align: center;
            margin-bottom: 30px;
            font-weight: 700;
            color: #222;
        }
        .mypage-box button, .mypage-box input[type="submit"] {
            width: 100%;
            margin-top: 10px;
        }
        .info-item {
            display: flex;
            justify-content: space-between;
            padding: 8px 0;
            border-bottom: 1px solid #eee;
        }
        
        /* 긴 텍스트 처리 */
        .info-item span:first-child {
            font-weight: 500;
            color: #555;
            flex-shrink: 0;
            margin-right: 10px;
        }
        .info-item span:last-child {
            color: #333;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
            max-width: 250px;
            text-align: right;
        }
        
        /* --- 4. 예약 내역 섹션 (우측) --- */
        .reservation-section {
            width: 600px;
            max-width: 100%;
            background-color: rgba(255, 255, 255, 0.9);
            backdrop-filter: blur(10px);
            -webkit-backdrop-filter: blur(10px);
            padding: 40px;
            border-radius: 12px;
            box-shadow: 0 8px 32px 0 rgba(0, 0, 0, 0.15);
            border: 1px solid rgba(255, 255, 255, 0.18);
        }
        
        .reservation-section h2 {
            margin-top: 0;
            margin-bottom: 25px;
            font-weight: 700;
            color: #222;
            border-bottom: 2px solid #eee;
            padding-bottom: 10px;
        }

        /* 💡세로 스크롤 및 줄바꿈을 위한 컨테이너 */
        .reservation-list-container {
            max-height: 450px; /* 고정 높이 설정 (세로 스크롤 시작점) */
            overflow-y: auto; /* 세로 스크롤 활성화 */
            padding-right: 15px; 
            margin-right: -15px;
            
            display: flex;
            flex-wrap: wrap; /* 카드가 넘치면 다음 줄로 이동 */
            gap: 15px; /* 카드 사이의 간격 */
        }
        
        /* 스크롤바 스타일 */
        .reservation-list-container::-webkit-scrollbar {
            width: 6px;
        }
        .reservation-list-container::-webkit-scrollbar-thumb {
            background-color: #ccc;
            border-radius: 10px;
        }
        .reservation-list-container::-webkit-scrollbar-track {
            background-color: #f1f1f1;
        }

        /* 💡가로 스크롤 관련 스타일 제거 */
        .scroll-x { display: none; } 
        
        /* 💡예약 카드 스타일 (줄바꿈 가능하도록 수정) */
        .reservation-card-horizontal {
            width: calc(50% - 7.5px); /* 컨테이너 너비의 50%에서 gap 절반을 뺀 값 */
            background: #fff;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.08);
            border-top: 5px solid #ccc;
        }

        .reservation-card-horizontal[data-status="RESERVED"]   { border-top-color:#52c41a; }
        .reservation-card-horizontal[data-status="COMPLETED"]  { border-top-color:#1890ff; }
        .reservation-card-horizontal[data-status="CANCELLED"],
        .reservation-card-horizontal[data-status="EXPIRED"]    { border-top-color:#faad14; }

        .res-img-box {
            width: 100%;
            height: 130px;
            background: #f2f2f2;
            border-radius: 8px;
            display:flex;
            align-items:center;
            justify-content:center;
            margin-bottom:12px;
        }
        
        .no-reservation {
            text-align: center;
            padding: 30px;
            color: #777;
            font-size: 16px;
            background: #f8f8f8;
            border-radius: 8px;
        }

        /* --- 5. 반응형 (모바일) --- */
        @media (max-width: 992px) {
            .main-container {
                flex-direction: column;
                align-items: center;
            }
            .mypage-box, .reservation-section {
                width: 100%;
                margin-right: 0;
                margin-bottom: 30px;
            }
            .reservation-list-container {
                max-height: 50vh; 
            }
            /* 💡모바일에서는 카드가 한 줄에 하나씩 오도록 */
            .reservation-card-horizontal {
                 width: 100%; 
            }
        }
    </style>
</head>

<body>
		<jsp:include page="/WEB-INF/views/common/header.jsp"/>


		<main class="main-container">
		    <div class="mypage-box">
		        <h2>마이페이지</h2>
		        <div class="info-list">
		            <div class="info-item">
		                <span>닉네임</span>
		                <span>${user.nickname}</span>
		            </div>
		            <div class="info-item">
		                <span>이름</span>
		                <span>${user.name}</span>
		            </div>
		            <div class="info-item">
		                <span>아이디</span>
		                <span>${user.memberId}</span>
		            </div>
		            <div class="info-item">
		                <span>이메일</span>
		                <span>${user.email}</span>
		            </div>
		            <div class="info-item">
		                <span>전화번호</span>
		                <span>${user.phoneNumber}</span>
		            </div>
		        </div>

		       <button type="button" class="btn btn-primary" onclick="location.href='mypage_edit?memberId=${user.memberId}'">정보 수정</button>
			   <button type="button" class="btn btn-info" onclick="location.href='${pageContext.request.contextPath}/myList'" style="margin-top:10px; width:100%;">신고 정보</button>
			  
		        <c:if test="${sessionScope.admin == 1}">
		            <button type="button" class="btn btn-warning" onclick="location.href='role'">회원 관리</button>
		        </c:if>

		        <button type="button" class="btn btn-danger" data-bs-toggle="modal" data-bs-target="#deleteConfirmModal" style="margin-top:10px; width:100%;">
		            회원 탈퇴
		        </button>
		    </div>
	        
			<div class="reservation-section">
			    <h2><span class="fa fa-calendar-check-o"></span> 나의 충전 예약 내역</h2>

			    <c:choose>
			        <c:when test="${not empty reservationList}">
			            
			            <ul class="nav nav-tabs" id="reservationTabs" role="tablist">
			                <li class="nav-item" role="presentation">
			                    <button class="nav-link active" id="reserved-tab" data-bs-toggle="tab" data-bs-target="#reserved-content" type="button" role="tab" aria-controls="reserved-content" aria-selected="true">예약됨</button>
			                </li>
			                <li class="nav-item" role="presentation">
			                    <button class="nav-link" id="completed-tab" data-bs-toggle="tab" data-bs-target="#completed-content" type="button" role="tab" aria-controls="completed-content" aria-selected="false">이용 완료</button>
			                </li>
			                <li class="nav-item" role="presentation">
			                    <button class="nav-link" id="cancelled-tab" data-bs-toggle="tab" data-bs-target="#cancelled-content" type="button" role="tab" aria-controls="cancelled-content" aria-selected="false">취소/만료</button>
			                </li>
			            </ul>
			            <div class="tab-content" id="reservationTabsContent" style="padding-top: 15px;">
			            
			                <div class="tab-pane fade show active" id="reserved-content" role="tabpanel" aria-labelledby="reserved-tab">
			                    <div class="reservation-list-container">
			                        <c:set var="reservedCount" value="0"/>
			                        <c:forEach var="res" items="${reservationList}">
			                            <c:if test="${res.status eq 'RESERVED'}">
			                                <c:set var="reservedCount" value="${reservedCount + 1}"/>
			                                <div class="reservation-card-horizontal" data-status="${res.status}">

			                                    <div class="res-img-box">
			                                        <img src="${pageContext.request.contextPath}/images/default_station.png" 
			                                             style="width:80px; opacity:.6;">
			                                    </div>
			                                    <div style="font-size:13px; color:#777;">
			                                        <strong>충전소</strong><br>
			                                        ${not empty res.stationName ? res.stationName : '정보 없음'}<br>
			                                        <strong>충전기 타입</strong><br>
			                                        <c:choose>
			                                            <c:when test="${not empty res.chargerType and res.chargerType ne '미지정'}">
			                                                <span style="color: ${res.chargerType eq '급속' ? '#2196F3' : '#4CAF50'}; font-weight: 600; font-size: 14px;">
			                                                    ${res.chargerType}
			                                                </span>
			                                            </c:when>
			                                            <c:otherwise>
			                                                <span style="color: #999;">미지정</span>
			                                            </c:otherwise>
			                                        </c:choose>
			                                        <br><br>
			                                        <strong>예약 시간</strong><br>
			                                        ${res.reservationStartFormatted}<br>
			                                        ~ ${res.reservationEndFormatted}
			                                    </div>
			                                    <div style="
			                                        margin-top:12px;
			                                        padding:6px 10px;
			                                        text-align:center;
			                                        border-radius:6px;
			                                        color:#fff;
			                                        font-size:12px;
			                                        font-weight:700;
			                                        background: #52c41a; 
			                                    ">
			                                        예약됨
			                                    </div>
			                                    <button type="button"
                                                    class="btn btn-sm btn-danger cancel-btn"
                                                    style="margin-top:15px; width:100%;"
                                                    data-reservation-id="${res.reservationId}"
                                                    data-payment-key="${res.paymentKey}"> 예약 취소 (환불)
                                                </button>
			                                    </div>
			                            </c:if>
			                        </c:forEach>
			                        <c:if test="${reservedCount == 0}">
			                            <div class="no-reservation-in-tab">현재 진행 중인 예약이 없습니다.</div>
			                        </c:if>
			                    </div>
			                </div> <div class="tab-pane fade" id="completed-content" role="tabpanel" aria-labelledby="completed-tab">
			                    <div class="reservation-list-container">
			                        <c:set var="completedCount" value="0"/>
			                        <c:forEach var="res" items="${reservationList}">
			                            <c:if test="${res.status eq 'COMPLETED'}">
			                                <c:set var="completedCount" value="${completedCount + 1}"/>
			                                <div class="reservation-card-horizontal" data-status="${res.status}">

			                                    <div class="res-img-box">
			                                        <img src="${pageContext.request.contextPath}/images/default_station.png" 
			                                             style="width:80px; opacity:.6;">
			                                    </div>
			                                    <div style="font-size:13px; color:#777;">
			                                        <strong>충전소</strong><br>
			                                        ${not empty res.stationName ? res.stationName : '정보 없음'}<br>
			                                        <strong>충전기 타입</strong><br>
			                                        <c:choose>
			                                            <c:when test="${not empty res.chargerType and res.chargerType ne '미지정'}">
			                                                <span style="color: ${res.chargerType eq '급속' ? '#2196F3' : '#4CAF50'}; font-weight: 600; font-size: 14px;">
			                                                    ${res.chargerType}
			                                                </span>
			                                            </c:when>
			                                            <c:otherwise>
			                                                <span style="color: #999;">미지정</span>
			                                            </c:otherwise>
			                                        </c:choose>
			                                        <br><br>
			                                        <strong>예약 시간</strong><br>
			                                        ${res.reservationStartFormatted}<br>
			                                        ~ ${res.reservationEndFormatted}
			                                    </div>
			                                    <div style="
			                                        margin-top:12px;
			                                        padding:6px 10px;
			                                        text-align:center;
			                                        border-radius:6px;
			                                        color:#fff;
			                                        font-size:12px;
			                                        font-weight:700;
			                                        background: #1890ff; 
			                                    ">
			                                        완료
			                                    </div>
			                                    </div>
			                            </c:if>
			                        </c:forEach>
			                        <c:if test="${completedCount == 0}">
			                            <div class="no-reservation-in-tab">완료된 충전 내역이 없습니다.</div>
			                        </c:if>
			                    </div>
			                </div> <div class="tab-pane fade" id="cancelled-content" role="tabpanel" aria-labelledby="cancelled-tab">
			                    <div class="reservation-list-container">
			                        <c:set var="cancelledCount" value="0"/>
			                        <c:forEach var="res" items="${reservationList}">
			                            <c:if test="${res.status eq 'CANCELLED' or res.status eq 'CANCELED' or res.status eq 'EXPIRED'}">
			                                <c:set var="cancelledCount" value="${cancelledCount + 1}"/>
			                                <div class="reservation-card-horizontal" data-status="${res.status}">

			                                    <div class="res-img-box">
			                                        <img src="${pageContext.request.contextPath}/images/default_station.png" 
			                                             style="width:80px; opacity:.6;">
			                                    </div>
			                                    <div style="font-size:13px; color:#777;">
			                                        <strong>충전소</strong><br>
			                                        ${not empty res.stationName ? res.stationName : '정보 없음'}<br>
			                                        <strong>충전기 타입</strong><br>
			                                        <c:choose>
			                                            <c:when test="${not empty res.chargerType and res.chargerType ne '미지정'}">
			                                                <span style="color: ${res.chargerType eq '급속' ? '#2196F3' : '#4CAF50'}; font-weight: 600; font-size: 14px;">
			                                                    ${res.chargerType}
			                                                </span>
			                                            </c:when>
			                                            <c:otherwise>
			                                                <span style="color: #999;">미지정</span>
			                                            </c:otherwise>
			                                        </c:choose>
			                                        <br><br>
			                                        <strong>예약 시간</strong><br>
			                                        ${res.reservationStartFormatted}<br>
			                                        ~ ${res.reservationEndFormatted}
			                                    </div>
			                                    <div style="
			                                        margin-top:12px;
			                                        padding:6px 10px;
			                                        text-align:center;
			                                        border-radius:6px;
			                                        color:#fff;
			                                        font-size:12px;
			                                        font-weight:700;
			                                        background: #faad14; 
			                                    ">
			                                        <c:choose>
			                                            <c:when test="${res.status eq 'CANCELLED' or res.status eq 'CANCELED'}">취소됨</c:when>
			                                            <c:when test="${res.status eq 'EXPIRED'}">만료</c:when>
			                                            <c:otherwise>오류</c:otherwise>
			                                        </c:choose>
			                                    </div>
			                                    </div>
			                            </c:if>
			                        </c:forEach>
			                        <c:if test="${cancelledCount == 0}">
			                            <div class="no-reservation-in-tab">취소되거나 만료된 내역이 없습니다.</div>
			                        </c:if>
			                    </div>
			                </div> </div> </c:when>
	                
			        <c:otherwise>
			            <div class="no-reservation">
			                아직 예약된 충전 내역이 없습니다. 🚗💨
			            </div>
			        </c:otherwise>

			    </c:choose>

			</div> </main>
	</body>
    
    <div class="modal fade" id="deleteConfirmModal" tabindex="-1" aria-labelledby="modalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="modalLabel">회원 탈퇴 확인</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    정말 탈퇴하시겠습니까? 이 작업은 되돌릴 수 없습니다.
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">취소</button>
                    <form action="delete" method="post" style="margin:0;">
                        <input type="hidden" name="memberId" value="${user.memberId}" />
                        <button type="submit" class="btn btn-danger">회원 탈퇴</button>
                    </form>
                </div>
            </div>
        </div>
    </div>
    
    <div class="modal fade" id="cancelConfirmModal" tabindex="-1" aria-labelledby="cancelModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="cancelModalLabel">예약 취소 확인</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    선택한 충전 예약을 정말 취소하시겠습니까?
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">닫기</button>
                    <button type="button" class="btn btn-danger" id="confirmCancelBtn">예약 취소</button>
                </div>
            </div>
        </div>
    </div>

    <jsp:include page="/WEB-INF/views/common/footer.jsp"/>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script>
document.addEventListener('DOMContentLoaded', function() {
    const cancelModalElement = document.getElementById('cancelConfirmModal');
    const cancelModal = new bootstrap.Modal(cancelModalElement);
    const confirmCancelBtn = document.getElementById('confirmCancelBtn');
    
    let reservationIdToCancel = null;
    let paymentKeyToCancel = null; // ★ 추가
    
    const contextPath = "${pageContext.request.contextPath}";

    document.querySelectorAll('.cancel-btn').forEach(button => {
        button.addEventListener('click', function() {
            reservationIdToCancel = this.dataset.reservationId;
            paymentKeyToCancel = this.dataset.paymentKey; // ★ 값 가져오기
            cancelModal.show();
        });
    });

    confirmCancelBtn.addEventListener('click', async function() {
        if (!reservationIdToCancel) return;

        // [추가] 1. 버튼 비활성화 (중복 클릭 방지)
        confirmCancelBtn.disabled = true;
        confirmCancelBtn.innerText = "처리 중..."; // 텍스트 변경 (선택사항)

        try {
            // 1. 결제 취소 요청 (/cancel)
            // paymentKey가 있는 경우에만 결제 취소 진행 (무료 예약일 수도 있으니)
            if (paymentKeyToCancel && paymentKeyToCancel !== "") {
                const cancelResponse = await fetch(contextPath + '/cancel', {
                    method: 'POST',
                    headers: {'Content-Type': 'application/x-www-form-urlencoded'},
                    body: 'paymentKey=' + encodeURIComponent(paymentKeyToCancel) + 
                          '&cancelReason=' + encodeURIComponent("사용자 예약 취소")
                });
                
                const cancelResult = await cancelResponse.json();
                
                // 토스 취소 실패 시 중단
                if (cancelResponse.status !== 200) {
                    alert('결제 취소 실패: ' + cancelResult.message);
                    return; 
                }
                console.log("결제 취소 성공");
            }

            // 2. 예약 DB 취소 처리 (/reservation/delete)
            // (결제 취소가 성공했거나, 무료 예약인 경우 실행)
            const response = await fetch(contextPath + '/reservation/delete?reservationId=' 
                + reservationIdToCancel, {
                method: 'POST',
                headers: {'Content-Type': 'application/x-www-form-urlencoded'}
            });

            const data = await response.json();

            if (data.success) {
                alert('예약 및 결제가 취소되었습니다.');
                window.location.reload();
            } else {
                alert('DB 예약 취소 처리 실패: ' + data.message);
            }
        } catch (error) {
            console.error('취소 요청 중 오류:', error);
            alert('네트워크 오류가 발생했습니다.');

            // [추가] 2. 에러 발생 시 버튼 다시 살리기 (중요!)
            confirmCancelBtn.disabled = false;
            confirmCancelBtn.innerText = "예약 취소";
        } finally {
            cancelModal.hide();
            reservationIdToCancel = null;
            paymentKeyToCancel = null;
        }
    });
});
</script>
	

	</body>
	</html>