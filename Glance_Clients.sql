
SELECT
       Clients._IDRRef AS ClientsRef,
       Clients._ParentIDRRef AS ClientsParent,
       Clients._Description AS "Clients_Наименование",
       Clients._Fld280 AS "Clients_НаименованиеПолное",
       Clients._Fld288RRef AS Clients_RegStoreRef,
       Clients._Fld292 AS "Clients_МагазинРегистрации",
       Clients._Fld302 AS "Clients_МагазинТекРегистрации",
       Clients._Fld291 AS "Clients_Консультант",
       Clients._Fld290 AS "Clients_ДатаРегистрации",
       DAY(Clients._Fld290) AS Clients_RegDay,
       MONTH(Clients._Fld290) AS Clients_RegMonth,
       YEAR(Clients._Fld290) AS Clients_RegYear,
       Clients._Fld287 AS "Clients_ДатаРождения",
       Clients._Fld295 AS "Clients_ГодРождения",
       Clients._Fld294 AS "Clients_МесяцРождения",
       Clients._Fld293 AS "Clients_ДеньРождения",
       Clients._Fld3185RRef AS "Clients_ГруппаПолучателейСкидкиRef",
       Clients._Fld278 AS "Clients_Комментарий",
       Clients._Fld296RRef AS "Clients_ПолнотнаяГруппаПлечеваяRef",
       Clients._Fld298RRef AS "Clients_ПолнотнаяГруппаПояснаяRef",
       Clients._Fld297RRef AS "Clients_РазмернаяГруппаПлечеваяRef",
       Clients._Fld299RRef AS "Clients_РазмернаяГруппаПояснаяRef",
       Clients._Fld300RRef AS "Clients_РостRef",
       Clients._Fld301RRef AS "Clients_ТипФигурыRef",
       Clients._Fld289 AS "Clients_ЭтоРозничныйПокупатель",
       Clients._Fld281RRef AS "Clients_ЮрФизЛицоRef"
FROM
     _Reference28 AS Clients -- Справочник.Контрагенты (_Reference28)
WHERE  Clients._Marked = 0x00
       AND Clients._Folder = 0x01;