-- 11a: Participación por tamaño de proveedor (órdenes, monto total y monto en compras corrientes)
WITH t AS (
    SELECT TamanoProveedor AS tamano,
           COUNT(DISTINCT codigoOC) AS ordenes,
           SUM(MontoNetoItemCLP)    AS monto,
           SUM(CASE WHEN EsContratoGrande = 0 THEN MontoNetoItemCLP ELSE 0 END) AS monto_corriente
    FROM ordenes_items
    WHERE EsMontoValido = 1 AND EsDatoInvalido = 0
    GROUP BY TamanoProveedor
)
SELECT tamano,
       ordenes,
       ROUND(100.0 * ordenes / SUM(ordenes) OVER (), 1)                  AS pct_ordenes,
       ROUND(monto / 1e6)                                                AS monto_millones,
       ROUND(100.0 * monto / SUM(monto) OVER (), 1)                      AS pct_monto,
       ROUND(100.0 * monto_corriente / SUM(monto_corriente) OVER (), 1)  AS pct_monto_corriente
FROM t
ORDER BY monto DESC;