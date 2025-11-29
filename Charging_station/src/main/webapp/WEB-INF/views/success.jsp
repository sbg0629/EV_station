<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>결제 완료 - EV충전소</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
    <style>
        body {
            background: #f0f0f0;
            font-family: 'Malgun Gothic', '맑은 고딕', sans-serif;
            margin: 0;
            padding: 20px 0;
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .payment-container {
            max-width: 600px;
            width: 100%;
            margin: 0 auto;
            background: #ffffff;
            border-radius: 15px;
            box-shadow: 0 5px 20px rgba(0, 0, 0, 0.1);
            overflow: hidden;
        }

        .payment-header {
            background: linear-gradient(135deg, #2a5298 0%, #1e3c72 100%);
            padding: 40px 30px;
            text-align: center;
            color: white;
            position: relative;
        }

        .payment-header i {
            font-size: 3.5rem;
            margin-bottom: 20px;
            opacity: 0;
            animation: fadeInScale 0.6s ease forwards;
        }

        .payment-header h2 {
            font-size: 1.8rem;
            font-weight: 700;
            margin: 0;
            opacity: 0;
            animation: fadeInUp 0.6s ease 0.2s forwards;
        }

        .payment-body {
            padding: 40px 30px;
        }

        .info-section {
            margin-bottom: 30px;
            opacity: 0;
            animation: fadeInUp 0.6s ease 0.4s forwards;
        }

        .info-title {
            font-size: 0.9rem;
            color: #666;
            margin-bottom: 8px;
            font-weight: 500;
        }

        .info-content {
            font-size: 1.1rem;
            color: #333;
            font-weight: 600;
            padding: 12px;
            background: #f8f9fa;
            border-radius: 8px;
            border-left: 4px solid #2a5298;
        }

        .status-message {
            text-align: center;
            padding: 30px 20px;
            margin: 20px 0;
            background: #e8f5e9;
            border-radius: 10px;
            opacity: 0;
            animation: fadeInUp 0.6s ease 0.6s forwards;
        }

        .status-message i {
            font-size: 2.5rem;
            color: #4CAF50;
            margin-bottom: 15px;
        }

        .status-message p {
            font-size: 1.1rem;
            color: #2e7d32;
            margin: 0;
            font-weight: 600;
        }

        .loading-status {
            text-align: center;
            padding: 30px 20px;
            margin: 20px 0;
            background: #fff3e0;
            border-radius: 10px;
        }

        .loading-status .spinner {
            width: 40px;
            height: 40px;
            border: 4px solid #f3f3f3;
            border-top: 4px solid #FF9800;
            border-radius: 50%;
            animation: spin 1s linear infinite;
            margin: 0 auto 15px;
        }

        .loading-status p {
            font-size: 1rem;
            color: #e65100;
            margin: 0;
            font-weight: 500;
        }

        .button-group {
            display: flex;
            gap: 15px;
            margin-top: 30px;
            opacity: 0;
            animation: fadeInUp 0.6s ease 0.8s forwards;
        }

        .btn-custom {
            flex: 1;
            padding: 15px 20px;
            border: none;
            border-radius: 8px;
            font-size: 1rem;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
        }

        .btn-primary-custom {
            background: #2a5298;
            color: white;
        }

        .btn-primary-custom:hover {
            background: #1e3c72;
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(42, 82, 152, 0.3);
        }

        .btn-secondary-custom {
            background: #f8f9fa;
            color: #333;
            border: 1px solid #ddd;
        }

        .btn-secondary-custom:hover {
            background: #e9ecef;
            transform: translateY(-2px);
        }

        @keyframes fadeInScale {
            from {
                opacity: 0;
                transform: scale(0.5);
            }
            to {
                opacity: 1;
                transform: scale(1);
            }
        }

        @keyframes fadeInUp {
            from {
                opacity: 0;
                transform: translateY(20px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        @keyframes spin {
            0% { transform: rotate(0deg); }
            100% { transform: rotate(360deg); }
        }

        @media (max-width: 576px) {
            .payment-container {
                margin: 0 15px;
            }
            
            .payment-header {
                padding: 30px 20px;
            }
            
            .payment-body {
                padding: 30px 20px;
            }
            
            .button-group {
                flex-direction: column;
            }
        }
    </style>
</head>
<body>
    <div class="payment-container">
        <div class="payment-header">
            <i class="fas fa-charging-station"></i>
            <h2>결제 처리중</h2>
        </div>

        <div class="payment-body">
            <div id="loadingSection" class="loading-status">
                <div class="spinner"></div>
                <p>결제 정보를 확인하고 있습니다...</p>
            </div>

            <div id="successSection" style="display: none;">
                <div class="status-message">
                    <i class="fas fa-check-circle"></i>
                    <p>예약 및 결제가 완료되었습니다!</p>
                </div>

                <div class="info-section">
                    <div class="info-title">결제 금액</div>
                    <div class="info-content" id="amountDisplay"></div>
                </div>

                <div class="info-section">
                    <div class="info-title">주문 번호</div>
                    <div class="info-content" id="orderIdDisplay"></div>
                </div>

                <div class="info-section">
                    <div class="info-title">예약 시간</div>
                    <div class="info-content" id="reservationTimeDisplay"></div>
                </div>

                <div class="button-group">
                    <button class="btn-custom btn-primary-custom" onclick="location.href='${pageContext.request.contextPath}/map_kakao'">
                        <i class="fas fa-map-marked-alt"></i> 충전소 찾기
                    </button>
                    <button class="btn-custom btn-secondary-custom" onclick="location.href='${pageContext.request.contextPath}/home'">
                        <i class="fas fa-home"></i> 메인으로
                    </button>
                </div>
            </div>
        </div>
    </div>

    <script>
        const urlParams = new URLSearchParams(window.location.search);

        // 토스 결제 정보
        const paymentKey = urlParams.get("paymentKey");
        const orderId = urlParams.get("orderId");
        const amount = urlParams.get("amount");

        // 예약 정보
        const stationId = urlParams.get("stationId");
        const startTime = urlParams.get("start");
        const endTime = urlParams.get("end");
        const chargerType = urlParams.get("chargerType");

        async function processPaymentAndReservation() {
            try {
                // Step 1: 결제 승인
                const paymentData = {
                    paymentKey: paymentKey,
                    orderId: orderId,
                    amount: amount
                };

                const payResponse = await fetch("/confirm", {
                    method: "POST",
                    headers: { "Content-Type": "application/json" },
                    body: JSON.stringify(paymentData),
                });

                const payResult = await payResponse.json();

                if (!payResponse.ok) {
                    alert("결제 승인 실패: " + payResult.message);
                    window.location.href = `/fail?message=${payResult.message}`;
                    return;
                }

                console.log("결제 성공! 예약을 진행합니다.");

                // Step 2: 예약 저장
                const reservationData = {
                    stationRowId: stationId,
                    reservationStart: startTime,
                    reservationEnd: endTime,
                    orderId: orderId,
                    chargerType: chargerType || null
                };

                const resResponse = await fetch("${pageContext.request.contextPath}/reservation/add", {
                    method: "POST",
                    headers: { "Content-Type": "application/json" },
                    body: JSON.stringify(reservationData)
                });

                const resResult = await resResponse.json();

                if (resResult.success) {
                    // 성공 화면 표시
                    showSuccessScreen();
                } else {
                    alert("❌ 결제는 되었으나 예약 저장에 실패했습니다.\n관리자에게 문의해주세요.");
                    console.error(resResult.message);
                }

            } catch (error) {
                console.error("처리 중 오류 발생:", error);
                alert("시스템 오류가 발생했습니다.");
            }
        }

        function showSuccessScreen() {
            // 로딩 숨기기
            document.getElementById('loadingSection').style.display = 'none';
            
            // 성공 섹션 표시
            document.getElementById('successSection').style.display = 'block';
            
            // 헤더 변경
            document.querySelector('.payment-header h2').textContent = '결제 완료';
            document.querySelector('.payment-header i').className = 'fas fa-check-circle';
            
            // 정보 표시
            document.getElementById('amountDisplay').textContent = Number(amount).toLocaleString() + '원';
            document.getElementById('orderIdDisplay').textContent = orderId;
            
            if (startTime && endTime) {
                const start = new Date(startTime);
                const end = new Date(endTime);
                const timeText = `${start.toLocaleDateString()} ${start.toLocaleTimeString('ko-KR', {hour: '2-digit', minute:'2-digit'})} ~ ${end.toLocaleTimeString('ko-KR', {hour: '2-digit', minute:'2-digit'})}`;
                document.getElementById('reservationTimeDisplay').textContent = timeText;
            }
        }

        // 페이지 로드 시 실행
        processPaymentAndReservation();
    </script>
</body>
</html>