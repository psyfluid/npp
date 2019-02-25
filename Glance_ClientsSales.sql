
SELECT DISTINCT
       _AccumReg2222._Fld2224_RRRef AS ClientsRef,
       CASE
           WHEN _AccumReg2222._RecorderTRef = 0x00000046
           THEN _Document70._Fld988RRef
           WHEN _AccumReg2222._RecorderTRef = 0x00000056
           THEN _Document86._Fld1438RRef
           WHEN _AccumReg2222._RecorderTRef = 0x0000004D
           THEN _Document77._Fld1228RRef
           WHEN _AccumReg2222._RecorderTRef = 0x0000003D
           THEN _Document61._Fld801RRef
       END AS storeRef,
       CONVERT(DATE, _AccumReg2222._Period) AS 'ДатаОперации',
       DAY(_AccumReg2222._Period) AS 'ДеньПродажи',
       MONTH(_AccumReg2222._Period) AS 'МесяцПродажи',
       YEAR(_AccumReg2222._Period) AS 'ГодПродажи',
       _AccumReg2222._RecorderRRef AS _RecorderRRef,
       _AccumReg2222._RecorderTRef AS _RecorderTRef,
       SUM(_AccumReg2222._Fld2225) AS ProfitSum
FROM
     dbo._AccumReg2222 _AccumReg2222 -- РегистрНакопления.ПродажиПоДисконтнымКартам (_AccumReg2222)
     LEFT JOIN dbo._Document70 _Document70 -- Документ.ОтчетОРозничныхПродажах (_Document70)
          ON _AccumReg2222._RecorderTRef = 0x00000046
             AND _AccumReg2222._RecorderRRef = _Document70._IDRRef
     LEFT JOIN dbo._Document86 _Document86 -- Документ.ЧекККМ (_Document86) 
          ON _AccumReg2222._RecorderTRef = 0x00000056
             AND _AccumReg2222._RecorderRRef = _Document86._IDRRef
     LEFT JOIN dbo._Document77 _Document77 -- Документ.РеализацияТоваров (_Document77)
          ON _AccumReg2222._RecorderTRef = 0x0000004D
             AND _AccumReg2222._RecorderRRef = _Document77._IDRRef
     LEFT JOIN dbo._Document61 _Document61 -- Документ.ВозвратТоваровОтПокупателя (_Document61)
          ON _AccumReg2222._RecorderTRef = 0x0000003D
             AND _AccumReg2222._RecorderRRef = _Document61._IDRRef
WHERE  _AccumReg2222._Period >= '2017-01-01 00:00:00'
       AND _AccumReg2222._Period < CONVERT(DATE, GETDATE())
GROUP BY
         _AccumReg2222._Fld2224_RRRef,
         CASE
             WHEN _AccumReg2222._RecorderTRef = 0x00000046
             THEN _Document70._Fld988RRef
             WHEN _AccumReg2222._RecorderTRef = 0x00000056
             THEN _Document86._Fld1438RRef
             WHEN _AccumReg2222._RecorderTRef = 0x0000004D
             THEN _Document77._Fld1228RRef
             WHEN _AccumReg2222._RecorderTRef = 0x0000003D
             THEN _Document61._Fld801RRef
         END,
         _AccumReg2222._Period,
         _AccumReg2222._RecorderRRef,
         _AccumReg2222._RecorderTRef
ORDER BY
         'ДатаОперации';