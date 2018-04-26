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

SELECT TOP 1000
       sr.[date] AS date,
       sr.place_uid AS place_uid,
       sr.item_uid AS item_uid,
       ISNULL(sr.size,'') AS size,
       ISNULL(sr.[value],0) AS value
INTO #DrawerRests
FROM
     dbo.ShopRest sr 

WHERE  sr.[date] >= DATEADD(DAY, -DATEPART(DAY,CONVERT(date, GETDATE()))+1 ,DATEADD(MONTH, -1, CONVERT(date, GETDATE())))
	   AND sr.place_uid = 0xAFC87DCCCDF31846454406A5E60F4412 AND sr.item_uid = 0x9324275AA90776894DC9705C34887DEB

UNION ALL

SELECT TOP 1000
       sa.[date],
       sa.place_uid,
       sa.item_uid,
       ISNULL(sa.size,''),
       ISNULL(sa.[value],0)
FROM
     dbo.ShopAdjust sa 

WHERE  sa.[date] >= DATEADD(DAY, -DATEPART(DAY,CONVERT(date, GETDATE()))+1 ,DATEADD(MONTH, -1, CONVERT(date, GETDATE())))
	   AND sa.place_uid = 0xAFC87DCCCDF31846454406A5E60F4412 AND sa.item_uid = 0x9324275AA90776894DC9705C34887DEB

UNION ALL

SELECT TOP 1000
       ss.[date],
       ss.place_uid,
       ss.item_uid,
       ISNULL(ss.size,''),
       ISNULL(ss.[value],0)
FROM
     dbo.ShopSupply ss 

WHERE  ss.[date] >= DATEADD(DAY, -DATEPART(DAY,CONVERT(date, GETDATE()))+1 ,DATEADD(MONTH, -1, CONVERT(date, GETDATE())))
	   AND ss.place_uid = 0xAFC87DCCCDF31846454406A5E60F4412 AND ss.item_uid = 0x9324275AA90776894DC9705C34887DEB

UNION ALL

SELECT TOP 1000
       sti.[date],
       sti.place_uid,
       sti.item_uid,
       ISNULL(sti.size,''),
       ISNULL(sti.[value],0)
FROM
     dbo.ShopTransIn sti 

WHERE  sti.[date] >= DATEADD(DAY, -DATEPART(DAY,CONVERT(date, GETDATE()))+1 ,DATEADD(MONTH, -1, CONVERT(date, GETDATE())))
	   AND sti.place_uid = 0xAFC87DCCCDF31846454406A5E60F4412 AND sti.item_uid = 0x9324275AA90776894DC9705C34887DEB

UNION ALL

SELECT TOP 1000
       ssr.[date],
       ssr.place_uid,
       ssr.item_uid,
       ISNULL(ssr.size,''),
       ISNULL(ssr.[value],0)
FROM
     dbo.ShopSaleReturn ssr 

WHERE  ssr.[date] >= DATEADD(DAY, -DATEPART(DAY,CONVERT(date, GETDATE()))+1 ,DATEADD(MONTH, -1, CONVERT(date, GETDATE())))
	   AND ssr.place_uid = 0xAFC87DCCCDF31846454406A5E60F4412 AND ssr.item_uid = 0x9324275AA90776894DC9705C34887DEB;

SELECT 
    #DrawerRests.date,
    #DrawerRests.place_uid,
    #DrawerRests.item_uid,
    #DrawerRests.size,
    SUM(#DrawerRests.value) AS value
FROM #DrawerRests
GROUP BY
    #DrawerRests.date,
    #DrawerRests.place_uid,
    #DrawerRests.item_uid,
    #DrawerRests.size

DROP TABLE #DrawerRests;
GO
