WITH RECENT_RSDT (USR_NO, RSDT_NO) AS (
	SELECT A.USR_NO, RSDT_NO
	FROM (SELECT MAX(LOG_TKTM) AS MAX_TIME, USR_NO FROM USR_INFO_CHG_LOG WHERE RSDT_NO <> "" GROUP BY USR_NO) A,
	 USR_INFO_CHG_LOG 
	WHERE A.MAX_TIME=USR_INFO_CHG_LOG.LOG_TKTM
), RECENT_MCCO (USR_NO, MCCO_NM) AS (
	SELECT A.USR_NO, MCCO_NM
	FROM (SELECT MAX(LOG_TKTM) AS MAX_TIME, USR_NO FROM USR_INFO_CHG_LOG WHERE MCCO_NM <> "" GROUP BY USR_NO) A,
	 USR_INFO_CHG_LOG 
	WHERE A.MAX_TIME=USR_INFO_CHG_LOG.LOG_TKTM
), RANKED_LOC (USR_NO, LOC_NM, LOCRANK) AS (
	SELECT USR_NO, LOC_NM, RANK() OVER(
	PARTITION BY
		USR_NO
	ORDER BY
		LOG_ID DESC
	) LocRank FROM USR_INFO_CHG_LOG WHERE LOC_NM <> ""
), USER_AGE (USR_NO, AGE) AS (
	SELECT USR_NO, CASE SUBSTR(RSDT_NO,7, 1) 
					WHEN 1 THEN 
						CASE WHEN SUBSTR(RSDT_NO, 3, 4) <= 0626 THEN 
							2020 - SUBSTR(RSDT_NO,1,2) - 1900 ELSE
							2020 - SUBSTR(RSDT_NO,1,2) - 1900 - 1 END
					WHEN 2 THEN 
						CASE WHEN SUBSTR(RSDT_NO, 3, 4) <= 0626 THEN 
							2020 - SUBSTR(RSDT_NO,1,2) - 1900 ELSE
							2020 - SUBSTR(RSDT_NO,1,2) - 1900 - 1 END
					WHEN 3 THEN 
						CASE WHEN SUBSTR(RSDT_NO, 3, 4) <= 0626 THEN 
							2020 - SUBSTR(RSDT_NO,1,2) - 2000 ELSE
							2020 - SUBSTR(RSDT_NO,1,2) - 2000 - 1 END
					WHEN 4 THEN 
						CASE WHEN SUBSTR(RSDT_NO, 3, 4) <= 0626 THEN 
							2020 - SUBSTR(RSDT_NO,1,2) - 2000 ELSE
							2020 - SUBSTR(RSDT_NO,1,2) - 2000 - 1 END
						END AS AGE FROM RECENT_RSDT
), USER_GENDER(USR_NO, GENDER) AS (
	SELECT USR_NO, 
	CASE SUBSTR(RSDT_NO,7,1) WHEN 1 THEN 'MALE' WHEN 2 THEN 'FEMALE' 
							WHEN 3 THEN 'MALE' WHEN 4 THEN 'FEMALE' 
							ELSE NULL END FROM RECENT_RSDT
), COUNT_MENU(USR_NO, MENU_NM, CNT_MENU) AS (		-- most frequent menu count
	SELECT USR_NO, MENU_NM, COUNT(MENU_NM) FROM MENU_LOG 
	WHERE MENU_NM != 'logout' AND MENU_NM != 'login' 
	GROUP BY USR_NO, MENU_NM
), MAX_VAL (USR_NO, MAX_CNT) AS (
	SELECT USR_NO, MAX(CNT_MENU)
	FROM COUNT_MENU 
	GROUP BY USR_NO
), MAX_MENU (USR_NO, MENU_NM) AS (
	SELECT A.USR_NO , A.MENU_NM  
	FROM COUNT_MENU AS A, MAX_VAL AS B 
	WHERE CNT_MENU=MAX_CNT AND A.USR_NO = B.USR_NO
), GET_LOG_TIME (LOG_TKTM, USR_NO, MENU_NM) AS (
	SELECT M.LOG_TKTM, M.USR_NO, M.MENU_NM 
	FROM MENU_LOG AS M, MAX_MENU AS K
	WHERE M.USR_NO = K.USR_NO AND K.MENU_NM =M.MENU_NM
), GET_MAX_LOG_TIME (M_TKTM, USR_NO) AS (
	SELECT MAX(LOG_TKTM), USR_NO FROM
	GET_LOG_TIME 
	GROUP BY USR_NO
), USERS (USR_NO) AS (
	SELECT DISTINCT USR_NO FROM USR_INFO_CHG_LOG
)


-- 최종 출력 버전
SELECT USERS.USR_NO, UG.GENDER, UA.AGE, 
		RL.LOCATION, PL.PREV_LOCATION,  
		MCCO.MCCO_NM, RD.REGISTER_DAY, 
		MFM.MOST_FREQUENT_MENU, RM.RECENT_MENU FROM USERS 
LEFT JOIN
	(SELECT USERS.USR_NO, IFNULL(USER_GENDER.GENDER, '-') AS GENDER
	 FROM USERS LEFT OUTER JOIN USER_GENDER ON USERS.USR_NO=USER_GENDER.USR_NO) AS UG
	ON USERS.USR_NO=UG.USR_NO
LEFT JOIN
	(SELECT USERS.USR_NO, IFNULL(USER_AGE.AGE, '-') AS AGE
	 FROM USERS LEFT OUTER JOIN USER_AGE ON USERS.USR_NO=USER_AGE.USR_NO) AS UA
	ON USERS.USR_NO=UA.USR_NO
LEFT JOIN
	(SELECT USERS.USR_NO, IFNULL(RECENT_LOC.LOC_NM, '-') AS LOCATION
	 FROM USERS LEFT OUTER JOIN (SELECT USR_NO, LOC_NM FROM RANKED_LOC WHERE LOCRANK = 1) AS RECENT_LOC
	  ON USERS.USR_NO=RECENT_LOC.USR_NO) AS RL
	ON USERS.USR_NO=RL.USR_NO
LEFT JOIN
	(SELECT USERS.USR_NO, IFNULL(PREV_LOC.LOC_NM, '-') AS PREV_LOCATION
	 FROM USERS LEFT OUTER JOIN (SELECT USR_NO, LOC_NM FROM RANKED_LOC WHERE LOCRANK = 2) AS PREV_LOC
	  ON USERS.USR_NO=PREV_LOC.USR_NO) AS PL
	ON USERS.USR_NO=PL.USR_NO
LEFT JOIN 
	(SELECT USERS.USR_NO, IFNULL(RECENT_MCCO.MCCO_NM, '-') AS MCCO_NM
	 FROM USERS LEFT OUTER JOIN RECENT_MCCO ON USERS.USR_NO=RECENT_MCCO.USR_NO) AS MCCO
	ON USERS.USR_NO=MCCO.USR_NO
LEFT JOIN 
	(SELECT USERS.USR_NO, IFNULL(REG_DAY.RegDay, '-') AS REGISTER_DAY
	 FROM USERS LEFT OUTER JOIN (SELECT USR_NO, SUBSTR(MIN(LOG_TKTM),1, 8) AS RegDay FROM USR_INFO_CHG_LOG GROUP BY USR_NO) AS REG_DAY
	 ON USERS.USR_NO=REG_DAY.USR_NO) AS RD
	ON USERS.USR_NO=RD.USR_NO
LEFT JOIN 
	(SELECT USERS.USR_NO, IFNULL(MOST_FREQ_MENU.MENU_NM, '-') AS MOST_FREQUENT_MENU
	 FROM USERS LEFT OUTER JOIN (SELECT A.USR_NO, B.MENU_NM FROM MENU_LOG AS B, GET_MAX_LOG_TIME AS A
	WHERE B.LOG_TKTM = A.M_TKTM AND B.USR_NO = A.USR_NO ORDER BY A.USR_NO) AS MOST_FREQ_MENU
	 ON USERS.USR_NO=MOST_FREQ_MENU.USR_NO) AS MFM
	ON USERS.USR_NO=MFM.USR_NO
LEFT JOIN
	(SELECT USERS.USR_NO, IFNULL(R_MENU.MENU_NM, '-') AS RECENT_MENU
	 FROM USERS LEFT OUTER JOIN (SELECT MENU_LOG.USR_NO, MENU_LOG.MENU_NM 
	FROM (SELECT MAX(LOG_TKTM) AS RECENT_TIME FROM MENU_LOG 
		WHERE MENU_NM != 'logout' && MENU_NM != 'login' GROUP BY USR_NO) AS T, MENU_LOG 
	WHERE T.RECENT_TIME = MENU_LOG.LOG_TKTM) AS R_MENU
	 ON USERS.USR_NO=R_MENU.USR_NO) AS RM
	ON USERS.USR_NO=RM.USR_NO
ORDER BY USERS.USR_NO;