

SELECT
       m.uid AS goodsRef,
       m.code AS goodsCode,
       reg_price_13.currency_id,
       currency.name,
       currency.detail,
       currency.currency_code,
       currency.number_code,
       reg_price_7.value AS price7,
       CASE
           WHEN reg_price_13.currency_id = 2
                OR reg_price_13.currency_id IS NULL
           THEN reg_price_13.value * 60
           ELSE reg_price_13.value
       END AS price13,
       CASE
           WHEN reg_price_7.value > 0
           THEN 100 * (reg_price_7.value - (CASE
                                                WHEN reg_price_13.currency_id = 2
                                                     OR reg_price_13.currency_id IS NULL
                                                THEN reg_price_13.value * 60
                                                ELSE reg_price_13.value
                                            END)) / reg_price_7.value
           ELSE 0
       END AS marginPlan
FROM
     matrix.dbo.model m
     INNER JOIN matrix.dbo.reg_price_item reg_price_7
          ON m.id = reg_price_7.model_id
             AND reg_price_7.type_id = 7
     INNER JOIN matrix.dbo.reg_price_item reg_price_13
          ON m.id = reg_price_13.model_id
             AND reg_price_13.type_id = 13
     LEFT JOIN matrix.dbo.currency currency
          ON reg_price_13.currency_id = currency.id
WHERE  reg_price_7.value > 0
       OR reg_price_13.value > 0
ORDER BY
         marginPlan DESC;


