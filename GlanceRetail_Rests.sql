IF EXISTS
(
    SELECT
           *
    FROM
         tempdb..sysobjects
    WHERE  id = OBJECT_ID('tempdb..#CalendarDates')
           AND xtype = 'U'
)
    DROP TABLE #CalendarDates;
GO

IF EXISTS
(
    SELECT
           *
    FROM
         tempdb..sysobjects
    WHERE  id = OBJECT_ID('tempdb..#TT_TurnoverRests')
           AND xtype = 'U'
)
    DROP TABLE #TT_TurnoverRests;
GO

SELECT
	CONVERT(DATE, Calendar._Fld3065) AS CalendarDate
INTO #CalendarDates
FROM _InfoReg3064 AS Calendar
WHERE Calendar._Fld3065 >= DATEADD(DAY, -DATEPART(DAY, CONVERT(DATE, GETDATE())) + 1, DATEADD(MONTH, -1, CONVERT(DATE, GETDATE())))
	AND Calendar._Fld3065 <= GETDATE()
;

SELECT
       CAST(2 AS NUMERIC(1, 0)) AS _RecType,
       CONVERT(DATE, _AccumReg2245._Period) AS _Period,
       _AccumReg2245._Fld2246RRef AS warehouseRef,
       _AccumReg2245._Fld2247RRef AS goodsRef,
       _AccumReg2245._Fld2248RRef AS characteristicRef,
       0 AS Balance,
       CAST(SUM(CASE
                    WHEN _AccumReg2245._RecordKind = 0
                    THEN _AccumReg2245._Fld2249
                    ELSE-_AccumReg2245._Fld2249
                END) AS NUMERIC(21, 3)) AS Turnover,
       CAST(SUM(CASE
                    WHEN _AccumReg2245._RecordKind = 0
                    THEN _AccumReg2245._Fld2249
                    ELSE 0
                END) AS NUMERIC(21, 3)) AS Receipt,
       CAST(SUM(CASE
                    WHEN _AccumReg2245._RecordKind = 0
                    THEN 0
                    ELSE _AccumReg2245._Fld2249
                END) AS NUMERIC(21, 3)) AS Expense
INTO #TT_TurnoverRests
FROM
     _AccumReg2245 WITH (NOLOCK)
     LEFT OUTER JOIN _Reference39 WITH (NOLOCK)
          ON _AccumReg2245._Fld2246RRef = _Reference39._IDRRef
     LEFT OUTER JOIN _Reference29 WITH (NOLOCK)
          ON _Reference39._Fld540RRef = _Reference29._IDRRef
WHERE   _AccumReg2245._Period >= DATEADD(DAY, -DATEPART(DAY, CONVERT(DATE, GETDATE())) + 1, DATEADD(MONTH, -1, CONVERT(DATE, GETDATE())))
        AND _AccumReg2245._Active = 0x01
        AND _Reference29._Fld319 = 0x01
        AND _Reference39._Fld538RRef = 0xA6360784943FC3E244C0E625E12D72C0
GROUP BY
         CONVERT(DATE, _AccumReg2245._Period),
         _AccumReg2245._Fld2246RRef,
         _AccumReg2245._Fld2247RRef,
         _AccumReg2245._Fld2248RRef
HAVING CAST(SUM(CASE
                    WHEN _AccumReg2245._RecordKind = 0
                    THEN _AccumReg2245._Fld2249
                    ELSE-_AccumReg2245._Fld2249
                END) AS NUMERIC(21, 3)) <> 0
       OR CAST(SUM(CASE
                       WHEN _AccumReg2245._RecordKind = 0
                       THEN _AccumReg2245._Fld2249
                       ELSE 0
                   END) AS NUMERIC(21, 3)) <> 0
       OR CAST(SUM(CASE
                       WHEN _AccumReg2245._RecordKind = 0
                       THEN 0
                       ELSE _AccumReg2245._Fld2249
                   END) AS NUMERIC(21, 3)) <> 0
UNION ALL
SELECT
       CAST(1 AS NUMERIC(1, 0)) AS _RecType,
       DATEADD(DAY, -DATEPART(DAY, CONVERT(DATE, GETDATE())) + 1, DATEADD(MONTH, -1, CONVERT(DATE, GETDATE()))) AS _Period,
       TT_AccumRegTotals2250.warehouseRef AS warehouseRef,
       TT_AccumRegTotals2250.goodsRef AS goodsRef,
       TT_AccumRegTotals2250.characteristicRef AS characteristicRef,
       CAST(SUM(TT_AccumRegTotals2250.Balance) AS NUMERIC(28, 3)) AS Balance,
       SUM(0) AS Turnover,
       SUM(0) AS Receipt,
       SUM(0) AS Expense
FROM
(
    SELECT
           _AccumRegTotals2250._Fld2246RRef AS warehouseRef,
           _AccumRegTotals2250._Fld2247RRef AS goodsRef,
           _AccumRegTotals2250._Fld2248RRef AS characteristicRef,
           CAST(_AccumRegTotals2250._Fld2249 AS NUMERIC(22, 3)) AS Balance
    FROM
         _AccumRegTotals2250 WITH (NOLOCK)
         LEFT OUTER JOIN _Reference39 WITH (NOLOCK)
              ON _AccumRegTotals2250._Fld2246RRef = _Reference39._IDRRef
         LEFT OUTER JOIN _Reference29 WITH (NOLOCK)
              ON _Reference39._Fld540RRef = _Reference29._IDRRef
    WHERE   _AccumRegTotals2250._Period = '3999-11-01 00:00:00'
            AND _Reference29._Fld319 = 0x01
            AND _Reference39._Fld538RRef = 0xA6360784943FC3E244C0E625E12D72C0
            AND _AccumRegTotals2250._Fld2249 <> 0
    UNION ALL
    SELECT
           _AccumReg2245._Fld2246RRef AS warehouseRef,
           _AccumReg2245._Fld2247RRef AS goodsRef,
           _AccumReg2245._Fld2248RRef AS characteristicRef,
           CAST(SUM(CASE
                        WHEN _AccumReg2245._RecordKind = 0
                        THEN-_AccumReg2245._Fld2249
                        ELSE _AccumReg2245._Fld2249
                    END) AS NUMERIC(21, 3)) AS Balance
    FROM
         _AccumReg2245 WITH (NOLOCK)
         LEFT OUTER JOIN _Reference39 WITH (NOLOCK)
              ON _AccumReg2245._Fld2246RRef = _Reference39._IDRRef
         LEFT OUTER JOIN _Reference29 WITH (NOLOCK)
              ON _Reference39._Fld540RRef = _Reference29._IDRRef
    WHERE  _AccumReg2245._Period >= DATEADD(DAY, -DATEPART(DAY, CONVERT(DATE, GETDATE())) + 1, DATEADD(MONTH, -1, CONVERT(DATE, GETDATE())))
           AND _AccumReg2245._Period < '3999-11-01 00:00:00'
           AND _AccumReg2245._Active = 0x01
           AND _Reference29._Fld319 = 0x01
           AND _Reference39._Fld538RRef = 0xA6360784943FC3E244C0E625E12D72C0
    GROUP BY
             _AccumReg2245._Fld2246RRef,
             _AccumReg2245._Fld2247RRef,
             _AccumReg2245._Fld2248RRef
    HAVING CAST(SUM(CASE
                        WHEN _AccumReg2245._RecordKind = 0
                        THEN-_AccumReg2245._Fld2249
                        ELSE _AccumReg2245._Fld2249
                    END) AS NUMERIC(21, 3)) <> 0
) TT_AccumRegTotals2250
GROUP BY
         TT_AccumRegTotals2250.warehouseRef,
         TT_AccumRegTotals2250.goodsRef,
         TT_AccumRegTotals2250.characteristicRef
HAVING CAST(SUM(TT_AccumRegTotals2250.Balance) AS NUMERIC(28, 3)) <> 0

ORDER BY
         warehouseRef,
         goodsRef,
         characteristicRef,
         _Period,
         _RecType

;

SELECT 
	_Reference39._Fld540RRef AS storeRef,
	#TT_TurnoverRests.goodsRef AS goodsRef,
	#TT_TurnoverRests.characteristicRef AS characteristicRef,
	#CalendarDates.CalendarDate AS CalendarDate,
	CAST(SUM(CASE 
				WHEN #TT_TurnoverRests._Period = DATEADD(DAY, -DATEPART(DAY, CONVERT(DATE, GETDATE())) + 1, DATEADD(MONTH, -1, CONVERT(DATE, GETDATE())))
					THEN #TT_TurnoverRests.Balance
				ELSE CASE 
						WHEN #TT_TurnoverRests._Period < #CalendarDates.CalendarDate
							THEN #TT_TurnoverRests.Turnover
						ELSE 0
						END
				END) AS NUMERIC(27, 3)) AS f_2

FROM #CalendarDates 

LEFT OUTER JOIN #TT_TurnoverRests
	ON #TT_TurnoverRests._Period <= #CalendarDates.CalendarDate

LEFT OUTER JOIN _Reference39 WITH (NOLOCK)
	ON #TT_TurnoverRests.warehouseRef = _Reference39._IDRRef

GROUP BY _Reference39._Fld540RRef,
	#TT_TurnoverRests.goodsRef,
	#TT_TurnoverRests.characteristicRef,
	#CalendarDates.CalendarDate

ORDER BY 
	_Reference39._Fld540RRef,
	#TT_TurnoverRests.goodsRef,
	#TT_TurnoverRests.characteristicRef,
	#CalendarDates.CalendarDate

;

DROP TABLE #CalendarDates;
GO

DROP TABLE #TT_TurnoverRests;
GO
