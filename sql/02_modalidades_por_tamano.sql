SELECT Modalidad,
       CASE WHEN EsContratoGrande = 1 THEN 'Contrato grande' ELSE 'Compra corriente' END AS segmento,
       COUNT(DISTINCT codigoOC)           AS ordenes,
       ROUND(SUM(MontoNetoItemCLP) / 1e6) AS monto_millones
FROM ordenes_items
WHERE EsMontoValido = 1 AND EsDatoInvalido = 0
GROUP BY Modalidad, segmento
ORDER BY Modalidad, segmento;