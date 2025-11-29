package com.boot.Main_Page.controller;

import com.boot.Main_Page.dto.PaymentDTO;
import com.boot.Main_Page.service.PaymentService;
import com.boot.login.google.service.GoogleOAuthService;

import lombok.extern.slf4j.Slf4j;

import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.json.simple.parser.ParseException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import java.io.*;
import java.net.HttpURLConnection;
import java.net.URL;
import java.nio.charset.StandardCharsets;
import java.util.Base64;

@Controller
@Slf4j
public class PaymentController {

//  이건 위젯으로 결제할때 사용
  String widgetSecretKey = "test_sk_DLJOpm5Qrl7PN94ANOW5VPNdxbWn";
//  이건 위젯없이 개별 api(프론트는 내가 만들때 사용)

	
	@Autowired
	private PaymentService paymentService;

    private final GoogleOAuthService googleOAuthService;

    PaymentController(GoogleOAuthService googleOAuthService) {
        this.googleOAuthService = googleOAuthService;
    }
	
	@GetMapping("/payment")
	public String payment() {
		return "/payment";
	}
	
	@RequestMapping("/cancelPage")
	public String cancelPage() {
		return "/cancelPage";
	}
	
	@RequestMapping("/indiv_payment")
	public String indiv_payment() {
		return "/indiv_payment";
	}
	
    @GetMapping("/success")
    public String successPage() {
        return "success";
    }

    @GetMapping("/fail")
    public String failPage() {
        return "fail";
    }

    private final Logger logger = LoggerFactory.getLogger(this.getClass());

    @RequestMapping(value = "/confirm")
    public ResponseEntity<JSONObject> confirmPayment(@RequestBody String jsonBody) throws Exception {

        JSONParser parser = new JSONParser();
        String orderId;
        String amount;
        String paymentKey;
        try {
            // 클라이언트에서 받은 JSON 요청 바디입니다.
            JSONObject requestData = (JSONObject) parser.parse(jsonBody);
            paymentKey = (String) requestData.get("paymentKey");
            orderId = (String) requestData.get("orderId");
            amount = (String) requestData.get("amount");
        } catch (ParseException e) {
            throw new RuntimeException(e);
        };
        JSONObject obj = new JSONObject();
        obj.put("orderId", orderId);
        obj.put("amount", amount);
        obj.put("paymentKey", paymentKey);

        // 토스페이먼츠 API는 시크릿 키를 사용자 ID로 사용하고, 비밀번호는 사용하지 않습니다.
        // 비밀번호가 없다는 것을 알리기 위해 시크릿 키 뒤에 콜론을 추가합니다.
        

        Base64.Encoder encoder = Base64.getEncoder();
        byte[] encodedBytes = encoder.encode((widgetSecretKey + ":").getBytes(StandardCharsets.UTF_8));
        String authorizations = "Basic " + new String(encodedBytes);

        // 결제를 승인하면 결제수단에서 금액이 차감돼요.
        URL url = new URL("https://api.tosspayments.com/v1/payments/confirm");
        HttpURLConnection connection = (HttpURLConnection) url.openConnection();
        connection.setRequestProperty("Authorization", authorizations);
        connection.setRequestProperty("Content-Type", "application/json");
        connection.setRequestMethod("POST");
        connection.setDoOutput(true);

        OutputStream outputStream = connection.getOutputStream();
        outputStream.write(obj.toString().getBytes("UTF-8"));

        int code = connection.getResponseCode();
        boolean isSuccess = code == 200;

        InputStream responseStream = isSuccess ? connection.getInputStream() : connection.getErrorStream();

        // 결제 성공 및 실패 비즈니스 로직을 구현하세요.
        Reader reader = new InputStreamReader(responseStream, StandardCharsets.UTF_8);
        JSONObject jsonObject = (JSONObject) parser.parse(reader);
        responseStream.close();
        
        // 결제 성공 시 데이터 확인 용
        // 참고 : https://docs.tosspayments.com/reference#payment-%EA%B0%9D%EC%B2%B4
        if(isSuccess) {
        	System.out.println("============== 결제 승인 정보 ==============");
            System.out.println("결제 상태(status): " + jsonObject.get("status"));
            System.out.println("구매 상품(orderName): " + jsonObject.get("orderName"));
            System.out.println("승인 일시(approvedAt): " + jsonObject.get("approvedAt"));
            System.out.println("결제 금액: " + Long.parseLong(jsonObject.get("totalAmount").toString()));
            System.out.println("부가세(vat): " + jsonObject.get("vat"));
            System.out.println("카드(card): " + jsonObject.get("card"));
            
            String method = (String) jsonObject.get("method");
            System.out.println("결제 수단(method): " + method);

            // [수정] 결제 수단에 따라 '제공자' 정보 꺼내기
            String provider = "";
            
            if ("카드".equals(method)) {
                // 1. 카드 결제인 경우 -> card 객체 안을 봐야 함
                JSONObject cardObj = (JSONObject) jsonObject.get("card");
                if (cardObj != null) {
                     // issuerCode(발급사)나 acquirerCode(매입사) 등을 확인
                     provider = (String) cardObj.get("issuerCode"); 
                     System.out.println("카드 정보: " + cardObj.toJSONString());
                }
            } else if ("간편결제".equals(method)) {
                // 2. 간편결제(카카오페이 등)인 경우 -> easyPay 객체 안을 봐야 함
                JSONObject easyPayObj = (JSONObject) jsonObject.get("easyPay");
                if (easyPayObj != null) {
                    provider = (String) easyPayObj.get("provider"); // "카카오페이", "네이버페이" 등
                }
            }

            System.out.println("결제 제공자(provider): " + provider); // 이제 나옵니다!
            
            System.out.println("========================================");
            
            PaymentDTO dto = new PaymentDTO();
            dto.setPaymentKey((String) jsonObject.get("paymentKey"));
            dto.setOrderId((String) jsonObject.get("orderId"));
            dto.setOrderName((String) jsonObject.get("orderName"));
            dto.setMethod((String) jsonObject.get("method"));
            dto.setStatus((String) jsonObject.get("status"));
            dto.setApprovedAt((String) jsonObject.get("approvedAt"));
            
            long amountVal = Long.parseLong(jsonObject.get("totalAmount").toString());
            dto.setAmount((int) amountVal); // DTO가 int라면 캐스팅
            
            paymentService.insertPayment(dto);
            log.info("DB 저장 완료");
        }

        return ResponseEntity.status(code).body(jsonObject);
    }
    
    
    
 // PaymentController.java

    @RequestMapping(value = "/cancel", method = RequestMethod.POST)
    public ResponseEntity<String> cancelPayment(
            @RequestParam String paymentKey,
            @RequestParam String cancelReason
    ) {
        try {
            // 1. 토스 취소 API 호출 (URL 뒤에 paymentKey가 붙음)
            URL url = new URL("https://api.tosspayments.com/v1/payments/" + paymentKey + "/cancel");
            
            HttpURLConnection connection = (HttpURLConnection) url.openConnection();
            connection.setRequestMethod("POST");
            connection.setRequestProperty("Content-Type", "application/json");
            
            Base64.Encoder encoder = Base64.getEncoder();
            byte[] encodedBytes = encoder.encode((widgetSecretKey + ":").getBytes(StandardCharsets.UTF_8));
            connection.setRequestProperty("Authorization", "Basic " + new String(encodedBytes));
            connection.setDoOutput(true);

            // 2. 취소 사유 보내기
            JSONObject jsonBody = new JSONObject();
            jsonBody.put("cancelReason", cancelReason);
            
            try (OutputStream os = connection.getOutputStream()) {
                os.write(jsonBody.toString().getBytes(StandardCharsets.UTF_8));
            }

            // 3. 응답 처리
            int code = connection.getResponseCode();
            boolean isSuccess = code == 200;
            
            InputStream responseStream = isSuccess ? connection.getInputStream() : connection.getErrorStream();
            Reader reader = new InputStreamReader(responseStream, StandardCharsets.UTF_8);
            
            JSONParser parser = new JSONParser();
            JSONObject jsonResult = (JSONObject) parser.parse(reader);
            
            // 4. [성공 시 DB 업데이트]
            if (isSuccess) {
                String approvedAt = (String) jsonResult.get("approvedAt"); // 취소된 시간도 approvedAt 필드 등에 갱신되어 옴 (혹은 현재시간 사용)
                
                // 서비스 호출해서 DB 업데이트
                paymentService.cancelPayment(paymentKey, cancelReason, approvedAt);
                
                System.out.println("결제 취소 및 DB 업데이트 완료!");
            }

            return ResponseEntity.status(code).body(jsonResult.toString());

        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.internalServerError().body("취소 중 에러 발생");
        }
    }
    

}