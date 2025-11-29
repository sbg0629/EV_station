package com.boot.Reservation.dto;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

import com.fasterxml.jackson.annotation.JsonFormat;
import lombok.Data;

@Data
public class ReservationDTO {

    private Long reservationId;    
    private String memberId;        // member_id
    private String stationRowId;      // station_row_id

    @JsonFormat(pattern = "yyyy-MM-dd'T'HH:mm:ss")
    private LocalDateTime reservationStart;   // reservation_start

    @JsonFormat(pattern = "yyyy-MM-dd'T'HH:mm:ss")
    private LocalDateTime reservationEnd;     // reservation_end

    private String status;          // status
    private LocalDateTime createdAt; // created_at
    private LocalDateTime updatedAt; // updated_at
    
    private String orderId;    // 추가: 조인용 주문번호
    private String paymentKey; // 추가: 결제 취소용 키
    
    // 충전소 정보 (조인으로 가져옴)
    private String stationName;    // 충전소 이름
    private String stationAddress;  // 충전소 주소
    private String chargerType;     // 충전기 타입 (FAST/SLOW 또는 완속/급속)


    // ===== 추가 편의 Getter(선택) =====
    public String getReservationStartFormatted() {
        return reservationStart != null ?
                reservationStart.format(DateTimeFormatter.ofPattern("yyyy.MM.dd (E) HH:mm")) : null;
    }

    public String getReservationEndFormatted() {
        return reservationEnd != null ?
                reservationEnd.format(DateTimeFormatter.ofPattern("HH:mm")) : null;
    }
}
