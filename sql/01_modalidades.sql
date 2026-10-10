WITH por_modalidad AS (
    SELECT Modalidad,
           COUNT(DISTINCT codigoOC)  AS ordenes,
           SUM(MontoNetoItemCLP)     AS monto
    FROM ordenes_items
    WHERE EsMontoValido = 1 AND EsDatoInvalido = 0
    GROUP BY Modalidad
)
SELECT Modalidad,
       ordenes,
       ROUND(monto / 1e6)                                AS monto_millones,
       ROUND(100.0 * ordenes / SUM(ordenes) OVER (), 1)  AS pct_ordenes,
       ROUND(100.0 * monto / SUM(monto) OVER (), 1)      AS pct_monto,
       ROUND(monto / ordenes / 1e6, 1)                   AS prom_por_orden_millones
FROM por_modalidad
ORDER BY monto DESC;