package com.boot.Main_Page.dao;

import java.util.HashMap;
import java.util.List;

import com.boot.Main_Page.dto.ElecDTO;

public interface FavoriteDAO {
    
    // 즐겨찾기 추가 (삽입)
    void addFavorite(HashMap<String, Object> param);
    
    // 즐겨찾기 중복 체크 및 등록 여부 확인
    int checkFavorite(HashMap<String, Object> param);
    
    void deleteFavorite(HashMap<String, Object> param);
    
    List<ElecDTO> getFavoriteStations(String memberId);
}