package com.boot.Main_Page.dao;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import com.boot.Main_Page.dto.ChargerInfoDTO;
import com.boot.Main_Page.dto.ElecDTO;
import java.util.Map; 


public interface ElecDAO {
	public ArrayList<ElecDTO> list();
    
    /**
     * 1. 반경 검색 (XML의 'searchByRadius' 호출)
     */
    public List<ElecDTO> searchByRadius(Map<String, Object> params); 

    /**
     * 2. 키워드 검색 (XML의 'searchByKeyword' 호출)
     */
    public List<ElecDTO> searchByKeyword(Map<String, Object> params);
    
    /**
     * 3. 지도 영역 검색 (XML의 'searchByBounds' 호출)
     */
    public List<ElecDTO> searchByBounds(Map<String, Object> params);
    
    public List<ChargerInfoDTO> getChargerList(String apiStatId);
    
    public int needsUpdate(Map<String, Object> params);
}