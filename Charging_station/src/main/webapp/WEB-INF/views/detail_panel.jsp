<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<style>
	/* 닫기 버튼 */
	.close-btn {
	    position: absolute;
	    top: 20px;
	    right: 20px;
	    width: 36px;
	    height: 36px;
	    font-size: 24px;
	    font-weight: 300;
	    color: #666;
	    background: rgba(0, 0, 0, 0.05);
	    border: none;
	    border-radius: 50%;
	    cursor: pointer;
	    transition: all 0.3s ease;
	    display: flex;
	    align-items: center;
	    justify-content: center;
	    z-index: 10;
	    line-height: 1;
	}
	.close-btn:hover {
	    background: rgba(0, 0, 0, 0.1);
	    color: #333;
	    transform: rotate(90deg);
	}

	/* 패널 전체 */
	#detail-panel {
	    font-family: 'Noto Sans KR', 'Malgun Gothic', '맑은 고딕', sans-serif;
	    background: white;
	    padding: 0;
	    overflow-y: auto;
	}

	/* 헤더 영역 (그라데이션 배경) */
	.detail-header {
	    background: linear-gradient(135deg, #52c41a 0%, #95de64 100%);
	    padding: 32px 24px 24px;
	    position: relative;
	}

	/* 충전소 이름 */
	#detail-panel #station-name {
	    font-size: 22px;
	    font-weight: 700;
	    color: white;
	    margin: 0 0 12px 0;
	    padding-right: 50px;
	    line-height: 1.4;
	    text-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
	}

	/* 주소 */
	#detail-panel #station-address {
	    font-size: 14px;
	    color: rgba(255, 255, 255, 0.95);
	    margin: 0;
	    line-height: 1.6;
	    padding-right: 50px;
	}

	/* 즐겨찾기 버튼 */
	#favorite-btn {
	    position: absolute; 
	    top: 60px; 
	    right: 20px;
	    background: none;
	    border: none;
	    font-size: 28px; 
	    color: white; 
	    cursor: pointer;
	    padding: 0;
	    line-height: 1;
	    transition: color 0.2s, transform 0.2s;
	}
	#favorite-btn:hover { color: #fff; }

	/* 즐겨찾기 상태별 스타일 */
	#favorite-btn[data-status="unfavorited"] {
	    color: rgba(255, 255, 255, 0.6);
	    font-family: Arial, sans-serif;
	    font-size: 32px;
	}
	#favorite-btn[data-status="unfavorited"]:hover {
	    color: #ffc107;
	    transform: scale(1.2);
	}
	#favorite-btn[data-status="favorited"] {
	    color: #ffc107;
	    font-family: Arial, sans-serif;
	    font-size: 32px;
	}
	#favorite-btn[data-status="favorited"]:hover { color: #e0a800; }
	#favorite-btn[data-status="logged-out"] {
	    color: rgba(255, 255, 255, 0.4);
	    cursor: not-allowed;
	    font-family: Arial, sans-serif;
	    font-size: 32px;
	}

	/* 컨텐츠 영역 */
	.detail-content { padding: 24px; }

	/* 섹션 타이틀 */
	.section-title {
	    font-size: 15px;
	    font-weight: 700;
	    color: #333;
	    margin: 0 0 16px 0;
	    display: flex;
	    align-items: center;
	    gap: 8px;
	}
	.section-title::before {
	    content: '';
	    width: 4px;
	    height: 18px;
	    background: linear-gradient(135deg, #52c41a 0%, #95de64 100%); 
	    border-radius: 2px;
	}

	/* 운영 정보 섹션 */
	.info-section {
	    background: #f8f9fa;
	    border-radius: 12px;
	    padding: 20px;
	    margin-bottom: 20px;
	}
	.info-section p {
	    font-size: 14px;
	    color: #555;
	    margin: 0 0 12px 0;
	    line-height: 1.6;
	    display: flex;
	    align-items: flex-start;
	}
	.info-section p:last-child { margin-bottom: 0; }
	.info-label {
	    font-weight: 600;
	    color: #333;
	    min-width: 110px;
	    flex-shrink: 0;
	}
	.info-value { color: #666; flex: 1; }

	/* --- ⚡ 충전기 현황 카드 및 리스트 스타일 (개선됨) --- */
	.status-section { margin-bottom: 20px; }

	.charger-cards {
	    display: grid;
	    grid-template-columns: 1fr 1fr;
	    gap: 12px;
	    margin-top: 16px;
	}

	.charger-card {
	    background: white;
	    border: 2px solid #e9ecef;
	    border-radius: 12px;
	    padding: 20px 16px;
	    text-align: center;
	    transition: all 0.3s ease;
	    cursor: pointer;
	    position: relative;
	}

	.charger-card:hover {
	    transform: translateY(-2px);
	    box-shadow: 0 6px 16px rgba(0, 0, 0, 0.08);
	    border-color: #52c41a;
	}

	.charger-card.fast {
	    border-color: #e3f2fd;
	    background: linear-gradient(180deg, #ffffff 0%, #f0f7ff 100%);
	}
	.charger-card.slow {
	    border-color: #e8f5e9;
	    background: linear-gradient(180deg, #ffffff 0%, #f1f8f4 100%);
	}

	.charger-icon { font-size: 28px; margin-bottom: 8px; display: block; }
	.charger-type {
	    font-size: 11px;
	    font-weight: 600;
	    color: #999;
	    text-transform: uppercase;
	    letter-spacing: 0.5px;
	    margin-bottom: 4px;
	}
	.charger-card.fast .charger-type { color: #2196F3; }
	.charger-card.slow .charger-type { color: #4CAF50; }

	.charger-count {
	    font-size: 24px;
	    font-weight: 800;
	    color: #333;
	    margin-bottom: 4px;
	}
	.charger-label { font-size: 12px; color: #666; margin-bottom: 10px; }

	/* 🔽 클릭 시 펼쳐지는 상세 목록 디자인 개선 */
	.charger-details-list {
	    display: none;
	    list-style: none;
	    padding: 15px 10px 5px;
	    margin: 10px -16px -20px;
	    border-top: 1px solid rgba(0,0,0,0.06);
	    background: rgba(255,255,255,0.6);
	    border-radius: 0 0 12px 12px;
	    text-align: left;
	    font-size: 13px;
	}

	.charger-details-list li {
	    display: flex;
	    justify-content: space-between;
	    align-items: center;
	    padding: 6px 0;
	    border-bottom: 1px dashed #eee;
	}
	.charger-details-list li:last-child { border-bottom: none; }

	.charger-details-list li span:first-child {
	    color: #555;
	    font-weight: 500;
	    white-space: nowrap;
	    overflow: hidden;
	    text-overflow: ellipsis;
	    max-width: 110px; 
	}
	.charger-details-list li span:last-child {
	    font-weight: 700;
	    color: #333;
	    background: #fff;
	    padding: 2px 8px;
	    border-radius: 10px;
	    box-shadow: 0 1px 3px rgba(0,0,0,0.1);
	    font-size: 12px;
	}

	/* 이용 제한 뱃지 */
	.restriction-badge {
	    display: inline-block;
	    padding: 6px 12px;
	    background: #f1f3f5;
	    border: 1px solid #dee2e6;
	    border-radius: 20px;
	    font-size: 13px;
	    font-weight: 600;
	    color: #495057;
	    margin-top: 8px;
	}
	/* 노란색 뱃지 (이용자제한) */
	.restriction-badge.badge-yellow {
	    background: linear-gradient(135deg, rgba(255, 193, 7, 0.1) 0%, rgba(255, 213, 79, 0.1) 100%);
	    border-color: rgba(255, 193, 7, 0.3);
	    color: #e6a800;
	}
	/* 빨간색 뱃지 (비공개/점검) */
	.restriction-badge.badge-red {
	    background: linear-gradient(135deg, rgba(244, 67, 54, 0.1) 0%, rgba(255, 138, 128, 0.1) 100%);
	    border-color: rgba(244, 67, 54, 0.3);
	    color: #d93025;
	}

	/* 구분선 */
	.divider { height: 1px; background: #e9ecef; margin: 24px 0; }

	/* 길찾기 버튼 그룹 */
	#detail-panel .action-buttons {
	    margin-top: 25px;
	    padding-top: 20px;
	    border-top: 1px solid #f0f0f0;
	    display: flex;
	    justify-content: center;
	    gap: 12px;
	}
	#detail-panel .navi-btn, #detail-panel .roadview-btn, #detail-panel .logistic-btn {
	    display: inline-flex;
	    align-items: center;
	    justify-content: center;
	    padding: 12px 20px;
	    font-size: 14px;
	    font-weight: 700;
	    text-decoration: none;
	    border-radius: 8px;
	    transition: all 0.2s;
	    box-shadow: 0 2px 6px rgba(0,0,0,0.1);
	}
	#detail-panel .navi-btn {
	    background-color: #FEE500; color: #181600;
	}
	#detail-panel .navi-btn:hover { background-color: #F7E000; transform: translateY(-2px); }

	#detail-panel .roadview-btn {
	    background-color: #007bff; color: white;
	}
	#detail-panel .roadview-btn:hover { background-color: #0056b3; transform: translateY(-2px); }
	#detail-panel .logistic-btn {
	    background-color: #343aeb;
	    color: #fff;
	}
	#detail-panel .logistic-btn.active {
	    background-color: #1d1db2;
	}
	#detail-panel .logistic-btn:hover {
	    transform: translateY(-2px);
	}

	#detail-panel .report-malfunction-btn {
	    background-color: #dc3545;
	    color: white;
	}
	#detail-panel .report-malfunction-btn:hover {
	    background-color: #c82333; 
	    transform: translateY(-2px);
	}

	/* 스크롤바 */
	#detail-panel::-webkit-scrollbar { width: 6px; }
	#detail-panel::-webkit-scrollbar-track { background: transparent; }
	#detail-panel::-webkit-scrollbar-thumb { background: rgba(0, 0, 0, 0.2); border-radius: 10px; }
	#detail-panel::-webkit-scrollbar-thumb:hover { background: rgba(0, 0, 0, 0.3); }

	/* 🌟 제3의 패널: 개별 충전기 상태창 */
	#status-detail-panel {
	    position: absolute;
	    top: 60px;
	    right: 0;
	    width: 320px;
	    height: calc(100vh - 60px);
	    background: #fff;
	    z-index: 2000;
	    box-shadow: -4px 0 12px rgba(0,0,0,0.1);
	    border-left: 1px solid #eee;
	    overflow-y: auto;
	    display: none;
	    transition: transform 0.3s ease;
	    transform: translateX(100%);
	}
	#status-detail-panel.open {
	    display: block;
	    transform: translateX(0);
	}

	.status-header {
	    background: #343a40;
	    color: white;
	    padding: 15px;
	    font-weight: 700;
	    display: flex;
	    justify-content: space-between;
	    align-items: center;
	}

	.status-list {
	    list-style: none;
	    padding: 0;
	    margin: 0;
	}

	.status-item {
	    padding: 15px;
	    border-bottom: 1px solid #f1f3f5;
	    display: flex;
	    align-items: center;
	    gap: 12px;
	}

	/* 상태 아이콘 (원형) */
	.status-indicator {
	    width: 12px;
	    height: 12px;
	    border-radius: 50%;
	    display: inline-block;
	}
	.stat-green { background-color: #52c41a; box-shadow: 0 0 8px rgba(82,196,26,0.4); }
	.stat-red { background-color: #ff4d4f; box-shadow: 0 0 8px rgba(255,77,79,0.4); animation: pulse 2s infinite; }
	.stat-gray { background-color: #adb5bd; }

	.charger-id-badge {
	    background: #f8f9fa;
	    border: 1px solid #dee2e6;
	    padding: 2px 6px;
	    border-radius: 4px;
	    font-size: 12px;
	    font-weight: 700;
	    color: #495057;
	}

	.charger-info-text {
	    font-size: 13px;
	    color: #333;
	}
	.charger-status-text {
	    font-size: 12px;
	    font-weight: 700;
	    margin-left: auto;
	}

	@keyframes pulse {
	    0% { opacity: 1; }
	    50% { opacity: 0.6; }
	    100% { opacity: 1; }
	}

	.congestion-prediction-section {
	    margin-bottom: 20px;
	    padding: 16px;
	    background: #f8f9fa;
	    border-radius: 12px;
	    display: none;
	}

	.congestion-chart-wrapper {
	    position: relative;
	    width: 100%;
	    height: 200px;
	    margin-top: 12px;
	    border: 1px solid #e9ecef;
	    border-radius: 10px;
	    background: #fff;
	    overflow: hidden;
	}

	#congestion-chart {
	    width: 100%;
	    height: 100%;
	    display: block;
	    position: relative;
	    z-index: 1;
	    background: #fff;
	}

	.chart-placeholder {
	    position: absolute;
	    inset: 0;
	    display: flex;
	    align-items: center;
	    justify-content: center;
	    font-size: 13px;
	    color: #777;
	    background: rgba(255,255,255,0.9);
	    text-align: center;
	    padding: 0 16px;
	    z-index: 10;
	    pointer-events: none;
	}

	.next-hour-info {
	    margin-top: 12px;
	    font-size: 13px;
	    color: #555;
	    background: #fff;
	    border-radius: 8px;
	    padding: 10px 12px;
	    border: 1px dashed #d9d9d9;
	}

	/* 예약 모달 */
	.reservation-modal {
	    display: none;
	    position: fixed;
	    top: 0;
	    left: 0;
	    width: 100%;
	    height: 100%;
	    background: rgba(0, 0, 0, 0.5);
	    z-index: 9999;
	    align-items: center;
	    justify-content: center;
	}

	.reservation-modal.show {
	    display: flex;
	}

	.reservation-modal-content {
	    background: white;
	    border-radius: 16px;
	    padding: 32px;
	    width: 90%;
	    max-width: 400px;
	    max-height: 80vh;
	    overflow-y: auto;
	    box-shadow: 0 8px 32px rgba(0, 0, 0, 0.2);
	}

	.reservation-modal h3 {
	    margin: 0 0 24px 0;
	    font-size: 20px;
	    font-weight: 700;
	    color: #333;
	    text-align: center;
	}

	.reservation-form-group {
	    margin-bottom: 20px;
	}

	.reservation-form-group label {
	    display: block;
	    font-size: 14px;
	    font-weight: 600;
	    color: #333;
	    margin-bottom: 8px;
	}

	/* 날짜 입력 필드 스타일 */
	.reservation-form-group input[type="date"] {
	    width: 100%;
	    padding: 12px;
	    border: 2px solid #e9ecef;
	    border-radius: 8px;
	    font-size: 14px;
	    transition: border-color 0.3s;
	}

	.reservation-form-group input:focus {
	    outline: none;
	    border-color: #52c41a;
	}

	/* 시간 선택 그리드 */
	.time-grid {
	    display: grid;
	    grid-template-columns: repeat(4, 1fr);
	    gap: 10px;
	    margin-top: 15px;
	}

	.time-btn {
	    padding: 10px 5px;
	    border: 1px solid #000;
	    border-radius: 5px;
	    background-color: white;
	    color: #000;
	    cursor: pointer;
	    font-size: 14px;
	    font-weight: 600;
	    transition: all 0.2s;
	    min-height: 40px;
	}

	/* hover */
	.time-btn:hover:not(.selected):not(.unavailable) {
	    background-color: #f2f2f2;
	    border-color: #000;
	}

	/* 선택 시 초록색 스타일 */
	.time-btn.selected {
	    background-color: #52c41a; 
	    color: white;
	    border-color: #52c41a;
	    font-weight: bold;
	}

	/* ★ 예약 불가능 시간 스타일 (어둡게 처리, 취소선 제거) */
	.time-btn.unavailable {
	    background-color: #d9d9d9;
	    color: #888;
	    border-color: #ccc;
	    cursor: not-allowed;
	    opacity: 0.6;
	}

	/* 버튼 섹션 스타일 */
	.reservation-modal-buttons {
	    display: flex;
	    justify-content: center; 
	    gap: 12px;
	    margin-top: 24px;
	}

	.reservation-modal-buttons button {
	    flex: 1; 
	    padding: 12px;
	    border: none;
	    border-radius: 8px;
	    font-size: 14px;
	    font-weight: 600;
	    cursor: pointer;
	    transition: all 0.3s;
	}

	/* 🟢 '예약하기'는 초록색 */
	.reservation-confirm-btn {
	    background: #52c41a; 
	    color: white;
	}

	.reservation-confirm-btn:hover {
	    background: #45a916;
	}

	/* ⚪ '취소'는 밝은 회색 */
	.reservation-cancel-btn {
	    background: #f0f0f0;
	    color: #666;
	}

	.reservation-cancel-btn:hover {
	    background: #e0e0e0;
	}
</style>

<script src="https://js.tosspayments.com/v2/standard"></script>

<div id="detail-panel">
    <button id="close-btn" class="close-btn" title="닫기">&times;</button>

    <div class="detail-header">
        <h3 id="station-name">충전소 이름</h3>
        <p id="station-address">주소 정보</p>
        
        <c:if test="${not empty sessionScope.id}">
            <button id="favorite-btn" data-status="unfavorited" title="즐겨찾기 추가/삭제">☆</button> 
        </c:if>
    </div>

    <div class="detail-content">
        
        <div class="status-section">
            <div class="section-title">⚡ 충전기 현황 (클릭하여 상세 보기)</div>
            <div class="charger-cards">
                
                <div class="charger-card fast clickable" id="fast-charger-toggle" data-target="#fast-details-list">
                    <span class="charger-icon">⚡</span>
                    <div class="charger-type">급속</div>
                    <div id="fast-charger-count" class="charger-count">0</div>
                    <div class="charger-label">대</div>
                    
                    <ul class="charger-details-list" id="fast-details-list"></ul>
                </div>
                
                <div class="charger-card slow clickable" id="slow-charger-toggle" data-target="#slow-details-list">
                    <span class="charger-icon">🔌</span>
                    <div class="charger-type">완속</div>
                    <div id="slow-charger-count" class="charger-count">0</div>
                    <div class="charger-label">대</div>
                    
                    <ul class="charger-details-list" id="slow-details-list"></ul>
                </div>
            </div>
        </div>

        <div class="divider"></div>

        <!-- 🌟 시간대별 혼잡도 예측 (예약 데이터 기반) -->
        <div class="congestion-prediction-section" id="congestion-prediction-section" style="display: none;">
            <div class="section-title">📊 시간대별 혼잡도 예측</div>
            <div id="prediction-info" class="prediction-info" style="font-size: 12px; color: #666; margin-bottom: 12px; padding: 10px; background: linear-gradient(135deg, #e6f7ff 0%, #f0f9ff 100%); border-radius: 8px; border-left: 4px solid #1890ff;">
                💡 예약 데이터와 현재 충전기 상태를 기반으로 시간대별 혼잡도를 예측합니다.
            </div>
            <div style="background: #fff; border-radius: 12px; padding: 20px; border: 1px solid #e8e8e8; box-shadow: 0 2px 8px rgba(0,0,0,0.04);">
                <div id="chart-loading" style="text-align: center; padding: 40px; color: #999;">
                    <div style="font-size: 14px;">데이터 로딩 중...</div>
                </div>
                <div id="chart-container" style="position: relative; width: 100%; height: 300px; min-height: 300px; display: none;">
                    <canvas id="congestion-chart-canvas" style="width: 100% !important; height: 100% !important;"></canvas>
                </div>
            </div>
            <div id="congestion-stats" style="margin-top: 12px; padding: 14px; background: linear-gradient(135deg, #fafafa 0%, #f5f5f5 100%); border-radius: 10px; font-size: 13px; display: none;">
                <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 10px; padding-bottom: 10px; border-bottom: 1px solid #e8e8e8;">
                    <span style="color: #666; display: flex; align-items: center;">
                        <span style="display: inline-block; width: 8px; height: 8px; background: #1890ff; border-radius: 50%; margin-right: 8px;"></span>
                        현재 혼잡도
                    </span>
                    <span id="current-congestion-value" style="font-weight: bold; font-size: 16px; color: #1890ff;">-</span>
                </div>
                <div style="display: flex; justify-content: space-between; align-items: center;">
                    <span style="color: #666; display: flex; align-items: center;">
                        <span style="display: inline-block; width: 8px; height: 8px; background: #ff4d4f; border-radius: 50%; margin-right: 8px;"></span>
                        가장 혼잡한 시간
                    </span>
                    <span id="peak-hour-value" style="font-weight: bold; font-size: 16px; color: #ff4d4f;">-</span>
                </div>
            </div>
        </div>

        <div class="info-section">
            <div class="section-title">📋 운영 정보</div>
            
            <p>
                <span class="info-label">운영기관</span>
                <span id="operator_large" class="info-value">-</span>
            </p>
            <p>
                <span class="info-label">연락처</span>
                <span id="busi_call" class="info-value">-</span>
            </p>
            <p>
                <span class="info-label">이용시간</span>
                <span id="use_time" class="info-value">-</span>
            </p>
            <p>
                <span class="info-label">주차정보</span>
                <span id="parking_free" class="info-value">-</span>
            </p>
            <p>
                <span class="info-label">시설 구분</span>
                <span id="facility_type_large" class="info-value">-</span>
            </p>
            
            <div style="margin: 12px 0; border-top: 1px dashed #e9ecef;"></div>

            <p style="display: block; margin: 0;">
                <span class="info-label" style="margin-bottom: 4px; display:inline-block;">이용 제한 / 특이사항</span>
                <span id="user_restriction" class="restriction-badge" style="display:inline-block; width: auto; line-height: 1.4;">정보 없음</span>
            </p>
        </div>

    </div>
    
    <input type="hidden" id="current-station-id" value=""> 

	<div class="action-buttons">
	        <a id="navi-link" href="#" target="_blank" class="navi-btn">
	            <i class="fa fa-map-marker" style="margin-right:6px;"></i> 길찾기
	        </a>

	        <a id="roadview-link" href="#" target="_blank" class="roadview-btn">
	            <i class="fa fa-street-view" style="margin-right:6px;"></i> 로드뷰
	        </a>
			
			<c:if test="${not empty sessionScope.id}">
			         <button id="reserve-btn" class="reserve-btn">
			             📅 예약하기
			         </button>
			     </c:if>
            <button id="logistic-btn" class="logistic-btn" type="button">
                📈 혼잡도 예측
            </button>

			<c:if test="${not empty sessionScope.id}">
			                <button id="report-malfunction-btn" class="report-malfunction-btn" type="button">
			                    🚨 고장 신고
			                </button>
			            </c:if>

    </div>

	<input type="hidden" id="current-lat" value="">
<input type="hidden" id="current-lng" value="">

<div class="nearby-search-group" style="margin-top: 15px; text-align: center;">
    <p style="font-size:12px; color:#666; margin-bottom:8px;">충전하는 동안 다녀오세요 ☕</p>
    <button type="button" onclick="searchNearby('CE7')" style="padding:8px 12px; border:1px solid #ddd; background:#fff; border-radius:20px; cursor:pointer; margin-right:5px;">
        ☕ 카페
    </button>
    <button type="button" onclick="searchNearby('CS2')" style="padding:8px 12px; border:1px solid #ddd; background:#fff; border-radius:20px; cursor:pointer;">
        🏪 편의점
    </button>
    <button type="button" onclick="clearNearbyMarkers()" style="padding:8px 12px; border:1px solid #ddd; background:#f8f9fa; border-radius:20px; cursor:pointer; margin-left:5px; color:#888;">
        🔄 지우기
    </button>
</div>

	    <div style="text-align: right; padding: 10px 24px 20px; color: #999; font-size: 12px; margin-top: 5px;">
	        <i class="fa fa-clock-o"></i> 업데이트: <span id="last-updated-time">-</span>
	    </div>
	    
	</div> <div id="status-detail-panel">
	    <div class="status-header">
	        <span>🔌 충전기 상세 현황</span>
	        <button onclick="closeStatusPanel()" style="background:none;border:none;color:white;cursor:pointer;">&times;</button>
	    </div>
	    <ul id="real-time-charger-list" class="status-list">
	    </ul>
	</div>
	
	
	
	<div id="reservation-modal" class="reservation-modal">
	    <div class="reservation-modal-content">
	        <button id="close-reservation-modal" class="close-btn" title="닫기" style="position: absolute; top: 20px; right: 20px;">&times;</button>
	        <h3>⚡ 충전 시간 예약</h3>
	        
	        <div class="reservation-form-group">
	            <label>충전기 타입 선택</label>
	            <div style="display: flex; gap: 12px; margin-top: 8px;">
	                <button type="button" class="charger-type-select-btn" data-type="fast" id="fast-type-btn" style="flex: 1; padding: 12px; border: 2px solid #2196F3; background: #e3f2fd; border-radius: 8px; cursor: pointer; font-weight: 600; color: #2196F3;">
	                    ⚡ 급속
	                </button>
	                <button type="button" class="charger-type-select-btn" data-type="slow" id="slow-type-btn" style="flex: 1; padding: 12px; border: 2px solid #4CAF50; background: #e8f5e9; border-radius: 8px; cursor: pointer; font-weight: 600; color: #4CAF50;">
	                    🔌 완속
	                </button>
	            </div>
	            <div id="charger-type-info" style="margin-top: 8px; font-size: 12px; color: #666;"></div>
	        </div>
	        
	        <div class="reservation-form-group date-select">
	            <label for="reservation-date">날짜 선택</label>
	            <input type="date" id="reservation-date" required>
	        </div>
	        
	        <div class="reservation-form-group">
	            <label>시간 선택 (30분 예약)</label>
	            <div id="time-grid" class="time-grid">
	                </div>
	        </div>

	        <div class="reservation-modal-buttons">
	            <button class="reservation-confirm-btn" id="confirm-reservation-btn">예약하기</button>
	            <button class="reservation-cancel-btn" id="cancel-reservation-btn">취소</button>
	        </div>
	    </div>
	</div>
	
	<!-- Chart.js CDN -->
	<script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.0/dist/chart.umd.min.js"></script>
	
	<script>
	    // 🌟 로그인 상태 확인 (JSTL)
	    const IS_LOGGED_IN = <c:out value="${not empty sessionScope.id}" default="false"/>;
	    
	    // ---------------------------------------------------------
	    // 1. 토스 SDK 초기화 (전역 변수)
	    // ---------------------------------------------------------
	    const tossClientKey = "test_ck_0RnYX2w532wgdzd9NDBlVNeyqApQ"; // 본인 키
	    // 로그인한 유저 ID가 있다면 넣고, 없으면 ANONYMOUS
	    const tossCustomerKey = "${sessionScope.id}" || "ANONYMOUS";   
	    const tossPayments = TossPayments(tossClientKey);
	    // 결제 객체는 결제 요청 시점에 생성하는 것이 안전합니다.

	    // ---------------------------------------------------------
	    // 2. DOM 요소 참조
	    // ---------------------------------------------------------
	    const favoriteBtn = document.getElementById('favorite-btn');
	    const stationIdInput = document.getElementById('current-station-id');
	    const logisticBtn = document.getElementById('logistic-btn');
	    const logisticSection = document.getElementById('congestion-prediction-section');
	    const chartCanvas = document.getElementById('congestion-chart-canvas');
	    const chartLoading = document.getElementById('chart-loading');
	    const congestionStats = document.getElementById('congestion-stats');
	    const currentCongestionValue = document.getElementById('current-congestion-value');
	    const peakHourValue = document.getElementById('peak-hour-value');
	    const predictionInfo = document.getElementById('prediction-info');
	    
	    // Chart.js 인스턴스 저장용
	    let congestionChart = null;
	    const CONTEXT_PATH = '${pageContext.request.contextPath}';
	    
	    // 예약 관련 요소
	    const reserveBtn = document.getElementById('reserve-btn');
	    const reservationModal = document.getElementById('reservation-modal');
	    const closeReservationModalBtn = document.getElementById('close-reservation-modal');
	    const reservationDateInput = document.getElementById('reservation-date');
	    const timeGrid = document.getElementById('time-grid');
	    const confirmReservationBtn = document.getElementById('confirm-reservation-btn');
	    const cancelReservationBtn = document.getElementById('cancel-reservation-btn');
	    const fastTypeBtn = document.getElementById('fast-type-btn');
	    const slowTypeBtn = document.getElementById('slow-type-btn');
	    const chargerTypeInfo = document.getElementById('charger-type-info');
	    
	    let selectedTimes = []; // 최대 4개 (2시간 = 30분 * 4)
	    let selectedChargerType = null; // 'fast' or 'slow'
	    let fastChargerCount = 0;
	    let slowChargerCount = 0;

	    // 09:00 ~ 22:30 30분 단위 시간 배열
	    const timeStrings = [
	        "09:00", "09:30", "10:00", "10:30", "11:00", "11:30",
	        "12:00", "12:30", "13:00", "13:30", "14:00", "14:30",
	        "15:00", "15:30", "16:00", "16:30", "17:00", "17:30",
	        "18:00", "18:30", "19:00", "19:30", "20:00", "20:30",
	        "21:00", "21:30", "22:00", "22:30"
	    ];

	    // ---------------------------------------------------------
	    // 3. 결제 및 예약 요청 함수 (모달에서 '예약하기' 누를 때 실행)
	    // ---------------------------------------------------------
	    const reportMalfunctionBtn = document.getElementById('report-malfunction-btn');

	    async function createReservation(stationId, date, startTime, endTime, chargerType) {
	        try {
	            // 날짜/시간 계산
	            var startDateTime = date + 'T' + startTime + ':00';
	            var endDateTime = date + 'T' + endTime + ':00';

	            // 결제 금액 설정 (예약금 5000원)
	            const reservationPrice = 5000; 

	            // 결제 객체 생성 (v2 SDK)
	            const payment = tossPayments.payment({ customerKey: tossCustomerKey });

	            // 결제 요청
	            await payment.requestPayment({
	                method: "CARD",
	                amount: {
	                    currency: "KRW",
	                    value: reservationPrice,
	                },
	                // 주문 ID 생성 (유니크해야 함)
	                orderId: "RES_" + "${sessionScope.id}_" + new Date().getTime(), 
	                orderName: "전기차 충전소 예약",
	                
	                // ★ 결제 성공 시 이동할 URL에 예약 정보를 쿼리 스트링으로 붙여서 보냄
	                successUrl: window.location.origin + "/success" + 
	                            "?stationId=" + encodeURIComponent(stationId) +
	                            "&start=" + encodeURIComponent(startDateTime) + 
	                            "&end=" + encodeURIComponent(endDateTime) +
	                            "&chargerType=" + encodeURIComponent(chargerType === 'fast' ? '급속' : '완속'),
	                            
	                failUrl: window.location.origin + "/fail",
	                customerEmail: "customer@example.com",
	                customerName: "${sessionScope.name}" || "예약자",
	            });

	        } catch (error) {
	            console.error('결제 요청 실패:', error);
	            alert('결제 요청 중 오류가 발생했습니다: ' + error.message);
	        }
	    }

	    // ---------------------------------------------------------
	    // 4. 즐겨찾기 관련 함수들
	    // ---------------------------------------------------------
	    function updateFavoriteButton(status) {
	        if (!favoriteBtn) return;
	        favoriteBtn.setAttribute('data-status', status);
	        
	        if (status === 'logged-out') {
	            favoriteBtn.textContent = '🔒'; 
	            favoriteBtn.title = '로그인 후 이용 가능';
	            favoriteBtn.disabled = true;
	        } else if (status === 'favorited') {
	            favoriteBtn.textContent = '★'; 
	            favoriteBtn.title = '즐겨찾기에 등록됨 (클릭 시 삭제)';
	            favoriteBtn.disabled = false;
	        } else {
	            favoriteBtn.textContent = '☆'; 
	            favoriteBtn.title = '즐겨찾기에 추가';
	            favoriteBtn.disabled = false;
	        }
	    }

    // 외부 호출 함수: 충전소 클릭 시 실행
    window.setStationIdAndCheckFavorite = function(id) {
        if (stationIdInput) stationIdInput.value = id;
        
        // 🌟 혼잡도 차트 자동 표시 및 업데이트
        if (id && logisticSection) {
            // 혼잡도 예측 섹션 자동으로 열기
            logisticSection.style.display = 'block';
            setLogisticButtonState(true);
            // 차트 자동 로드
            loadLogisticPrediction(id);
        }
        
        if (!IS_LOGGED_IN) {
            updateFavoriteButton('logged-out');
            return;
        }
        checkFavoriteStatus(id);
    };
	    
	    async function checkFavoriteStatus(stationId) {
	        updateFavoriteButton('unfavorited'); 
	        try {
	            const url = '${pageContext.request.contextPath}/favorite/checkStatus';
	            const response = await fetch(url, {
	                method: 'POST', 
	                headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
	                body: 'stationId=' + encodeURIComponent(stationId) 
	            });
	            const data = await response.json();
	            if (data.isFavorited) updateFavoriteButton('favorited');
	            else updateFavoriteButton('unfavorited');
	        } catch (error) {
	            console.error('Check status failed:', error);
	            updateFavoriteButton('unfavorited'); 
	        }
	    }

	    async function toggleFavorite(stationId) {
	        const currentStatus = favoriteBtn.getAttribute('data-status');
	        let endpoint = '';
	        let successStatus = '';
	        
	        if (currentStatus === 'favorited') {
	            endpoint = '${pageContext.request.contextPath}/favorite/delete';
	            successStatus = 'unfavorited';
	        } else { 
	            endpoint = '${pageContext.request.contextPath}/favorite/add';
	            successStatus = 'favorited';
	        }

	        try {
	            const response = await fetch(endpoint, {
	                method: 'POST',
	                headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
	                body: 'stationId=' + encodeURIComponent(stationId)
	            });
	            const data = await response.json();
	            
	            if (data.success) {
	                updateFavoriteButton(successStatus); 
	                if (successStatus === 'unfavorited' && typeof window.fetchFavoriteStations === 'function') {
	                    window.fetchFavoriteStations(); 
	                }
	            } else {
	                alert(data.message);
	                checkFavoriteStatus(stationId); 
	            }
	        } catch (error) {
	            console.error('Error:', error);
	            alert('서버 오류가 발생했습니다.');
	            checkFavoriteStatus(stationId); 
	        }
	    }

	    // ---------------------------------------------------------
	    // 5. 예약 모달 UI 로직
	    // ---------------------------------------------------------
	    async function generateTimeButtons(dateStr) {
	        if (!timeGrid) return;
	        timeGrid.innerHTML = ''; 
	        
	        // 1. 함수 호출 시점의 현재 시각
	        const now = new Date(); 
	        
	        const yyyy = now.getFullYear();
	        const mm = String(now.getMonth() + 1).padStart(2, '0');
	        const dd = String(now.getDate()).padStart(2, '0');
	        const todayStr = `${yyyy}-${mm}-${dd}`;
	        
	        // 2. 선택된 날짜 파싱
	        const selectedDate = new Date(dateStr + 'T00:00:00');
	        const selectedDateOnly = new Date(selectedDate.getFullYear(), selectedDate.getMonth(), selectedDate.getDate());
	        const todayDateOnly = new Date(now.getFullYear(), now.getMonth(), now.getDate());
	        
	        // 3. 과거 날짜인지 확인
	        const isPastDate = selectedDateOnly < todayDateOnly;
	        // 4. 오늘 날짜인지 확인
	        const isToday = dateStr === todayStr;

	        // 5. 예약된 시간대 조회 (선택된 충전기 타입에 따라)
	        let reservedTimeRanges = []; // {start: "09:00", end: "09:30"} 형태
	        if (selectedChargerType && stationIdInput.value) {
	            try {
	                const response = await fetch(CONTEXT_PATH + '/reservation/list?stationRowId=' + encodeURIComponent(stationIdInput.value));
	                if (response.ok) {
	                    const data = await response.json();
	                    if (data.success && data.list) {
	                        // 선택된 날짜와 충전기 타입이 같은 예약만 필터링하고 시간 범위로 변환
	                        const selectedChargerTypeName = selectedChargerType === 'fast' ? '급속' : '완속';
	                        reservedTimeRanges = data.list
	                            .filter(res => {
	                                const resDate = new Date(res.reservationStart);
	                                const resDateStr = resDate.getFullYear() + '-' + 
	                                    String(resDate.getMonth() + 1).padStart(2, '0') + '-' + 
	                                    String(resDate.getDate()).padStart(2, '0');
	                                // 날짜가 같고, 상태가 RESERVED이고, 충전기 타입이 같거나 없으면 포함
	                                return resDateStr === dateStr && 
	                                       res.status === 'RESERVED' &&
	                                       (res.chargerType === selectedChargerTypeName || 
	                                        !res.chargerType || 
	                                        res.chargerType === '미지정');
	                            })
	                            .map(res => {
	                                const startDate = new Date(res.reservationStart);
	                                const endDate = new Date(res.reservationEnd);
	                                const startHours = String(startDate.getHours()).padStart(2, '0');
	                                const startMinutes = String(startDate.getMinutes()).padStart(2, '0');
	                                const endHours = String(endDate.getHours()).padStart(2, '0');
	                                const endMinutes = String(endDate.getMinutes()).padStart(2, '0');
	                                return {
	                                    start: startHours + ':' + startMinutes,
	                                    end: endHours + ':' + endMinutes,
	                                    startMinutes: startDate.getHours() * 60 + startDate.getMinutes(),
	                                    endMinutes: endDate.getHours() * 60 + endDate.getMinutes()
	                                };
	                            });
	                    }
	                }
	            } catch (error) {
	                console.error('예약 시간 조회 실패:', error);
	            }
	        }

	        // 6. 선택된 타입의 충전기 대수
	        const maxChargers = selectedChargerType === 'fast' ? fastChargerCount : 
	                           selectedChargerType === 'slow' ? slowChargerCount : 0;

	        // 시간을 분 단위로 변환하는 함수
	        function timeToMinutes(timeStr) {
	            const [hour, minute] = timeStr.split(':').map(Number);
	            return hour * 60 + minute;
	        }
	        
	        // 예약된 시간 범위와 겹치는지 확인
	        function isTimeReserved(timeStr) {
	            const timeMinutes = timeToMinutes(timeStr);
	            return reservedTimeRanges.some(range => {
	                return timeMinutes >= range.startMinutes && timeMinutes < range.endMinutes;
	            });
	        }
	        
	        // 해당 시간대에 예약 가능한 충전기가 있는지 확인
	        // 완속 12대 중 1대가 예약되면, 나머지 11대는 여전히 예약 가능해야 함
	        function hasAvailableCharger(timeStr) {
	            // 충전기 대수가 0이면 예약 불가
	            if (maxChargers <= 0) return false;
	            
	            const timeMinutes = timeToMinutes(timeStr);
	            const timeEndMinutes = timeMinutes + 30; // 선택하려는 시간의 종료 시각 (30분 후)
	            
	            // 해당 시간대에 겹치는 예약 개수 계산
	            // 예: 완속 12대 중 1대가 9시~10시 예약되어 있으면, 9시~9시30분 시간대에는 1개 예약이 겹침
	            const overlappingReservations = reservedTimeRanges.filter(range => {
	                // 선택하려는 시간 범위와 예약된 시간 범위가 겹치는지 확인
	                // 겹침 조건: 선택 시작 < 예약 종료 AND 선택 종료 > 예약 시작
	                return timeMinutes < range.endMinutes && timeEndMinutes > range.startMinutes;
	            }).length;
	            
	            // 예약된 개수가 충전기 대수보다 적으면 예약 가능
	            // 예: 완속 12대 중 1대만 예약되어 있으면 (1 < 12) -> 예약 가능
	            // 예: 완속 12대 모두 예약되어 있으면 (12 >= 12) -> 예약 불가
	            return overlappingReservations < maxChargers;
	        }

	        timeStrings.forEach(timeStr => {
	            const button = document.createElement('button');
	            button.textContent = timeStr;
	            button.classList.add('time-btn');
	            button.setAttribute('data-time', timeStr);
	            
	            let isDisabled = false;
	            let disabledReason = '';
	            
	            // 과거 날짜는 모든 시간 비활성화
	            if (isPastDate) {
	                isDisabled = true;
	                disabledReason = '과거 날짜는 예약할 수 없습니다.';
	            }
	            // 오늘 날짜는 현재 시간 이후만 선택 가능
	            else if (isToday) {
	                const [timeHour, timeMinute] = timeStr.split(':').map(Number);
	                
	                // 현재 시각
	                const currentHour = now.getHours();
	                const currentMinute = now.getMinutes();
	                
	                // ★ 버튼 시간이 현재 시간보다 이전이거나 같으면 비활성화 (5분 여유)
	                const timeInMinutes = timeHour * 60 + timeMinute;
	                const currentInMinutes = currentHour * 60 + currentMinute;
	                if (timeInMinutes <= currentInMinutes + 5) {
	                    isDisabled = true;
	                    disabledReason = '최소 5분 이후 시간만 예약 가능합니다.';
	                }
	            }
	            
	            // 충전기 타입이 선택되지 않았으면 비활성화
	            if (!selectedChargerType) {
	                isDisabled = true;
	                disabledReason = '충전기 타입을 먼저 선택해주세요.';
	            }
	            
	            // 충전기 대수가 0이면 비활성화
	            if (!isDisabled && maxChargers <= 0) {
	                isDisabled = true;
	                const chargerTypeName = selectedChargerType === 'fast' ? '급속' : '완속';
	                disabledReason = chargerTypeName + ' 충전기가 없습니다.';
	            }
	            
	            // 예약 가능 대수 체크 (충전기 대수가 있을 때만)
	            if (!isDisabled && maxChargers > 0 && !hasAvailableCharger(timeStr)) {
	                isDisabled = true;
	                const chargerTypeName = selectedChargerType === 'fast' ? '급속' : '완속';
	                const timeMinutes = timeToMinutes(timeStr);
	                const timeEndMinutes = timeMinutes + 30;
	                const overlappingCount = reservedTimeRanges.filter(range => {
	                    // 선택하려는 시간 범위와 예약된 시간 범위가 겹치는지 확인
	                    return timeMinutes < range.endMinutes && timeEndMinutes > range.startMinutes;
	                }).length;
	                
	                if (overlappingCount >= maxChargers) {
	                    disabledReason = chargerTypeName + ' 충전기 ' + maxChargers + '대 모두 예약되어 예약 불가합니다.';
	                } else {
	                    disabledReason = chargerTypeName + ' 충전기 ' + maxChargers + '대 중 ' + overlappingCount + '대가 예약되어 예약 불가합니다.';
	                }
	            }
	            
	            if (isDisabled) {
	                button.classList.add('unavailable');
	                button.disabled = true;
	                button.title = disabledReason;
	            }
	            
	            // 선택된 시간인지 확인
	            if (selectedTimes.includes(timeStr) && !button.disabled) {
	                button.classList.add('selected');
	            }

	            timeGrid.appendChild(button);
	        });
	    }

	    // ---------------------------------------------------------
	    // 6-a. 로지스틱 혼잡도 예측 관련 함수
	    // ---------------------------------------------------------
	    function setLogisticButtonState(active) {
	        if (!logisticBtn) return;
	        if (active) {
	            logisticBtn.classList.add('active');
	            logisticBtn.textContent = '📉 혼잡도 닫기';
	        } else {
	            logisticBtn.classList.remove('active');
	            logisticBtn.textContent = '📈 혼잡도 예측';
	        }
	    }

	    function showChartMessage(message) {
	        if (!chartPlaceholder) {
	            console.warn('[차트] chartPlaceholder 요소가 없습니다.');
	            return;
	        }
	        chartPlaceholder.textContent = message;
	        chartPlaceholder.style.display = 'flex';
	        chartPlaceholder.style.visibility = 'visible';
	    }

	    function hideChartMessage() {
	        if (!chartPlaceholder) {
	            console.warn('[차트] chartPlaceholder 요소가 없습니다.');
	            return;
	        }
	        chartPlaceholder.style.display = 'none';
	        chartPlaceholder.style.visibility = 'hidden';
	        console.log('[차트] placeholder 숨김 완료');
	    }

	    // 🌟 새로운 혼잡도 예측 함수 (Chart.js 사용)
	    async function loadLogisticPrediction(statId) {
	        console.log('[혼잡도 예측] 시작 - statId:', statId);
	        
	        if (!chartCanvas) {
	            console.error('[혼잡도 예측] chartCanvas가 없습니다.');
	            return;
	        }
	        
	        // 로딩 표시
	        if (chartLoading) {
	            chartLoading.style.display = 'block';
	        }
	        if (chartCanvas) {
	            chartCanvas.style.display = 'none';
	        }
	        
	        try {
	            const url = CONTEXT_PATH + '/station/congestion/predict?statId=' + encodeURIComponent(statId);
	            console.log('[혼잡도 예측] API 호출 - URL:', url);
	            
	            const res = await fetch(url);
	            if (!res.ok) {
	                throw new Error('응답 오류: ' + res.status);
	            }
	            
	            const data = await res.json();
	            console.log('[혼잡도 예측] 응답 데이터:', data);
	            
	            if (data.success && data.probabilities) {
	                // 로딩 숨기기
	                if (chartLoading) chartLoading.style.display = 'none';
	                
	                // 차트 컨테이너 표시
	                const chartContainer = document.getElementById('chart-container');
	                if (chartContainer) {
	                    chartContainer.style.display = 'block';
	                    console.log('[차트] 차트 컨테이너 표시 완료');
	                } else {
	                    console.error('[차트] chart-container 요소를 찾을 수 없습니다.');
	                }
	                
	                // DOM 업데이트 후 차트 렌더링 (약간의 지연 필요)
	                setTimeout(() => {
	                    // Chart.js로 차트 렌더링
	                    renderCongestionChart(data.probabilities, data.currentHour, data.currentCongestion || (data.currentProbability * 100));
	                    
	                    // 통계 정보 표시
	                    if (congestionStats) congestionStats.style.display = 'block';
	                    
	                    console.log('[혼잡도 예측] 차트 렌더링 완료');
	                }, 100);
	            } else {
	                throw new Error('데이터 없음');
	            }
	        } catch (error) {
	            console.error('[혼잡도 예측] 오류:', error);
	            if (chartLoading) {
	                chartLoading.innerHTML = '<div style="color: #ff4d4f; font-size: 14px;">데이터를 불러올 수 없습니다.</div>';
	            }
	        }
	    }
	    
	    // Chart.js로 차트 렌더링
	    function renderCongestionChart(probabilities, currentHour, currentCongestion) {
	        console.log('[차트 렌더링] 시작 - probabilities:', probabilities, 'currentHour:', currentHour);
	        
	        // Chart.js 로드 확인
        if (typeof Chart === 'undefined') {
            console.error('[차트] Chart.js가 로드되지 않았습니다. CDN 재시도...');
            // Chart.js가 없으면 강제로 로드 시도
            const script = document.createElement('script');
            script.src = 'https://cdn.jsdelivr.net/npm/chart.js@4.4.0/dist/chart.umd.min.js';
            script.onload = function() {
                console.log('[차트] Chart.js 로드 완료, 차트 재렌더링 시도');
                setTimeout(() => renderCongestionChart(probabilities, currentHour, currentCongestion), 100);
            };
            script.onerror = function() {
                alert('Chart.js 라이브러리를 불러올 수 없습니다. 인터넷 연결을 확인해주세요.');
            };
            document.head.appendChild(script);
            return;
        }
        
        // 차트 컨테이너 확인 및 표시
        const chartContainer = document.getElementById('chart-container');
        if (!chartContainer) {
            console.error('[차트] chart-container 요소가 없습니다.');
            return;
        }
        chartContainer.style.display = 'block';
        chartContainer.style.visibility = 'visible';
        chartContainer.style.opacity = '1';
        
        if (!chartCanvas) {
            console.error('[차트] chartCanvas가 없습니다.');
            return;
        }
        
        console.log('[차트] chartCanvas 요소 확인:', chartCanvas);
        console.log('[차트] 차트 컨테이너 크기:', chartContainer.offsetWidth, 'x', chartContainer.offsetHeight);
	        
	        // 기존 차트가 있으면 제거
	        if (congestionChart) {
	            congestionChart.destroy();
	            congestionChart = null;
	        }
	        
	        // 데이터 준비
	        const labels = [];
	        const values = [];
	        const colors = [];
	        
	        let maxProb = 0;
	        let peakHour = 0;
	        
	        for (let hour = 0; hour < 24; hour++) {
	            labels.push(hour + '시');
	            const prob = probabilities[hour] !== undefined ? probabilities[hour] : (probabilities[String(hour)] || 0);
	            const percent = Math.round(prob * 100);
	            values.push(percent);
	            
	            // 현재 시간대 강조
	            if (hour === currentHour) {
	                colors.push('#1890ff'); // 파란색
	            } else if (percent >= 80) {
	                colors.push('#ff4d4f'); // 빨간색 (매우 혼잡)
	            } else if (percent >= 50) {
	                colors.push('#faad14'); // 주황색 (혼잡)
	            } else {
	                colors.push('#52c41a'); // 초록색 (여유)
	            }
	            
	            // 최대값 찾기
	            if (percent > maxProb) {
	                maxProb = percent;
	                peakHour = hour;
	            }
	        }
	        
	        console.log('[차트 렌더링] 데이터 준비 완료 - values:', values);
	        
	        // 통계 정보 업데이트
	        if (currentCongestionValue) {
	            currentCongestionValue.textContent = Math.round(currentCongestion) + '%';
	        }
	        if (peakHourValue) {
	            peakHourValue.textContent = peakHour + '시 (' + maxProb + '%)';
	        }
	        
	        // Chart.js로 차트 생성
	        const ctx = chartCanvas.getContext('2d');
	        
	        // canvas가 보이도록 명시적으로 설정
	        chartCanvas.style.display = 'block';
	        chartCanvas.style.width = '100%';
	        chartCanvas.style.height = '100%';
	        
	        console.log('[차트] Chart.js 인스턴스 생성 시작');
	        
	        try {
	            congestionChart = new Chart(ctx, {
	                type: 'line',
	                data: {
	                    labels: labels,
	                    datasets: [{
	                        label: '혼잡도 (%)',
	                        data: values,
	                        borderColor: '#1890ff',
	                        backgroundColor: 'rgba(24, 144, 255, 0.1)',
	                        borderWidth: 2,
	                        fill: true,
	                        tension: 0.4,
	                        pointRadius: function(context) {
	                            return context.dataIndex === currentHour ? 6 : 3;
	                        },
	                        pointBackgroundColor: function(context) {
	                            return context.dataIndex === currentHour ? '#ff4d4f' : colors[context.dataIndex];
	                        },
	                        pointBorderColor: '#fff',
	                        pointBorderWidth: 2,
	                        pointHoverRadius: 8
	                    }]
	                },
	                options: {
	                    responsive: true,
	                    maintainAspectRatio: false,
	                    animation: {
	                        duration: 1000
	                    },
	                plugins: {
	                    legend: {
	                        display: false
	                    },
	                    tooltip: {
	                        callbacks: {
	                            label: function(context) {
	                                return '혼잡도: ' + context.parsed.y + '%';
	                            }
	                        }
	                    }
	                },
	                scales: {
	                    y: {
	                        beginAtZero: true,
	                        max: 100,
	                        ticks: {
	                            callback: function(value) {
	                                return value + '%';
	                            }
	                        },
	                        grid: {
	                            color: 'rgba(0, 0, 0, 0.05)'
	                        }
	                    },
	                    x: {
	                        grid: {
	                            display: false
	                        }
	                    }
	                }
	            }
	        });
	        
	        console.log('[차트 렌더링] ✅ Chart.js 차트 생성 완료');
	        
	        // 차트가 생성된 후 강제로 업데이트 및 크기 조정
	        setTimeout(() => {
	            if (congestionChart) {
	                congestionChart.resize();
	                congestionChart.update();
	                console.log('[차트] 차트 크기 조정 및 업데이트 완료, 차트 크기:', congestionChart.width, 'x', congestionChart.height);
	            }
	        }, 300);
	        
	        } catch (error) {
	            console.error('[차트 렌더링] 오류 발생:', error);
	            alert('차트를 생성하는 중 오류가 발생했습니다: ' + error.message);
	        }
	    }

	    window.resetLogisticPrediction = function() {
	        if (logisticSection) logisticSection.style.display = 'none';
	        setLogisticButtonState(false);
	        
	        // Chart.js 차트 제거
	        if (congestionChart) {
	            congestionChart.destroy();
	            congestionChart = null;
	        }
	        
	        // 초기화
	        const chartContainer = document.getElementById('chart-container');
	        if (chartContainer) chartContainer.style.display = 'none';
	        if (chartLoading) {
	            chartLoading.style.display = 'block';
	            chartLoading.innerHTML = '<div style="font-size: 14px;">데이터 로딩 중...</div>';
	        }
	        if (congestionStats) {
	            congestionStats.style.display = 'none';
	        }
	    };

	    function handleTimeSelection(event) {
	        const target = event.target;
	        if (!target.classList.contains('time-btn') || target.classList.contains('unavailable')) return;

	        const clickedTime = target.getAttribute('data-time');
	        const clickedIndex = selectedTimes.indexOf(clickedTime);
	        
	        // 이미 선택된 시간이면 제거
	        if (clickedIndex !== -1) {
	            selectedTimes.splice(clickedIndex, 1);
	            target.classList.remove('selected');
	        } else {
	            // 최대 4개까지만 선택 가능 (2시간 = 30분 * 4)
	            if (selectedTimes.length >= 4) {
	                alert('최대 2시간(4개 시간대)까지만 예약 가능합니다.');
	                return;
	            }
	            
	            // 연속된 시간만 선택 가능하도록 체크
	            if (selectedTimes.length > 0) {
	                // 선택된 시간들을 정렬
	                const sortedTimes = [...selectedTimes, clickedTime].sort();
	                const timeIndices = sortedTimes.map(t => timeStrings.indexOf(t));
	                
	                // 연속된 시간인지 확인
	                let isConsecutive = true;
	                for (let i = 1; i < timeIndices.length; i++) {
	                    if (timeIndices[i] - timeIndices[i-1] !== 1) {
	                        isConsecutive = false;
	                        break;
	                    }
	                }
	                
	                if (!isConsecutive) {
	                    alert('연속된 시간대만 선택할 수 있습니다.');
	                    return;
	                }
	            }
	            
	            selectedTimes.push(clickedTime);
	            selectedTimes.sort(); // 시간 순서대로 정렬
	            target.classList.add('selected');
	        }
	        
	        // 선택된 시간 표시 업데이트
	        updateSelectedTimeDisplay();
	    }
	    
	    function updateSelectedTimeDisplay() {
	        if (selectedTimes.length === 0) {
	            if (chargerTypeInfo) {
	                const count = selectedChargerType === 'fast' ? fastChargerCount : slowChargerCount;
	                const typeName = selectedChargerType === 'fast' ? '급속' : '완속';
	                chargerTypeInfo.textContent = typeName + ' 충전기: ' + count + '대';
	            }
	        } else {
	            const startTime = selectedTimes[0];
	            const endTime = selectedTimes[selectedTimes.length - 1];
	            const [endHour, endMin] = endTime.split(':').map(Number);
	            const endTimePlus30 = String(endHour).padStart(2, '0') + ':' + String(endMin + 30).padStart(2, '0');
	            
	            if (chargerTypeInfo) {
	                const typeName = selectedChargerType === 'fast' ? '급속' : '완속';
	                chargerTypeInfo.textContent = typeName + ' 충전기: ' + startTime + ' ~ ' + endTimePlus30 + ' (' + selectedTimes.length + '개 선택, ' + (selectedTimes.length * 30) + '분)';
	            }
	        }
	    }

	    function closeReservationModalAndReset() {
	        if (reservationModal) reservationModal.classList.remove('show');
	        if (reservationDateInput) reservationDateInput.value = '';
	        selectedTimes = [];
	        selectedChargerType = null;
	        if (timeGrid) timeGrid.innerHTML = '';
	        if (fastTypeBtn) fastTypeBtn.style.background = '#e3f2fd';
	        if (slowTypeBtn) slowTypeBtn.style.background = '#e8f5e9';
	        if (fastTypeBtn) fastTypeBtn.style.color = '#2196F3';
	        if (slowTypeBtn) slowTypeBtn.style.color = '#4CAF50';
	        if (chargerTypeInfo) chargerTypeInfo.textContent = '';
	    }
	    
	    // 충전기 타입 선택 함수
	    function selectChargerType(type) {
	        selectedChargerType = type;
	        selectedTimes = []; // 타입 변경 시 선택 초기화
	        
	        // 버튼 스타일 업데이트
	        if (fastTypeBtn && slowTypeBtn) {
	            if (type === 'fast') {
	                fastTypeBtn.style.background = '#2196F3';
	                fastTypeBtn.style.color = 'white';
	                slowTypeBtn.style.background = '#e8f5e9';
	                slowTypeBtn.style.color = '#4CAF50';
	            } else {
	                slowTypeBtn.style.background = '#4CAF50';
	                slowTypeBtn.style.color = 'white';
	                fastTypeBtn.style.background = '#e3f2fd';
	                fastTypeBtn.style.color = '#2196F3';
	            }
	        }
	        
	        // 정보 표시
	        updateSelectedTimeDisplay();
	        
	        // 시간 버튼 재생성
	        if (reservationDateInput && reservationDateInput.value) {
	            generateTimeButtons(reservationDateInput.value);
	        }
	    }

	    // ---------------------------------------------------------
	    // 6. 초기화 (DOMContentLoaded)
	    // ---------------------------------------------------------
	    document.addEventListener('DOMContentLoaded', function () {
	        // 즐겨찾기 초기 상태
	        if (!IS_LOGGED_IN) updateFavoriteButton('logged-out');

	        // 즐겨찾기 버튼 클릭
	        if (favoriteBtn) {
	            favoriteBtn.addEventListener('click', function () {
	                if (favoriteBtn.getAttribute('data-status') === 'logged-out') {
	                    alert('로그인 후 이용 가능합니다.');
	                    return;
	                }
	                const stationId = stationIdInput.value;
	                if (!stationId) {
	                    alert('충전소 정보가 없습니다.');
	                    return;
	                }
	                toggleFavorite(stationId);
	            });
	        }

	        // [예약 버튼] 클릭 -> 모달 열기
	        if (reserveBtn) {
	            reserveBtn.addEventListener('click', function () {
	                // 충전기 대수 정보 가져오기
	                const fastCountEl = document.getElementById('fast-charger-count');
	                const slowCountEl = document.getElementById('slow-charger-count');
	                if (fastCountEl) fastChargerCount = parseInt(fastCountEl.textContent) || 0;
	                if (slowCountEl) slowChargerCount = parseInt(slowCountEl.textContent) || 0;
	                
	                const today = new Date();
	                const yyyy = today.getFullYear();
	                const mm = String(today.getMonth() + 1).padStart(2, '0');
	                const dd = String(today.getDate()).padStart(2, '0');
	                const todayStr = `${yyyy}-${mm}-${dd}`;
	                
	                if(reservationDateInput) {
	                    reservationDateInput.value = todayStr;
	                    // ★ 오늘 이전 날짜는 달력에서 선택 불가 (min 속성으로 막기)
	                    reservationDateInput.min = todayStr;
	                    
	                    // 최대 선택 가능 날짜 설정 (예: 1개월 후)
	                    const maxDate = new Date(today);
	                    maxDate.setMonth(maxDate.getMonth() + 1);
	                    const maxYyyy = maxDate.getFullYear();
	                    const maxMm = String(maxDate.getMonth() + 1).padStart(2, '0');
	                    const maxDd = String(maxDate.getDate()).padStart(2, '0');
	                    reservationDateInput.max = `${maxYyyy}-${maxMm}-${maxDd}`;
	                }
	                
	                // 초기화
	                selectedChargerType = null;
	                selectedTimes = [];
	                if (fastTypeBtn) {
	                    fastTypeBtn.style.background = '#e3f2fd';
	                    fastTypeBtn.style.color = '#2196F3';
	                }
	                if (slowTypeBtn) {
	                    slowTypeBtn.style.background = '#e8f5e9';
	                    slowTypeBtn.style.color = '#4CAF50';
	                }
	                if (chargerTypeInfo) chargerTypeInfo.textContent = '충전기 타입을 선택해주세요.';
	                
	                // todayStr로 시간 버튼 생성 (타입 선택 전이므로 모두 비활성화)
	                generateTimeButtons(todayStr);
	                
	                if(reservationModal) reservationModal.classList.add('show');
	            });
	        }
	        
	        // 충전기 타입 선택 버튼
	        if (fastTypeBtn) {
	            fastTypeBtn.addEventListener('click', function() {
	                selectChargerType('fast');
	            });
	        }
	        
	        if (slowTypeBtn) {
	            slowTypeBtn.addEventListener('click', function() {
	                selectChargerType('slow');
	            });
	        }

	        // 시간 선택 그리드 이벤트
	        if (timeGrid) timeGrid.addEventListener('click', handleTimeSelection);

	        // 날짜 변경 시 시간 초기화 및 새로 생성
	        if (reservationDateInput) {
	            reservationDateInput.addEventListener('change', function () {
	                selectedTimes = [];
	                generateTimeButtons(this.value); 
	            });
	        }
	        
	        // 날짜 입력 필드에서 직접 입력 방지 (과거 날짜)
	        if (reservationDateInput) {
	            reservationDateInput.addEventListener('input', function() {
	                const selectedDate = new Date(this.value + 'T00:00:00');
	                const today = new Date();
	                today.setHours(0, 0, 0, 0);
	                
	                if (selectedDate < today) {
	                    const yyyy = today.getFullYear();
	                    const mm = String(today.getMonth() + 1).padStart(2, '0');
	                    const dd = String(today.getDate()).padStart(2, '0');
	                    this.value = yyyy + '-' + mm + '-' + dd;
	                    alert('과거 날짜는 선택할 수 없습니다.');
	                }
	            });
	            
	            // 달력에서 과거 날짜 클릭 방지
	            reservationDateInput.addEventListener('click', function() {
	                const today = new Date();
	                const yyyy = today.getFullYear();
	                const mm = String(today.getMonth() + 1).padStart(2, '0');
	                const dd = String(today.getDate()).padStart(2, '0');
	                const todayStr = yyyy + '-' + mm + '-' + dd;
	                this.min = todayStr;
	            });
	        }

	        // 모달 닫기 버튼들
	        if (closeReservationModalBtn) closeReservationModalBtn.addEventListener('click', closeReservationModalAndReset);
	        if (cancelReservationBtn) cancelReservationBtn.addEventListener('click', closeReservationModalAndReset);

	        // [모달 내 예약확정 버튼] 클릭 -> 결제 실행
	        if (confirmReservationBtn) {
	            confirmReservationBtn.addEventListener('click', function () {
	                const stationId = stationIdInput.value;
	                const date = reservationDateInput.value;
	                
	                if (!selectedChargerType) {
	                    alert('충전기 타입(급속/완속)을 선택해주세요.');
	                    return;
	                }
	                
	                if (!date || selectedTimes.length === 0) {
	                    alert('날짜와 시간을 선택해주세요. (최소 1개, 최대 4개 시간대 선택 가능)');
	                    return;
	                }
	                
	                // 첫 번째 선택 시간을 시작 시간으로 사용
	                const startTime = selectedTimes[0];
	                // 마지막 선택 시간 + 30분을 종료 시간으로 사용
	                const lastTime = selectedTimes[selectedTimes.length - 1];
	                const [lastHour, lastMin] = lastTime.split(':').map(Number);
	                const endHour = lastHour;
	                let endMin = lastMin + 30;
	                if (endMin >= 60) {
	                    endMin -= 60;
	                    // 다음 날로 넘어가는 경우는 처리하지 않음 (22:30이 마지막이므로)
	                }
	                const endTime = String(endHour).padStart(2, '0') + ':' + String(endMin).padStart(2, '0');
	                
	                // 결제 및 예약 함수 호출 (시작 시간과 종료 시간, 충전기 타입 전달)
	                createReservation(stationId, date, startTime, endTime, selectedChargerType);
	            });
	        }

	        resetLogisticPrediction();

	        if (logisticBtn) {
	            logisticBtn.addEventListener('click', function () {
	                const stationId = stationIdInput.value;
	                if (!stationId) {
	                    alert('충전소를 먼저 선택해주세요.');
	                    return;
	                }
	                // 토글: 열려있으면 닫기, 닫혀있으면 열기
	                const shouldOpen = logisticSection.style.display === 'none';
	                if (shouldOpen) {
	                    logisticSection.style.display = 'block';
	                    setLogisticButtonState(true);
	                    loadLogisticPrediction(stationId);
	                } else {
	                    logisticSection.style.display = 'none';
	                    setLogisticButtonState(false);
	                    // 차트 정리
	                    if (congestionChart) {
	                        congestionChart.destroy();
	                        congestionChart = null;
	                    }
	                }
	            });
	        }

	        // 고장 신고 버튼 클릭
			  if (reportMalfunctionBtn) {
			        reportMalfunctionBtn.addEventListener('click', function() {
			            const stationId = stationIdInput.value; // 현재 상세 정보의 stationId
			            if (!stationId) {
			                alert("고장 신고할 충전소를 선택해주세요.");
			                return;
			            }
			            // chargerId는 선택하지 않았으므로, 폼에서 사용자가 선택하도록 유도
			            window.location.href = CONTEXT_PATH + "/report?apiStatId=" + encodeURIComponent(stationId);
			        });
			    }
			});
	</script>