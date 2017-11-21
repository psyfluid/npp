

IF EXISTS
(
    SELECT
           *
    FROM
         tempdb..sysobjects
    WHERE  id = OBJECT_ID('tempdb..#StoreDates')
           AND xtype = 'U'
)
    DROP TABLE #StoreDates;
GO

SELECT
       sr.place_uid,
       MAX(sr.[date]) AS maxDate
INTO
     #StoreDates
FROM
     drawer.dbo.StoreRest sr
GROUP BY
         sr.place_uid;

SELECT TOP 1000
       sd.place_uid,
       s.code,
       s.name,
       sd.maxDate,
       sr.item_uid,
       ISNULL(sr.size, 0) AS size,
       ISNULL(sr.[value], 0) AS value
FROM
     #StoreDates sd
     LEFT JOIN drawer.dbo.StoreRest sr
          ON sd.place_uid = sr.place_uid
             AND sd.maxDate = sr.[date]
     LEFT JOIN matrix.dbo.stores s
          ON sd.place_uid = s.uid
WHERE  s.uid IS NOT NULL
ORDER BY
         s.code;

DROP TABLE #StoreDates;
GO
