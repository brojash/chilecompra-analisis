WITH prov AS (
    SELECT UPPER(TRIM(ProveedorRUT)),
           MAX(Proveedor)           AS proveedor,
           COUNT(DISTINCT codigoOC) AS ordenes,
           SUM(MontoNetoItemCLP)    AS monto
    FROM ordenes_items
    WHERE EsMontoValido = 1 AND EsDatoInvalido = 0 AND ProveedorRUT IS NOT NULL AND MontoNetoItemCLP IS NOT NULL
    GROUP BY UPPER(TRIM(ProveedorRUT))
)
SELECT proveedor,
       ordenes,
       ROUND(monto / 1e6)                                           AS monto_millones,
       ROUND(100.0 * monto / SUM(monto) OVER (), 2)                 AS pct_monto,
       ROUND(100.0 * SUM(monto) OVER (ORDER BY monto DESC)
             / SUM(monto) OVER (), 1)                               AS pct_acumulado
FROM prov
ORDER BY monto DESC
LIMIT 15;