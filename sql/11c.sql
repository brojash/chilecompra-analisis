-- 11c: Peso de las pymes en los 12 rubros con mayor monto
WITH r AS (
    SELECT RubroN1,
           SUM(MontoNetoItemCLP) AS monto,
           SUM(CASE WHEN TamanoProveedor IN ('Micro','Pequeña','Mediana')
                    THEN MontoNetoItemCLP ELSE 0 END) AS monto_pyme
    FROM ordenes_items
    WHERE EsMontoValido = 1 AND EsDatoInvalido = 0
      AND RubroN1 IS NOT NULL AND TRIM(RubroN1) <> ''
    GROUP BY RubroN1
)
SELECT RubroN1,
       ROUND(monto / 1e6)                 AS monto_millones,
       ROUND(100.0 * monto_pyme / monto, 1) AS pct_pyme
FROM r
ORDER BY monto DESC
LIMIT 12;