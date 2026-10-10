-- 11e: Mayores ítems adjudicados a proveedores clasificados como pyme
SELECT Proveedor, TamanoProveedor, Modalidad, RubroN2,
       ROUND(MontoNetoItemCLP / 1e6) AS monto_millones
FROM ordenes_items
WHERE EsMontoValido = 1 AND EsDatoInvalido = 0
  AND TamanoProveedor IN ('Micro', 'Pequeña', 'Mediana')
ORDER BY MontoNetoItemCLP DESC
LIMIT 10;