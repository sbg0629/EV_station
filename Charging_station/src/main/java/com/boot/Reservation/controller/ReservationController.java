package com.boot.Reservation.controller;

import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import com.boot.Reservation.dto.ReservationDTO;
import com.boot.Reservation.service.ReservationService;

import lombok.extern.slf4j.Slf4j;

@RestController
@RequestMapping("/reservation")
@Slf4j
public class ReservationController {

    @Autowired
    private ReservationService reservationService;

    @PostMapping("/add")
    public ResponseEntity<Map<String, Object>> createReservation(
            @RequestBody ReservationDTO dto,
            HttpSession session) {

        Map<String, Object> result = new HashMap<>();

        try {
            String memberId = (String) session.getAttribute("id");
            if (memberId == null || memberId.isEmpty()) {
                result.put("success", false);
                result.put("message", "로그인이 필요합니다.");
                return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(result);
            }

            dto.setMemberId(memberId);

            log.info("[예약 요청] memberId={}, stationRowId={}, start={}, end={}",
                    memberId, dto.getStationRowId(), dto.getReservationStart(), dto.getReservationEnd());

            int status = reservationService.createReservation(dto);

            if (status > 0) {
                result.put("success", true);
                result.put("message", "예약이 완료되었습니다.");
                return ResponseEntity.ok(result);
            } else {
                result.put("success", false);
                result.put("message", "예약 처리 실패");
                return ResponseEntity.badRequest().body(result);
            }

        } catch (RuntimeException e) {
            log.error("예약 처리 실패: {}", e.getMessage());
            result.put("success", false);
            result.put("message", e.getMessage());
            return ResponseEntity.badRequest().body(result);

        } catch (Exception e) {
            log.error("예약 처리 중 오류", e);
            result.put("success", false);
            result.put("message", "서버 오류가 발생했습니다.");
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(result);
        }
    }

    @GetMapping("/list")
    public ResponseEntity<Map<String, Object>> getReservations(
            @RequestParam(value = "stationRowId", required = false) String stationRowId,
            HttpSession session) {

        Map<String, Object> result = new HashMap<>();

        try {
            // stationRowId가 있으면 해당 충전소의 예약 목록 조회
            if (stationRowId != null && !stationRowId.isEmpty()) {
                List<ReservationDTO> reservations = reservationService.getReservationsByStationId(stationRowId);
                result.put("success", true);
                result.put("list", reservations);
                return ResponseEntity.ok(result);
            }
            
            // stationRowId가 없으면 내 예약 목록 조회
            String memberId = (String) session.getAttribute("id");
            if (memberId == null || memberId.isEmpty()) {
                result.put("success", false);
                result.put("message", "로그인이 필요합니다.");
                return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(result);
            }

            List<ReservationDTO> reservations = reservationService.getReservationsByMemberId(memberId);

            result.put("success", true);
            result.put("list", reservations);
            return ResponseEntity.ok(result);

        } catch (Exception e) {
            log.error("예약 목록 조회 실패", e);
            result.put("success", false);
            result.put("message", "예약 목록 조회 중 오류가 발생했습니다.");
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(result);
        }
    }

    @PostMapping("/delete")
    public ResponseEntity<Map<String, Object>> cancelReservation(
            @RequestParam("reservationId") int reservationId,
            HttpSession session) {

        Map<String, Object> result = new HashMap<>();

        try {
            String memberId = (String) session.getAttribute("id");

            if (memberId == null || memberId.isEmpty()) {
                result.put("success", false);
                result.put("message", "로그인이 필요합니다.");
                return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(result);
            }

            int status = reservationService.cancelReservation(reservationId, memberId);

            if (status > 0) {
                result.put("success", true);
                result.put("message", "예약 취소 완료");
                return ResponseEntity.ok(result);
            } else {
                result.put("success", false);
                result.put("message", "예약 취소 실패 또는 권한 없음");
                return ResponseEntity.badRequest().body(result);
            }

        } catch (Exception e) {
            log.error("예약 취소 오류", e);
            result.put("success", false);
            result.put("message", "서버 오류로 취소 실패");
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(result);
        }
    }

    @GetMapping("/check-availability")
    public ResponseEntity<Map<String, Object>> checkAvailability(
            @RequestParam("stationRowId") String stationRowId,
            @RequestParam("start") LocalDateTime start,
            @RequestParam("end") LocalDateTime end) {

        Map<String, Object> result = new HashMap<>();

        try {
            boolean available = reservationService.isReservationTimeAvailable(stationRowId, start, end);

            result.put("success", true);
            result.put("available", available);
            return ResponseEntity.ok(result);

        } catch (Exception e) {
            log.error("예약 가능 여부 체크 중 오류", e);
            result.put("success", false);
            result.put("message", "시간 체크 중 서버 오류 발생");
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(result);
        }
    }
}
