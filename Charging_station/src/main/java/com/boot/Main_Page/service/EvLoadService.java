package com.boot.Main_Page.service;

import java.net.URI;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.cache.annotation.Cacheable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.util.UriComponentsBuilder;

import com.boot.Main_Page.dao.ElecDAO;
import com.boot.Main_Page.dao.EvLoadMapper;
import com.boot.Main_Page.dto.ChargerInfoDTO;
import com.boot.Main_Page.dto.EvApiDto;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class EvLoadService {
	
	@Autowired
    private SqlSession sqlSession;

    @Autowired
    private EvLoadMapper evLoadMapper;
    
    @Autowired
    private ElecDAO elecDAO;

    private final String SERVICE_KEY = "bd57b87ea9aa7ba4d2e87197051340c26321a4c486cef4b994b2269766664ccb";
    private final int ROWS_PER_PAGE = 3000; 

    public String loadApiData() {
        try {
            // 1단계: 개수 비교
            EvApiDto probeResponse = callApi(1, 1);
            
            if (probeResponse == null || probeResponse.getTotalCount() == null) {
                return "API 연결 실패";
            }

            int apiTotalCount = probeResponse.getTotalCount();
            int dbTotalCount = evLoadMapper.getDbCount();

            log.info("API 개수: {} vs DB 개수: {}", apiTotalCount, dbTotalCount);

            // 개수가 같으면 패스 (하지만 초기 적재 때는 다를 테니 아래 로직이 실행됨)
            if (apiTotalCount <= dbTotalCount) {
                return "최신 상태입니다. (추가된 충전소 없음)";
            }
            
            log.info(">>> 신규 충전소 감지! 전체 동기화를 시작합니다...");
            
            int totalPages = (int) Math.ceil((double) apiTotalCount / ROWS_PER_PAGE);
            int totalSaved = 0;
            
            // 2단계: 전체 페이지 순회
            for (int page = 1; page <= totalPages; page++) {
                EvApiDto response = callApi(page, ROWS_PER_PAGE);
                
                if (response != null && response.getItems() != null && response.getItems().getItem() != null) {
                    List<EvApiDto.Item> items = response.getItems().getItem();
                    
                    // [수정된 부분] for문으로 하나씩 넣던 걸 지우고, 한 방에 넣는 메서드 호출!
                    int savedCount = saveItems(items); 
                    totalSaved += savedCount;
                    
                    log.info("진행률: {} / {} 페이지 완료 (누적 {}건)", page, totalPages, totalSaved);
                }
            }

            return "동기화 완료! 총 " + apiTotalCount + "개로 갱신되었습니다.";

        } catch (Exception e) {
            log.error("동기화 중 오류", e);
            return "오류: " + e.getMessage();
        }
    }

    private EvApiDto callApi(int pageNo, int numOfRows) {
        try {
            URI uri = UriComponentsBuilder
                    .fromHttpUrl("http://apis.data.go.kr/B552584/EvCharger/getChargerInfo")
                    .queryParam("serviceKey", SERVICE_KEY)
                    .queryParam("pageNo", pageNo)
                    .queryParam("numOfRows", numOfRows)
//                    .queryParam("zcode", "11") // 전국 데이터라면 주석 유지
                    .queryParam("dataType", "JSON")
                    .build()
                    .toUri();

            RestTemplate restTemplate = new RestTemplate();
            return restTemplate.getForObject(uri, EvApiDto.class);
        } catch (Exception e) {
            log.error("{}페이지 호출 중 에러: {}", pageNo, e.getMessage());
            return null;
        }
    }

    // 배치 저장 메서드 (이게 있어야 saveAllStations가 실행됨)
    @Transactional
    public int saveItems(List<EvApiDto.Item> items) {
        try {
            if (items != null && !items.isEmpty()) {
                // 여기서 Mapper의 saveAllStations(배치 insert)를 호출
                evLoadMapper.saveAllStations(items);
            }
            return items.size();
        } catch (Exception e) {
            log.error("배치 저장 실패: {}", e.getMessage());
            return 0;
        }
    }
    @Transactional
    public void refreshStationStatus(String statId) {
        try {
            // 1. URL 생성 (statId 파라미터가 핵심!)
            URI uri = UriComponentsBuilder
                    .fromHttpUrl("http://apis.data.go.kr/B552584/EvCharger/getChargerInfo")
                    .queryParam("serviceKey", SERVICE_KEY)
                    .queryParam("pageNo", 1)
                    .queryParam("numOfRows", 50)  // 한 충전소에 충전기가 50개 넘는 곳은 거의 없음
//                    .queryParam("zcode", "11")    // 서울 (필요 없다면 주석 처리)
                    .queryParam("statId", statId) // 🎯 핵심: 이 ID의 충전소 정보만 요청
                    .queryParam("dataType", "JSON")
                    .build()
                    .toUri();

            // 2. API 호출
            RestTemplate restTemplate = new RestTemplate();
            EvApiDto response = restTemplate.getForObject(uri, EvApiDto.class);

            // 3. 응답 데이터 파싱 및 DB 저장
            if (response != null && 
                response.getItems() != null && 
                response.getItems().getItem() != null) {
                
                List<EvApiDto.Item> items = response.getItems().getItem();
                
                log.info("API 응답 개수 (ID: {}): {}건", statId, items.size());
                
                // 데이터가 비어있지 않다면 저장 수행
                if (!items.isEmpty()) {
                    // 기존에 만들어둔 배치 저장 메서드 재활용 (UPSERT)
                	log.info("첫 번째 충전기 ID 확인: DB값과 비교해보세요 -> [{}]", items.get(0).getChgerId());
                    evLoadMapper.saveAllStations(items);
                    log.info("✅ 실시간 갱신 완료 - 충전소 ID: {}", statId);
                } else {
                    log.info("📭 갱신 데이터 없음 - 충전소 ID: {}", statId);
                }
            }

        } catch (Exception e) {
            // 갱신 실패해도 전체 서비스는 죽으면 안 되므로 로그만 남김
            log.error("❌ 실시간 갱신 중 오류 발생 (ID: {}): {}", statId, e.getMessage());
        }
    }
    
    /**
     * 🌟 [스마트 갱신]
     * 데이터가 'minutes'분 이상 오래된 경우에만 API를 호출하여 갱신합니다.
     */
    @Transactional
    public void refreshStationStatusSmart(String statId, int minutes) {
        try {
            ElecDAO elecDao = sqlSession.getMapper(ElecDAO.class);
            
            // 1. DB에 물어봅니다. "이 충전소 10분 지났어?"
            Map<String, Object> params = new HashMap<>();
            params.put("apiStatId", statId);
            params.put("minutes", minutes);
            
            int needsUpdate = elecDao.needsUpdate(params);

            // 2. 10분이 지났으면(1) -> API 호출 (트래픽 1 소모)
            if (needsUpdate > 0) {
                log.info("⏳ 오래된 데이터 감지 (ID: {}). API 갱신을 수행합니다.", statId);
                refreshStationStatus(statId); // 기존의 1회 갱신 메서드 재사용
            } else {
                // 3. 10분 안 지났으면(0) -> 패스 (트래픽 절약!)
                log.info("✅ 최신 데이터 (ID: {}). API 호출을 건너뜁니다.", statId);
            }

        } catch (Exception e) {
            log.error("스마트 갱신 중 오류 (ID: {}): {}", statId, e.getMessage());
        }
    }
    @Cacheable(value = "chargerList", key = "#statId", unless = "#result == null or #result.isEmpty()")
    public List<ChargerInfoDTO> getChargerListWithCache(String statId) {
        
        // ⭐ Cache Miss (10분 지남) 시에만 이 로직이 실행됩니다.
    	log.info("📢 Cache Miss 발생 (캐시 만료 또는 최초 조회). API/DB 갱신을 수행합니다. StatId: {}", statId);

        // 1. **(선택적)** 충전소 정보가 DB에 너무 오래되었거나 없으면 API를 호출하여 DB를 강제 갱신합니다.
        //    (이 부분은 기존 refreshStationStatusSmart 로직을 대체하는 API 호출입니다.)
        
        // 만약 항상 최신 데이터가 필요한 경우 (예: 지도에서 실시간 상태가 중요):
        refreshStationStatus(statId); // API 호출 및 DB 갱신 (트래픽 발생)
        
        // 2. DB에서 데이터를 조회하여 반환
        List<ChargerInfoDTO> list = elecDAO.getChargerList(statId);
        
        // 반환된 list는 자동으로 Redis에 10분 TTL로 저장됩니다.
        return list;
    }
}
