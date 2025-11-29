package com.boot.Main_Page.service;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import com.boot.Main_Page.dto.ElecDTO;

public interface ElecService {
	public ArrayList<ElecDTO> list();
    
    /**
     * 1. 반경 검색 (Controller가 호출)
     */
    public List<ElecDTO> findStationsByRadius(Map<String, Object> params);

    /**
     * 2. 키워드 검색 (Controller가 호출)
     */
    public List<ElecDTO> findStationsByKeyword(Map<String, Object> params);
    
    /**
     * 3. 지도 영역 검색 (Controller가 호출)
     */
    public List<ElecDTO> findStationsByBounds(Map<String, Object> params);
}