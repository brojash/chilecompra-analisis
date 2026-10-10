SELECT RegionUnidadCompra AS region,
       COUNT(DISTINCT codigoOC) AS ordenes,
       ROUND(SUM(MontoNetoItemCLP) / 1e6) AS monto_millones,
       ROUND(100.0 * SUM(MontoNetoItemCLP) / SUM(SUM(MontoNetoItemCLP)) OVER (), 1) AS pct_monto,
       ROUND(100.0 * SUM(CASE WHEN EsContratoGrande = 1 THEN MontoNetoItemCLP ELSE 0 END)
             / SUM(MontoNetoItemCLP), 1) AS pct_en_contratos_grandes
FROM ordenes_items
WHERE EsMontoValido = 1 AND EsDatoInvalido = 0
GROUP BY RegionUnidadCompra
ORDER BY monto_millones DESC;