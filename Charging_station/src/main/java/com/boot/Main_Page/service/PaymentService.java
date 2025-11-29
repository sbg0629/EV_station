package com.boot.Main_Page.service;

import com.boot.Main_Page.dto.PaymentDTO;

public interface PaymentService {
    // 결제 정보 저장하기
    void insertPayment(PaymentDTO paymentDTO);
    
    // 결제 취소
    void cancelPayment(String paymentKey, String cancelReason, String canceledAt);
}
