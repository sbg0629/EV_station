-- ============================================
-- 혼잡도 분석용 더미 데이터 생성 스크립트
-- ============================================

USE ev;

-- 1) 더미 멤버 50명 생성 (이미 있으면 스킵)
DELIMITER $$

DROP PROCEDURE IF EXISTS create_dummy_members$$

CREATE PROCEDURE create_dummy_members()
BEGIN
  DECLARE i INT DEFAULT 1;
  
  WHILE i <= 50 DO
    INSERT IGNORE INTO member_tb (member_id, name, password, nickname, email, phone_number, join_date)
    VALUES (
      CONCAT('dummy_user', LPAD(i,3,'0')),
      CONCAT('User ', i),
      '$2a$10$dummy.hash.here', -- 해시된 비밀번호 형식 (실제 운영에서는 적절한 해시 필요)
      CONCAT('user', i),
      CONCAT('dummy', i, '@example.com'),
      CONCAT('010', LPAD(i,8,'0')),
      NOW()
    );
    SET i = i + 1;
  END WHILE;
  
  SELECT CONCAT('✅ 더미 멤버 생성 완료: ', COUNT(*), '명') AS result
  FROM member_tb 
  WHERE member_id LIKE 'dummy_user%';
END$$

DELIMITER ;

CALL create_dummy_members();
DROP PROCEDURE IF EXISTS create_dummy_members;

-- 2) reservation 더미 데이터 생성
-- 오늘 날짜 + 미래 7일간의 예약 데이터 생성
-- station_row_id는 사용자가 테스트할 충전소 ID로 변경하세요 (예: 'BNBN0239')

DELIMITER $$

DROP PROCEDURE IF EXISTS create_dummy_reservations$$

CREATE PROCEDURE create_dummy_reservations(
    IN station_id VARCHAR(100),
    IN total_count INT
)
BEGIN
  DECLARE i INT DEFAULT 1;
  DECLARE member_index INT;
  DECLARE member_id_val VARCHAR(100);
  DECLARE start_dt DATETIME;
  DECLARE end_dt DATETIME;
  DECLARE duration_min INT;
  DECLARE ord_id VARCHAR(100);
  DECLARE chg_type VARCHAR(10);
  DECLARE st VARCHAR(20);
  DECLARE days_offset INT;
  DECLARE hour_val INT;
  DECLARE minute_val INT;
  
  -- 기존 더미 예약 데이터 삭제 (선택사항 - 원하면 주석 해제)
  -- DELETE FROM reservation_tb WHERE station_row_id = station_id AND member_id LIKE 'dummy_user%';
  
  WHILE i <= total_count DO
    -- 랜덤 멤버 선택 (1..50)
    SET member_index = FLOOR(1 + RAND()*50);
    SET member_id_val = CONCAT('dummy_user', LPAD(member_index,3,'0'));
    
    -- 날짜: 오늘부터 7일 후까지 (0~7일)
    SET days_offset = FLOOR(RAND() * 8);
    
    -- 시간: 0~23시
    SET hour_val = FLOOR(RAND() * 24);
    
    -- 분: 0, 15, 30, 45분 (30분 단위)
    SET minute_val = FLOOR(RAND() * 4) * 15;
    
    -- 시작 시간: 오늘 + days_offset일 + hour_val시 + minute_val분
    SET start_dt = DATE_ADD(DATE(NOW()), INTERVAL days_offset DAY);
    SET start_dt = DATE_ADD(start_dt, INTERVAL hour_val HOUR);
    SET start_dt = DATE_ADD(start_dt, INTERVAL minute_val MINUTE);
    
    -- 지속시간: 30분, 60분, 90분, 120분 중 하나
    SET duration_min = 30 + (FLOOR(RAND() * 4) * 30);
    SET end_dt = DATE_ADD(start_dt, INTERVAL duration_min MINUTE);
    
    -- order_id
    SET ord_id = CONCAT('ORD', LPAD(i,6,'0'));
    
    -- charger_type: 60% 확률로 급속, 40% 확률로 완속
    -- 'FAST' 또는 '급속' 형식 지원
    IF RAND() < 0.6 THEN
      IF RAND() < 0.5 THEN
        SET chg_type = 'FAST';
      ELSE
        SET chg_type = '급속';
      END IF;
    ELSE
      IF RAND() < 0.5 THEN
        SET chg_type = 'SLOW';
      ELSE
        SET chg_type = '완속';
      END IF;
    END IF;
    
    -- status: 75% 확률로 RESERVED (혼잡도에 반영됨), 15% COMPLETED, 10% CANCELED
    IF RAND() < 0.75 THEN
      SET st = 'RESERVED';
    ELSEIF RAND() < 0.9 THEN
      SET st = 'COMPLETED';
    ELSE
      SET st = 'CANCELLED';
    END IF;
    
    -- 예약 데이터 삽입
    INSERT INTO reservation_tb (
      member_id, 
      station_row_id, 
      reservation_start, 
      reservation_end, 
      status, 
      order_id, 
      charger_type,
      created_at,
      updated_at
    )
    VALUES (
      member_id_val, 
      station_id, 
      start_dt, 
      end_dt, 
      st, 
      ord_id, 
      chg_type,
      NOW(),
      NOW()
    );
    
    SET i = i + 1;
  END WHILE;
  
  -- 생성 결과 요약 출력
  SELECT 
    CONCAT('✅ 더미 예약 생성 완료: ', COUNT(*), '건') AS total_count,
    CONCAT('📅 RESERVED 상태: ', SUM(CASE WHEN status = 'RESERVED' THEN 1 ELSE 0 END), '건') AS reserved_count,
    CONCAT('📅 COMPLETED 상태: ', SUM(CASE WHEN status = 'COMPLETED' THEN 1 ELSE 0 END), '건') AS completed_count,
    CONCAT('📅 CANCELLED 상태: ', SUM(CASE WHEN status = 'CANCELLED' THEN 1 ELSE 0 END), '건') AS cancelled_count,
    CONCAT('⚡ FAST/급속: ', SUM(CASE WHEN charger_type IN ('FAST', '급속') THEN 1 ELSE 0 END), '건') AS fast_count,
    CONCAT('🔌 SLOW/완속: ', SUM(CASE WHEN charger_type IN ('SLOW', '완속') THEN 1 ELSE 0 END), '건') AS slow_count,
    CONCAT('📆 오늘 날짜: ', SUM(CASE WHEN DATE(reservation_start) = DATE(NOW()) THEN 1 ELSE 0 END), '건') AS today_count,
    CONCAT('📆 미래 날짜: ', SUM(CASE WHEN DATE(reservation_start) > DATE(NOW()) THEN 1 ELSE 0 END), '건') AS future_count
  FROM reservation_tb 
  WHERE station_row_id = station_id 
    AND member_id LIKE 'dummy_user%';
    
END$$

DELIMITER ;

-- 3) 더미 데이터 생성 실행
-- ⚠️ station_row_id를 테스트할 충전소 ID로 변경하세요!
-- 예: CALL create_dummy_reservations('BNBN0239', 300);

-- 예제: BNBN0239 충전소에 300건의 더미 예약 생성
CALL create_dummy_reservations('BNBN0239', 300);

-- 다른 충전소에도 데이터를 넣고 싶다면:
-- CALL create_dummy_reservations('SF003112', 200);
-- CALL create_dummy_reservations('다른충전소ID', 150);

-- 프로시저 제거
DROP PROCEDURE IF EXISTS create_dummy_reservations;

-- 4) 생성된 데이터 확인 쿼리
SELECT 
    '=== 생성된 예약 데이터 요약 ===' AS info
UNION ALL
SELECT CONCAT('총 예약 수: ', COUNT(*), '건') 
FROM reservation_tb 
WHERE station_row_id = 'BNBN0239' 
  AND member_id LIKE 'dummy_user%'
UNION ALL
SELECT CONCAT('RESERVED 상태: ', COUNT(*), '건 (혼잡도에 반영됨)') 
FROM reservation_tb 
WHERE station_row_id = 'BNBN0239' 
  AND member_id LIKE 'dummy_user%'
  AND status = 'RESERVED'
UNION ALL
SELECT CONCAT('오늘 날짜 예약: ', COUNT(*), '건') 
FROM reservation_tb 
WHERE station_row_id = 'BNBN0239' 
  AND member_id LIKE 'dummy_user%'
  AND DATE(reservation_start) = DATE(NOW())
  AND status = 'RESERVED'
UNION ALL
SELECT CONCAT('미래 날짜 예약: ', COUNT(*), '건') 
FROM reservation_tb 
WHERE station_row_id = 'BNBN0239' 
  AND member_id LIKE 'dummy_user%'
  AND DATE(reservation_start) > DATE(NOW())
  AND status = 'RESERVED'
UNION ALL
SELECT CONCAT('오늘 시간대별 예약 (RESERVED): ', GROUP_CONCAT(CONCAT(HOUR(reservation_start), '시:', COUNT(*), '건') ORDER BY HOUR(reservation_start)))
FROM reservation_tb 
WHERE station_row_id = 'BNBN0239' 
  AND member_id LIKE 'dummy_user%'
  AND DATE(reservation_start) = DATE(NOW())
  AND status = 'RESERVED'
GROUP BY HOUR(reservation_start)
LIMIT 24;

-- 5) 특정 충전소의 오늘 예약 시간대별 조회 (혼잡도 확인용)
SELECT 
    HOUR(reservation_start) AS hour,
    COUNT(*) AS reservation_count,
    SUM(CASE WHEN charger_type IN ('FAST', '급속') THEN 1 ELSE 0 END) AS fast_count,
    SUM(CASE WHEN charger_type IN ('SLOW', '완속') THEN 1 ELSE 0 END) AS slow_count
FROM reservation_tb
WHERE station_row_id = 'BNBN0239'
  AND DATE(reservation_start) >= DATE(NOW())
  AND status = 'RESERVED'
GROUP BY HOUR(reservation_start)
ORDER BY hour;

