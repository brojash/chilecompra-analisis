-- 11b: Peso de las pymes (Micro + Pequeña + Mediana) por modalidad
SELECT Modalidad,
       ROUND(100.0 * COUNT(DISTINCT CASE WHEN TamanoProveedor IN ('Micro','Pequeña','Mediana')
                                         THEN codigoOC END) / COUNT(DISTINCT codigoOC), 1) AS pct_ordenes_pyme,
       ROUND(100.0 * SUM(CASE WHEN TamanoProveedor IN ('Micro','Pequeña','Mediana')
                              THEN MontoNetoItemCLP ELSE 0 END) / SUM(MontoNetoItemCLP), 1) AS pct_monto_pyme,
       ROUND(100.0 * SUM(CASE WHEN TamanoProveedor = 'NoClasificado'
                              THEN MontoNetoItemCLP ELSE 0 END) / SUM(MontoNetoItemCLP), 1) AS pct_monto_noclasificado
FROM ordenes_items
WHERE EsMontoValido = 1 AND EsDatoInvalido = 0
GROUP BY Modalidad;