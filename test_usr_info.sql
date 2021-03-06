/* 
-- 스크립트 설명 
1. 과제를 작성하는데 필요한 MySQL Database 와 Table을 생성하고 데이터를 로딩하는데 사용할 스크립트입니다. 
2. 스크립트는 메뉴 로그 (test_menu.sql) 및 사용자 정보 변경 (test_usr_info.sql) 총 2개입니다.
3. 먼저 MySQL Community Server 최신 버전 (8.0 이상)을 다운 받아서 설치합니다. (https://dev.mysql.com/downloads/mysql)
4. root 계정으로 MySQL에 접속 해서 'source test_menu.sql', 'source test_usr_info.sql' 을 실행하면 과제를 위한 사전준비가 마무리 됩니다.
*/

-- 1. KAKAOBANK 데이터베이스 생성 (데이터베이스가 없을경우)
CREATE DATABASE IF NOT EXISTS KAKAOBANK
CHARACTER SET utf8mb4 
COLLATE utf8mb4_bin;

-- 2. 사용자정보변경로그 테이블 drop(테이블이 있을경우)
DROP TABLE IF EXISTS KAKAOBANK.USR_INFO_CHG_LOG;

-- 3. 사용자정보변경로그 테이블 생성
CREATE TABLE KAKAOBANK.USR_INFO_CHG_LOG (
    LOG_TKTM    VARCHAR(14)   NOT NULL  COMMENT '로그일시'
  , LOG_ID      VARCHAR(20)   NOT NULL  COMMENT '로그ID'
  , USR_NO      VARCHAR(10)   NULL      COMMENT '사용자번호'
  , RSDT_NO     VARCHAR(20)   NULL      COMMENT '주민등록번호'
  , LOC_NM      VARCHAR(10)   NULL      COMMENT '지역명'
  , MCCO_NM     VARCHAR(50)   NULL      COMMENT '이동통신사명'
  , PRIMARY KEY (LOG_TKTM, LOG_ID)
) COMMENT '사용자정보변경로그'
;

-- 4. 사용자정보변경로그 데이터 생성
INSERT INTO KAKAOBANK.USR_INFO_CHG_LOG VALUES('20190301030814','id000','001','','서울','');
INSERT INTO KAKAOBANK.USR_INFO_CHG_LOG VALUES('20190302105904','id001','001','','가평','');
INSERT INTO KAKAOBANK.USR_INFO_CHG_LOG VALUES('20190302110132','id002','004','6107081******','','');
INSERT INTO KAKAOBANK.USR_INFO_CHG_LOG VALUES('20190302110537','id003','001','','','SK');
INSERT INTO KAKAOBANK.USR_INFO_CHG_LOG VALUES('20190305022554','id004','003','','용인','알뜰폰');
INSERT INTO KAKAOBANK.USR_INFO_CHG_LOG VALUES('20190305030829','id005','004','','서울','');
INSERT INTO KAKAOBANK.USR_INFO_CHG_LOG VALUES('20190305031532','id006','003','','','LG');
INSERT INTO KAKAOBANK.USR_INFO_CHG_LOG VALUES('20190305110540','id007','001','','이천','');
INSERT INTO KAKAOBANK.USR_INFO_CHG_LOG VALUES('20190306022801','id008','003','','광주','');
INSERT INTO KAKAOBANK.USR_INFO_CHG_LOG VALUES('20190306030916','id009','004','','고양','');
INSERT INTO KAKAOBANK.USR_INFO_CHG_LOG VALUES('20190307022934','id010','003','','양평','');
INSERT INTO KAKAOBANK.USR_INFO_CHG_LOG VALUES('20190309022937','id011','003','','여주','');
INSERT INTO KAKAOBANK.USR_INFO_CHG_LOG VALUES('20190310023036','id012','003','','','KT');
INSERT INTO KAKAOBANK.USR_INFO_CHG_LOG VALUES('20190311023119','id013','003','','','SK');
INSERT INTO KAKAOBANK.USR_INFO_CHG_LOG VALUES('20190311030211','id014','002','9003051******','부산','SK');
INSERT INTO KAKAOBANK.USR_INFO_CHG_LOG VALUES('20190311031331','id015','004','','파주','');
INSERT INTO KAKAOBANK.USR_INFO_CHG_LOG VALUES('20190312181432','id016','001','','양평','');
INSERT INTO KAKAOBANK.USR_INFO_CHG_LOG VALUES('20190313030218','id017','002','','경주','');
INSERT INTO KAKAOBANK.USR_INFO_CHG_LOG VALUES('20190313030224','id018','003','','서울','');
INSERT INTO KAKAOBANK.USR_INFO_CHG_LOG VALUES('20190313031018','id019','001','0306044******','','');
INSERT INTO KAKAOBANK.USR_INFO_CHG_LOG VALUES('20190313031435','id020','004','','인천','');
INSERT INTO KAKAOBANK.USR_INFO_CHG_LOG VALUES('20190315030228','id021','002','','포항','');
INSERT INTO KAKAOBANK.USR_INFO_CHG_LOG VALUES('20190315030551','id022','003','','용인','');
INSERT INTO KAKAOBANK.USR_INFO_CHG_LOG VALUES('20190315031659','id023','004','','서울','');
INSERT INTO KAKAOBANK.USR_INFO_CHG_LOG VALUES('20190316031133','id024','001','','화성','');
INSERT INTO KAKAOBANK.USR_INFO_CHG_LOG VALUES('20190317061427','id025','002','','울산','');
INSERT INTO KAKAOBANK.USR_INFO_CHG_LOG VALUES('20190317061529','id026','002','','','LG');
INSERT INTO KAKAOBANK.USR_INFO_CHG_LOG VALUES('20190318031602','id027','001','','연천','');
INSERT INTO KAKAOBANK.USR_INFO_CHG_LOG VALUES('20190318132447','id028','002','','','알뜰폰');
INSERT INTO KAKAOBANK.USR_INFO_CHG_LOG VALUES('20190320031035','id029','001','','포천','SK');
INSERT INTO KAKAOBANK.USR_INFO_CHG_LOG VALUES('20190320041030','id030','002','','김해','');
INSERT INTO KAKAOBANK.USR_INFO_CHG_LOG VALUES('20190321011433','id031','003','7504302******','','');
INSERT INTO KAKAOBANK.USR_INFO_CHG_LOG VALUES('20190321031231','id032','003','','천안','');
INSERT INTO KAKAOBANK.USR_INFO_CHG_LOG VALUES('20190321031443','id033','003','','','KT');
INSERT INTO KAKAOBANK.USR_INFO_CHG_LOG VALUES('20190321041033','id034','002','','창원','');
INSERT INTO KAKAOBANK.USR_INFO_CHG_LOG VALUES('20190322034922','id035','001','','','KT');
INSERT INTO KAKAOBANK.USR_INFO_CHG_LOG VALUES('20190322044947','id036','002','','','KT');
INSERT INTO KAKAOBANK.USR_INFO_CHG_LOG VALUES('20190327061534','id037','002','','','알뜰폰');
INSERT INTO KAKAOBANK.USR_INFO_CHG_LOG VALUES('20190328035018','id038','001','','','LG');
INSERT INTO KAKAOBANK.USR_INFO_CHG_LOG VALUES('20190331031708','id039','004','','양주','');