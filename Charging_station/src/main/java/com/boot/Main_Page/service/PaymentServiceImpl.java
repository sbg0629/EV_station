package com.boot.Main_Page.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.boot.Main_Page.dao.PaymentDAO;
import com.boot.Main_Page.dto.PaymentDTO;

@Service
public class PaymentServiceImpl implements PaymentService{
	
	@Autowired
	private PaymentDAO paymentDAO;

	@Override
	public void insertPayment(PaymentDTO paymentDTO) {
		paymentDAO.insertPayment(paymentDTO);
	}

	@Override
	public void cancelPayment(String paymentKey, String cancelReason, String canceledAt) {
	    PaymentDTO dto = new PaymentDTO();
	    dto.setPaymentKey(paymentKey);
	    dto.setCancelReason(cancelReason);
	    dto.setCanceledAt(canceledAt);
	    
	    paymentDAO.updatePaymentCancel(dto);
	}

}
