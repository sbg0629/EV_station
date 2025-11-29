package com.boot.Main_Page.dao;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import com.boot.Main_Page.dto.EvApiDto;

@Mapper
public interface EvLoadMapper {
//    void upsertStation(EvApiDto.Item item);
    void updateStationStatus(EvApiDto.Item item);
    void saveAllStations(List<EvApiDto.Item> items);
    
    // [추가] 현재 DB에 저장된 충전소 총 개수 조회
    int getDbCount();
}