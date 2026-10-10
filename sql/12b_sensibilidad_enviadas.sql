-- 12b: Sensibilidad a la inclusión de órdenes "Enviada a Proveedor"
SELECT 'Base (Aceptada + Recepción Conforme)' AS escenario,
       ROUND(SUM(MontoNetoItemCLP) / 1e6) AS monto_millones,
       ROUND(100.0 * SUM(CASE WHEN TamanoProveedor IN ('Micro','Pequeña','Mediana')
                              THEN MontoNetoItemCLP ELSE 0 END) / SUM(MontoNetoItemCLP), 1) AS pct_pyme,
       ROUND(100.0 * SUM(CASE WHEN Modalidad = 'Licitacion'
                              THEN MontoNetoItemCLP ELSE 0 END) / SUM(MontoNetoItemCLP), 1) AS pct_licitacion
FROM ordenes_items
WHERE EstadoOC IN ('Aceptada', 'Recepcion Conforme') AND EsDatoInvalido = 0
UNION ALL
SELECT 'Con Enviada a Proveedor',
       ROUND(SUM(MontoNetoItemCLP) / 1e6),
       ROUND(100.0 * SUM(CASE WHEN TamanoProveedor IN ('Micro','Pequeña','Mediana')
                              THEN MontoNetoItemCLP ELSE 0 END) / SUM(MontoNetoItemCLP), 1),
       ROUND(100.0 * SUM(CASE WHEN Modalidad = 'Licitacion'
                              THEN MontoNetoItemCLP ELSE 0 END) / SUM(MontoNetoItemCLP), 1)
FROM ordenes_items
WHERE EstadoOC IN ('Aceptada', 'Recepcion Conforme', 'Enviada a Proveedor') AND EsDatoInvalido = 0;