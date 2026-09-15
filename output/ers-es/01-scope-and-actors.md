[← Index](./index.md)

# Alcance y vocabulario

Esta revisión cubre el microservicio Menu y las obligaciones de sus consumidores que aparecen explícitamente en las fuentes locales, las decisiones de cierre delegadas, la solicitud explícita de UI del 2026-09-13 y `docs/md/Auditoria-4.md`. No cubre una especificación completa del sistema de restaurante. Los números de Auditoria-4 trazan directamente el modelo consolidado; los contratos externos de UI faltantes se registran como abiertos, no se inventan.

Menu es propietario de definiciones comerciales, presentaciones de items hoja, personalizaciones, configuraciones de combo y recetas. `PREPARED` y `STOCKED` son tipos de `MenuItem` hoja que comparten `MenuItemVariant`; `COMBO` es una composición cuyas unidades vendibles son `ComboConfiguration`. Orders aplica cantidades de línea y reglas externas de orden, conserva el resumen monetario histórico y orquesta el envío de preparación a Cocina. Inventory posee artículos y existencias. No se requiere contrato directo Menu–Cocina. El administrador gestiona revisiones de combos mediante lecturas y confirmación explícita. Autoridad: [ALIGN](../../docs/reviews/ers-interfaces-alignment/decisions.md), modificada por `Auditoria-4.md`; las convenciones aprobadas de autorización permanecen en interfaces.

## Alcance de las UI consumidoras

La UI de orden cubre selección de mesas asignadas, contexto de una orden existente, selección del catálogo y composición local de la preorden. La UI administrativa cubre gestión del catálogo, separación del ciclo de vida, alta/edición de items y revisión de combos pendientes. Son obligaciones de los consumidores: no convierten mesas, órdenes, inventario, imágenes ni ajustes finales de Billing en datos propiedad de Menu. Sus requisitos confirmados usan los identificadores `REQ-UI-*`, `BR-UI-*` y `DATA-UI-*`; las proyecciones externas faltantes permanecen en `OPEN-011` a `OPEN-019`.

La clasificación comercial de UI aplica solo a registros `MenuItem` hoja y tiene los valores confirmados `DISH` (Platillo), `BEVERAGE` (Bebida), `DESSERT` (Postre) y `COMPLEMENT` (Complemento). `COMBO` se selecciona como tipo de `MenuItem`, no como clasificación comercial. Los `MenuItem` hoja usan `ItemCategory`; los combos usan el repositorio separado `ComboCategory`.

La secuencia decisoria es: modelo inicial y crítica (`Problema-Inicial`, págs. 103–133); propuesta, revisión externa y corrección (`Modelo-Final`, págs. 6–52); revisión y recomendaciones finales (`Auditoria-3`, págs. 1–9); corrección consolidada (`Auditoria-4`, items 1–46). Los pasajes repetidos no constituyen decisiones independientes. `Auditoria-4` sustituye la interpretación de configuración explícita para todas las variantes, el precio fijo de opciones de combo y el combo como variante. Los precios de variante y configuración de combo son absolutos. El informe no toma el veredicto del consultor como prueba de que estén cerrados los contratos operativos.

| Concepto                        | Significado                                                                                                                                                     |
| ------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Menu                            | Menú o catálogo propiedad del restaurante, con identidad, nombre y descripción.                                                                                 |
| MenuItem                        | Un item del catálogo dentro de un `Menu`; su tipo es `PREPARED`, `STOCKED` o `COMBO`.                                                                           |
| Item hoja                       | Un `MenuItem` de tipo `PREPARED` o `STOCKED`; se vende mediante una o más `MenuItemVariant`.                                                                    |
| PreparedItem / StockedItem      | Nombres técnicos de los tipos de `MenuItem` hoja. Ambos contienen una o más `MenuItemVariant` concretas.                                                        |
| Combo                           | Composición de `ComboConfiguration`, `ComboSlot` y `ComboOption`; no es una variante hoja.                                                                      |
| MenuItemVariant                 | Presentación concreta vendible de un `MenuItem` hoja PREPARED o STOCKED, con `unitPrice` absoluto y suministro propio.                                          |
| Variante técnica DEFAULT        | Presentación técnica cuando un `MenuItem` hoja no tiene características de presentación seleccionables por el cliente; no equivale a un default opcional de UX. |
| ComboConfiguration              | Configuración concreta vendible de un combo, con `unitPrice` absoluto y uno o más slots.                                                                        |
| VariantDimension / VariantValue | Nombres técnicos de una característica de presentación y uno de sus valores, como tamaño y Grande.                                                              |
| STOCKED / PREPARED / COMBO      | Tipos de `MenuItem` elegidos primero en Backoffice; los dos primeros son hojas y COMBO es una composición.                                                      |
| ComboSlot / ComboOption         | Slot y opción incluida con `MenuItemVariant` hoja fijada, `quantity` positiva y contribución `priceDelta` opcional.                                             |
| ModifierGroup / ModifierOption  | Grupo y opción de personalización de un `MenuItem` hoja; `ModifierOption` contiene el comportamiento general/default.                                           |
| VariantModifierConfig           | Excepción opcional de una opción sobre una variante hoja; solo existe cuando difiere del default.                                                               |
| ResolvedVariantModifier         | Proyección publicada de comportamiento efectivo para POS/KDS; elimina resolver default/excepción en la toma de orden.                                           |
| IngredientEffect                | Adición medida (ADD) u omisión de ingrediente (OMIT).                                                                                                           |
| Recipe / RecipeComponent        | Receta identificada y versionada, y sus ingredientes con cantidad y unidad.                                                                                     |
| inventoryItemId                 | Referencia lógica a un artículo propiedad de Inventory; no prescribe un tipo de almacenamiento.                                                                 |
| MenuItem.status                 | Decisión administrativa administrador activa/desactiva                                                                                                          |
| Variant.status                  | Ciclo de vida de la presentación variante retirada/archivada                                                                                                    |
| eligible                        | Validez comercial/estructural para nueva venta falta configuración, referencia archivada                                                                        |
| available                       | Posibilidad de servirla ahora falta queso, Coca sin stock                                                                                                       |
| REVIEW_REQUIRED                 | Hay dependencias de combo que deben revisarse cambió una variante referenciada                                                                                  |

Fuentes: `docs/md/Problema-Inicial.md` págs. 108–111; `docs/md/Modelo-Final.md` págs. 6–23, 26–52; `docs/md/Auditoria-3.md` págs. 8–9; `docs/md/Auditoria-4.md` items 1–46.

## Ampliación por cierre delegado

Se incorporan Consultoria-2 (pp. 9–16), Consultoria-rendimiento y [decisiones de cierre](../../docs/md/Decisiones-cierre-invariantes.md). Inventory calcula disponibilidad con claves opacas e insumos; Menu conserva el significado de presentaciones hoja y configuraciones de combo. Orders conserva snapshots y solicita movimientos; POS/KDS participa en el perfil de aceptación de rendimiento. Estos últimos son compromisos externos, no funciones internas de Menu. El estado ACTIVE/INACTIVE del `MenuItem` sigue siendo administrativo; las presentaciones hoja añaden ARCHIVED. Las revisiones de recetas quedan fijadas explícitamente en las definiciones. Una línea de orden hoja conserva su presentación y una línea de combo conserva su `ComboConfiguration`.
