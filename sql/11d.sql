-- 11d: Peso por tamaño de proveedor en contratos grandes y en compras corrientes
SELECT CASE WHEN EsContratoGrande = 1 THEN 'Contrato grande' ELSE 'Compra corriente' END AS segmento,
       TamanoProveedor                     AS tamano,
       COUNT(DISTINCT codigoOC)            AS ordenes,
       ROUND(SUM(MontoNetoItemCLP) / 1e6)  AS monto_millones,
       ROUND(100.0 * SUM(MontoNetoItemCLP)
             / SUM(SUM(MontoNetoItemCLP)) OVER (PARTITION BY EsContratoGrande), 1) AS pct_del_segmento
FROM ordenes_items
WHERE EsMontoValido = 1 AND EsDatoInvalido = 0
GROUP BY EsContratoGrande, TamanoProveedor
ORDER BY EsContratoGrande DESC, monto_millones DESC;