
SELECT
       Clients._IDRRef AS "Ссылка",
       Clients._ParentIDRRef AS "Родитель",
       Clients._Description AS "Наименование",
       Clients._Fld280 AS "НаименованиеПолное",
       Clients._Fld288RRef AS RegStoreRef,
       Clients._Fld292 AS "МагазинРегистрации",
       Clients._Fld302 AS "МагазинТекРегистрации",
       Clients._Fld291 AS "Консультант",
       Clients._Fld290 AS "ДатаРегистрации",
       DAY(Clients._Fld290) AS RegDay,
       MONTH(Clients._Fld290) AS RegMonth,
       YEAR(Clients._Fld290) AS RegYear,
       Clients._Fld287 AS "ДатаРождения",
       Clients._Fld295 AS "ГодРождения",
       Clients._Fld294 AS "МесяцРождения",
       Clients._Fld293 AS "ДеньРождения",
       Clients._Fld3185RRef AS "ГруппаПолучателейСкидки",
       Clients._Fld278 AS "Комментарий",
       Clients._Fld2479 AS "ПолучатьСмс",
       Clients._Fld296RRef AS "ПолнотнаяГруппаПлечевая",
       Clients._Fld298RRef AS "ПолнотнаяГруппаПоясная",
       Clients._Fld297RRef AS "РазмернаяГруппаПлечевая",
       Clients._Fld299RRef AS "РазмернаяГруппаПоясная",
       Clients._Fld300RRef AS "Рост",
       Clients._Fld301RRef AS "ТипФигуры",
       Clients._Folder AS "ЭтоГруппа",
       Clients._Fld289 AS "ЭтоРозничныйПокупатель",
       Clients._Fld281RRef AS "ЮрФизЛицо"
FROM
     _Reference28 AS Clients -- Справочник.Контрагенты (_Reference28)
WHERE  Clients._Marked = 0x00
       AND Clients._Folder = 0x01;