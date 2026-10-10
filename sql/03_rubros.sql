WITH rubros AS (
    SELECT RubroN1,
           COUNT(DISTINCT codigoOC) AS ordenes,
           SUM(MontoNetoItemCLP)    AS monto_total,
           SUM(CASE WHEN EsContratoGrande = 0 THEN MontoNetoItemCLP ELSE 0 END) AS monto_corriente
    FROM ordenes_items
    WHERE EsMontoValido = 1 AND EsDatoInvalido = 0
	AND RubroN1 IS NOT NULL AND TRIM(RubroN1) <> ''
    GROUP BY RubroN1
)
SELECT RubroN1,
       ordenes,
       ROUND(monto_total / 1e6)                          AS monto_millones,
       ROUND(100.0 * monto_total / SUM(monto_total) OVER (), 1) AS pct_monto,
       RANK() OVER (ORDER BY monto_total DESC)           AS ranking_total,
       RANK() OVER (ORDER BY monto_corriente DESC)       AS ranking_corriente
FROM rubros
ORDER BY monto_total DESC
LIMIT 15;