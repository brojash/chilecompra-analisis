SELECT CASE
         WHEN NombreItem LIKE '%GAS LICUADO%' THEN 'Gas licuado'
         WHEN NombreItem LIKE '%DIESEL%' OR NombreItem LIKE '%BENCINA%' THEN 'Combustibles'
         WHEN NombreItem LIKE '%PASAJE%' THEN 'Pasajes aéreos'
         ELSE 'Otros sin rubro'
       END AS categoria,
       COUNT(DISTINCT codigoOC)           AS ordenes,
       ROUND(SUM(MontoNetoItemCLP) / 1e6) AS monto_millones
FROM ordenes_items
WHERE EsMontoValido = 1 AND EsDatoInvalido = 0
  AND (RubroN1 IS NULL OR TRIM(RubroN1) = '')
GROUP BY categoria
ORDER BY monto_millones DESC;