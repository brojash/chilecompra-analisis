-- 10b: Subrubros (nivel 2) dentro de los tres rubros con mayor monto
SELECT RubroN1, RubroN2,
       COUNT(DISTINCT codigoOC)           AS ordenes,
       ROUND(SUM(MontoNetoItemCLP) / 1e6) AS monto_millones
FROM ordenes_items
WHERE EsMontoValido = 1 AND EsDatoInvalido = 0
  AND (RubroN1 LIKE 'Servicios de limpieza industrial%'
       OR RubroN1 LIKE 'Servicios de construcci%'
       OR RubroN1 LIKE 'Servicios agr%')
GROUP BY RubroN1, RubroN2
ORDER BY SUM(MontoNetoItemCLP) DESC
LIMIT 12;