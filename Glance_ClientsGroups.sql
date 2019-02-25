

SELECT
       ClientsGroups._IDRRef AS "Ссылка",
       ClientsGroups._ParentIDRRef AS "Родитель",
       ClientsGroups._Description AS "Наименование"
FROM
     _Reference28 AS ClientsGroups -- Справочник.Контрагенты (_Reference28)
WHERE  ClientsGroups._Marked = 0x00
       AND ClientsGroups._Folder = 0x00;