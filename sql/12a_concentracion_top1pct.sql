-- 12a: Qué porcentaje del monto concentran el 1% y el 10% de las filas más grandes
WITH base AS (
    SELECT MontoNetoItemCLP AS monto,
           NTILE(100) OVER (ORDER BY MontoNetoItemCLP DESC) AS percentil
    FROM ordenes_items
    WHERE EsMontoValido = 1 AND EsDatoInvalido = 0 AND MontoNetoItemCLP IS NOT NULL
)
SELECT ROUND(SUM(monto) / 1e6) AS monto_total_millones,
       ROUND(100.0 * SUM(CASE WHEN percentil = 1 THEN monto ELSE 0 END) / SUM(monto), 1)   AS pct_en_top_1pct_filas,
       ROUND(100.0 * SUM(CASE WHEN percentil <= 10 THEN monto ELSE 0 END) / SUM(monto), 1) AS pct_en_top_10pct_filas
FROM base;