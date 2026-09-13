[← Index](./index.md)

# Alcance y vocabulario

Esta revisión cubre el microservicio Menu y las obligaciones de sus consumidores que aparecen explícitamente en las fuentes locales, las decisiones de cierre delegadas y la solicitud explícita de UI del 2026-09-13. No cubre una especificación completa del sistema de restaurante. Las páginas son las marcas `Página` de los documentos Markdown; los contratos externos de UI faltantes se registran como abiertos, no se inventan.

Menu es propietario de definiciones comerciales, variantes, personalizaciones, combos, recetas y subtotal unitario resuelto. Orders aplica cantidades de línea y reglas externas de orden, conserva el resumen monetario histórico y orquesta el envío de preparación a Cocina. Inventory posee artículos y existencias. No se requiere contrato directo Menu–Cocina. El administrador gestiona revisiones de combos mediante lecturas y confirmación explícita. Autoridad: [ALIGN](../../docs/reviews/ers-interfaces-alignment/decisions.md); las convenciones aprobadas de autorización permanecen en interfaces.

## Alcance de las UI consumidoras

La UI de orden cubre selección de mesas asignadas, contexto de una orden existente, selección del catálogo y composición local de la preorden. La UI administrativa cubre gestión del catálogo, separación del ciclo de vida, alta/edición de items y revisión de combos pendientes. Son obligaciones de los consumidores: no convierten mesas, órdenes, inventario, imágenes ni ajustes finales de Billing en datos propiedad de Menu. Sus requisitos confirmados usan los identificadores `REQ-UI-*`, `BR-UI-*` y `DATA-UI-*`; las proyecciones externas faltantes permanecen en `OPEN-011` a `OPEN-019`.

La clasificación comercial de UI es un vocabulario de presentación distinto, con valores confirmados `DISH` (Platillo), `BEVERAGE` (Bebida), `COMBO` (Combo), `DESSERT` (Postre) y `COMPLEMENT` (Complemento). No es el mismo concepto que `categoryId` ni que el tipo de suministro de Menu.

La secuencia decisoria es: modelo inicial y crítica (`Problema-Inicial`, págs. 103–133); propuesta, revisión externa y corrección (`Modelo-Final`, págs. 6–52); revisión y recomendaciones finales (`Auditoria-3`, págs. 1–9). Los pasajes repetidos no constituyen decisiones independientes. La corrección posterior sustituye el precio delta de variante por precio absoluto y traslada precio, límite y efectos del modificador a su configuración por variante. El informe no toma el veredicto del consultor como prueba de que estén cerrados los contratos operativos.

| Concepto | Significado |
| --- | --- |
| Menu | Agrupación de productos con referencia al restaurante, nombre y descripción. |
| MenuItem | Producto comercial con metadatos, estado administrativo y clasificación de suministro. |
| MenuItemVariant | Presentación concreta vendible con precio absoluto y suministro propio. |
| Variante predeterminada | Presentación de un producto sin dimensiones seleccionables; DEFAULT es el nombre conceptual, no un identificador global impuesto. |
| VariantDimension / VariantValue | Dimensión de variación de un producto y valor que una variante selecciona. |
| STOCKED / PREPARED / COMBO | Suministro por artículo de inventario, receta o espacios de selección de componentes. |
| ComboSlot / ComboOption | Slot y opción incluida con variante STOCKED/PREPARED fijada y cantidad suministrada; sin ajuste de precio por opción. |
| ModifierGroup / ModifierOption | Grupo y opción de personalización propios de un producto. |
| VariantModifierConfig | Comportamiento de una opción en una variante: ajuste de precio, máximo seleccionable y efectos. |
| IngredientEffect | Adición medida (ADD) u omisión de ingrediente (OMIT). |
| Recipe / RecipeComponent | Receta identificada y versionada, y sus ingredientes con cantidad y unidad. |
| inventoryItemId | Referencia lógica a un artículo propiedad de Inventory; no prescribe un tipo de almacenamiento. |

Fuentes: `docs/md/Problema-Inicial.md` págs. 108–111; `docs/md/Modelo-Final.md` págs. 6–23, 26–52; `docs/md/Auditoria-3.md` págs. 8–9.

## Ampliación por cierre delegado

Se incorporan Consultoria-2 (pp. 9–16), Consultoria-rendimiento y [decisiones de cierre](../../docs/md/Decisiones-cierre-invariantes.md). Inventory calcula disponibilidad con claves opacas e insumos; Menu conserva significado de variantes y combos. Orders conserva snapshots y solicita movimientos; POS/KDS participa en el perfil de aceptación de rendimiento. Estos últimos son compromisos externos, no funciones internas de Menu. ACTIVE/INACTIVE del producto sigue siendo administrativo; las variantes añaden ARCHIVED. Las revisiones de recetas quedan fijadas explícitamente en las definiciones.
