SELECT u.umbral_millones,
       COUNT(*) AS items,
       ROUND(100.0 * SUM(o.MontoNetoItemCLP) /
             (SELECT SUM(MontoNetoItemCLP) FROM ordenes_items
              WHERE EsMontoValido = 1 AND EsDatoInvalido = 0), 1) AS pct_del_monto
FROM (SELECT 20 AS umbral_millones UNION ALL SELECT 50 UNION ALL SELECT 100) u
JOIN ordenes_items o ON o.MontoNetoItemCLP >= u.umbral_millones * 1e6
WHERE o.EsMontoValido = 1 AND o.EsDatoInvalido = 0
GROUP BY u.umbral_millones;