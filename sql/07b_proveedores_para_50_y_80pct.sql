-- 07b: Cuántos proveedores (RUT normalizado) hacen falta para llegar al 50% y al 80% del monto
WITH prov AS (
    SELECT UPPER(TRIM(ProveedorRUT)) AS rut, SUM(MontoNetoItemCLP) AS monto
    FROM ordenes_items
    WHERE EsMontoValido = 1 AND EsDatoInvalido = 0
      AND MontoNetoItemCLP IS NOT NULL AND ProveedorRUT IS NOT NULL
    GROUP BY UPPER(TRIM(ProveedorRUT))
),
acum AS (
    SELECT monto,
           ROW_NUMBER() OVER (ORDER BY monto DESC) AS n,
           SUM(monto)   OVER (ORDER BY monto DESC) AS acumulado,
           SUM(monto)   OVER ()                    AS total
    FROM prov
)
SELECT (SELECT COUNT(*) FROM acum)                              AS proveedores_total,
       (SELECT MIN(n) FROM acum WHERE acumulado >= 0.5 * total) AS prov_para_50pct,
       (SELECT MIN(n) FROM acum WHERE acumulado >= 0.8 * total) AS prov_para_80pct;