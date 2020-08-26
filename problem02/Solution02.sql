WITH RANKED_LOG (USR_NO, MENU_NM, LOGRANK) AS ( 		    -- make rank of log based on user
	SELECT USR_NO, MENU_NM, RANK() OVER (
		PARTITION BY
			USR_NO
		ORDER BY
			LOG_ID
	) 
	FROM
	MENU_LOG
), JOINING_MENU (USR_NO, PREV, NEXT) AS (				        -- do self-join for searching previous log of the one based on rank and user
	SELECT A.USR_NO, A.MENU_NM, B.MENU_NM 
		FROM RANKED_LOG AS A, RANKED_LOG AS B 
		WHERE A.USR_NO = B.USR_NO AND A.LOGRANK = B.LOGRANK - 1 AND A.LOGRANK
), GROUPING_MENU (MENU, PREV_MENU, NUM_APPROCH) AS (				-- count menu appproach grouping by joined menu
	SELECT  T.NEXT , T.PREV , COUNT(USR_NO)  FROM JOINING_MENU AS T
	GROUP BY T.PREV, T.NEXT
	ORDER BY binary(T.NEXT) ASC, COUNT(USR_NO) DESC, binary(T.PREV) ASC 
)

-- calculate ratio : (# of accesses to the previous menu in a specific menu) / (Total # of accesses to a specific menu) * 100%
SELECT G.MENU AS MENU, G.PREV_MENU AS PREV_MENU, G.NUM_APPROCH AS NUM_APPROCH, TRUNCATE(NUM_APPROCH/Total * 100.0, 2) AS 'Ratio(%)'
	FROM (SELECT MENU, SUM(NUM_APPROCH) AS Total FROM GROUPING_MENU GROUP BY MENU) T, GROUPING_MENU AS G
	WHERE T.MENU = G.MENU;
