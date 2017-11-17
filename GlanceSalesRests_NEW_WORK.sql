// IF EXISTS(select* from tempdb..sysobjects where id=OBJECT_ID('tempdb..#Sales')and xtype='U') DROP TABLE #Sales
// GO
// IF EXISTS(select* from tempdb..sysobjects where id=OBJECT_ID('tempdb..#SalesPriceDates')and xtype='U') DROP TABLE #SalesPriceDates
// GO
// IF EXISTS(select* from tempdb..sysobjects where id=OBJECT_ID('tempdb..#Rests')and xtype='U') DROP TABLE #Rests
// GO
// IF EXISTS(select* from tempdb..sysobjects where id=OBJECT_ID('tempdb..#SalesRests')and xtype='U') DROP TABLE #SalesRests
// GO
// IF EXISTS(select* from tempdb..sysobjects where id=OBJECT_ID('tempdb..#ReceiptDates')and xtype='U') DROP TABLE #ReceiptDates
// GO

SQL
SELECT 
// TOP 100
	Warehouses._Fld540RRef AS storeRef,
	Warehouses._Fld539RRef AS OrgRef,
	DATEADD(DAY, DATEPART(DAY, _AccumReg2210._Period) - 1, DATEADD(MONTH, DATEPART(MONTH, _AccumReg2210._Period) - 1, DATEADD(YEAR, DATEPART(YEAR, _AccumReg2210._Period) - 2000, '2000-01-01 00:00:00'))) AS Period,
	CASE 
		WHEN _AccumReg2210._Fld2935RRef = 0xA31287B97BA949794195482AF5A0D6D5 --AND _AccumReg2210._RecorderTRef = 0x00000046
			THEN DATEADD(DAY, DATEPART(DAY, _AccumReg2210._Period) - 1, DATEADD(MONTH, DATEPART(MONTH, _AccumReg2210._Period) - 1, DATEADD(YEAR, DATEPART(YEAR, _AccumReg2210._Period) - 2000, '2000-01-01 23:59:59')))
		WHEN _Document70._IDRRef IS NULL
			THEN DATEADD(DAY, DATEPART(DAY, _AccumReg2210._Period) - 1, DATEADD(MONTH, DATEPART(MONTH, _AccumReg2210._Period) - 1, DATEADD(YEAR, DATEPART(YEAR, _AccumReg2210._Period) - 2000, '2000-01-01 23:59:59')))
		ELSE DATEADD(DAY, DATEPART(DAY, _Document70._Date_Time) - 1, DATEADD(MONTH, DATEPART(MONTH, _Document70._Date_Time) - 1, DATEADD(YEAR, DATEPART(YEAR, _Document70._Date_Time) - 2000, '2000-01-01 23:59:59')))
		END AS SalesDate,
	CASE 
		WHEN _AccumReg2210._Fld2935RRef = 0xA31287B97BA949794195482AF5A0D6D5
			THEN CAST('Продажа' AS nvarchar(9))
		ELSE CAST('Возврат' AS nvarchar(9))
		END AS OperationType,
	_AccumReg2210._Fld2212RRef AS goodsRef,
	_AccumReg2210._Fld2213RRef AS characteristicRef,
	CAST(SUM(_AccumReg2210._Fld2216) AS NUMERIC(18, 0)) AS Quantity,
	CASE 
		WHEN SUM(_AccumReg2210._Fld2218) = 0
			THEN 0
		ELSE CAST(CAST(100 AS NUMERIC(3, 0)) - CAST(CAST(100 AS NUMERIC(3, 0)) AS NUMERIC(11, 8)) * CAST(SUM(_AccumReg2210._Fld2217) AS NUMERIC(21, 2)) / CAST(SUM(_AccumReg2210._Fld2218) AS NUMERIC(21, 2)) AS NUMERIC(3, 0))
		END AS DiscountPercent,
	CAST(SUM(_AccumReg2210._Fld2217) AS NUMERIC(21, 2)) AS SumTotal

INTO #Sales

FROM _AccumReg2210 _AccumReg2210 WITH (NOLOCK)

LEFT OUTER JOIN _Reference39 Warehouses WITH (NOLOCK)
	ON _AccumReg2210._Fld2211RRef = Warehouses._IDRRef

LEFT OUTER JOIN _Document70 WITH (NOLOCK)
	ON _AccumReg2210._Fld2214_TYPE = 0x08
		AND _AccumReg2210._Fld2214_RTRef = 0x00000046
		AND _AccumReg2210._Fld2214_RRRef = _Document70._IDRRef

WHERE 
	_AccumReg2210._Period >= '2017-01-01 00:00:00'

GROUP BY 
	Warehouses._Fld540RRef,
	Warehouses._Fld539RRef,
	DATEADD(DAY, DATEPART(DAY, _AccumReg2210._Period) - 1, DATEADD(MONTH, DATEPART(MONTH, _AccumReg2210._Period) - 1, DATEADD(YEAR, DATEPART(YEAR, _AccumReg2210._Period) - 2000, '2000-01-01 00:00:00'))),
	CASE 
		WHEN _AccumReg2210._Fld2935RRef = 0xA31287B97BA949794195482AF5A0D6D5 --AND _AccumReg2210._RecorderTRef = 0x00000046
			THEN DATEADD(DAY, DATEPART(DAY, _AccumReg2210._Period) - 1, DATEADD(MONTH, DATEPART(MONTH, _AccumReg2210._Period) - 1, DATEADD(YEAR, DATEPART(YEAR, _AccumReg2210._Period) - 2000, '2000-01-01 23:59:59')))
		WHEN _Document70._IDRRef IS NULL
			THEN DATEADD(DAY, DATEPART(DAY, _AccumReg2210._Period) - 1, DATEADD(MONTH, DATEPART(MONTH, _AccumReg2210._Period) - 1, DATEADD(YEAR, DATEPART(YEAR, _AccumReg2210._Period) - 2000, '2000-01-01 23:59:59')))
		ELSE DATEADD(DAY, DATEPART(DAY, _Document70._Date_Time) - 1, DATEADD(MONTH, DATEPART(MONTH, _Document70._Date_Time) - 1, DATEADD(YEAR, DATEPART(YEAR, _Document70._Date_Time) - 2000, '2000-01-01 23:59:59')))
		END,
	CASE 
		WHEN _AccumReg2210._Fld2935RRef = 0xA31287B97BA949794195482AF5A0D6D5
			THEN CAST('Продажа' AS nvarchar(9))
		ELSE CAST('Возврат' AS nvarchar(9))
		END,
	_AccumReg2210._Fld2212RRef,
	_AccumReg2210._Fld2213RRef
	
;

SQL
SELECT 
	#Sales.storeRef AS storeRef,
	#Sales.OrgRef AS OrgRef,
	CONVERT(NVARCHAR(12), #Sales.Period, 104) AS Period,
	DATEPART(week, #Sales.Period) AS Week,
	Day(#Sales.Period) AS Day,
	Month(#Sales.Period) AS Month,
	Year(#Sales.Period) AS Year,
	#Sales.SalesDate AS SalesDate,
	#Sales.OperationType AS OperationType,
	#Sales.goodsRef AS goodsRef,
	#Sales.characteristicRef AS characteristicRef,
	#Sales.Quantity AS Quantity,
	#Sales.DiscountPercent AS DiscountPercent,
	#Sales.SumTotal AS SumTotal,
	MAX(Prices._Period) AS MaxPricePeriod,
	MAX(PurchasePrices._Period) AS MaxPurchasePricePeriod,
	MAX(PurchasePricesGC._Period) AS MaxPurchasePriceGCPeriod

INTO #SalesPriceDates

FROM #Sales WITH (NOLOCK)

LEFT OUTER JOIN _Reference29 WITH (NOLOCK)
	ON #Sales.storeRef = _Reference29._IDRRef

LEFT OUTER JOIN _InfoReg1912 Prices WITH (NOLOCK)
	ON #Sales.storeRef = Prices._Fld1915RRef
		AND #Sales.goodsRef = Prices._Fld1913RRef
		AND #Sales.characteristicRef = Prices._Fld1914RRef
		AND #Sales.SalesDate >= Prices._Period

LEFT OUTER JOIN _InfoReg1902 PurchasePrices WITH (NOLOCK)
	ON _Reference29._Fld316RRef = PurchasePrices._Fld1905RRef
		AND #Sales.goodsRef = PurchasePrices._Fld1903RRef
		AND #Sales.characteristicRef = PurchasePrices._Fld1904RRef
		AND #Sales.SalesDate >= PurchasePrices._Period

LEFT OUTER JOIN _InfoReg1902 PurchasePricesGC WITH (NOLOCK)
	ON PurchasePricesGC._Fld1905RRef = 0xA54400505691473211E6D67555773573
		AND #Sales.goodsRef = PurchasePricesGC._Fld1903RRef
		AND #Sales.characteristicRef = PurchasePricesGC._Fld1904RRef
		AND #Sales.SalesDate >= PurchasePricesGC._Period

GROUP BY 
	#Sales.storeRef,
	#Sales.OrgRef,
	#Sales.Period,
	#Sales.SalesDate,
	#Sales.OperationType,
	#Sales.goodsRef,
	#Sales.characteristicRef,
	#Sales.Quantity,
	#Sales.DiscountPercent,
	#Sales.SumTotal
	
;

SQL
SELECT
	Rests.storeRef AS storeRef,
	Rests.goodsRef AS goodsRef,
	Rests.characteristicRef AS characteristicRef,
	Rests.amount AS amountRests,
	MAX(Prices._Period) AS MaxPriceRests
INTO #Rests

FROM (
	SELECT 
		Warehouses._Fld540RRef AS storeRef,
		RestsUnfolded.goodsRef AS goodsRef,
		RestsUnfolded.characteristicRef AS characteristicRef,
		CAST(SUM(RestsUnfolded.amount) AS NUMERIC(15, 0)) AS amount
	
	FROM (
		SELECT _AccumRegTotals2250._Fld2248RRef AS characteristicRef,
			_AccumRegTotals2250._Fld2247RRef AS goodsRef,
			_AccumRegTotals2250._Fld2246RRef AS warehouseRef,
			CAST(_AccumRegTotals2250._Fld2249 AS NUMERIC(15, 0)) AS amount
		
		FROM _AccumRegTotals2250 WITH (NOLOCK)
		WHERE _AccumRegTotals2250._Fld2249 <> 0
		) RestsUnfolded
		LEFT OUTER JOIN _Reference39 AS Warehouses WITH (NOLOCK)
			ON RestsUnfolded.warehouseRef = Warehouses._IDRRef
	
	GROUP BY 
		Warehouses._Fld540RRef,
		RestsUnfolded.goodsRef,
		RestsUnfolded.characteristicRef
	
	HAVING CAST(SUM(RestsUnfolded.amount) AS NUMERIC(15, 0)) > 0
	) Rests

LEFT OUTER JOIN _InfoReg1912 Prices WITH (NOLOCK)
	ON Rests.storeRef = Prices._Fld1915RRef
		AND Rests.goodsRef = Prices._Fld1913RRef
		AND Rests.characteristicRef = Prices._Fld1914RRef
		AND GETDATE() >= Prices._Period
	
GROUP BY 
	Rests.storeRef,
	Rests.goodsRef,
	Rests.characteristicRef,
	Rests.amount

;	

SQL
SELECT 
	ISNULL(#SalesPriceDates.storeRef, #Rests.storeRef) AS storeRef,
	ISNULL(#SalesPriceDates.goodsRef, #Rests.goodsRef) AS goodsRef,
	ISNULL(#SalesPriceDates.characteristicRef, #Rests.characteristicRef) AS characteristicRef,
	#SalesPriceDates.Period,
	#SalesPriceDates.Week,
	#SalesPriceDates.Day,
	#SalesPriceDates.Month,
	#SalesPriceDates.Year,
	#SalesPriceDates.SalesDate,
	#SalesPriceDates.OperationType,
	#SalesPriceDates.Quantity,
	#SalesPriceDates.DiscountPercent,
	#SalesPriceDates.SumTotal,
	#SalesPriceDates.OrgRef,
	#SalesPriceDates.MaxPricePeriod,
	#SalesPriceDates.MaxPurchasePricePeriod,
	#SalesPriceDates.MaxPurchasePriceGCPeriod,
	#Rests.amountRests,
	#Rests.MaxPriceRests

INTO #SalesRests
		
FROM #SalesPriceDates WITH (NOLOCK)
	FULL OUTER JOIN #Rests WITH (NOLOCK)
	ON	#SalesPriceDates.storeRef = #Rests.storeRef
		AND #SalesPriceDates.goodsRef = #Rests.goodsRef
		AND #SalesPriceDates.characteristicRef = #Rests.characteristicRef

GROUP BY
	ISNULL(#SalesPriceDates.storeRef, #Rests.storeRef),
	ISNULL(#SalesPriceDates.goodsRef, #Rests.goodsRef),
	ISNULL(#SalesPriceDates.characteristicRef, #Rests.characteristicRef),
	#SalesPriceDates.Period,
	#SalesPriceDates.Week,
	#SalesPriceDates.Day,
	#SalesPriceDates.Month,
	#SalesPriceDates.Year,
	#SalesPriceDates.SalesDate,
	#SalesPriceDates.OperationType,
	#SalesPriceDates.Quantity,
	#SalesPriceDates.DiscountPercent,
	#SalesPriceDates.SumTotal,
	#SalesPriceDates.OrgRef,
	#SalesPriceDates.MaxPricePeriod,
	#SalesPriceDates.MaxPurchasePricePeriod,
	#SalesPriceDates.MaxPurchasePriceGCPeriod,
	#Rests.amountRests,
	#Rests.MaxPriceRests

;

SQL
SELECT 
	Warehouses._Fld540RRef AS storeRef
	,_AccumReg2245._Fld2247RRef as goodsRef
	,MIN(DATEADD(DAY, DATEPART(DAY, _AccumReg2245._Period) - 1, DATEADD(MONTH, DATEPART(MONTH, _AccumReg2245._Period) - 1, DATEADD(YEAR, DATEPART(YEAR, _AccumReg2245._Period) - 2000, '2000-01-01 00:00:00')))) as Min_Period
	,MAX(DATEADD(DAY, DATEPART(DAY, _AccumReg2245._Period) - 1, DATEADD(MONTH, DATEPART(MONTH, _AccumReg2245._Period) - 1, DATEADD(YEAR, DATEPART(YEAR, _AccumReg2245._Period) - 2000, '2000-01-01 00:00:00')))) as Max_Period

INTO #ReceiptDates

FROM 
	_AccumReg2245 -- РегистрНакопления.ТоварыНаСкладах (_AccumReg2245)
		LEFT OUTER JOIN _Reference39 Warehouses WITH(NOLOCK)
		ON _AccumReg2245._Fld2246RRef = Warehouses._IDRRef
	
WHERE
	_AccumReg2245._Active = 0x01
	AND _AccumReg2245._RecordKind = 0
	AND _AccumReg2245._Period >= '20170101'

GROUP BY
	Warehouses._Fld540RRef
	,_AccumReg2245._Fld2247RRef

;

SQL
SELECT 
	Goods._Fld3798RRef AS BrandRef,
	UPPER(_Reference3822._Description) AS BRAND,
	_Reference3822._Description AS 'Бренд',
	#SalesRests.storeRef AS storeRef,
	SUBSTRING(_Reference29._Code,1,3) AS storeCode,
	_Reference29._Description AS 'Магазин',
	_Reference29_Parent._Description AS 'МагазинГруппа',
	_Reference36._Description AS 'Организация',
	CASE 
		WHEN _Reference29._Fld319 = 0x01
			THEN 'СРС'
		ELSE 'ФРС'
		END AS 'Сеть',
	_Reference52._Description AS 'Город',
	CONVERT(NVARCHAR(12), ISNULL(#ReceiptDates.Min_Period, '19000101'), 104) AS 'ДатаПервойПоставки', 
	CONVERT(NVARCHAR(12), ISNULL(#ReceiptDates.Max_Period, '19000101'), 104) AS 'ДатаПоследнейПоставки',
	CASE
		WHEN #ReceiptDates.Min_Period IS NULL
			THEN 0
		ELSE DATEPART(week, #ReceiptDates.Min_Period)
		END AS 'НеделяПервойПоставки',
	CASE
		WHEN #ReceiptDates.Min_Period IS NULL
			THEN 0
		ELSE Day(#ReceiptDates.Min_Period)
		END AS 'ДеньПервойПоставки',
	CASE
		WHEN #ReceiptDates.Min_Period IS NULL
			THEN 0
		ELSE Month(#ReceiptDates.Min_Period)
		END AS 'МесяцПервойПоставки',
	CASE
		WHEN #ReceiptDates.Min_Period IS NULL
			THEN 0
		ELSE Year(#ReceiptDates.Min_Period)
		END AS 'ГодПервойПоставки',
	CASE
		WHEN #ReceiptDates.Max_Period IS NULL
			THEN 0
		ELSE DATEPART(week, #ReceiptDates.Max_Period)
		END AS 'НеделяПоследнейПоставки',	
	CASE
		WHEN #ReceiptDates.Max_Period IS NULL
			THEN 0
		ELSE Day(#ReceiptDates.Max_Period)
		END AS 'ДеньПоследнейПоставки',
	CASE
		WHEN #ReceiptDates.Max_Period IS NULL
			THEN 0
		ELSE Month(#ReceiptDates.Max_Period)
		END AS 'МесяцПоследнейПоставки',
	CASE
		WHEN #ReceiptDates.Max_Period IS NULL
			THEN 0
		ELSE Year(#ReceiptDates.Max_Period)
		END AS 'ГодПоследнейПоставки',
	#SalesRests.Period AS 'Дата',
	#SalesRests.Week AS 'Неделя',
	#SalesRests.Day AS 'День',
	#SalesRests.Month AS 'Месяц',
	#SalesRests.Year AS 'Год',
	#SalesRests.SalesDate AS 'ДатаПродажи',
	ISNULL(#SalesRests.OperationType, 'Без движ.') AS 'ВидОперации',
	#SalesRests.goodsRef AS goodsRef,
	CASE 
		WHEN Goods._ParentIDRRef = 0x8D4250B188D289B94BCFAD91FB4A33C1
			THEN 'Glance Concept'
		WHEN Goods._ParentIDRRef = 0xB23E3149267409844F1EBE69CB2D9822
			THEN 'Комиссия Партнеров'
		ELSE 'Glance'
		END AS 'ВидТовара',
	Goods._ParentIDRRef AS GoodsParentRef,
	Goods._Description AS 'Наименование',
	Goods._Fld468 AS 'Артикул',
	Goods._Fld3797 AS 'АртикулПоставщика',
	'http://apps-srv-1:8383/fotobank/servlet/' +
		SUBSTRING(CAST(CONVERT(UNIQUEIDENTIFIER, #SalesRests.goodsRef) AS VARCHAR(36)), 29, 8) +
		SUBSTRING(CAST(CONVERT(UNIQUEIDENTIFIER, #SalesRests.goodsRef) AS VARCHAR(36)), 24, 5) +
		SUBSTRING(CAST(CONVERT(UNIQUEIDENTIFIER, #SalesRests.goodsRef) AS VARCHAR(36)), 19, 5) + '-' +
		SUBSTRING(CAST(CONVERT(UNIQUEIDENTIFIER, #SalesRests.goodsRef) AS VARCHAR(36)), 7, 2) +
		SUBSTRING(CAST(CONVERT(UNIQUEIDENTIFIER, #SalesRests.goodsRef) AS VARCHAR(36)), 5, 2) + '-' +
		SUBSTRING(CAST(CONVERT(UNIQUEIDENTIFIER, #SalesRests.goodsRef) AS VARCHAR(36)), 3, 2) +
		SUBSTRING(CAST(CONVERT(UNIQUEIDENTIFIER, #SalesRests.goodsRef) AS VARCHAR(36)), 1, 2) +
		SUBSTRING(CAST(CONVERT(UNIQUEIDENTIFIER, #SalesRests.goodsRef) AS VARCHAR(36)), 12, 2) +
		SUBSTRING(CAST(CONVERT(UNIQUEIDENTIFIER, #SalesRests.goodsRef) AS VARCHAR(36)), 10, 2) +
		SUBSTRING(CAST(CONVERT(UNIQUEIDENTIFIER, #SalesRests.goodsRef) AS VARCHAR(36)), 17, 2) +
		SUBSTRING(CAST(CONVERT(UNIQUEIDENTIFIER, #SalesRests.goodsRef) AS VARCHAR(36)), 15, 2) AS ITEM_IMAGE,
	GoodsParent._Description AS 'Капсула',
	_Reference55_PG._Description as 'ПГ',
	_Reference54._Description as 'Тип',
	_Reference55_PT._Description as 'Подтип',
	_Reference55_C._Description as 'Цвет',
	_Reference55_S._Description as 'Состав',
	_Reference3507._Description as 'Комплектность',
	_Reference3508._Description as 'КатегорияИзделия',
	_Reference46._Description as 'Художник',
	_Reference48._Description AS 'Характеристика',
	ISNULL(ObjectProperties2._Description, '') AS 'Рост',
	ISNULL(ObjectProperties1._Description, '') AS 'Размер',
	#SalesRests.Quantity AS 'Количество',
	CAST(Prices._Fld1916 AS NUMERIC(8, 2)) AS 'Цена',
	CAST(PricesRests._Fld1916 AS NUMERIC(8, 2)) AS 'ЦенаОстаток',
	#SalesRests.DiscountPercent AS 'ПроцентСкидки',
	#SalesRests.SumTotal AS 'СуммаПродаж',
	CAST(PurchasePricesGC._Fld1906 AS NUMERIC(8, 2)) AS 'ЦенаЗакупочная',
	CAST(#SalesRests.Quantity * PurchasePricesGC._Fld1906 AS NUMERIC(15, 2)) AS 'СуммаЗакупочная',
	CAST(PurchasePrices._Fld1906 AS NUMERIC(8, 2)) 'ЦенаОптовая',
	CAST(#SalesRests.Quantity * PurchasePrices._Fld1906 AS NUMERIC(15, 2)) AS 'СуммаОптовая',
	CASE 
		WHEN _Reference29._Fld319 = 0x01
			THEN #SalesRests.SumTotal - CAST(#SalesRests.Quantity * PurchasePricesGC._Fld1906 AS NUMERIC(15, 2))
		ELSE CAST(#SalesRests.Quantity * PurchasePrices._Fld1906 AS NUMERIC(15, 2)) - CAST(#SalesRests.Quantity * PurchasePricesGC._Fld1906 AS NUMERIC(15, 2))
		END AS 'Выручка',
	#SalesRests.amountRests AS 'КоличествоОстаток',
	CAST(#SalesRests.amountRests * PricesRests._Fld1916 AS NUMERIC(15, 2)) AS 'СуммаОстаток'

FROM #SalesRests WITH (NOLOCK)

LEFT OUTER JOIN _Reference29 WITH (NOLOCK)
	ON #SalesRests.storeRef = _Reference29._IDRRef

LEFT OUTER JOIN _Reference29 _Reference29_Parent WITH (NOLOCK)
	ON _Reference29._ParentIDRRef = _Reference29_Parent._IDRRef
	
LEFT OUTER JOIN _Reference36 WITH (NOLOCK)
	ON #SalesRests.OrgRef = _Reference36._IDRRef

LEFT OUTER JOIN _Reference52 WITH (NOLOCK)
	ON _Reference29._Fld321RRef = _Reference52._IDRRef

LEFT OUTER JOIN _InfoReg1912 Prices WITH (NOLOCK)
	ON #SalesRests.storeRef = Prices._Fld1915RRef
		AND #SalesRests.goodsRef = Prices._Fld1913RRef
		AND #SalesRests.characteristicRef = Prices._Fld1914RRef
		AND #SalesRests.MaxPricePeriod = Prices._Period

LEFT OUTER JOIN _InfoReg1912 PricesRests WITH (NOLOCK)
	ON #SalesRests.storeRef = PricesRests._Fld1915RRef
		AND #SalesRests.goodsRef = PricesRests._Fld1913RRef
		AND #SalesRests.characteristicRef = PricesRests._Fld1914RRef
		AND #SalesRests.MaxPriceRests = PricesRests._Period

LEFT OUTER JOIN _InfoReg1902 PurchasePrices WITH (NOLOCK)
	ON _Reference29._Fld316RRef = PurchasePrices._Fld1905RRef
		AND #SalesRests.goodsRef = PurchasePrices._Fld1903RRef
		AND #SalesRests.characteristicRef = PurchasePrices._Fld1904RRef
		AND #SalesRests.MaxPurchasePricePeriod = PurchasePrices._Period

LEFT OUTER JOIN _InfoReg1902 PurchasePricesGC WITH (NOLOCK)
	ON PurchasePricesGC._Fld1905RRef = 0xA54400505691473211E6D67555773573
		AND #SalesRests.goodsRef = PurchasePricesGC._Fld1903RRef
		AND #SalesRests.characteristicRef = PurchasePricesGC._Fld1904RRef
		AND #SalesRests.MaxPurchasePriceGCPeriod = PurchasePricesGC._Period

LEFT OUTER JOIN _Reference48 WITH (NOLOCK)
	ON #SalesRests.characteristicRef = _Reference48._IDRRef

LEFT OUTER JOIN _InfoReg1617 ObjectPropertyValues1 WITH (NOLOCK)
	ON ObjectPropertyValues1._Fld1618_TYPE = 0x08
		AND ObjectPropertyValues1._Fld1618_RTRef = 0x00000030
		AND #SalesRests.characteristicRef = ObjectPropertyValues1._Fld1618_RRRef
		AND ObjectPropertyValues1._Fld1619RRef = 0xBBD7B70A6439234649F7BFA0DB1D8C2E

LEFT OUTER JOIN _InfoReg1617 ObjectPropertyValues2 WITH (NOLOCK)
	ON ObjectPropertyValues2._Fld1618_TYPE = 0x08
		AND ObjectPropertyValues2._Fld1618_RTRef = 0x00000030
		AND #SalesRests.characteristicRef = ObjectPropertyValues2._Fld1618_RRRef
		AND ObjectPropertyValues2._Fld1619RRef = 0xBCD721C03859A06D4FB2C58E7544A4DE

LEFT OUTER JOIN _Reference21 AS ObjectProperties1
	ON ObjectPropertyValues1._Fld1620_RRRef = ObjectProperties1._IDRRef

LEFT OUTER JOIN _Reference21 AS ObjectProperties2
	ON ObjectPropertyValues2._Fld1620_RRRef = ObjectProperties2._IDRRef

LEFT OUTER JOIN _Reference33 Goods WITH (NOLOCK)
	ON #SalesRests.goodsRef = Goods._IDRRef

LEFT OUTER JOIN _Reference33 GoodsParent WITH (NOLOCK)
	ON Goods._ParentIDRRef = GoodsParent._IDRRef

LEFT OUTER JOIN _Reference3822 WITH (NOLOCK)
	ON Goods._Fld3798RRef = _Reference3822._IDRRef
	
LEFT OUTER JOIN _Reference55 _Reference55_PG WITH (NOLOCK) -- Справочник.ЗначенияСвойствGlance (_Reference55)
	ON Goods._Fld484RRef = _Reference55_PG._IDRRef

LEFT OUTER JOIN _Reference54 WITH (NOLOCK) -- Справочник.ТипыИзделий (_Reference54)
	ON Goods._Fld492RRef = _Reference54._IDRRef

LEFT OUTER JOIN _Reference55 _Reference55_PT WITH (NOLOCK) -- Справочник.ЗначенияСвойствGlance (_Reference55)
	ON Goods._Fld493RRef = _Reference55_PT._IDRRef
	
LEFT OUTER JOIN _Reference55 _Reference55_C WITH (NOLOCK) -- Справочник.ЗначенияСвойствGlance (_Reference55)
	ON Goods._Fld494RRef = _Reference55_C._IDRRef

LEFT OUTER JOIN _Reference55 _Reference55_S WITH (NOLOCK) -- Справочник.ЗначенияСвойствGlance (_Reference55)
	ON Goods._Fld483RRef = _Reference55_S._IDRRef

LEFT OUTER JOIN _Reference3507 WITH (NOLOCK) -- Справочник.Комплектность (_Reference3507)
	ON Goods._Fld3533RRef = _Reference3507._IDRRef

LEFT OUTER JOIN _Reference3508 WITH (NOLOCK) -- Справочник.КатегорияИзделия (_Reference3508)
	ON Goods._Fld3534RRef = _Reference3508._IDRRef

LEFT OUTER JOIN _Reference46 WITH (NOLOCK) -- Справочник.ФизическиеЛица (_Reference46)
	ON Goods._Fld3459RRef = _Reference46._IDRRef
	
LEFT OUTER JOIN #ReceiptDates
	ON #SalesRests.storeRef = #ReceiptDates.storeRef
		AND #SalesRests.goodsRef = #ReceiptDates.goodsRef
	
GROUP BY 
	Goods._Fld3798RRef,
	_Reference3822._Description,
	_Reference29._Description,
	_Reference29._Code,
	_Reference29_Parent._Description,
	#SalesRests.storeRef,
	_Reference36._Description,
	CASE 
		WHEN _Reference29._Fld319 = 0x01
			THEN 'СРС'
		ELSE 'ФРС'
		END,
	_Reference29._Fld319,
	_Reference52._Description,
	#SalesRests.Period,
	#SalesRests.Week,
	#SalesRests.Day,
	#SalesRests.Month,
	#SalesRests.Year,
	#SalesRests.SalesDate,
	ISNULL(#SalesRests.OperationType, 'Без движ.'),
	CASE 
		WHEN Goods._ParentIDRRef = 0x8D4250B188D289B94BCFAD91FB4A33C1
			THEN 'Glance Concept'
		WHEN Goods._ParentIDRRef = 0xB23E3149267409844F1EBE69CB2D9822
			THEN 'Комиссия Партнеров'
		ELSE 'Glance'
		END,
	'http://apps-srv-1:8383/fotobank/servlet/' +
		SUBSTRING(CAST(CONVERT(UNIQUEIDENTIFIER, #SalesRests.goodsRef) AS VARCHAR(36)), 29, 8) +
		SUBSTRING(CAST(CONVERT(UNIQUEIDENTIFIER, #SalesRests.goodsRef) AS VARCHAR(36)), 24, 5) +
		SUBSTRING(CAST(CONVERT(UNIQUEIDENTIFIER, #SalesRests.goodsRef) AS VARCHAR(36)), 19, 5) + '-' +
		SUBSTRING(CAST(CONVERT(UNIQUEIDENTIFIER, #SalesRests.goodsRef) AS VARCHAR(36)), 7, 2) +
		SUBSTRING(CAST(CONVERT(UNIQUEIDENTIFIER, #SalesRests.goodsRef) AS VARCHAR(36)), 5, 2) + '-' +
		SUBSTRING(CAST(CONVERT(UNIQUEIDENTIFIER, #SalesRests.goodsRef) AS VARCHAR(36)), 3, 2) +
		SUBSTRING(CAST(CONVERT(UNIQUEIDENTIFIER, #SalesRests.goodsRef) AS VARCHAR(36)), 1, 2) +
		SUBSTRING(CAST(CONVERT(UNIQUEIDENTIFIER, #SalesRests.goodsRef) AS VARCHAR(36)), 12, 2) +
		SUBSTRING(CAST(CONVERT(UNIQUEIDENTIFIER, #SalesRests.goodsRef) AS VARCHAR(36)), 10, 2) +
		SUBSTRING(CAST(CONVERT(UNIQUEIDENTIFIER, #SalesRests.goodsRef) AS VARCHAR(36)), 17, 2) +
		SUBSTRING(CAST(CONVERT(UNIQUEIDENTIFIER, #SalesRests.goodsRef) AS VARCHAR(36)), 15, 2),
	#SalesRests.goodsRef,
	Goods._ParentIDRRef,
	GoodsParent._Description,
	_Reference55_PG._Description,
	_Reference54._Description,
	_Reference55_PT._Description,
	_Reference55_C._Description,
	_Reference55_S._Description,
	_Reference3507._Description,
	_Reference3508._Description,
	_Reference46._Description,
	Goods._Description,
	Goods._Fld468,
	Goods._Fld3797,
	_Reference48._Description,
	ISNULL(ObjectProperties2._Description, ''),
	ISNULL(ObjectProperties1._Description, ''),
	#SalesRests.Quantity,
	Prices._Fld1916,
	#SalesRests.DiscountPercent,
	#SalesRests.SumTotal,
	PurchasePricesGC._Fld1906,
	PurchasePrices._Fld1906,
	PricesRests._Fld1916,
	#SalesRests.amountRests,
	#SalesRests.MaxPriceRests,
	#ReceiptDates.Min_Period,
	#ReceiptDates.Max_Period,
	CONVERT(NVARCHAR(12), ISNULL(#ReceiptDates.Min_Period, '19000101'), 104), 
	CONVERT(NVARCHAR(12), ISNULL(#ReceiptDates.Max_Period, '19000101'), 104)

ORDER BY 
	_Reference3822._Description,
	_Reference29._Description,
	#SalesRests.Year,
	#SalesRests.Month,
	#SalesRests.Day,
	Goods._Fld468,
	ISNULL(ObjectProperties2._Description, ''),
	ISNULL(ObjectProperties1._Description, '')

;

// DROP TABLE #Sales
// GO
// DROP TABLE #SalesPriceDates
// GO
// DROP TABLE #Rests
// GO
// DROP TABLE #SalesRests
// GO
// DROP TABLE #ReceiptDates
// GO
// ;
