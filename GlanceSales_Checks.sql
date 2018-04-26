SELECT TOP 1000
       Warehouses._Fld540RRef AS storeRef,
       Warehouses._Fld539RRef AS OrgRef,
       DATEADD(DAY, DATEPART(DAY, _AccumReg2210._Period) - 1, DATEADD(MONTH, DATEPART(MONTH, _AccumReg2210._Period) - 1, DATEADD(YEAR, DATEPART(YEAR, _AccumReg2210._Period) - 2000, '2000-01-01 00:00:00'))) AS Period,
       CASE
           WHEN _AccumReg2210._Fld2935RRef = 0xA31287B97BA949794195482AF5A0D6D5 --AND _AccumReg2210._RecorderTRef = 0x00000046
           THEN DATEADD(DAY, DATEPART(DAY, _AccumReg2210._Period) - 1, DATEADD(MONTH, DATEPART(MONTH, _AccumReg2210._Period) - 1, DATEADD(YEAR, DATEPART(YEAR, _AccumReg2210._Period) - 2000, '2000-01-01 23:59:59')))
           WHEN _Document70._IDRRef IS NULL
           THEN DATEADD(DAY, DATEPART(DAY, _AccumReg2210._Period) - 1, DATEADD(MONTH, DATEPART(MONTH, _AccumReg2210._Period) - 1, DATEADD(YEAR, DATEPART(YEAR, _AccumReg2210._Period) - 2000, '2000-01-01 23:59:59')))
           ELSE DATEADD(DAY, DATEPART(DAY, _Document70._Date_Time) - 1, DATEADD(MONTH, DATEPART(MONTH, _Document70._Date_Time) - 1, DATEADD(YEAR, DATEPART(YEAR, _Document70._Date_Time) - 2000, '2000-01-01 23:59:59')))
       END AS SalesDate,
       CASE
           WHEN _AccumReg2210._Fld2935RRef = 0xA31287B97BA949794195482AF5A0D6D5
           THEN CAST('Продажа' AS NVARCHAR(9))
           ELSE CAST('Возврат' AS NVARCHAR(9))
       END AS OperationType,
       _AccumReg2210._Fld2212RRef AS goodsRef,
       _AccumReg2210._Fld2213RRef AS characteristicRef,
       CAST(SUM(_AccumReg2210._Fld2216) AS NUMERIC(18, 0)) AS Quantity,
       CASE
           WHEN SUM(_AccumReg2210._Fld2218) = 0
           THEN 0
           ELSE CAST(CAST(100 AS NUMERIC(3, 0)) - CAST(CAST(100 AS NUMERIC(3, 0)) AS NUMERIC(11, 8)) * CAST(SUM(_AccumReg2210._Fld2217) AS NUMERIC(21, 2)) / CAST(SUM(_AccumReg2210._Fld2218) AS NUMERIC(21, 2)) AS NUMERIC(3, 0))
       END AS DiscountPercent,
       CAST(SUM(_AccumReg2210._Fld2217) AS NUMERIC(21, 2)) AS SumTotal
--INTO
--     #Sales
FROM
     _AccumReg2210 _AccumReg2210 WITH (NOLOCK)
     LEFT OUTER JOIN _Reference39 Warehouses WITH (NOLOCK)
          ON _AccumReg2210._Fld2211RRef = Warehouses._IDRRef
     LEFT OUTER JOIN _Document70 WITH (NOLOCK)
          ON _AccumReg2210._Fld2214_TYPE = 0x08
             AND _AccumReg2210._Fld2214_RTRef = 0x00000046
             AND _AccumReg2210._Fld2214_RRRef = _Document70._IDRRef
WHERE  _AccumReg2210._Period >= '2017-01-01 00:00:00'
GROUP BY
         Warehouses._Fld540RRef,
         Warehouses._Fld539RRef,
         DATEADD(DAY, DATEPART(DAY, _AccumReg2210._Period) - 1, DATEADD(MONTH, DATEPART(MONTH, _AccumReg2210._Period) - 1, DATEADD(YEAR, DATEPART(YEAR, _AccumReg2210._Period) - 2000, '2000-01-01 00:00:00'))),
         CASE
             WHEN _AccumReg2210._Fld2935RRef = 0xA31287B97BA949794195482AF5A0D6D5 --AND _AccumReg2210._RecorderTRef = 0x00000046
             THEN DATEADD(DAY, DATEPART(DAY, _AccumReg2210._Period) - 1, DATEADD(MONTH, DATEPART(MONTH, _AccumReg2210._Period) - 1, DATEADD(YEAR, DATEPART(YEAR, _AccumReg2210._Period) - 2000, '2000-01-01 23:59:59')))
             WHEN _Document70._IDRRef IS NULL
             THEN DATEADD(DAY, DATEPART(DAY, _AccumReg2210._Period) - 1, DATEADD(MONTH, DATEPART(MONTH, _AccumReg2210._Period) - 1, DATEADD(YEAR, DATEPART(YEAR, _AccumReg2210._Period) - 2000, '2000-01-01 23:59:59')))
             ELSE DATEADD(DAY, DATEPART(DAY, _Document70._Date_Time) - 1, DATEADD(MONTH, DATEPART(MONTH, _Document70._Date_Time) - 1, DATEADD(YEAR, DATEPART(YEAR, _Document70._Date_Time) - 2000, '2000-01-01 23:59:59')))
         END,
         CASE
             WHEN _AccumReg2210._Fld2935RRef = 0xA31287B97BA949794195482AF5A0D6D5
             THEN CAST('Продажа' AS NVARCHAR(9))
             ELSE CAST('Возврат' AS NVARCHAR(9))
         END,
         _AccumReg2210._Fld2212RRef,
         _AccumReg2210._Fld2213RRef

ORDER BY
    storeRef, Period, goodsRef, characteristicRef