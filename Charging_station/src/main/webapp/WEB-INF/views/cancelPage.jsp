<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>결제 취소 관리</title>
</head>
<body>

    <h2>결제 취소</h2>
    
    <form action="/cancel" method="post">
        
        <p>
            <label for="paymentKey">결제 키 (paymentKey):</label><br>
            <input type="text" id="paymentKey" name="paymentKey" placeholder="tgen_..." required style="width: 300px;">
        </p>

        <p>
            <label for="cancelReason">취소 사유:</label><br>
            <input type="text" id="cancelReason" name="cancelReason" placeholder="예: 단순변심" required style="width: 300px;">
        </p>

        <button type="submit">결제 취소하기</button>
    </form>

    <hr>
    <p>
        <small>※ 결제 키(paymentKey)는 DB의 payment 테이블에서 확인할 수 있습니다.</small>
    </p>

</body>
</html>