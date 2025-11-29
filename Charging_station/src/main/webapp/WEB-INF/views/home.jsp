<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.ArrayList" %>
<%@ page import="com.boot.Main_Page.dto.ElecDTO" %>
<%@ page import="com.fasterxml.jackson.databind.ObjectMapper" %>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>EV충전소 메인 페이지</title>
<link href="${pageContext.request.contextPath}/css/header.css" rel="stylesheet" type="text/css">
	<link href="${pageContext.request.contextPath}/css/footer.css" rel="stylesheet" type="text/css">
	
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/font-awesome/4.6.3/css/font-awesome.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
    
    <style>
  /* 1. body 스타일 (Sticky Footer 레이아웃) */
  body {
    display: flex;
    flex-direction: column; /* 헤더, main, 푸터를 세로로 쌓음 */
    min-height: 100vh;
    background: #f0f0f0;
    font-family: 'Malgun Gothic', '맑은 고딕', sans-serif;
    margin: 0;
  }
  
  /* 2. [신규] 모든 메인 콘텐츠를 감싸는 래퍼 */
  .main-content-wrapper {
      flex-grow: 1; /* 헤더/푸터 제외 남은 공간 모두 차지 */
      /* 이 태그가 푸터를 밀어내는 역할을 합니다. */
  }

  /* 3. [수정] 애니메이션 영역 (이름 변경 및 flex-grow 제거) */
  .animation-container {
      /* 기존 body의 스타일을 여기로 이동 */
      display: flex;
      justify-content: center;
      align-items: center;
      overflow: hidden;
      background: #f0f0f0; /* body와 동일한 배경색 */
      	padding: 300px 0; /* 위아래 여백 */
  }

  /* 4. (기존 동일) 애니메이션 상세 스타일 */
  .animation-container .container { /* .container 선택자를 좀 더 명확하게 */
    position: relative;
    width: 400px;
    height: 200px;
  }

  .circle {
    width: 100px;
    height: 100px;
    background: #06c75d;
    border-radius: 50%;
    position: absolute;
    left: -60px;
    top: 70px;
    animation: roll 3s forwards;
  }

  @keyframes roll {
    0% { left: -60px; transform: rotate(0deg); }
    50% { left: 175px; transform: rotate(720deg); }
    100% { left: 175px; transform: rotate(720deg); }
  }

  .broken {
    position: absolute;
    left: 175px;
    top: 75px;
    width: 50px;
    height: 50px;
    opacity: 0;
    display: flex;
    justify-content: space-between;
    animation: break 1s forwards 3s;
  }

  .broken div {
    width: 24px;
    height: 50px;
    background: #06c75d;
    transform-origin: top;
  }

  .broken div:nth-child(1) { transform: rotate(-30deg); }
  .broken div:nth-child(2) { transform: rotate(30deg); }

  @keyframes break {
    0% { opacity: 0; }
    1% { opacity: 1; }
    100% { transform: translateX(-10px) rotate(-30deg); opacity: 1; }
  }

  .name {
    position: absolute;
    left: 250px;
    top: 105px;
    font-size: 35px;
    font-weight: bold;
    opacity: 0;
    animation: showName 1s forwards 4s;
  }

  @keyframes showName {
    0% { opacity: 0; }
    100% { opacity: 1; }
  }
  
  /* 5. 기능 소개 섹션 */
  .feature-section {
      background: #ffffff; /* 흰색 배경 */
      padding: 80px 0;
      text-align: center;
  }
  .feature-section h2 {
      font-weight: 700;
      margin-bottom: 60px;
      color: #333;
  }
  .feature-item {
      padding: 20px;
      cursor: pointer;
      transition: all 0.3s ease;
  }
  .feature-item:hover {
      transform: translateY(-5px);
  }
  .feature-item i { /* Font Awesome 아이콘 */
      font-size: 3.5rem;
      color: #007bff; /* 포인트 컬러 */
      margin-bottom: 25px;
  }
  .feature-item h3 {
      font-size: 1.5rem;
      font-weight: 600;
      margin-bottom: 15px;
  }
  .feature-item p {
    color: #555;
    line-height: 1.6;
    font-size: 1rem;
  }
  
  /* 충전 어댑터 애니메이션 섹션 */
  .adapter-section {
    background: #f8f9fa;
    padding: 80px 20px;
    text-align: center;
  }
  .adapter-section h3 {
    font-weight: 700;
    margin-bottom: 50px;
    color: #333;
    font-size: 2rem;
  }
  .adapter-container {
    max-width: 1200px;
    margin: 0 auto;
    position: relative;
    height: 250px;
  }
  .adapter-row {
    display: flex;
    justify-content: center;
    align-items: center;
    gap: 30px;
    flex-wrap: wrap;
  }
  .adapter-item {
    flex: 0 0 calc(25% - 30px);
    max-width: 200px;
    background: white;
    border-radius: 15px;
    padding: 30px 20px;
    box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
    opacity: 0.4;
    transform: scale(0.9);
    transition: all 0.5s ease;
    position: relative;
  }
  .adapter-item.active {
    opacity: 1;
    transform: scale(1);
    box-shadow: 0 10px 30px rgba(42, 82, 152, 0.3);
    border: 2px solid #2a5298;
  }
  .adapter-item img {
    width: 100%;
    max-width: 120px;
    height: auto;
    margin-bottom: 15px;
    object-fit: contain;
  }
  .adapter-item h4 {
    font-size: 1.1rem;
    font-weight: 600;
    color: #333;
    margin-bottom: 5px;
  }
  .adapter-item p {
    font-size: 0.9rem;
    color: #666;
    margin: 0;
  }
  
  /* 반응형 */
  @media (max-width: 992px) {
    .adapter-item {
      flex: 0 0 calc(50% - 30px);
    }
  }
  @media (max-width: 576px) {
    .adapter-item {
      flex: 0 0 100%;
    }
  }
  
  /* 6. 텍스트 애니메이션 섹션 (EV충전소 스타일) */
  .text-animation-section {
    width: 100%;
    padding: 80px 20px;
    background: #ffffff;
    display: flex;
    align-items: center;
    justify-content: center;
  }

  .text-animation-container {
    max-width: 1200px;
    margin: 0 auto;
    display: flex;
    align-items: center;
    justify-content: space-between;
    gap: 60px;
  }

  .text-animation-content {
    flex: 1;
    display: flex;
    flex-direction: column;
    justify-content: center;
    align-items: center;
    text-align: center;
  }

  .text-animation-wrapper {
    display: flex;
    flex-direction: column;
    gap: 20px;
    align-items: center;
  }

  .text-animation-item {
    font-size: 3rem;
    font-weight: bold;
    color: #2a5298;
    opacity: 0;
    transform: translateY(30px);
    display: inline-block;
  }

  .text-animation-image {
    flex: 1;
    display: flex;
    align-items: center;
    justify-content: center;
    opacity: 0;
    animation: fadeInRight 1s ease-out 0.5s forwards;
  }

  .text-animation-image img {
    max-width: 100%;
    height: auto;
    max-height: 500px;
    object-fit: contain;
    border-radius: 0;
    filter: drop-shadow(0 10px 30px rgba(0, 0, 0, 0.1));
    animation: floatAnimation 3s ease-in-out infinite;
    transition: all 0.3s ease;
  }

  .text-animation-image img:hover {
    filter: drop-shadow(0 15px 40px rgba(42, 82, 152, 0.15));
    transform: translateY(-5px) scale(1.02);
  }

  @keyframes fadeInRight {
    from {
      opacity: 0;
      transform: translateX(30px);
    }
    to {
      opacity: 1;
      transform: translateX(0);
    }
  }

  @keyframes floatAnimation {
    0%, 100% {
      transform: translateY(0px) scale(1);
    }
    50% {
      transform: translateY(-10px) scale(1.01);
    }
  }

  .text-animation-item.animate {
    animation: fadeInUp 0.8s ease-out forwards;
  }

  /* 페이드인 + 슬라이드업 애니메이션 */
  @keyframes fadeInUp {
    from {
      opacity: 0;
      transform: translateY(30px);
    }
    to {
      opacity: 1;
      transform: translateY(0);
    }
  }

  /* 페이드인 + 다운 */
  @keyframes fadeInDown {
    from {
      opacity: 0;
      transform: translateY(-30px);
    }
    to {
      opacity: 1;
      transform: translateY(0);
    }
  }

  /* 반짝이는 효과 */
  @keyframes shimmer {
    0% {
      background-position: -1000px 0;
    }
    100% {
      background-position: 1000px 0;
    }
  }

  .shimmer-effect {
    background: linear-gradient(
      90deg,
      rgba(30, 60, 114, 0) 0%,
      rgba(42, 82, 152, 0.8) 50%,
      rgba(30, 60, 114, 0) 100%
    );
    background-size: 1000px 100%;
    background-clip: text;
    -webkit-background-clip: text;
    -webkit-text-fill-color: transparent;
    animation: shimmer 2s infinite;
  }

  /* 반응형 디자인 */
  @media (max-width: 768px) {
    .text-animation-container {
      flex-direction: column;
      text-align: center;
    }
    
    .text-animation-item {
      font-size: 2rem;
    }

    .text-animation-image {
      width: 100%;
      max-width: 300px;
    }

    .text-animation-image img {
      max-height: 300px;
    }
  }
  
</style>
</head>
<body>
	<jsp:include page="/WEB-INF/views/common/header.jsp"/>

  <main class="main-content-wrapper">
      <!-- 텍스트 애니메이션 섹션 -->
      <section class="text-animation-section">
        <div class="text-animation-container">
          <div class="text-animation-content">
            <div class="text-animation-wrapper">
              <span class="text-animation-item">더 빠르게</span>
              <span class="text-animation-item">더 편하게</span>
              <span class="text-animation-item">더 안전하게</span>
            </div>
          </div>
          <div class="text-animation-image">
            <img src="https://img.seoul.co.kr/img/upload/2021/01/21/SSI_20210121175944_O2.jpg" alt="전기차 충전소">
          </div>
        </div>
      </section>
    
      <section class="feature-section">
             <div class="container">
                 <h2>EV충전소만의 특별한 기능</h2>
                 <div class="row">
                     <div class="col-md-4">
                         <div class="feature-item" onclick="location.href='${pageContext.request.contextPath}/map_kakao'">
                             <i class="fas fa-bolt"></i>
                             <h3>실시간 충전 위치</h3>
                             <p>사용 가능한 충전기 위치 정보를 확인하세요.</p>
                         </div>
                     </div>
                     <div class="col-md-4">
                         <div class="feature-item" onclick="handleFavoriteClick()">
                             <i class="fas fa-star"></i>
                             <h3>나만의 즐겨찾기</h3>
                             <p>자주 가는 충전소를 저장하고 빠르게 경로를 찾으세요.</p>
                         </div>
                     </div>
                     <div class="col-md-4">
                         <div class="feature-item" onclick="location.href='${pageContext.request.contextPath}/board'">
                             <i class="fas fa-comments"></i>
                             <h3>사용자 실제 후기</h3>
                             <p>다른 사용자들이 남긴 생생한 후기를 참고하세요.</p>
                         </div>
                     </div>
                 </div>
             </div>
      </section>

      <!-- 충전 어댑터 종류 섹션 -->
      <section class="adapter-section">
        <div class="container">
          <h3>지원하는 충전 어댑터 종류</h3>
          <div class="adapter-container">
            <div class="adapter-row">
              <div class="adapter-item" data-adapter="1">
                <img src="https://www.evchargingsolutions.co.uk/images/CCS%20connector.png" alt="CCS 콤보" onerror="this.src='data:image/svg+xml,%3Csvg xmlns=\'http://www.w3.org/2000/svg\' width=\'120\' height=\'80\'%3E%3Crect width=\'120\' height=\'80\' fill=\'%23e3f2fd\'/%3E%3Ctext x=\'50%25\' y=\'50%25\' text-anchor=\'middle\' dominant-baseline=\'middle\' font-size=\'12\' fill=\'%232196F3\'%3ECCS%3C/text%3E%3C/svg%3E'">
                <h4>DC콤보 (CCS)</h4>
                <p>유럽/미국 표준 급속충전</p>
              </div>
              <div class="adapter-item" data-adapter="2">
                <img src="https://www.evchargingsolutions.co.uk/images/CHAdeMO%20connector.png" alt="CHAdeMO" onerror="this.src='data:image/svg+xml,%3Csvg xmlns=\'http://www.w3.org/2000/svg\' width=\'120\' height=\'80\'%3E%3Crect width=\'120\' height=\'80\' fill=\'%23fff3e0\'/%3E%3Ctext x=\'50%25\' y=\'50%25\' text-anchor=\'middle\' dominant-baseline=\'middle\' font-size=\'12\' fill=\'%23FF9800\'%3ECHAdeMO%3C/text%3E%3C/svg%3E'">
                <h4>DC차데모</h4>
                <p>일본 표준 급속충전</p>
              </div>
              <div class="adapter-item" data-adapter="3">
                <img src="https://www.evchargingsolutions.co.uk/images/Type%202%20connector.png" alt="AC 완속" onerror="this.src='data:image/svg+xml,%3Csvg xmlns=\'http://www.w3.org/2000/svg\' width=\'120\' height=\'80\'%3E%3Crect width=\'120\' height=\'80\' fill=\'%23e8f5e9\'/%3E%3Ctext x=\'50%25\' y=\'50%25\' text-anchor=\'middle\' dominant-baseline=\'middle\' font-size=\'12\' fill=\'%234CAF50\'%3EAC완속%3C/text%3E%3C/svg%3E'">
                <h4>AC 완속</h4>
                <p>일반 완속충전</p>
              </div>
              <div class="adapter-item" data-adapter="4">
                <img src="https://www.tesla.com/sites/default/files/images/tesla_logo.png" alt="테슬라" onerror="this.src='data:image/svg+xml,%3Csvg xmlns=\'http://www.w3.org/2000/svg\' width=\'120\' height=\'80\'%3E%3Crect width=\'120\' height=\'80\' fill=\'%23f3e5f5\'/%3E%3Ctext x=\'50%25\' y=\'50%25\' text-anchor=\'middle\' dominant-baseline=\'middle\' font-size=\'12\' fill=\'%239C27B0\'%3ETesla%3C/text%3E%3C/svg%3E'">
                <h4>테슬라 전용</h4>
                <p>테슬라 Supercharger</p>
              </div>
            </div>
          </div>
        </div>
      </section>

  </main>
  <jsp:include page="/WEB-INF/views/common/footer.jsp"/>
  
  <script>
    // 텍스트 애니메이션 스크립트
    document.addEventListener('DOMContentLoaded', function() {
      const animatedTexts = document.querySelectorAll('.text-animation-item');
      
      // 각 텍스트를 순차적으로 애니메이션
      animatedTexts.forEach((text, index) => {
        setTimeout(() => {
          text.classList.add('animate');
          
          // 애니메이션 후 반짝이는 효과 추가
          setTimeout(() => {
            text.classList.add('shimmer-effect');
          }, 800);
        }, index * 300); // 각 텍스트마다 300ms 지연
      });
    });

    // 즐겨찾기 클릭 처리
    function handleFavoriteClick() {
      var isLoggedIn = ${not empty sessionScope.id};
      if (!isLoggedIn) {
        if (confirm('로그인이 필요한 기능입니다. 로그인 페이지로 이동하시겠습니까?')) {
          location.href = '${pageContext.request.contextPath}/login';
        }
      } else {
        location.href = '${pageContext.request.contextPath}/map_kakao';
      }
    }

    // 충전 어댑터 애니메이션
    document.addEventListener('DOMContentLoaded', function() {
      const adapterItems = document.querySelectorAll('.adapter-item');
      let currentIndex = 0;

      function highlightNextAdapter() {
        // 모든 아이템에서 active 제거
        adapterItems.forEach(item => {
          item.classList.remove('active');
        });

        // 다음 아이템 활성화
        adapterItems[currentIndex].classList.add('active');
        
        // 다음 인덱스로 이동
        currentIndex = (currentIndex + 1) % adapterItems.length;
      }

      // 첫 번째 아이템부터 시작
      if (adapterItems.length > 0) {
        highlightNextAdapter();
        // 3초마다 다음 아이템으로 변경
        setInterval(highlightNextAdapter, 3000);
      }
    });
  </script>
</body>
</html>