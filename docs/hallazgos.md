# Hallazgos

Análisis de las órdenes de compra de las municipalidades en Mercado Público (ChileCompra), primer semestre de 2025 (enero a junio).

## Alcance y definiciones

- **Modalidades incluidas:** Licitación, Convenio Marco y Trato Directo. Compra Ágil no está incluida.
- **Monto transado:** suma de `MontoNetoItemCLP` en órdenes en estado *Aceptada* o *Recepción Conforme*, sin la orden de casilleros excluida por error de moneda. Se llama "monto transado" y no "gasto del semestre" porque una orden puede registrar el valor total de un contrato de varios años.
- **Total analizado:** $1.493.476 millones, 112.126 órdenes y 15.752 proveedores (RUT distintos).
- **Contrato grande:** ítem de $50 millones o más. **Compra corriente:** el resto.
- **Pyme:** Micro + Pequeña + Mediana, según la clasificación `TamanoProveedor` de ChileCompra.
- Las decisiones de limpieza están en [`decisiones.md`](decisiones.md).

## Concentración general del monto

- El 1% de las filas más grandes concentra el 70,8% del monto transado, y el 10% concentra el 93,8%.
- Con umbrales de $20, $50 y $100 millones por ítem, los contratos grandes concentran el 80,4%, 70,9% y 63,5% del monto. La conclusión no depende del umbral elegido.
- Por eso casi todos los rankings se reportan dos veces: por monto total y en compras corrientes.

## P1: ¿Qué rubros y regiones concentran más monto?

### Rubros
- Sobre el monto con rubro asignado (≈$1,41 billones, 94,4% del total), tres rubros concentran cerca del 53%: limpieza industrial (23,3%), construcción y mantenimiento (19,9%) y servicios agrícolas, pesqueros y forestales (9,7%).
- Los nombres de los rubros engañan:
  - El 87,5% de "limpieza industrial" es eliminación y tratamiento de desechos.
  - El 87,3% de "construcción y mantenimiento" es construcción de edificios en general.
  - El 97% de "servicios agrícolas" es horticultura, que en la práctica es mantenimiento de áreas verdes (jardines y parques, 88%; poda, césped y fumigación, el resto).
- El ranking cambia al excluir contratos grandes: limpieza industrial pasa del 1° al 5°, servicios agrícolas del 3° al 18° y defensa del 6° al 14°. En compras corrientes lideran transporte (1°), servicios profesionales (2°) y construcción (3°).

### Regiones
- La Región Metropolitana concentra el 35,4% del monto y Valparaíso el 14,3%.
- En 13 de las 16 regiones, la mitad o más del monto está en contratos grandes.
- La RM y el Maule tienen un número similar de órdenes (13.652 y 12.548), pero la RM transa 5,7 veces más monto: la diferencia regional está en el tamaño de los contratos.
- Tres órdenes de un mismo proveedor (COSEMAR) en la Municipalidad de Viña del Mar, todas en estado Aceptada, suman $86.847 millones: el 40,7% del monto de la región de Valparaíso. Sin ellas, Valparaíso seguiría segunda, pero con una ventaja sobre Biobío de ~$13.000 millones en vez de ~$100.000 millones.

### Limitaciones
- El ranking de rubros excluye el 5,6% del monto (Convenio Marco sin rubro, analizado aparte; ver Calidad de datos).
- No se normalizó por población: las comparaciones regionales son en monto absoluto.

## P2: ¿Qué tan concentrado está el monto en pocos proveedores?

- Hay 15.752 proveedores (por RUT normalizado). 132 (0,8%) suman el 50% del monto y 1.096 (7,0%) suman el 80%: más concentrado que la regla 80/20.
- El mayor proveedor (COSEMAR) pesa 7,8% con solo 45 órdenes. Los 5 primeros suman 17,3% y los 15 primeros 26,5%.
- Hay dos perfiles entre los mayores:
  - **Contratos únicos y gigantes:** Constructora Lo Blanco y Neogreen, una orden cada una, de ~$20 mil millones.
  - **Proveedores recurrentes de combustible y gas:** COPEC y GASCO, ~2.200 órdenes cada uno.
- En compras corrientes (sin contratos grandes), los 10 mayores proveedores suman 11,2% del monto, contra 23,0% en el monto total. Lideran proveedores de combustible y gas (COPEC 4,7%, GASCO 2,1%, ESMAX 0,7%), seguidos de seguros e insumos de oficina.
- La concentración en monto total viene de pocos contratos gigantes; la concentración en el día a día viene de pocos proveedores de combustible y gas.

### Limitaciones
- El monto transado incluye contratos de varios años.
- Agrupar por RUT puede subestimar la concentración de grupos empresariales.
- Cuatro RUT aparecían duplicados en SQL por diferencias de escritura (mayúsculas o espacios): SQL contaba 15.756 RUT distintos y, al normalizarlos con `UPPER(TRIM())`, quedan 15.752, igual que en Power BI. Las cifras de concentración (132 y 1.096 proveedores) se recalcularon con el RUT normalizado y no cambiaron.

## P3: ¿Cuánto pesan Trato Directo y Convenio Marco frente a Licitación?

| Modalidad | % de las órdenes | % del monto | % de su monto en contratos grandes |
|---|---|---|---|
| Licitación | 67% | 82% | 76% |
| Trato Directo | 19% | 11% | 61% |
| Convenio Marco | 13% | 7% | 21% |

- Por monto, Licitación domina. Esa dominancia viene de pocos contratos grandes: unas 3.400 órdenes (3% del total) concentran el 71% del monto, y en Licitación el 76% de su monto está en 2.975 órdenes.
- En compras corrientes el reparto es más parejo: Licitación 67%, Convenio Marco 18% y Trato Directo 15% del monto.
- Trato Directo es 1 de cada 5 órdenes corrientes, pero de monto bajo (promedio de $3,0 millones por orden, contra $4,0 millones en Licitación y $5,3 millones en Convenio Marco).
- Las 317 órdenes de Trato Directo con ítems grandes suman el 61% de su monto: son las que merecen una revisión más detallada.

### Limitaciones
- Los datos no permiten juzgar si un trato directo estuvo justificado; solo miden cuánto pesan.
- Compra Ágil no está incluida, por lo que los porcentajes de órdenes se refieren a las tres modalidades analizadas, no a todas las compras municipales.

## P4: ¿Qué participación tienen las pymes y en qué rubros?

- Las pymes reciben el 55,0% de las órdenes y el 42,1% del monto. Las empresas grandes, el 33,8% de las órdenes y el 49,5% del monto.
- El 8,4% del monto corresponde a proveedores sin clasificar, por lo que la participación pyme está entre 42,1% y 50,5%.

| Segmento | Pyme | Grande | No clasificado |
|---|---|---|---|
| Compras corrientes | 51,9% | 36,5% | 11,6% |
| Contratos grandes | 38,1% | 54,9% | 7,0% |

- La ventaja de las empresas grandes viene de los contratos grandes. Aun así, las pymes llevan el 38,1% del monto de esos contratos, y algo más de la mitad de ese monto corresponde a medianas.
- Las microempresas reciben el 15,5% de las órdenes pero solo el 6,2% del monto. Pasan de 12,9% del monto en compras corrientes a 3,4% en contratos grandes.
- Por modalidad, Licitación es la más abierta a pymes (62,5% de las órdenes y 44,9% del monto) y Convenio Marco la menos (19,2% de las órdenes y 20,6% del monto).
- Por rubro, las pymes pesan más en construcción (68,6%), artículos para estructuras (64,0%) y servicios profesionales (61,8%), y menos en residuos (16,1%) y productos derivados de minerales (11,4%).
- Los 10 mayores ítems adjudicados a pymes son todos de Licitación.

### Verificaciones
- **Caso extremo:** la mayor orden de una pyme (Constructora Lo Blanco, clasificada Mediana, $20.495 millones, ~10% del monto de contratos grandes de medianas) parece desproporcionada para una empresa de ese tamaño. Si se reclasificara como grande, la participación pyme bajaría de 42,1% a 40,7% (efecto máximo de 1,4 puntos).
- **Sensibilidad a los estados:** incluir las órdenes "Enviada a Proveedor" (+9,2% del monto) baja la participación pyme de 42,1% a 39,7% y deja casi igual el peso de Licitación (82,2% a 82,4%). La conclusión se mantiene.

### Limitaciones
- Se usa la clasificación de tamaño de ChileCompra sin poder verificarla: no se conoce el criterio ni el año de referencia.
- No se mide cuántas pymes distintas participan, solo cuánto monto y cuántas órdenes reciben.

## Calidad de datos

- **Convenio Marco sin rubro:** el 99,5% de sus filas no trae rubro, ni código ONU, ni producto, ni número de convenio. Solo se puede clasificar por el texto de `NombreItem`. Ese grupo pesa $83.245 millones, el 5,6% del monto total.
- **Clasificación por palabras clave de ese grupo:** combustibles 26,7%, gas licuado 13,6%, computación y TI 10,9% y otros 4,7% (vestuario, seguros, pasajes, supermercado). Queda sin clasificar el 44,1% del grupo, equivalente al 2,5% del monto total. La clasificación por texto es aproximada.
- **Montos como texto:** los archivos usan coma decimal; sin leerlos con `decimal=","` los montos quedan como texto.
- **Una orden excluida por error de moneda:** arriendo de casilleros en San Nicolás, con un monto equivalente a ~$27.400 millones marcado en UF, incoherente con su descripción de un arriendo mensual. Es una hipótesis, no una certeza.
- **Valores extremos reales:** los ítems más grandes son contratos plurianuales de residuos, obras y áreas verdes (por ejemplo, contratos de 72 meses registrados como un solo monto). No se eliminaron.
