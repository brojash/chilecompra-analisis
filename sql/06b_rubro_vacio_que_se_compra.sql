SELECT NombreItem,
       COUNT(*)                           AS filas,
       ROUND(SUM(MontoNetoItemCLP) / 1e6) AS monto_millones
FROM ordenes_items
WHERE EsMontoValido = 1 AND EsDatoInvalido = 0
  AND (RubroN1 IS NULL OR TRIM(RubroN1) = '')
GROUP BY NombreItem
ORDER BY filas DESC
LIMIT 10;