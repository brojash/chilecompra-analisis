SELECT codigoOC, UnidadCompra, EstadoOC,
       ROUND(SUM(MontoNetoItemCLP) / 1e6) AS monto_millones
FROM ordenes_items
WHERE Proveedor LIKE 'COSEMAR%' AND EsDatoInvalido = 0
GROUP BY codigoOC, UnidadCompra, EstadoOC
ORDER BY SUM(MontoNetoItemCLP) DESC
LIMIT 10;