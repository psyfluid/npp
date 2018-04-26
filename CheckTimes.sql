
SELECT
       _Reference29._Code AS "Магазин",
       CAST(_Document86._Date_Time AS DATE) AS "Дата",
       _Reference46._Description AS "ФИО",
       _Reference46._Fld2952 AS "УИДЗУП",
       MIN(CAST(_Document86._Date_Time AS TIME)) AS minTime,
       MAX(CAST(_Document86._Date_Time AS TIME)) AS maxTime
FROM
     _Document86 -- Документ.ЧекККМ (_Document86)
     INNER JOIN _Reference29
          ON _Document86._Fld1438RRef = _Reference29._IDRRef -- Справочник.Магазины (_Reference29)
     LEFT JOIN _Reference46
          ON _Document86._Fld1441RRef = _Reference46._IDRRef -- Справочник.ФизическиеЛица (_Reference46)
WHERE  _Document86._Posted = 0x01
       AND _Document86._Date_Time >= '2017-12-01'
       AND _Reference29._Fld319 = 0x01
GROUP BY
         _Reference29._Code,
         CAST(_Document86._Date_Time AS DATE),
         _Reference46._Description,
         _Reference46._Fld2952;
