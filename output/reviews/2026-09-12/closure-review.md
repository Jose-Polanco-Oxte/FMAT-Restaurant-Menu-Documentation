# Cierre de invariantes discutidas — revisión 4

Se revisaron las anotaciones vigentes del usuario en OPEN-001/006, `Consultoria-2.md` pp. 9–16 y `Consultoria-rendimiento.md`. Las elecciones nuevas están identificadas como decisiones adoptadas bajo delegación en [Decisiones-cierre-invariantes](../../docs/md/Decisiones-cierre-invariantes.md); no se presentan como acuerdos históricos de las auditorías originales.

| Asunto | Estado | Decisión y evidencia documental |
| --- | --- | --- |
| OPEN-001 | Cerrado | ADR-001: proyección plana, Inventory sin conocimiento de productos, correlación/versiones/caducidad y no disponible ante fallo. REQ/BR/INT/DATA/CON afectados se enumeran en módulo 09. |
| OPEN-003 | Cerrado | ADR-003: ARCHIVED, historia sin purga en esta versión, snapshot neto persistido, outbox, movimientos idempotentes y reversión contra el original. |
| OPEN-004 | Cerrado | ADR-004: perfil nominal, mezcla, duración y ráfaga; QA-MENU-004 a 017 separan percentiles, errores y propiedades de integridad. Son objetivos, no resultados. |
| OPEN-005 | Cerrado | ADR-005: modificadores por suma de cantidades, espacios por opciones seleccionadas una vez, capacidad por máximos y validación por estado. BR-MENU-011/012 dejan de estar ambiguos o basados en COUNT incorrecto. |
| OPEN-006 | Cerrado | ADR-006: revisión inmutable de producto y receta, formato requerido, no-op/reintentos, referencias fijadas y conservación para líneas existentes. REQ-MENU-021 pasa a confirmado. |
| OPEN-008 | Cerrado | ADR-008: mínimo de variantes elegibles, ausencia de precio sin candidatas y migración de DEFAULT preservando identidad histórica. |
| OPEN-002 | Pendiente | La copia y los conflictos de lotes no tienen discusión nueva. |
| OPEN-007 | Parcial | Se concretó intercambio de inventario e historia, pero no contratos completos de catálogo/cocina. |
| OPEN-009 | Parcial | Se concretaron snapshots de insumos y versiones; multiplicadores de precio de porciones y componentes repetidos siguen sin decisión. |
| OPEN-010 | Parcial | Se concretaron límites enteros de selección y archivado; otros rangos, nombres y reclasificación siguen pendientes. |

## Elecciones necesarias del arquitecto

- La anotación de disponibilidad mezclaba cambios de definición y cambios del resultado de disponibilidad. Se publican necesidades de insumos desde Menu y evaluaciones desde Inventory, evitando realimentación. La clave de Inventory es opaca: conservar correlación no significa interpretar variantes.
- La caducidad es un dato obligatorio por evaluación; no se inventa un número de segundos. Una evaluación vencida nunca habilita ventas y una nueva definición requiere evaluación propia.
- Se elige conservar historia sin purga en esta versión, sin deducir plazos legales ni períodos arbitrarios. Se separa exactitud de reversión de la política que decide si un plato preparado puede reintegrarse.
- Se elige una selección máxima por identidad ComboOption. La multiplicidad de ingredientes suministrados no consume múltiples selecciones de slot. Dos unidades de un modificador sí consumen dos selecciones de su grupo.
- Se completa el guardado parcial con protección de configuraciones ACTIVE ante ediciones y archivado de componentes requeridos. No basta con validar solo la activación inicial.
- Se fija la versión de receta en cada variante; editar una receta no migra silenciosamente todos los productos. La versión del producto cambia cuando adopta la nueva receta.
- Se completa la parte no desarrollada de OPEN-008: DEFAULT no se convierte silenciosamente en un tamaño, las nuevas identidades se validan antes de sustituir la oferta.
- Los valores de rendimiento proceden de la propuesta aportada; la mezcla reproducible y elección de extremos de los rangos (30 minutos, 60 segundos) se documentan como decisión nueva. No se utilizan las referencias web de la consultoría como obligaciones normativas.

## Revisión semántica de escenarios

| Escenario | Resultado documental exigido |
| --- | --- |
| Grupo mínimo 2 con una opción de máximo 2 | Capacidad suficiente; elegirla dos veces satisface el mínimo. |
| Configuración de máximo cero o deshabilitada | No aporta capacidad seleccionable. |
| Opción de combo que entrega seis unidades | Consume una selección; sus seis unidades participan en insumos, no en el conteo. El precio por porción continúa pendiente en OPEN-009. |
| Archivado del único componente de un slot obligatorio activo | Cambio rechazado hasta corregir o desactivar la oferta dependiente. |
| Caída de Inventory o respuesta expirada | No disponible; una respuesta vieja no rehabilita la oferta. |
| Dos solicitudes compiten por el último insumo | La proyección no garantiza venta; Inventory acepta íntegramente o rechaza cada descuento contra existencias actuales. |
| Cambio de receta después de capturar una línea | Referencias fijadas y snapshot impiden recalcular historia desde receta actual. |
| Mensaje duplicado con igual identidad | Un solo efecto; contenido distinto con la misma identidad se rechaza. |
| Reversión antes del descuento o superior a lo descontado | Rechazada; una reversión autorizada usa el original aplicado. |
| OMIT y ADD del mismo ingrediente | Se excluye aportación base y se añade la cantidad ADD, limitada al componente correspondiente. |
| Todas las variantes inelegibles | Producto no disponible; no se muestra cero ni un precio desde histórico. |
| Añadir dimensiones al producto DEFAULT | Nueva revisión con nuevas identidades; la identidad histórica de DEFAULT no cambia. |

Estos son recorridos documentales de las reglas, no pruebas ejecutadas de servicios. Las decisiones en ADR se revisaron contra los enunciados de ambas versiones. El índice y la matriz se reconstruyeron a partir de los bloques actuales. Se añadió SUPERSEDED-014 a 017 para distinguir las decisiones reemplazadas.

La comprobación estructural reproducible es [validate.py](./validate.py), con resultado en [validation.json](./validation.json). Comprueba IDs, estados, conteos, enlaces, anclas, presencia de campos y correspondencia entre idiomas. La revisión semántica anterior complementa ese control y no puede ser sustituida por él. No se realizaron pruebas de rendimiento ni integración real.
