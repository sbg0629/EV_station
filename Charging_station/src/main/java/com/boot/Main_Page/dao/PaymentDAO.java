package com.boot.Main_Page.dao;

import org.apache.ibatis.annotations.Mapper;
import com.boot.Main_Page.dto.PaymentDTO;

@Mapper // 이게 붙어야 스프링이 인식합니다 (혹은 XML 설정 사용 시 생략 가능)
public interface PaymentDAO {
    // 결제 정보 저장하기
    void insertPayment(PaymentDTO paymentDTO);
    
    // (나중에 필요하면 추가) 결제 취소 상태 업데이트
    void updatePaymentCancel(PaymentDTO paymentDTO);
}