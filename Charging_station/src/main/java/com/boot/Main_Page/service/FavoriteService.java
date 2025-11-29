package com.boot.Main_Page.service;

import java.util.List;

import com.boot.Main_Page.dto.ElecDTO;

public interface FavoriteService {
    
    // 즐겨찾기 추가 처리 (중복 체크 포함)
    // 반환값: 1 = 성공, 0 = 중복
    int addFavorite(String memberId, String stationId);

    // 즐겨찾기 등록 여부 확인
    int checkFavorite(String memberId, String stationId);
    
    int deleteFavorite(String memberId, String stationId);
    
    List<ElecDTO> getFavoriteStations(String memberId);
}