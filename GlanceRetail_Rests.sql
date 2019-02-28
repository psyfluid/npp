
SELECT
       CAST(2 AS NUMERIC(1, 0)) AS _RecType,
       CONVERT(DATE, _AccumReg2245._Period) AS _Period,
       _AccumReg2245._Fld2246RRef AS f_4,
       _AccumReg2245._Fld2247RRef AS f_5,
       _AccumReg2245._Fld2248RRef AS f_6,
       0 AS _Fld2249Balance,
       CAST(SUM(CASE
                    WHEN _AccumReg2245._RecordKind = 0
                    THEN _AccumReg2245._Fld2249
                    ELSE-_AccumReg2245._Fld2249
                END) AS NUMERIC(21, 3)) AS _Fld2249Turnover,
       CAST(SUM(CASE
                    WHEN _AccumReg2245._RecordKind = 0
                    THEN _AccumReg2245._Fld2249
                    ELSE 0
                END) AS NUMERIC(21, 3)) AS _Fld2249Receipt,
       CAST(SUM(CASE
                    WHEN _AccumReg2245._RecordKind = 0
                    THEN 0
                    ELSE _AccumReg2245._Fld2249
                END) AS NUMERIC(21, 3)) AS _Fld2249Expense
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
       #V8TblAli1_T._Fld2246RRef AS f_7,
       #V8TblAli1_T._Fld2247RRef AS f_8,
       #V8TblAli1_T._Fld2248RRef AS f_9,
       CAST(SUM(#V8TblAli1_T._Fld2249Balance) AS NUMERIC(28, 3)) AS _Fld2249Balance,
       CAST(CAST(SUM(#V8TblAli1_T._Fld2249Turnover) AS NUMERIC(14, 0)) AS NUMERIC(22, 3)) AS _Fld2249Turnover,
       CAST(CAST(SUM(#V8TblAli1_T._Fld2249Receipt) AS NUMERIC(14, 0)) AS NUMERIC(22, 3)) AS _Fld2249Receipt,
       CAST(CAST(SUM(#V8TblAli1_T._Fld2249Expense) AS NUMERIC(14, 0)) AS NUMERIC(22, 3)) AS _Fld2249Expense
FROM
(
    SELECT
           _AccumRegTotals2250._Fld2246RRef AS _Fld2246RRef,
           _AccumRegTotals2250._Fld2247RRef AS _Fld2247RRef,
           _AccumRegTotals2250._Fld2248RRef AS _Fld2248RRef,
           CAST(_AccumRegTotals2250._Fld2249 AS NUMERIC(22, 3)) AS _Fld2249Balance,
           0 AS _Fld2249Turnover,
           0 AS _Fld2249Receipt,
           0 AS _Fld2249Expense
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
           _AccumReg2245._Fld2246RRef AS _Fld2246RRef,
           _AccumReg2245._Fld2247RRef AS _Fld2247RRef,
           _AccumReg2245._Fld2248RRef AS _Fld2248RRef,
           CAST(SUM(CASE
                        WHEN _AccumReg2245._RecordKind = 0
                        THEN-_AccumReg2245._Fld2249
                        ELSE _AccumReg2245._Fld2249
                    END) AS NUMERIC(21, 3)) AS _Fld2249Balance,
           0 AS _Fld2249Turnover,
           0 AS _Fld2249Receipt,
           0 AS _Fld2249Expense
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
) #V8TblAli1_T
GROUP BY
         #V8TblAli1_T._Fld2246RRef,
         #V8TblAli1_T._Fld2247RRef,
         #V8TblAli1_T._Fld2248RRef
HAVING CAST(SUM(#V8TblAli1_T._Fld2249Balance) AS NUMERIC(28, 3)) <> 0
       OR CAST(SUM(#V8TblAli1_T._Fld2249Turnover) AS NUMERIC(14, 0)) <> 0
       OR CAST(SUM(#V8TblAli1_T._Fld2249Receipt) AS NUMERIC(14, 0)) <> 0
       OR CAST(SUM(#V8TblAli1_T._Fld2249Expense) AS NUMERIC(14, 0)) <> 0
ORDER BY
         f_4,
         f_5,
         f_6,
         _Period,
         _RecType;
