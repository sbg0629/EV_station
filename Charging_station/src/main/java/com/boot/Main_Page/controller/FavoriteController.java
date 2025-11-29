package com.boot.Main_Page.controller;


import java.util.HashMap;
import java.util.List;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.boot.Main_Page.dto.ElecDTO;
import com.boot.Main_Page.service.FavoriteService;

import lombok.extern.slf4j.Slf4j;

@RestController
@Slf4j
public class FavoriteController {

    @Autowired
    private FavoriteService favoriteService;

    /**
     * 충전소 즐겨찾기 추가 요청 처리
     * URL: /favorite/add
     */
    @PostMapping("/favorite/add")
    public HashMap<String, Object> addFavorite(
            @RequestParam(value = "stationId", required = false) String stationId, 
            HttpSession session) {

        HashMap<String, Object> result = new HashMap<>();
        String memberId = (String) session.getAttribute("id");

        if (memberId == null || memberId.isEmpty()) {
            result.put("success", false);
            result.put("message", "로그인이 필요합니다.");
            return result;
        }
        
        if (stationId == null || stationId.isEmpty()) {
            result.put("success", false);
            result.put("message", "충전소 ID가 유효하지 않아 즐겨찾기 추가에 실패했습니다.");
            return result;
        }
        
        log.info("@# Favorite Add Request: Member ID={}, Station ID={}", memberId, stationId);

        try {
            int status = favoriteService.addFavorite(memberId, stationId);

            if (status == 1) {
                result.put("success", true);
                result.put("message", "⭐ 즐겨찾기에 성공적으로 추가되었습니다.");
            } else {
                result.put("success", false);
                result.put("message", "이미 즐겨찾기에 등록된 충전소입니다.");
            }
        } catch (Exception e) {
            log.error("@# 즐겨찾기 추가 중 DB 오류 발생: {}", e.getMessage(), e);
            result.put("success", false);
            result.put("message", "서버 오류로 인해 추가에 실패했습니다.");
        }

        return result;
    }
    
    /**
     * 충전소 즐겨찾기 삭제 요청 처리
     * URL: /favorite/delete
     */
    @PostMapping("/favorite/delete")
    public HashMap<String, Object> deleteFavorite(
            @RequestParam(value = "stationId", required = false) String stationId, 
            HttpSession session) {
        
        HashMap<String, Object> result = new HashMap<>();
        String memberId = (String) session.getAttribute("id");

        if (memberId == null || memberId.isEmpty()) {
            result.put("success", false);
            result.put("message", "로그인이 필요합니다.");
            return result;
        }
        
        if (stationId == null || stationId.isEmpty()) {
            result.put("success", false);
            result.put("message", "충전소 ID가 유효하지 않아 즐겨찾기 삭제에 실패했습니다.");
            return result;
        }
        
        log.info("@# Favorite Delete Request: Member ID={}, Station ID={}", memberId, stationId);
        
        try {
            favoriteService.deleteFavorite(memberId, stationId);
            result.put("success", true);
            result.put("message", "즐겨찾기에서 삭제되었습니다.");
        } catch (Exception e) {
            log.error("@# 즐겨찾기 삭제 중 DB 오류 발생: {}", e.getMessage(), e);
            result.put("success", false);
            result.put("message", "서버 오류로 인해 삭제에 실패했습니다.");
        }

        return result;
    }

    /**
     * 충전소의 즐겨찾기 등록 여부 확인 (AJAX 엔드포인트)
     * URL: /favorite/checkStatus
     */
    @PostMapping("/favorite/checkStatus")
    public HashMap<String, Object> checkFavoriteStatus(
            @RequestParam(value = "stationId", required = false) String stationId, 
            HttpSession session) {

        HashMap<String, Object> result = new HashMap<>();
        String memberId = (String) session.getAttribute("id");

        if (memberId == null || memberId.isEmpty()) {
            result.put("isFavorited", false); // 비로그인 상태는 무조건 등록 안 됨
            return result;
        }
        
        if (stationId == null || stationId.isEmpty()) {
            result.put("isFavorited", false);
            return result;
        }

        try {
            int count = favoriteService.checkFavorite(memberId, stationId);
            result.put("isFavorited", count > 0);
        } catch (Exception e) {
            log.error("@# 즐겨찾기 상태 확인 중 오류 발생: {}", e.getMessage(), e);
            result.put("isFavorited", false); 
        }
        return result;
    }
    
    /**
     * 사용자 즐겨찾기 목록 조회 (새로 추가)
     * URL: /favorite/list
     */
    @GetMapping("/favorite/list")
    public List<ElecDTO> getFavoriteList(HttpSession session) {
        String memberId = (String) session.getAttribute("id");
        
        if (memberId == null || memberId.isEmpty()) {
            log.warn("@# 즐겨찾기 목록 조회 요청 - 로그인되지 않은 사용자");
            // 빈 목록 반환 (403 Forbidden 대신 빈 JSON 배열)
            return List.of(); 
        }
        
        log.info("@# 즐겨찾기 목록 조회 요청: Member ID={}", memberId);
        return favoriteService.getFavoriteStations(memberId);
    }
}