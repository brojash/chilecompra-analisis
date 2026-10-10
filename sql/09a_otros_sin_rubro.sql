-- 09a: Ítems sin rubro que no entran en las categorías por palabra clave, ordenados por monto
SELECT NombreItem,
       COUNT(DISTINCT codigoOC)           AS ordenes,
       ROUND(SUM(MontoNetoItemCLP) / 1e6) AS monto_millones
FROM ordenes_items
WHERE EsMontoValido = 1 AND EsDatoInvalido = 0
  AND (RubroN1 IS NULL OR TRIM(RubroN1) = '')
  AND NombreItem NOT LIKE '%GAS LICUADO%'
  AND NombreItem NOT LIKE '%DIESEL%'
  AND NombreItem NOT LIKE '%BENCINA%'
  AND NombreItem NOT LIKE '%PASAJE%'
GROUP BY NombreItem
ORDER BY SUM(MontoNetoItemCLP) DESC
LIMIT 25;