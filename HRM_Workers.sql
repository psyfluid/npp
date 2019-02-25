IF EXISTS
(
    SELECT
           *
    FROM
         tempdb..sysobjects
    WHERE  id = OBJECT_ID('tempdb..#WorkersPeriods')
           AND xtype = 'U'
)
    DROP TABLE #WorkersPeriods;
GO


SELECT
       MIN(_InfoRg5838._Period) AS minPeriod,
	   MAX(_InfoRg5838._Period) AS maxPeriod,
       _InfoRg5838._Fld5839RRef AS personID
INTO
     #WorkersPeriods
FROM
     _InfoRg5838 -- РегистрСведений.Работники (_InfoRg5838)
	 
WHERE
	dbo._InfoRg5838._Fld5839RRef = 0x9a56005056914daa11e754d5a9cb2630;


SELECT
       _InfoRg5838._Active AS "Активность",
       _InfoRg5838._Fld5843RRef AS "ГрафикРаботы",
       _InfoRg5838._Fld5841RRef AS "Должность",
       _InfoRg5838._Fld12471RRef AS "ДолжностьУпр",
       _InfoRg5838._Fld12470RRef AS "ДолжностьШР",
       _InfoRg5838._Fld5842 AS "ЗанимаемыхСтавок",
       _InfoRg5838._LineNo AS "НомерСтроки",
       _InfoRg5838._Period AS "Период",
       _InfoRg5838._Fld5840RRef AS "Подразделение",
       _InfoRg5838._Fld5846RRef AS "ПричинаИзмененияСостояния",
       _InfoRg5838._Fld5847RRef AS "ПричинаУвольнения",
       _InfoRg5838._RecorderTRef AS "Регистратор",
       _InfoRg5838._RecorderRRef AS "Регистратор",
       _InfoRg5838._Fld5839RRef AS "ФизЛицо"
FROM
     _InfoRg5838 -- РегистрСведений.Работники (_InfoRg5838)
	 
WHERE
	dbo._InfoRg5838._Fld5839RRef = 0x9a56005056914daa11e754d5a9cb2630;




DROP TABLE #WorkersPeriods;
GO
