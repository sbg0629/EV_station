package com.boot.Main_Page.dto;

import lombok.Data; // Lombok을 쓰신다면

@Data
public class PaymentDTO {
    private Long id;              // PK
    private String paymentKey;    // 토스 결제 키
    private String orderId;       // 주문번호
    private String orderName;
    private int amount;           // 금액
    private String method;        // 결제 수단
    private String status;        // 결제 상태
    private String approvedAt;    // 승인 일시
    
    // 취소 관련
    private boolean isCanceled;   // 취소 여부 (DB엔 0/1로 들어감)
    private String cancelReason;  // 취소 사유
    private String canceledAt;    // 취소 시간
}