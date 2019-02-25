

SELECT TOP 100
	   Checks._Fld1438RRef AS storeRef,
       Warehouses._Fld539RRef AS OrgRef,
       DATEADD(DAY, DATEPART(DAY, Checks._Date_Time) - 1, DATEADD(MONTH, DATEPART(MONTH, Checks._Date_Time) - 1, DATEADD(YEAR, DATEPART(YEAR, Checks._Date_Time) - 2000, '2000-01-01 00:00:00'))) AS Period,
       CASE
           WHEN Checks._Fld1429RRef = 0xA4FEEDD07DA60D484EE48B6C4BE07A6A
           THEN DATEADD(DAY, DATEPART(DAY, Checks._Date_Time) - 1, DATEADD(MONTH, DATEPART(MONTH, Checks._Date_Time) - 1, DATEADD(YEAR, DATEPART(YEAR, Checks._Date_Time) - 2000, '2000-01-01 23:59:59')))
           ELSE DATEADD(DAY, DATEPART(DAY, ChecksSale._Date_Time) - 1, DATEADD(MONTH, DATEPART(MONTH, ChecksSale._Date_Time) - 1, DATEADD(YEAR, DATEPART(YEAR, ChecksSale._Date_Time) - 2000, '2000-01-01 23:59:59')))
       END AS SalesDate,
       CASE
           WHEN Checks._Fld1429RRef = 0xA4FEEDD07DA60D484EE48B6C4BE07A6A
           THEN CAST('Продажа' AS NVARCHAR(9))
           ELSE CAST('Возврат' AS NVARCHAR(9))
       END AS OperationType,
       ChecksGoods._Fld1450RRef AS goodsRef,
       ChecksGoods._Fld1451RRef AS characteristicRef,
       CAST(SUM(ChecksGoods._Fld1454) AS NUMERIC(18, 0)) AS Quantity,
       CASE
           WHEN SUM(ChecksGoods._Fld1455) = 0
           THEN 0
           ELSE CAST(CAST(100 AS NUMERIC(3, 0)) - CAST(CAST(100 AS NUMERIC(3, 0)) AS NUMERIC(11, 8)) * CAST(SUM(ChecksGoods._Fld1456) AS NUMERIC(21, 2)) / CAST(SUM(ChecksGoods._Fld1454 * ChecksGoods._Fld1455) AS NUMERIC(21, 2)) AS NUMERIC(3, 0))
       END AS DiscountPercent,
       CAST(SUM(ChecksGoods._Fld1456) AS NUMERIC(21, 2)) AS SumTotal
--INTO
--     #Sales
FROM
     _Document86_VT1448 ChecksGoods WITH (NOLOCK)
     INNER JOIN _Document86 Checks WITH (NOLOCK)
          ON ChecksGoods._Document86_IDRRef = Checks._IDRRef
             AND Checks._Date_Time >= '2017-01-01 00:00:00'
             AND Checks._Marked = 0x00
             AND (Checks._Fld1442RRef = 0x89F57AF1607D02E348AA4420D45671C8
                  OR Checks._Fld1442RRef = 0xA5BC0794150D43594A2DACE5EDBD2DDA)
     LEFT OUTER JOIN _Document86 ChecksSale WITH (NOLOCK)
          ON Checks._Fld1439RRef = ChecksSale._IDRRef
     LEFT OUTER JOIN _Reference29 Stores WITH (NOLOCK)
          ON Checks._Fld1438RRef = Stores._IDRRef
     LEFT OUTER JOIN _Reference39 Warehouses WITH (NOLOCK)
          ON Stores._Fld310RRef = Warehouses._IDRRef
GROUP BY
         Checks._Fld1438RRef,
         Warehouses._Fld539RRef,
         DATEADD(DAY, DATEPART(DAY, Checks._Date_Time) - 1, DATEADD(MONTH, DATEPART(MONTH, Checks._Date_Time) - 1, DATEADD(YEAR, DATEPART(YEAR, Checks._Date_Time) - 2000, '2000-01-01 00:00:00'))),
         CASE
             WHEN Checks._Fld1429RRef = 0xA4FEEDD07DA60D484EE48B6C4BE07A6A
             THEN DATEADD(DAY, DATEPART(DAY, Checks._Date_Time) - 1, DATEADD(MONTH, DATEPART(MONTH, Checks._Date_Time) - 1, DATEADD(YEAR, DATEPART(YEAR, Checks._Date_Time) - 2000, '2000-01-01 23:59:59')))
             ELSE DATEADD(DAY, DATEPART(DAY, ChecksSale._Date_Time) - 1, DATEADD(MONTH, DATEPART(MONTH, ChecksSale._Date_Time) - 1, DATEADD(YEAR, DATEPART(YEAR, ChecksSale._Date_Time) - 2000, '2000-01-01 23:59:59')))
         END,
         CASE
             WHEN Checks._Fld1429RRef = 0xA4FEEDD07DA60D484EE48B6C4BE07A6A
             THEN CAST('Продажа' AS NVARCHAR(9))
             ELSE CAST('Возврат' AS NVARCHAR(9))
         END,
         ChecksGoods._Fld1450RRef,
         ChecksGoods._Fld1451RRef
ORDER BY
         storeRef,
         Period,
         goodsRef,
         characteristicRef;