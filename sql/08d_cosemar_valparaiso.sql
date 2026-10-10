SELECT codigoOC, Institucion, RegionUnidadCompra, EstadoOC,
       ROUND(SUM(MontoNetoItemCLP) / 1e6) AS monto_millones
FROM ordenes_items
WHERE codigoOC IN ('3929-36-SE25', '3929-17-SE25', '3929-37-SE25')
GROUP BY codigoOC, Institucion, RegionUnidadCompra, EstadoOC;