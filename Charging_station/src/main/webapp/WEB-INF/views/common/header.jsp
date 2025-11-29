<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Header</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
    <link href="${pageContext.request.contextPath}/css/header.css" rel="stylesheet" type="text/css">
</head>
<body>
    <nav id="nav3">
        <a href="${pageContext.request.contextPath}/home" class="logo">
            <img class="nav-icon" src="${pageContext.request.contextPath}/image/EV.png" alt="EV충전소 로고"> EV충전소
        </a>
        
        <ul class="main-nav">
            <li><a href="${pageContext.request.contextPath}/home"><img class="nav-icon" src="${pageContext.request.contextPath}/image/home.png" alt="홈">홈</a></li>
            <li><a href="${pageContext.request.contextPath}/map_kakao"><img class="nav-icon" src="${pageContext.request.contextPath}/image/charging.png" alt="충전소 찾기">충전소 찾기</a></li> 
            <li><a href="${pageContext.request.contextPath}/notice"><img class="nav-icon" src="${pageContext.request.contextPath}/image/notificaiton.png" alt="공지사항">공지사항</a></li>
            <li><a href="${pageContext.request.contextPath}/board"><img class="nav-icon" src="${pageContext.request.contextPath}/image/board.png" alt="자유게시판">자유게시판</a></li>
        </ul>

        <ul class="user-nav">
            <c:choose>
                <c:when test="${empty sessionScope.id}"> 
                    <li><button type="button" onclick="location.href='${pageContext.request.contextPath}/login'">로그인</button></li>
                    <li><button type="button" onclick="location.href='${pageContext.request.contextPath}/register'">회원가입</button></li>
                </c:when>
                <c:otherwise>
					<li>
					    <%-- 💡 수정된 부분: showFavoriteList 함수 호출 --%>
					    <a href="javascript:void(0);" onclick="showFavoriteList(event)">
					        <img class="nav-icon" src="../image/favourite.png" alt="즐겨찾기">즐겨찾기
					    </a>
					</li>
                    <li class="user-dropdown-container">
                        <button type="button" id="userMenuTrigger" class="user-menu-trigger">
                            <c:if test="${sessionScope.admin != 1}">
                                <img class="nav-icon" src="${pageContext.request.contextPath}/image/member.png" alt="회원 아이콘" />
                            </c:if>
                            <c:if test="${sessionScope.admin == 1}">
                                <img class="nav-icon" src="${pageContext.request.contextPath}/image/admin.png" alt="어드민 아이콘" />
                            </c:if>
                            <span>${sessionScope.name}님!</span>
                            <i class="fas fa-chevron-down"></i>
                        </button>
                        <div id="userMenuDropdown" class="user-dropdown-menu">
                            <ul>
                                <c:if test="${sessionScope.admin == 1}">
                                    <li>
                                        <form method="get" action="role" style="margin: 0;">
                                            <button type="submit">관리자페이지</button>
                                        </form>
                                    </li>
                                </c:if>
                                <li><a href="${pageContext.request.contextPath}/list">마이페이지</a></li>
                                <li>
                                    <form method="post" action="${pageContext.request.contextPath}/logout" style="margin: 0;">
                                        <button type="submit">로그아웃</button>
                                    </form>
                                </li>
                            </ul>
                        </div>
                    </li>
                </c:otherwise>
            </c:choose>
        </ul>
    </nav>

    <script>
        document.addEventListener("DOMContentLoaded", function() {
            var trigger = document.getElementById("userMenuTrigger");
            var dropdown = document.getElementById("userMenuDropdown");

            if (trigger && dropdown) {
                trigger.addEventListener("click", function(event) {
                    event.stopPropagation(); 
                    dropdown.classList.toggle("show"); 
                });

                window.addEventListener("click", function(event) {
                    if (dropdown.classList.contains("show") && !trigger.contains(event.target)) {
                        dropdown.classList.remove("show"); 
                    }
                });
            }
        });
        
        /**
         * 🌟 [수정된 함수] 즐겨찾기 메뉴 클릭 시 호출됩니다.
         * map_kakao.jsp에 정의된 fetchFavoriteStations 함수를 호출합니다.
         */
        function showFavoriteList(event) {
            // a 태그의 기본 동작(페이지 이동) 방지
            if (event) event.preventDefault();
            
            // 1. 로그인 체크 (JSTL로 확인된 상태 사용)
            if (!(${not empty sessionScope.id})) {
                alert("로그인이 필요한 기능입니다.");
                // map_kakao가 아닌 다른 페이지에서 누른 경우를 대비해 이동
                location.href='${pageContext.request.contextPath}/login'; 
                return;
            }

            // 2. 현재 페이지가 map_kakao.jsp인지 확인하여 함수 존재 여부 체크
            if (typeof fetchFavoriteStations !== 'function') {
                alert("즐겨찾기 목록은 '충전소 찾기' 페이지에서만 볼 수 있습니다. 페이지를 이동합니다.");
                location.href='${pageContext.request.contextPath}/map_kakao';
                return;
            }

            // 3. map_kakao.jsp의 fetchFavoriteStations 함수를 호출하여 목록 조회 및 지도 표시를 위임합니다.
            fetchFavoriteStations();
        }
    </script>
</body>
</html>