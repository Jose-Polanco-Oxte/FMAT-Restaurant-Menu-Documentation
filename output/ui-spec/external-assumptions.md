# Supuestos externos para los mockups

**Revisión:** 2 — 2026-09-13  
**Estado:** Supuestos de diseño para poder construir la UI; no son contratos aprobados ni modifican automáticamente la ERS o las interfaces de Menu.

## 1. Propósito

Este documento convierte los datos que la UI probablemente necesita, pero que todavía no tienen un contrato completo en `output/interfaces/`, en proyecciones externas explícitas. Se pueden utilizar como datos de ejemplo y como forma provisional de organizar los mockups.

Cada supuesto distingue:

- lo mínimo que la vista necesita representar;
- el proveedor probable;
- la estructura propuesta;
- lo que todavía debe confirmarse antes de implementar una integración.

## Correspondencia con la ERS canónica

Los supuestos de integración se mantienen aquí con detalle de mockup y se vinculan con los puntos externos de la ERS:

| Supuesto | Registro en la ERS | Estado de la decisión de UI |
|---|---|---|
| `ASSUMPTION-EXT-001` | [`OPEN-011`](../ers/09-conflicts-and-open-items.md#open-011) | Confirmada; falta contrato de Sala |
| `ASSUMPTION-EXT-002` | [`OPEN-012`](../ers/09-conflicts-and-open-items.md#open-012) | Confirmada; falta contrato de Orders |
| `ASSUMPTION-EXT-003` | [`OPEN-013`](../ers/09-conflicts-and-open-items.md#open-013) | Clasificación confirmada; falta catálogo/mapeo |
| `ASSUMPTION-EXT-004` | [`OPEN-014`](../ers/09-conflicts-and-open-items.md#open-014) | Confirmada; falta proyección administrativa |
| `ASSUMPTION-EXT-005` | [`OPEN-015`](../ers/09-conflicts-and-open-items.md#open-015) | Confirmada; falta persistencia de retiro suave |
| `ASSUMPTION-EXT-006` | Sin OPEN adicional | Contrato E-19/E-20/E-21 vigente; estado local confirmado |
| `ASSUMPTION-EXT-007` | [`OPEN-016`](../ers/09-conflicts-and-open-items.md#open-016) | Confirmada; falta semántica coordinada de guardado |
| `ASSUMPTION-EXT-008` | [`OPEN-017`](../ers/09-conflicts-and-open-items.md#open-017) | Confirmada; faltan detalles de Inventory |
| `ASSUMPTION-EXT-009` | [`OPEN-018`](../ers/09-conflicts-and-open-items.md#open-018) | Confirmada; falta proveedor de imágenes |
| `ASSUMPTION-EXT-010` | [`OPEN-019`](../ers/09-conflicts-and-open-items.md#open-019) | Acumulado confirmado; falta contrato final de Billing |

Los nombres de campos son conceptuales. No fijan rutas, transporte, persistencia, códigos de error, paginación ni límites numéricos.

## 2. Convenciones comunes

- Las identidades (`tableId`, `orderId`, `orderLineId`, `categoryId`, `imageId`) son opacas.
- `null` significa ausencia conocida del dato; no debe sustituirse por una cadena vacía o por cero sin una regla.
- Los importes incluyen `currency`.
- Las cantidades físicas incluyen `unit`; las cantidades de selección y de línea son enteros conceptuales.
- Las referencias a MenuItem incluyen `menuItemId`, `menuItemVersion` y `variantId` cuando la selección necesita fijar una presentación.
- Una proyección externa para UI no se convierte en autoridad si el servicio propietario devuelve posteriormente un valor diferente.

## 3. Supuestos

### ASSUMPTION-EXT-001 — Proyección de mesas asignadas

**Proveedor supuesto:** Sala, posiblemente enriquecido con una referencia de Orders.

**Necesidad de UI:** `V-MES-01` debe mostrar solamente las mesas asignadas al mesero y distinguir si cada mesa tiene una orden.

**Proyección propuesta:**

| Campo | Tipo conceptual | Uso |
|---|---|---|
| `tableId` | ID opaco | Identifica la mesa. |
| `displayLabel` | Texto | Número o nombre visible. |
| `assigned` | Booleano o pertenencia de la lista | Permite representar la asignación vigente. |
| `orderState` | `WITHOUT_ORDER` / `WITH_ORDER` | Estado mínimo requerido por la vista. |
| `activeOrderId` | ID o `null` | Abre la orden existente cuando aplica. |
| `orderSummary` | Objeto o `null` | Resumen opcional para tarjeta: importe, líneas u otro dato que Orders autorice. |

**Regla de presentación supuesta:** la lista recibida ya está limitada al mesero autenticado o el proveedor devuelve la asignación que permite filtrarla. La UI no inventa un límite de mesas.

**Debe confirmarse:** propietario de `orderState`, instante de consistencia, comportamiento cuando Sala y Orders discrepan y contrato de actualización.

### ASSUMPTION-EXT-002 — Proyección de orden activa y agregado

**Proveedor supuesto:** Orders.

**Necesidad de UI:** `V-MES-02` debe mostrar una orden existente y `V-MES-03` debe preparar líneas nuevas para crear o agregar a una orden.

**Proyección propuesta:**

```text
ActiveOrderProjection
├── orderId
├── tableId
├── status
├── lines[]
│   ├── orderLineId
│   ├── menuItemId
│   ├── menuItemVersion
│   ├── variantId
│   ├── displayName
│   ├── variantLabel
│   ├── quantity
│   ├── selectionSummary
│   ├── unitSubtotal
│   ├── lineTotal
│   └── currency
└── totals
    ├── subtotal
    ├── adjustments[]
    ├── total
    └── currency
```

**Operaciones supuestas para la UI:**

- crear una orden para una mesa sin orden;
- agregar una o varias líneas a una orden existente;
- devolver la proyección posterior o un error que deje intacto el borrador local.

**Regla de autoridad supuesta:** Menu aporta `unitSubtotal` por unidad mediante E-16; Orders calcula `lineTotal`, `totals` y cualquier regla externa de la orden confirmada. Para la captura de la preorden, la UI calcula el acumulado de sus líneas como `Σ(quantity × resolvedUnitSubtotal)`; Billing conserva la autoridad sobre los ajustes posteriores del importe final.

**Debe confirmarse:** estados de línea, edición de líneas ya confirmadas, política de duplicación, permisos del mesero, reglas de impuestos/descuentos/cargos y contrato de creación/agregado.

### ASSUMPTION-EXT-003 — Fuente externa de categorías y mapeo de clasificación visual

**Proveedor supuesto:** catálogo administrativo compartido, Menu o un BFF autorizado.

**Necesidad de UI:** ambos catálogos deben filtrar por categoría, clasificación y texto, y el editor debe permitir seleccionar la clasificación solicitada.

**Proyección propuesta:**

| Campo | Tipo conceptual | Valores/uso supuesto |
|---|---|---|
| `categoryId` | ID opaco | Identidad usada por E-02 y `MenuItemWrite`. |
| `categoryLabel` | Texto | Nombre visible de la categoría. |
| `classification` | Enumeración confirmada de UI | `DISH`, `BEVERAGE`, `COMBO`, `DESSERT`, `COMPLEMENT`. |
| `classificationLabel` | Etiqueta confirmada de UI | `Platillo`, `Bebida`, `Combo`, `Postre`, `Complemento`. |
| `sortOrder` | Número o posición | Orden visual, si se necesita. |
| `active` | Booleano | Permite ocultar opciones de categoría que ya no se ofrecen. |

**Regla confirmada para la UI:** `classification` es una clasificación comercial y permanece independiente de `fulfillmentType`, cuyos valores contractuales son `STOCKED`, `PREPARED` y `COMBO`. No se establece una correspondencia automática entre ambos.

**Debe confirmarse externamente:** quién mantiene el catálogo de categorías, qué `classification` corresponde a cada `categoryId`, si una categoría puede tener más de una clasificación y cómo se versionan los cambios de etiquetas. La existencia de las cinco clasificaciones y sus etiquetas no es un punto abierto de la UI.

### ASSUMPTION-EXT-004 — Proyección administrativa filtrable

**Proveedor supuesto:** extensión de E-19 en Menu o un adaptador administrativo.

**Necesidad de UI:** `V-ADM-01` debe usar los mismos filtros del catálogo de mesero y mostrar en una tarjeta los datos necesarios para gestionar un item.

**Proyección propuesta por tarjeta:**

| Campo | Fuente probable | Uso |
|---|---|---|
| `menuItemId` | Menu | Identidad y apertura del detalle. |
| `name` | Menu | Texto principal. |
| `imageRef` | Menu | Imagen o estado sin imagen. |
| `categoryId` / `categoryLabel` | Menu + catálogo de categorías | Filtro y badge. |
| `classification` | Clasificación confirmada de UI; mapeo externo | Filtro y badge. |
| `fulfillmentType` | Menu | Tipo de suministro. |
| `status` | Menu | `ACTIVE` o `INACTIVE`, y `ARCHIVED` si se adopta la extensión de ciclo de vida. |
| `reviewState` | Menu, solo combos | `UP_TO_DATE` o `REVIEW_REQUIRED`. |
| `pendingVariantIds` | Menu, solo combos | Indicador de variantes afectadas. |
| `fromPrice` | Menu/derivación | Precio inicial o `null`. |
| `eligible` | Menu/derivación | Disponibilidad comercial actual, si la tarjeta la necesita. |

**Filtros supuestos:** texto, `categoryId`, `classification`, `fulfillmentType`, `status` y `reviewState`, conservados al paginar.

**Alternativa de implementación supuesta:** E-19 podría ampliarse; si no, el adaptador podría combinar la página administrativa con E-08/E-03. La segunda opción no debe considerarse eficiente ni contractual hasta que se confirme.

**Debe confirmarse:** la forma definitiva del listado y si la búsqueda se resuelve en Menu, en un BFF o en la UI.

### ASSUMPTION-EXT-005 — Archivo lógico y operaciones de eliminación suave

**Proveedor supuesto:** Menu, mediante una ampliación del ciclo de vida administrativo.

**Necesidad de UI:** el administrador quiere un apartado de archivados y acciones de eliminar todos, eliminar seleccionados o eliminar uno por uno, entendiendo “eliminar” como retiro suave en la base de datos.

**Proyección de ciclo de vida propuesta:**

| Campo | Valor supuesto | Uso |
|---|---|---|
| `lifecycleState` | `ACTIVE`, `INACTIVE`, `ARCHIVED` | Separar archivado de desactivado. |
| `archivedAt` | Fecha/hora o `null` | Informar cuándo se archivó. |
| `archivedBy` | ID o `null` | Auditoría visual si el proveedor lo autoriza. |
| `archivedReason` | Texto/código o `null` | Explicar el retiro, si existe. |

**Operaciones de UI supuestas:** para retirar un item desde un apartado no archivado, `ARCHIVE_ONE`; dentro de `ARCHIVED`, `SOFT_DELETE_ONE`, `SOFT_DELETE_SELECTED` y `SOFT_DELETE_ALL_MATCHING`. La última significa todos los resultados del filtro vigente, no necesariamente todos los items del restaurante.

**Restricción actual:** la interfaz vigente de Menu solo define `ACTIVE/INACTIVE` para MenuItem y `ARCHIVED` para variantes; no define borrado ni reactivación de variantes archivadas. Este supuesto requiere una decisión de alineación antes de implementarse como contrato.

**Debe confirmarse:** si `ARCHIVED` se agrega al producto raíz, si un archivado puede restaurarse, qué ocurre con referencias históricas y si la acción “eliminar” será realmente un archivo lógico.

### ASSUMPTION-EXT-006 — Proyección de trabajo de revisión

**Proveedor supuesto:** Menu mediante E-19/E-20/E-21; el estado de selección de filas pertenece a la UI.

**Necesidad de UI:** la edición de un combo pendiente debe verse distinta y permitir revisar sus cambios antes de confirmar.

**Proyección de trabajo propuesta:**

```text
ReviewWorkItem
├── menuItemId
├── menuItemVersion
├── variantId
├── reviewToken
├── reviewTokenExpiresAt
├── changes[]
│   ├── changeId
│   ├── slotId
│   ├── optionId
│   ├── component
│   ├── observedVersion
│   └── reasons[]
└── localVerificationState
```

`localVerificationState` es un supuesto de presentación: `UNSEEN`, `SEEN` o `SELECTED_FOR_CONFIRMATION`. No se envía como `verified` a Menu.

**Regla aplicada para la UI:** la UI muestra filas de cambios y permite marcarlas localmente para orientar al administrador, pero la confirmación real se envía por `variantId + reviewToken` a E-21. Después debe refrescar E-20.

**Debe confirmarse externamente solo si se cambia el alcance:** un contrato de confirmación por componente. Para esta especificación, los componentes son filas informativas y las variantes son las unidades confirmables.

### ASSUMPTION-EXT-007 — Resultado de guardado conjunto de Recipe y MenuItem

**Proveedor supuesto:** un orquestador de backoffice o la propia UI coordinando Menu.

**Necesidad de UI:** el wizard de PREPARED permite editar receta y configuración del item en una experiencia continua, aunque actualmente existen operaciones separadas.

**Resultado visual propuesto:**

```text
ItemEditorCommitResult
├── overallState: COMMITTED | FAILED | REQUIRES_ATTENTION
├── menuItem: { menuItemId, menuItemVersion, status, warnings[] }
├── recipes[]: { recipeId, recipeVersion, status }
├── violations[]
└── correlationId
```

**Regla de UI supuesta:** la vista no etiqueta como “guardado” un resultado `REQUIRES_ATTENTION`; conserva el borrador y muestra qué operación terminó o falló.

**Debe confirmarse:** si se necesita una operación transaccional nueva, si la UI coordina E-11/E-13 y E-09 por separado, y qué compensación existe ante un fallo intermedio.

### ASSUMPTION-EXT-008 — Selector de Inventory

**Proveedor supuesto:** Inventory.

**Necesidad de UI:** seleccionar ingredientes para recetas/efectos y referencias para variantes STOCKED.

**Proyección propuesta:**

| Campo | Uso |
|---|---|
| `inventoryItemId` | Identidad que Menu conserva. |
| `name` | Etiqueta del selector. |
| `unit` | Unidad de la cantidad física. |
| `itemKind` | Distinguir ingrediente y referencia STOCKED, si Inventory lo define. |
| `query` | Texto de búsqueda. |
| `nextCursor` | Continuación, si el proveedor pagina. |
| `quantityRules` | Límites/precisión, si el proveedor los expone. |

**Regla supuesta:** la UI no mantiene un catálogo paralelo de unidades ni convierte cantidades por su cuenta.

**Debe confirmarse:** rutas, búsqueda, paginación, precisión, magnitud máxima, conversiones y comportamiento ante baja o cambio de unidad.

### ASSUMPTION-EXT-009 — Proveedor de imágenes

**Proveedor supuesto:** servicio de archivos/imágenes o infraestructura de la aplicación.

**Necesidad de UI:** el item puede mostrar una imagen y el editor puede seleccionar o sustituirla.

**Proyección propuesta:**

| Campo | Uso |
|---|---|
| `imageId` | Identidad del recurso multimedia. |
| `imageRef` | Referencia que finalmente guarda Menu. |
| `previewUrl` | Previsualización temporal o autorizada. |
| `altText` | Texto alternativo, si la aplicación lo exige. |
| `uploadState` | `EMPTY`, `UPLOADING`, `READY`, `FAILED`. |

**Regla supuesta:** Menu recibe solo `imageRef`; los bytes y el ciclo de carga pertenecen al proveedor externo.

**Debe confirmarse:** proveedor, permisos, límites de archivo, validación, eliminación y duración de URLs de previsualización.

### ASSUMPTION-EXT-010 — Proyección monetaria de preorden y ajustes finales

**Proveedor supuesto:** la UI para el borrador y Orders para la orden existente o confirmada; Billing para los ajustes del importe final.

**Necesidad de UI:** mostrar el precio acumulado al seleccionar items y el total proyectado al agregar a una orden.

**Valores propuestos:**

| Campo | Autoridad supuesta | Uso |
|---|---|---|
| `unitSubtotal` | Menu/E-16 | Precio de una unidad ya resuelta. |
| `quantity` | UI/Orders | Cantidad de la línea. |
| `lineCost` | UI | Costo de línea: `quantity × resolvedUnitSubtotal`. Es parte del costo acumulado de la preorden. |
| `preorderTotal` | UI | Costo acumulado de la preorden: `Σ(quantity × resolvedUnitSubtotal)`. |
| `existingOrderTotal` | Orders | Total actual de una orden existente. |
| `projectedOrderTotal` | Orders o UI según reglas | Total después de agregar líneas. |
| `currency` | Configuración monetaria | Moneda común de los importes. |

**Regla confirmada para la UI:** el precio del catálogo representa el costo de ordenar el item con la configuración seleccionada. La UI muestra `lineCost` y `preorderTotal` como costo de línea y acumulado de la preorden, respectivamente. No son el cobro final: Billing podrá aplicar posteriormente descuentos, impuestos, cargos, redondeo u otros ajustes de su contrato.

**Debe confirmarse externamente:** el contrato de Billing para descuentos, impuestos, cargos, redondeo y demás ajustes del importe final; también la respuesta autoritativa que Orders utilizará al confirmar o agregar la orden. La fórmula del acumulado de la preorden no está abierta.

## 4. Estado de los supuestos

| ID | Puede usarse para mockup | Requiere contrato antes de implementar |
|---|---:|---:|
| `ASSUMPTION-EXT-001` | Sí | Sí |
| `ASSUMPTION-EXT-002` | Sí | Sí |
| `ASSUMPTION-EXT-003` | Sí | Sí |
| `ASSUMPTION-EXT-004` | Sí | Sí |
| `ASSUMPTION-EXT-005` | Sí | Sí; implica cambio de ciclo de vida |
| `ASSUMPTION-EXT-006` | Sí | Sí, solo si se desea confirmar por componente |
| `ASSUMPTION-EXT-007` | Sí | Sí, si se requiere atomicidad |
| `ASSUMPTION-EXT-008` | Sí | Sí |
| `ASSUMPTION-EXT-009` | Sí | Sí |
| `ASSUMPTION-EXT-010` | Sí | Sí |

Estos supuestos permiten continuar con el diseño visual sin afirmar que los contratos externos ya existen.
