package  com.boot.Main_Page.service;

import java.util.HashMap;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.boot.Main_Page.dao.FavoriteDAO;
import com.boot.Main_Page.dto.ElecDTO;

import lombok.extern.slf4j.Slf4j;

@Service
@Slf4j
public class FavoriteServiceImpl implements FavoriteService {

    @Autowired
    private FavoriteDAO favoriteDAO;

    @Override
    public int addFavorite(String memberId, String stationId) {
        log.info("@# FavoriteService.addFavorite() - ID: {}, Station: {}", memberId, stationId);
        
        HashMap<String, Object> param = new HashMap<>();
        param.put("memberId", memberId);
        param.put("stationId", stationId);
        
        // 1. 중복 체크
        int count = favoriteDAO.checkFavorite(param);
        if (count > 0) {
            log.warn("@# 이미 등록된 즐겨찾기입니다.");
            return 0; // 이미 등록됨
        }
        
        // 2. 등록
        favoriteDAO.addFavorite(param);
        return 1; // 성공
    }

    @Override
    public int deleteFavorite(String memberId, String stationId) {
        log.info("@# FavoriteService.deleteFavorite() - ID: {}, Station: {}", memberId, stationId);
        
        HashMap<String, Object> param = new HashMap<>();
        param.put("memberId", memberId);
        param.put("stationId", stationId);
        
        // 삭제 
        favoriteDAO.deleteFavorite(param);
        return 1; 
    }

    @Override
    public int checkFavorite(String memberId, String stationId) {
        HashMap<String, Object> param = new HashMap<>();
        param.put("memberId", memberId);
        param.put("stationId", stationId);
        return favoriteDAO.checkFavorite(param);
    }
    @Override
    public List<ElecDTO> getFavoriteStations(String memberId) {
        log.info("@# FavoriteService.getFavoriteStations() - ID: {}", memberId);
        return favoriteDAO.getFavoriteStations(memberId);
    }
}