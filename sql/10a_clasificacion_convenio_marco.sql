-- 10a: Clasificación por palabras clave de ítems de Convenio Marco sin rubro
SELECT CASE
         WHEN NombreItem LIKE '%GAS LICUADO%' THEN 'Gas licuado'
         WHEN NombreItem LIKE '%DESCUENTO PESOS POR LITRO%' OR NombreItem LIKE '%DIESEL%'
              OR NombreItem LIKE '%BENCINA%' OR NombreItem LIKE '%GASOLINA%' THEN 'Combustibles'
         WHEN NombreItem LIKE '%PASAJE%' THEN 'Pasajes aéreos'
         WHEN NombreItem LIKE '%ALL IN ONE%' OR NombreItem LIKE '%LAPTOP%'
              OR NombreItem LIKE '%NOTEBOOK%' OR NombreItem LIKE '%LICENCIA%'
              OR NombreItem LIKE '%SOFTWARE%' OR NombreItem LIKE '%IAAS%'
              OR NombreItem LIKE '%BASES DE DATOS%'
              OR NombreItem LIKE '%INFRAESTRUCTURA TI%' THEN 'Computación y TI'
         WHEN NombreItem LIKE '%VESTUARIO%' THEN 'Vestuario y calzado'
         WHEN NombreItem LIKE '%SEGURO%' THEN 'Seguros'
         WHEN NombreItem LIKE '%SUPERMERCADO%' THEN 'Vales de supermercado'
         ELSE 'Sin clasificar'
       END AS categoria,
       COUNT(DISTINCT codigoOC)           AS ordenes,
       ROUND(SUM(MontoNetoItemCLP) / 1e6) AS monto_millones,
       ROUND(100.0 * SUM(MontoNetoItemCLP) / SUM(SUM(MontoNetoItemCLP)) OVER (), 1) AS pct_del_grupo
FROM ordenes_items
WHERE EsMontoValido = 1 AND EsDatoInvalido = 0
  AND (RubroN1 IS NULL OR TRIM(RubroN1) = '')
GROUP BY categoria
ORDER BY monto_millones DESC;