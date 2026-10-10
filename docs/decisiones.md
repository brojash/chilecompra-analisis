# Decisiones de limpieza y metodología

## Alcance
- Fuente: ChileCompra, Datos Abiertos > Descargas > Órdenes de compra.
- Sector: Municipalidades. Periodo: primer semestre de 2025 (enero a junio).
- Modalidades: Licitación, Convenio Marco, Trato Directo (Compra Ágil queda fuera de esta primera versión por su tamaño, ~4,3 GB).
- Limitación: solo incluye compras hechas vía Mercado Público.

## Estructura de los datos
- Cada fila es un ítem, no una orden. El monto de la orden se repite en cada ítem de esa orden.
- Regla: el monto se suma con `MontoNetoItemCLP`; las órdenes se cuentan con `COUNT(DISTINCT codigoOC)`. Sumar `MontoNetoOC_CLP` inflaría el monto.

## Decisiones

Las cifras de las decisiones 2, 4, 6, 7, 9, 10 y 13 se midieron al perfilar el archivo de Licitación, y se aplicó el mismo criterio a las otras dos modalidades. El resto se midió con SQL sobre las tres modalidades.

| # | Decisión | Motivo |
|---|----------|--------|
| 1 | Leer los archivos con `sep=";"`, `encoding="latin-1"` y `decimal=","` | Es el formato en que vienen; sin esto los montos quedan como texto |
| 2 | Monto válido = órdenes en estado "Aceptada" y "Recepcion Conforme" | Son órdenes en curso o cerradas con el proveedor (~97% de las filas de Licitación) |
| 3 | Excluir "Enviada a Proveedor", "Solicitud de Cancelacion" y "En Proceso" | Aún no confirmadas o con riesgo de cancelarse. Se mide la sensibilidad de incluir "Enviada a Proveedor" (decisión 15) |
| 4 | Usar las columnas `_CLP` para todos los montos | ChileCompra ya convierte CLF, UTM y USD a pesos (tasas implícitas coherentes con 2025). Solo ~0,6% de las filas de Licitación no está en CLP |
| 5 | Pyme = Micro + Pequeña + Mediana. "NoClasificado" se reporta aparte | No se puede asumir el tamaño de esas empresas; imputarlo sesgaría el resultado |
| 6 | Nulos en región: etiquetar como "Sin información", no eliminar | Son pocos (≤2,1% en Licitación) y eliminarlos quitaría monto del total |
| 7 | No usar `ActividadProveedor`, `Financiamiento` ni `DescripcionItem` | Nulos altos (5-12%) y no aportan a las preguntas del análisis |
| 8 | Identificar proveedores por RUT normalizado (`UPPER(TRIM(ProveedorRUT))`), no por nombre | El mismo RUT puede aparecer con nombres escritos distinto, y 4 RUT aparecían duplicados por mayúsculas o espacios (15.756 sin normalizar, 15.752 normalizados) |
| 9 | Excluir de las sumas las 41 filas sin monto (0,016% de las filas de Licitación) | Impacto despreciable. 8 filas con monto < $1 se mantienen |
| 10 | NO eliminar duplicados (en Licitación: 2.664 filas involucradas, 1.668 copias adicionales, 637 órdenes) | La suma de ítems calza con el total de la orden en el 100% de los casos; son líneas repetidas del mismo producto |
| 11 | NO eliminar outliers: segmentar entre "contratos grandes" (ítem ≥ $50 millones) y "compras corrientes", y reportar ambos | El 1% de las filas más grandes concentra el 70,8% del monto; casi todos son contratos reales, varios de varios años |
| 12 | La métrica se llama "monto transado", no "gasto del semestre" | Una orden puede registrar el valor total de un contrato plurianual |
| 13 | Reportar mediana y escala logarítmica, además del promedio | Distribución muy asimétrica: en Licitación, mediana $80 mil vs. promedio $5,4 millones |
| 14 | Excluir la orden 4707-160-SE25 (casilleros, San Nicolás) por probable error de moneda | Monto original 700.000 marcado como CLF (~$27.400 millones); la descripción indica un arriendo mensual, coherente con $700.000 CLP. Es una hipótesis, no certeza |
| 15 | Reportar resultados con y sin "Enviada a Proveedor" | Incluirla suma 9,2% al monto y baja la participación pyme de 42,1% a 39,7%; el peso de Licitación casi no cambia (82,2% a 82,4%) |
| 16 | Compra Ágil excluida de la versión 1 | Archivo de ~4,3 GB; los porcentajes entre modalidades se refieren solo a Licitación, Convenio Marco y Trato Directo. Se incorporará en la fase 2 procesándolo por partes |
| 17 | Análisis de sensibilidad del umbral de contrato grande: $20, $50 y $100 millones | Las conclusiones se mantienen: entre 63% y 80% del monto en menos del 2,5% de las filas |
| 18 | `RubroN1` vacío (99,5% de Convenio Marco; 5,6% del monto total): ranking de rubros solo con filas que traen rubro (≈94,4% del monto). Convenio Marco sin rubro se clasifica por palabras clave sobre `NombreItem` (cubre 55,9% del grupo); el resto se reporta como "Sin clasificar" (2,5% del monto total) | No existe campo oficial para clasificar (código ONU, producto y convenio también vacíos). Los ítems restantes son una cola larga; clasificarlos todos no es viable |
| 19 | Las cifras iniciales calculadas solo con Licitación en Python (73,8% de concentración y $1,37 billones) se reemplazan por las de SQL sobre las tres modalidades (70,8% y $1.493.476 millones) | Evita mezclar universos distintos |
| 20 | La participación pyme se reporta como piso (42,1%) y techo (50,5%) según cómo se asigne "NoClasificado" (8,4% del monto) | No se puede asumir el tamaño de esos proveedores; imputarlo sesgaría el resultado |
| 21 | Se usa `TamanoProveedor` tal como viene de ChileCompra. Verificado en contratos grandes: un caso extremo (Constructora Lo Blanco, Mediana, $20.495 M) cambia la participación pyme en 1,4 puntos como máximo | No hay datos de ventas ni de empleados para recalcular el tamaño |

## Validaciones

- [x] Suma de ítems vs. monto de la orden: calza en el 100%.
- [x] Ceros o negativos: ninguno. Hay 8 montos positivos menores a $1, que se mantienen.
- [x] Duplicados: se mantienen (ver decisión 10).
- [x] Valores extremos: el ítem máximo es de $46.736 millones; los 10 mayores suman ~19,5% del monto de Licitación y casi todos son contratos reales (ver decisión 11).
- [x] Periodo real del archivo: enero a junio de 2025. Los sufijos SE24 y SE25 de los códigos son parte del código de la orden, no la fecha.
- [x] Contratos con cantidad = 72: son contratos de 72 meses (plurianuales).
- [x] Conversión a pesos: las tasas implícitas de CLF, UTM y USD son coherentes (ver decisión 4).
- [x] Cifras del dashboard vs. SQL: el monto, el % pyme y el % de contratos grandes coinciden.
- [x] Diferencia de 4 proveedores entre SQL (15.756) y el dashboard (15.752): confirmada. Se debe a RUT escritos con distintas mayúsculas o espacios; al normalizar con `UPPER(TRIM())` ambos dan 15.752.
- [x] Cifras de concentración de proveedores recalculadas con el RUT normalizado (15.752 proveedores; 132 para el 50% y 1.096 para el 80%): no cambiaron. El gráfico 05_proveedores también se regeneró.
