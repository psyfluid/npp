

IF EXISTS
(
    SELECT
           *
    FROM
         tempdb..sysobjects
    WHERE  id = OBJECT_ID('tempdb..#DrawerRests')
           AND xtype = 'U'
)
    DROP TABLE #DrawerRests;
GO

DECLARE @beginDate DATE= DATEADD(DAY, -5, GETDATE());

SELECT
       sr.[date] AS date,
       sr.place_uid AS place_uid,
       sr.item_uid AS item_uid,
       ISNULL(sr.size, 0) AS size,
       ISNULL(sr.[value], 0) AS value
INTO
     #DrawerRests
FROM
     drawer.dbo.ShopRest sr
WHERE   sr.[date] >= @beginDate
UNION ALL
SELECT
       sa.[date],
       sa.place_uid,
       sa.item_uid,
       ISNULL(sa.size, 0),
       ISNULL(sa.[value], 0)
FROM
     drawer.dbo.ShopAdjust sa
WHERE   sa.[date] >= @beginDate
UNION ALL
SELECT
       ss.[date],
       ss.place_uid,
       ss.item_uid,
       ISNULL(ss.size, 0),
       ISNULL(ss.[value], 0)
FROM
     drawer.dbo.ShopSupply ss
WHERE   ss.[date] >= @beginDate
UNION ALL
SELECT
       sti.[date],
       sti.place_uid,
       sti.item_uid,
       ISNULL(sti.size, 0),
       ISNULL(sti.[value], 0)
FROM
     drawer.dbo.ShopTransIn sti
WHERE   sti.[date] >= @beginDate
UNION ALL
SELECT
       ssr.[date],
       ssr.place_uid,
       ssr.item_uid,
       ISNULL(ssr.size, 0),
       ISNULL(ssr.[value], 0)
FROM
     drawer.dbo.ShopSaleReturn ssr
WHERE  ssr.[date] >= @beginDate;

SELECT
       #DrawerRests.date,
       #DrawerRests.place_uid,
       #DrawerRests.item_uid,
       #DrawerRests.size,
       SUM(#DrawerRests.value) AS value
FROM
     #DrawerRests
GROUP BY
         #DrawerRests.date,
         #DrawerRests.place_uid,
         #DrawerRests.item_uid,
         #DrawerRests.size;

DROP TABLE #DrawerRests;
GO
