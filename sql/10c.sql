-- 10c: Ítems más grandes dentro del subrubro Horticultura
SELECT NombreItem,
       COUNT(DISTINCT codigoOC)           AS ordenes,
       ROUND(SUM(MontoNetoItemCLP) / 1e6) AS monto_millones
FROM ordenes_items
WHERE EsMontoValido = 1 AND EsDatoInvalido = 0 AND RubroN2 = 'Horticultura'
GROUP BY NombreItem
ORDER BY SUM(MontoNetoItemCLP) DESC
LIMIT 8;