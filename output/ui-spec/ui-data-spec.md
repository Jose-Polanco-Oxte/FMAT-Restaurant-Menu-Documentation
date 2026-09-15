# Especificación de vistas y datos para la UI de mockups

**Sistema:** FMAT Restaurant — superficies de operación y administración de Menu  
**Revisión:** 3
**Fecha:** 2026-09-15
**Alcance:** datos visibles y estados de las vistas; no define el flujo de navegación.

## 1. Propósito y forma de lectura

Este documento especifica qué información debe poder representarse en los mockups y cómo se organiza conceptualmente. No prescribe una tecnología de frontend, una distribución de menú, rutas de pantalla ni una secuencia de navegación.

Las vistas se registran independientemente del microservicio que posea cada dato. Cada dato se clasifica según su autoridad:

| Marca | Significado |
|---|---|
| `MENU` | Dato respaldado por la ERS o por un contrato de entrada de Menu. |
| `UI` | Estado temporal o decisión de presentación aportada para la UI; no es persistencia de Menu. |
| `EXTERNO` | Dato que debe provenir de Sala, Orders, Inventory u otro proveedor. |
| `DERIVADO` | Valor calculado a partir de datos respaldados, sin convertirse en una nueva autoridad. |
| `UI-OPEN` | Falta de contrato o decisión necesaria para fijar el dato con precisión. |

### 1.1 Fuentes normativas

- ERS canónica: [`output/ers/`](../ers/index.md), revisión 11.
- Interfaces actuales: [`output/interfaces/`](../interfaces/index.md), incluyendo sus esquemas JSON.
- La formalización normativa de las decisiones confirmadas de UI está en `REQ-UI-*`, `BR-UI-*` y `DATA-UI-*`; los contratos externos faltantes están en `OPEN-011` a `OPEN-019`.
- La solicitud del usuario aporta las responsabilidades de las vistas de mesero, las vistas administrativas y la distinción CREATE/EDIT. Estas decisiones de UI se distinguen de los datos que la documentación técnica no define.
- [`secuence-v5.md`](./old-version/secuence-v5.md) se usa únicamente para reconocer la intención anterior. No prevalece sobre la ERS ni sobre las interfaces actuales.

### 1.2 Aplanamiento de la especificación

Este documento reproduce directamente los datos, campos, estados y reglas que necesita el mockup. Las menciones a E-01–E-21, esquemas o documentos de la ERS son únicamente trazabilidad; no es necesario consultar otro documento para saber qué debe representarse en una vista.

### 1.3 Límites importantes

Menu administra `Menu`, `MenuItem`, variantes, modificadores, combos y recetas. Resuelve una selección vendible, pero no crea líneas de Orders, no confirma ventas, no descuenta existencias y no administra mesas. [Frontera de Menu](../interfaces/01-arquitectura.md)

La UI puede mostrar datos de varias fuentes en una misma vista. Eso no convierte esos datos en propiedad de Menu ni autoriza a inventar un contrato entre servicios.

## 2. Registro de vistas y composiciones

Las siguientes son vistas lógicas. Un estado o modo que cambia datos o controles relevantes se registra como composición visual, no necesariamente como una vista adicional.

| ID | Vista | Actor principal | Fuente dominante | Composiciones necesarias |
|---|---|---|---|---|
| `V-MES-01` | Mesas asignadas | Mesero | Sala | `WITHOUT_ORDER`, `WITH_ORDER`, vacío |
| `V-MES-02` | Orden actual | Mesero | Orders/Sala | orden existente, sin líneas, error de lectura |
| `V-MES-03` | Selección y configuración de items | Mesero | Menu + UI + Orders | `CREATE_ORDER`, `APPEND_TO_ORDER`, catálogo vacío, selección no disponible |
| `O-MES-01` | Configuración de item | Mesero | Menu + UI | item simple, item preparado, combo, edición de línea |
| `V-ADM-01` | Gestión del catálogo | Administrador | Menu | `ACTIVE`, `INACTIVE`, `REVIEW_REQUIRED`, `ARCHIVED`, variantes archivadas en el detalle |
| `V-ADM-02` | Editor de MenuItem | Administrador | Menu + Inventory | `CREATE`, `EDIT`, `STOCKED`, `PREPARED`, `COMBO` |
| `V-ADM-03` | Revisión administrativa de combo | Administrador | Menu | pendiente, atendida, pendiente nuevamente por cambio concurrente |
| `V-ADM-04` | Confirmación visual de guardado | Administrador | UI | alta guardada, edición guardada, guardado con advertencias |

`V-MES-01` y `V-MES-02` no pueden recibir sus datos completos de los contratos actuales de Menu. Se incluyen porque son superficies solicitadas por el usuario y se marcan como dependencias externas.

## 3. Vocabulario canónico para los mockups

### 3.1 MenuItem y sus presentaciones

| Concepto | Datos que representa | Uso visual |
|---|---|---|
| `Menu` | `menuId`, `restaurantId`, `name`, `description` | Contexto del catálogo. |
| `MenuItem` | `menuItemId`, `menuItemVersion`, `menuId`, `name`, `description`, `imageRef`, `categoryId`, `status`, `fulfillmentType` | Producto comercial y su estado. |
| `MenuItemVariant` | `variantId`, `status`, `dimensionValueIds`, `unitPrice`, `fulfillment`, `modifierConfigs` | Presentación vendible concreta. |
| Dimensión | `dimensionId`, nombre y valores (`valueId`, nombre) | Elección como tamaño u otra dimensión definida por el producto. |
| Estado de producto | `ACTIVE` o `INACTIVE` | Filtrado y acciones administrativas. No equivale a stock. |
| Estado de variante | `ACTIVE`, `INACTIVE` o `ARCHIVED` | Disponibilidad administrativa de una presentación. `ARCHIVED` no se reactiva en esta versión. |
| Tipo de `MenuItem` (`fulfillmentType`) | `STOCKED`, `PREPARED` o `COMBO` | Primera decisión del wizard; determina el editor y la estructura de `fulfillment`. Es inmutable desde la creación. |

`categoryId` es una referencia de categoría cuyo catálogo y nombres provienen de una dependencia externa. La clasificación visual confirmada para la UI se detalla en la sección 3.6. `fulfillmentType` sí tiene las tres enumeraciones anteriores, pero no es equivalente a las etiquetas de negocio `Platillo`, `Bebida`, `Postre` o `Complemento`.

### 3.2 Suministro

| Tipo | Datos de la variante | Datos visibles que pueden derivarse |
|---|---|---|
| `STOCKED` | `inventoryItemId`, `quantity`, `unit` | Referencia y consumo definido; no stock exacto. |
| `PREPARED` | `recipeId`, `recipeVersion` o una receta resuelta según contexto | Nombre/revisión de receta y sus componentes, cuando se obtengan por el contrato de Recipe. |
| `COMBO` | `slots[]` | Slots, opciones, cantidades suministradas y referencias fijadas a componentes. |

Las cantidades físicas son positivas y llevan unidad. Su precisión, magnitud, conversión y rutas concretas de Inventory continúan dependiendo del contrato de Inventory.

### 3.3 Modificadores

Un `ModifierGroup` tiene `groupId`, nombre, `minSelections`, `maxSelections` y opciones. Cada opción tiene `optionId` y nombre.

Una `ModifierConfig` vincula una opción a una variante mediante `configId`, `optionId`, `enabled`, `priceDelta`, `maxQuantity` y `effects`.

Los efectos son explícitos:

| Operación | Datos | Presentación |
|---|---|---|
| `ADD` | `inventoryItemId`, `quantity`, `unit` | Aumento de ingrediente y precio relativo configurado, si aplica. |
| `OMIT` | `inventoryItemId` | Omisión de ingrediente; no se expresa como cantidad negativa y no reduce el precio base. |

`priceDelta` es un ajuste relativo de la opción de modificador. No es el precio base de la variante ni un total cobrado.

### 3.4 Combos

Cada variante de combo contiene `ComboSlot` con `slotId`, nombre, `minSelections`, `maxSelections`, `options` y `baseOptionIds`.

Cada `ComboOption` contiene `optionId`, `enabled`, una referencia fija `component` a `menuItemId`, `menuItemVersion` y `variantId`, y `suppliedQuantity`.

La selección base (`baseOptionIds`) es una referencia administrativa para comparar precios de componentes. No es una selección predeterminada del cliente. Las opciones incluidas no agregan cargos al precio del combo; cada variante COMBO tiene `unitPrice` explícito.

### 3.5 Recetas

Una receta contiene `recipeId`, `recipeVersion`, nombre y componentes. Cada componente identifica `inventoryItemId`, `quantity` y `unit`.

Las revisiones de Recipe son inmutables. Crear o editar una receta y adoptar una revisión en una variante son operaciones conceptualmente distintas: la adopción requiere editar explícitamente el `MenuItem`.

### 3.6 Clasificación visual confirmada

La UI deberá disponer de una clasificación comercial independiente de `categoryId` y de `fulfillmentType`. Sus valores confirmados son:

| Valor estable | Etiqueta visible |
|---|---|
| `DISH` | Platillo |
| `BEVERAGE` | Bebida |
| `COMBO` | Combo |
| `DESSERT` | Postre |
| `COMPLEMENT` | Complemento |

Esta clasificación es obligatoria para los filtros y badges de las vistas de catálogo. Su existencia está confirmada por la decisión de UI del solicitante. El proveedor del catálogo de categorías y la forma de relacionar cada `categoryId` con una clasificación permanecen como supuesto externo, no la existencia de la clasificación.

## 4. Datos de contexto comunes

Estos datos pueden estar presentes en el shell o en la composición de una vista, aunque no todos pertenecen al payload de Menu.

| Dato | Marca | Regla de representación |
|---|---|---|
| `restaurantId` | `MENU` | Identifica el ámbito del recurso; no es el ID del microservicio. |
| `menuId` | `MENU` | Identifica la agrupación `Menu` cuyo catálogo se muestra. |
| Identidad del actor | `EXTERNO`/autorización | Puede mostrarse en el shell si la aplicación la recibe. La interfaz de Menu documenta permisos, no un perfil visual completo. |
| Permiso o modo operativo | `UI`/autorización | Controla qué acciones se muestran; no debe confundirse con `status` o `eligible`. |
| Moneda | `MENU`/configuración externa | Se muestra con cada importe. `MXN` en los ejemplos no fija la moneda universal. |
| Error o advertencia | `MENU` | Mostrar `code`, `message` y, cuando exista, cada `violation` con `path`, `entityId`, `details`. |

## 5. `V-MES-01` — Mesas asignadas

### 5.1 Responsabilidad

Permitir que el mesero vea únicamente las mesas que tiene asignadas y distinga las que no tienen orden de las que ya tienen una orden. La asignación, el estado de la mesa y la relación con la orden pertenecen a Sala/Orders, no a Menu.

### 5.2 Datos por mesa

| Campo de UI | Marca | Obligatorio para el mockup | Observación |
|---|---|---:|---|
| `tableId` | `EXTERNO` | Sí | Identidad de Sala; contrato no documentado aquí. |
| Etiqueta o número visible | `EXTERNO` | Sí | Nombre exacto del campo pendiente. |
| Asignación al mesero | `EXTERNO` | Sí para construir la lista | La lista debe venir ya limitada por Sala o por el componente autorizado. |
| Estado visual `WITHOUT_ORDER` / `WITH_ORDER` | `DERIVADO` | Sí | Derivado de la relación de Sala con Orders; no es `MenuItem.status`. |
| Referencia de orden activa | `EXTERNO` | Solo para `WITH_ORDER` | Se necesita para abrir la orden y agregar productos. |
| Resumen breve de la orden | `EXTERNO` | Opcional visualmente | Total, cantidad de líneas o última actividad requieren contrato de Orders. |

### 5.3 Estados de la vista

- Lista de mesas asignadas con estado `WITHOUT_ORDER`.
- Lista de mesas asignadas con estado `WITH_ORDER`.
- Lista vacía con causa distinguible: no hay mesas asignadas o no hay mesas en el filtro seleccionado, si Sala proporciona esa distinción.
- Fallo o indisponibilidad de Sala.

La cantidad limitada de mesas asignadas no debe representarse como una cuota fija inventada en la UI. El conjunto visible debe ser el recibido desde Sala.

## 6. `V-MES-02` — Orden actual

### 6.1 Responsabilidad

Mostrar la orden existente de la mesa seleccionada y ofrecer una entrada clara para agregar nuevos productos. La orden y sus líneas son propiedad de Orders.

### 6.2 Datos requeridos

| Campo de UI | Marca | Observación |
|---|---|---|
| `orderId` | `EXTERNO` | Menu no lo recibe en E-16. |
| `tableId` y etiqueta | `EXTERNO` | Se conserva el contexto proveniente de Sala. |
| Estado de la orden | `EXTERNO` | No existe enumeración documentada en este repositorio. |
| Líneas confirmadas | `EXTERNO` | El contrato de Orders debe definir identidad, producto, cantidad, selección y estado de cada línea. |
| Resumen de personalización | `EXTERNO`/`MENU` | Puede formarse con nombres de selección o con el snapshot retenido por Orders. |
| Precio de línea y total actual | `EXTERNO` | Menu solo entrega `unitSubtotal` por unidad en E-16. |
| Acción `Agregar productos` | `UI` | Requisito de la vista solicitado por el usuario. |

Las líneas ya confirmadas deben distinguirse visualmente de las selecciones nuevas. No se debe presentar una modificación de la orden confirmada como si fuera un cambio local de Menu.

### 6.3 Precio visible y acumulado de la preorden

El precio que se muestra en el catálogo representa el costo de ordenar el item con la configuración seleccionada. La UI deberá calcular el acumulado de la preorden como la suma de los costos de sus líneas configuradas:

```text
lineCost      = quantity × resolvedUnitSubtotal
preorderTotal = Σ lineCost
```

`resolvedUnitSubtotal` incluye el precio de la variante y los extras de los modificadores elegidos. En una tarjeta sin configuración resuelta, `fromPrice` representa el menor precio base de las variantes elegibles; al elegir variante y configuración se utiliza el importe resuelto correspondiente.

Este `preorderTotal` es el importe acumulado que debe visualizarse durante la toma de orden. No es necesario esperar a Billing para sumarlo. Billing podrá aplicar posteriormente los ajustes propios del importe final, pero esos ajustes no alteran el significado del acumulado mostrado en esta vista.

## 7. `V-MES-03` — Selección y configuración de items

### 7.1 Modos visuales

| Modo | Encabezado/contexto | Datos externos adicionales |
|---|---|---|
| `CREATE_ORDER` | Mesa sin orden; nueva orden | Identidad de mesa y contexto de Sala. |
| `APPEND_TO_ORDER` | Mesa con orden; agregar productos | `orderId` y resumen de Orders. |

Ambos modos comparten el catálogo de Menu y el panel temporal de selección. El panel no es una entidad persistida de Menu.

### 7.2 Fuente del catálogo

La lectura comercial normal es E-02:

`GET /v1/restaurants/{restaurantId}/catalog/menu-items?menuId=...`

Sus tarjetas contienen:

| Campo | Marca | Uso |
|---|---|---|
| `menuItemId` | `MENU` | Identidad estable para consultar el detalle y resolver. |
| `menuItemVersion` | `MENU` | Definición comercial fijada para la selección. |
| `name` | `MENU` | Texto principal. |
| `description` | `MENU` | Texto secundario o detalle. |
| `imageRef` | `MENU` | Referencia; no contiene bytes de imagen. |
| `categoryId` | `MENU` | Identidad de categoría. |
| `classification` | `EXTERNO`/`UI` | Badge y filtro obligatorio con uno de los cinco valores confirmados para items hoja; un COMBO se identifica por `fulfillmentType=COMBO` y no recibe una clasificación de item hoja. El proveedor y el mapeo desde `categoryId` son externos. |
| `eligible` | `MENU` | Si es falso, la tarjeta no debe ofrecerse como seleccionable. |
| `fromPrice` | `MENU` | Para un item hoja, menor `MenuItemVariant.unitPrice` elegible; para un COMBO, menor `ComboConfiguration.unitPrice` elegible; `null` si no existe una unidad elegible. |

E-02 solo devuelve `MenuItem ACTIVE`. Puede devolver un item no elegible con `eligible=false` y `fromPrice=null`; no divulga stock exacto.

### 7.3 Búsqueda y filtros

| Filtro solicitado | Estado de contrato |
|---|---|
| Búsqueda por nombre | Respaldado por `query`, coincidencia parcial sin distinguir mayúsculas en E-02. |
| Categoría | Respaldado por `categoryId` exacto en E-02. El catálogo de categorías y sus etiquetas no está definido. |
| Tipo `STOCKED`, `PREPARED`, `COMBO` | Existe en el detalle de MenuItem, pero no en `MenuItemCard` de E-02. Requiere hidratar E-03, ampliar la respuesta o aceptar que no sea un filtro contractual. |
| Clasificación `Platillo`, `Bebida`, `Combo`, `Postre`, `Complemento` | Confirmada como clasificación visual; los items hoja usan `DISH`, `BEVERAGE`, `DESSERT` o `COMPLEMENT`, y `COMBO` se representa por su tipo contractual. La fuente externa de categorías y el mapeo de `categoryId` permanecen en `ASSUMPTION-EXT-003`. |

No se debe presentar como hecho que `PREPARED=Platillo` o que `STOCKED=Bebida`; esa correspondencia no está establecida.

### 7.4 Panel de selección pendiente

El panel representa `DraftOrderLine[]`, definido aquí como estado temporal de la UI:

| Campo | Marca | Regla |
|---|---|---|
| `draftLineId` | `UI` | Identidad local para editar o quitar una línea antes de enviar. No es `orderLineId`. |
| `menuItemId` | `MENU` | Item elegido. |
| `menuItemVersion` | `MENU` | Versión comercial usada para resolver. |
| `variantId` | `MENU` | Variante concreta elegida; también se requiere cuando no existen dimensiones. |
| `selection` | `MENU`/`UI` | IDs y cantidades de modificadores y componentes conforme a `Selection`. |
| `quantity` | `UI`/Orders | Cantidad de unidades de la línea; el contrato de Menu resuelve una unidad y no establece el máximo de línea. |
| `resolution` | `MENU` | Resultado vigente de E-16 asociado a la configuración. |
| Resumen visible | `DERIVADO` | Nombre de item, variante, personalizaciones y disponibilidad. |
| Costo de línea | `DERIVADO` | `quantity × resolvedUnitSubtotal`; forma parte del acumulado de la preorden y no incluye ajustes posteriores de Billing. |

La UI puede agregar, editar cantidad, reconfigurar y quitar `DraftOrderLine` sin que cada acción sea un CRUD de backend. El costo de línea y el acumulado de la preorden se recalculan localmente a partir de la configuración vigente. Antes de confirmar, Orders debe obtener su propia resolución autoritativa según E-16 y conservar su snapshot; Billing podrá aplicar posteriormente los ajustes propios del importe final.

### 7.5 Estados de una tarjeta

- `AVAILABLE`: `eligible=true`; permite iniciar una selección.
- `UNAVAILABLE`: `eligible=false` o una resolución E-16 devuelve `NOT_ELIGIBLE`; no debe permitir confirmar esa selección.
- `REQUIRES_CONFIGURATION`: existe más de una variante o existen grupos/slots que deben seleccionarse; la forma exacta de determinarlo requiere el detalle E-03.
- `RESOLVING`: estado temporal de UI mientras se solicita la resolución.
- `RESOLUTION_ERROR`: se conserva el error de Menu y no se presenta como una línea válida.

`REQUIRES_CONFIGURATION`, `RESOLVING` y `RESOLUTION_ERROR` son estados de presentación; no son estados de Menu.

## 8. `O-MES-01` — Configuración de item

### 8.1 Datos de contexto

El overlay recibe:

| Dato | Marca |
|---|---|
| `menuItemId`, `menuItemVersion`, `variantId` | `MENU` |
| Nombre y etiqueta de variante | `MENU` |
| `dimensions` y valores disponibles | `MENU` |
| `modifierGroups` | `MENU` |
| `modifierConfigs` de la variante | `MENU` |
| Slots y opciones, si es combo | `MENU` |
| Selección actual a editar | `UI` |
| Cantidad de línea o unidad a personalizar | `UI` |

### 8.2 Configuración de item no combo

Para cada grupo se muestran:

1. nombre del grupo;
2. mínimo y máximo de selecciones;
3. opciones propias del producto;
4. disponibilidad de cada configuración (`enabled`);
5. cantidad elegida frente a `maxQuantity`;
6. `priceDelta` cuando sea pertinente para el cálculo;
7. efectos de ingrediente como consecuencia de la elección, no como un campo editable del cliente.

La selección se expresa con `configId` y `quantity`. Una misma configuración no se repite en la lista; la repetición se expresa en `quantity`. Las cantidades deben satisfacer los límites del grupo.

Para un efecto `OMIT`, la interfaz puede mostrar una acción semántica como “sin ingrediente”, pero no debe mostrar una resta de precio ni una cantidad negativa. Para un efecto `ADD`, la unidad y la cantidad provienen de la configuración de Inventory/Menu.

### 8.3 Configuración de combo

La interfaz debe representar cada `ComboSlot` y sus opciones habilitadas. Para cada opción debe poder distinguir:

- `optionId` y nombre;
- referencia del componente (`menuItemId`, `menuItemVersion`, `variantId`);
- `suppliedQuantity`;
- si la opción está `enabled`;
- cantidad de opciones seleccionadas frente a `minSelections` y `maxSelections` del slot.

Cuando una opción suministra varias unidades, el modelo de selección permite unidades con `unitIndex` de 1 a `suppliedQuantity`. Esto permite configurar unidades distintas sin confundir el número de unidades físicas con el número de opciones que cuenta el slot.

No se deben mostrar controles para cambiar la composición del combo durante la toma de orden. La composición se administra en `V-ADM-02`; en esta vista solo se eligen opciones y se personalizan las unidades permitidas.

### 8.4 Resultado de resolución

E-16 recibe `requestId`, `menuItemVersion`, `variantId` y `selection`. Devuelve:

| Sección | Uso en UI |
|---|---|
| `menuItem` | Confirmar identidad y versión seleccionada. |
| `selection` | Mostrar la selección normalizada. |
| `eligibility` | Mostrar disponible/no disponible y motivo. `validUntil` limita la vigencia visual positiva. |
| `pricing.basePrice` | Precio fijo de una unidad de la variante. |
| `pricing.extrasTotal` | Suma de extras de personalización, sin desglose monetario. |
| `pricing.unitSubtotal` | `basePrice + extrasTotal` antes de cantidad de línea y reglas externas de Orders. |
| `pricing.currency` | Moneda del importe. |
| `preparationUnits` e `ingredients` | Datos de resolución para Orders; solo mostrarlos en la UI si la responsabilidad de la superficie lo requiere. No son stock ni una orden confirmada. |

E-16 no crea una orden, no reserva stock y no confirma una venta. `requestId` no es `orderId`, `lineId` ni clave de idempotencia.

## 9. `V-ADM-01` — Gestión del catálogo

### 9.1 Fuentes administrativas

E-19 ofrece el listado administrativo:

`GET /v1/restaurants/{restaurantId}/menu-items`

Su página contiene `menuItemId`, `name`, `fulfillmentType`, `reviewState` y `pendingVariantIds`. No contiene `status`, `categoryId`, `imageRef`, precio ni la definición completa.

E-08 entrega la definición administrativa completa, incluyendo `status`, `categoryId`, `fulfillmentType`, dimensiones, grupos, variantes, precios y suministro. La UI debe tratar E-19 como resumen y E-08 como detalle, salvo que se amplíe el contrato administrativo.

### 9.2 Tarjeta administrativa propuesta

La tarjeta necesita separar datos disponibles directamente de datos que requieren hidratación:

| Dato de tarjeta | Fuente | Estado |
|---|---|---|
| `menuItemId` | E-19/E-08 | `MENU` |
| `name` | E-19/E-08 | `MENU` |
| `fulfillmentType` | E-19/E-08 | `MENU` |
| `reviewState` | E-19 para combos | `MENU` |
| `pendingVariantIds` | E-19 | `MENU` |
| `status` del item | E-08 | `MENU`, no disponible en E-19 |
| `categoryId` | E-08 | `MENU`, no disponible en E-19 |
| `imageRef` | E-08 | `MENU`, no disponible en E-19 |
| Precio visible | variantes de E-08; `fromPrice` en E-03 | `DERIVADO`, sujeto a estado/eligibilidad |
| `classification` | catálogo externo de categorías | `EXTERNO`/`UI`, badge y filtro obligatorio |
| Estado de disponibilidad | E-03 por variante | `MENU`, temporal; no equivale a status |
| Acciones | permisos + estado | `UI` |

La tarjeta no debe inventar “stock disponible”. Menu no divulga stock exacto en E-02.

### 9.3 Apartados y filtros

La separación semántica correcta según la documentación es:

| Apartado visual | Qué contiene | No confundir con |
|---|---|---|
| `ACTIVE` | MenuItems cuyo `status` es `ACTIVE` | `eligible=true`; un item activo puede no estar disponible. |
| `INACTIVE` | MenuItems cuyo `status` es `INACTIVE` | `ARCHIVED`; no es un estado de producto archivado. |
| `REVIEW_REQUIRED` | Combos con alguna `ComboConfiguration` pendiente | Estado de venta, `MenuItem.status` y estado de disponibilidad. |
| `UP_TO_DATE` | Combos sin cambios de dependencia pendientes | Un estado global aplicable a STOCKED/PREPARED; esos items tienen `reviewState=null`. |
| `ARCHIVED` | MenuItems retirados del catálogo activo y visibles en el apartado de archivados | `INACTIVE`; la eliminación de UI es suave y no equivale a borrado físico. |
| Variantes archivadas | Variantes `ARCHIVED`, visibles en el detalle administrativo | Un item archivado completo; una variante archivada no se reactiva en esta versión. |

`REVIEW_REQUIRED`/`UP_TO_DATE` son estados de revisión administrativa por `ComboConfiguration` y un agregado del combo, superpuestos al `MenuItem.status` `ACTIVE/INACTIVE`; no son estados adicionales de `MenuItem`, `MenuItemVariant` ni disponibilidad. Solo se aplican a combos.

La UI solicitada incluye búsqueda, categoría y tipo también en administración, pero E-19 actualmente no los define como parámetros. Este hecho queda en `UI-OPEN-004`; no debe ocultarse suponiendo que la paginación administrativa permite filtrar localmente todo el catálogo.

### 9.4 Acciones administrativas

| Acción visual | Objeto | Representación contractual |
|---|---|---|
| Desactivar | `MenuItem` | Editar la definición completa mediante E-09 estableciendo `status=INACTIVE`. |
| Activar | `MenuItem` | E-09, sujeto a validación de una configuración activa válida. |
| Archivar item | `MenuItem` | Estado `ARCHIVED` de ciclo de vida administrativo; dependencia externa descrita en `ASSUMPTION-EXT-005`. |
| Archivar variante | `MenuItemVariant` | E-09 con transición explícita a `ARCHIVED`; puede afectar combos dependientes. |
| Reactivar variante archivada | Variante | Prohibido en esta versión. |
| Eliminar item/variante | Cualquier elemento | La UI representa una eliminación suave; no debe presentarse como borrado físico. La persistencia de esa operación queda en `ASSUMPTION-EXT-005`. |

La UI puede tener selección múltiple y mostrar acciones masivas en el apartado `ARCHIVED`: `Eliminar uno`, `Eliminar seleccionados` y `Eliminar todos`. Estas acciones son de retiro suave y requieren el contrato externo descrito en `ASSUMPTION-EXT-005`; el mockup no debe presentarlas como borrado físico ni como destrucción del historial.

### 9.5 Datos del apartado archivado

Para que el mockup represente el apartado solicitado, cada tarjeta archivada deberá poder manejar:

| Campo | Marca | Uso |
|---|---|---|
| `menuItemId` | `EXTERNO`/Menu ampliado | Identifica el item archivado. |
| `name` | `MENU` | Texto principal. |
| `categoryId` y `classification` | `MENU`/catálogo externo | Filtros y badges. |
| `archivedAt` | `EXTERNO` | Fecha de archivo, si el proveedor la entrega. |
| `archivedBy` | `EXTERNO` | Actor que archivó, si el proveedor lo entrega. |
| `selectionState` | `UI` | Permite acciones sobre uno, varios o todos los resultados del alcance. |

Las acciones `Eliminar uno`, `Eliminar seleccionados` y `Eliminar todos` son acciones de retiro suave de UI. No significan borrar el historial ni los datos persistidos de forma física.

## 10. `V-ADM-02` — Editor de MenuItem

### 10.1 Modos

| Modo | Decisión de UI | Contrato de persistencia |
|---|---|---|
| `CREATE` | Cuatro pasos: clasificación/tipo, item/suministro, modificadores, resumen/aceptación | E-07 para MenuItem; E-11 si se crea Recipe. |
| `EDIT` | Tres pasos: item/suministro, modificadores, confirmación | E-09 reemplaza la definición completa bajo `If-Match`; E-13 puede editar Recipe. |
| `REVIEW_REQUIRED` | Variante visual con aviso y panel de dependencias pendientes | E-20/E-21 para revisión de combos; no es un estado asignable en E-09. |

Los pasos son una decisión de UI del usuario, no una secuencia impuesta por el contrato HTTP. La edición debe precargar la definición completa porque E-09 es reemplazo completo y rechaza omitir variantes existentes.

### 10.2 Paso de clasificación y tipo

El primer paso de creación debe permitir seleccionar la clasificación comercial confirmada para la UI y el tipo contractual de `MenuItem` (`fulfillmentType`) que determina la estructura de edición. `COMBO` se elige como tipo contractual y no como clasificación de item hoja.

La clasificación comercial se representa con estos valores y etiquetas:

- `DISH` — Platillo;
- `BEVERAGE` — Bebida;
- `COMBO` — Combo;
- `DESSERT` — Postre;
- `COMPLEMENT` — Complemento.

El `fulfillmentType` se representa con:

- `STOCKED`;
- `PREPARED`;
- `COMBO`.

La clasificación no reemplaza `categoryId` ni se debe mapear automáticamente a `fulfillmentType`. El contrato externo debe indicar dónde se persiste o cómo se proyecta la clasificación elegida; esa incertidumbre no cambia las opciones ni las etiquetas que debe mostrar el mockup.

### 10.3 Datos comunes del item

| Campo | Tipo de control conceptual | Reglas |
|---|---|---|
| `menuId` | Selector o contexto bloqueado | Debe pertenecer al restaurante. |
| `name` | Texto | Identifica una etiqueta; no se usa para relacionar componentes. Puede repetirse según la regla actual. |
| `description` | Texto multilínea | Descripción visible. |
| `imageRef` | Referencia de imagen | `string` o `null`; el contrato no define carga de bytes. |
| `categoryId` | Selector | Requiere fuente de categorías no documentada. |
| `classification` | Selector de clasificación comercial | Valores confirmados: `DISH`, `BEVERAGE`, `COMBO`, `DESSERT`, `COMPLEMENT`; el origen/persistencia es externo. |
| `status` | Selector de estado administrativo | `ACTIVE`/`INACTIVE`; activación sujeta a validación. |
| `dimensions` | Editor de dimensiones y valores | Las variantes deben usar valores de sus propias dimensiones. |
| `variants` | Lista/editor por presentación | Cada variante tiene precio, estado, suministro y configuraciones. |

El tipo de `MenuItem` (`fulfillmentType`) es inmutable después de crear el item. Cambiarlo no debe aparecer como una edición ordinaria sin confirmación de una decisión de reclasificación.

### 10.4 Editor de `STOCKED`

Para cada variante STOCKED se representan:

| Dato | Fuente |
|---|---|
| `variantId` | UI/Menu |
| `status` | Menu |
| valores de dimensión | Menu/UI |
| `unitPrice.amount`, `unitPrice.currency` | Menu |
| `fulfillment.inventoryItemId` | Inventory |
| `fulfillment.quantity` | UI/Menu, con límites pendientes de Inventory |
| `fulfillment.unit` | Inventory |
| configuraciones de modificadores | Menu |

El selector de Inventory debe mostrar al menos ID, nombre y unidad. Las rutas concretas, búsqueda y paginación del proveedor aún no están fijadas.

### 10.5 Editor de `PREPARED`

Para cada variante PREPARED se representa una referencia exacta:

| Dato | Fuente |
|---|---|
| `recipeId` | Menu, raíz de Recipe |
| `recipeVersion` | Menu, revisión adoptada |
| nombre de receta | E-12/E-13 si se carga la definición |
| componentes | E-12/E-13 y referencias de Inventory |

La UI puede ofrecer un subeditor de receta dentro del mismo paso, pero el documento debe distinguir:

1. el borrador de la receta;
2. la creación o edición de su revisión por E-11/E-13;
3. la adopción explícita de esa revisión en el MenuItem por E-09.

No existe actualmente una garantía de transacción conjunta entre las tres operaciones.

Para el mockup, el borrador del subeditor puede representarse como:

```text
RecipeDraft
├── recipeId          // null en una receta nueva
├── baseRecipeVersion // null en una receta nueva
├── name
└── components[]
    ├── inventoryItemId
    ├── quantity
    └── unit
```

El resultado visual de la aceptación deberá conservar por separado `recipeId/recipeVersion` y `menuItemId/menuItemVersion`; si alguna operación falla, la UI deberá identificar la parte que no quedó guardada.

### 10.6 Editor de `COMBO`

Para cada variante COMBO se representan:

| Dato | Reglas visuales y de datos |
|---|---|
| `unitPrice` | Precio absoluto de la variante; moneda del restaurante. |
| `slotId`, nombre | Identifica el espacio de selección. |
| `minSelections`, `maxSelections` | Límites de opciones seleccionadas; no contar `suppliedQuantity` como opciones adicionales. |
| `options[]` | Opciones habilitadas o deshabilitadas del slot. |
| `component` | Referencia fija a item, versión y variante del componente. |
| `suppliedQuantity` | Unidades físicas que entrega la opción; entero positivo. |
| `baseOptionIds` | Base administrativa única, dentro de límites y con opciones habilitadas. |

No se debe mostrar precio extra por opción de combo. Los cambios de precio de componentes pueden generar revisión administrativa del combo, pero no reescriben automáticamente el `unitPrice` del combo.

### 10.7 Paso de modificadores

El editor debe permitir definir grupos, opciones y configuraciones por variante:

1. grupo: `groupId`, nombre, mínimos y máximos;
2. opción propia del producto: `optionId`, nombre;
3. configuración por variante: `configId`, `optionId`, `enabled`, `priceDelta`, `maxQuantity`;
4. efectos: `ADD` u `OMIT` con los campos exigidos por la operación.

La UI puede ofrecer copiar configuraciones entre variantes, pero debe reflejar que E-17 solo copia dentro del mismo `MenuItem`, puede simular con `dryRun`, usa `FAIL` o `REPLACE`, y aplica todo-o-nada. Los IDs de las entidades copiadas no deben presentarse como si fueran la misma identidad del origen.

### 10.8 Paso de resumen y aceptación

El resumen debe ser de solo lectura y agrupar:

- identidad y datos comerciales del item;
- categoría y tipo de `MenuItem`;
- clasificación comercial;
- dimensiones y variantes;
- precio absoluto por variante;
- suministro STOCKED/PREPARED/COMBO;
- grupos y configuraciones de modificadores;
- recetas y revisiones adoptadas;
- slots, opciones y cantidades de combo;
- advertencias y violaciones devueltas por Menu.

Una advertencia no equivale a una aprobación silenciosa. La documentación permite guardar configuración incompleta en `INACTIVE` con warnings de capacidad; una configuración `ACTIVE` debe satisfacer las validaciones requeridas.

En edición, el cliente debe enviar `If-Match` con el ETag leído y una clave de idempotencia. Si la definición cambió desde la lectura, la UI debe conservar el borrador y mostrar el conflicto de revisión, no sobrescribirlo automáticamente.

## 11. `V-ADM-03` — Revisión administrativa de combo

### 11.1 Cuándo aparece

La revisión se activa cuando una variante componente fijada por un combo tiene un cambio relevante no atendido de precio, composición, receta adoptada, modificadores aplicables o estado efectivo. No se activa por stock, cosmética o una variante no referenciada.

Solo existen estados de revisión para combos:

- `REVIEW_REQUIRED`;
- `UP_TO_DATE`.

### 11.2 Resumen de la lista

E-19 muestra:

| Campo | Uso |
|---|---|
| `menuItemId` | Abrir el combo. |
| `name` | Identificación visible. |
| `fulfillmentType=COMBO` | Distinguir el alcance de revisión. |
| `reviewState` | Badge o filtro. |
| `pendingVariantIds` | Variantes afectadas. |

### 11.3 Detalle de una revisión

E-20 muestra `menuItemId`, `menuItemVersion`, estado agregado y todas las variantes de combo, incluidas archivadas. Para cada variante pendiente muestra:

| Dato | Representación |
|---|---|
| `variantId` | Encabezado de la unidad revisable. |
| `reviewToken` | Token opaco que debe conservarse para confirmar lo observado. No es autorización. |
| `reviewTokenExpiresAt` | Vigencia del token. |
| `changeId` | Identidad del cambio observado. |
| `slotId`, `optionId` | Ubicación del cambio dentro del combo. |
| `component` | Item, versión y variante fijados por la opción. |
| `observedVersion` | Versión comparada al detectar el cambio. |
| `reasons` | Motivos como `PRICE`; se muestran como explicación, no como decisión inventada. |
| `slotPrices.saved/current/difference` | Referencia administrativa del impacto de componentes; no es el precio de venta del combo. |

Para mostrar nombres y detalles comerciales del componente se debe consultar E-08/E-14 según el caso; E-20 expone referencias y cambios, no el catálogo completo.

### 11.4 Confirmación visual

La UI puede mostrar cada `changeId` como una fila observada y permitir seleccionar variantes pendientes, pero la confirmación contractual es por pares `variantId + reviewToken` en E-21. No existe un campo de entrada `verified=true` por componente.

Al confirmar:

- se envían las variantes seleccionadas y sus tokens;
- Menu atiende únicamente los cambios observados por esos tokens;
- se recibe el estado posterior y los `acknowledgedChangeIds`;
- la UI refresca E-20;
- cambios nuevos pueden dejar la variante o el combo en `REVIEW_REQUIRED`.

Por ello, el texto visual “revisión completada” solo debe mostrarse como `UP_TO_DATE` después de leer el estado posterior, no simplemente al pulsar Guardar.

## 12. `V-ADM-04` — Confirmación de guardado

Esta vista es un estado de presentación, no un nuevo recurso de Menu. Debe distinguir:

| Estado | Datos |
|---|---|
| Alta guardada | `menuItemId`, nueva revisión y definición retornada por E-07. |
| Edición guardada | `menuItemId`, nueva revisión y warnings retornados por E-09. |
| Receta guardada | `recipeId`, `recipeVersion` y definición retornada por E-11/E-13. |
| Revisión confirmada | `reviewId`, actor, instante, variantes y cambios reconocidos retornados por E-21. |
| Guardado parcial de UI | Borrador local no confirmado; no debe etiquetarse como persistido. |

El éxito de una mutación de Menu no prueba que Orders haya creado una orden ni que Inventory haya descontado stock.

## 13. Reglas de presentación transversales

1. Distinguir visualmente `ACTIVE/INACTIVE`, `ARCHIVED`, `eligible` y `REVIEW_REQUIRED`; son dimensiones distintas.
2. Mostrar una versión (`menuItemVersion`, `recipeVersion`) cuando el dato fijado sea relevante para selección, revisión o auditoría.
3. Mostrar los importes con su moneda y no usar `0` para representar `fromPrice=null`.
4. No mostrar stock exacto a partir de `eligible`.
5. No mostrar precio de componentes de combo como si formara parte del precio de venta del combo.
6. No presentar `unitSubtotal` como total de la orden.
7. Separar IDs de entidad, versiones, tokens de revisión y claves de UI.
8. Mostrar unidades junto a cantidades físicas; no mezclar cantidades físicas con cantidades de selección.
9. Distinguir controles editables de referencias de solo lectura.
10. Si hay warnings, violaciones o disponibilidad temporal, conservar su causa junto al dato afectado.
11. Una opción o variante retirada puede conservarse para historia sin ofrecerse como nueva selección.
12. La selección de una mesa, la orden existente y las líneas confirmadas deben permanecer identificables como datos externos a Menu.

## 14. Datos externos incorporados a la UI

Los siguientes datos sí forman parte del alcance de los mockups porque fueron solicitados explícitamente, aunque no pertenezcan a Menu:

- `tableId`, etiqueta de mesa, asignación del mesero y estado de mesa;
- `orderId`, estado de orden, `orderLineId`, líneas confirmadas y totales de Orders;
- clasificación visual confirmada: `Platillo`, `Bebida`, `Combo`, `Postre` y `Complemento`;
- estado y operaciones de archivado suave del catálogo;
- estado local de revisión de componentes;
- resultado coordinado de guardar Recipe y MenuItem;
- selector de ingredientes y referencias STOCKED de Inventory;
- ciclo de carga y previsualización de imágenes;
- costo de línea y acumulado de la preorden; Billing queda reservado para los ajustes posteriores del importe final.

Estos datos se documentan directamente en esta especificación y sus dependencias se detallan en [Supuestos externos para los mockups](./external-assumptions.md). La clasificación visual está confirmada; lo supuesto es únicamente el proveedor y el mapeo externo. Los supuestos no convierten `ARCHIVED`, `verified`, `DELETE`, precios de slots ni los modos de precio antiguos en campos vigentes de Menu.

## 15. Requisitos de UI incorporados por decisión del solicitante

Los siguientes requisitos son decisiones explícitas de la UI para esta especificación. No se presentan como requisitos internos de Menu cuando su dato pertenece a otro servicio.

### UI-REQ-001 — Mesas asignadas

**Requisito:** La UI deberá mostrar al mesero el conjunto de mesas que le entregue la fuente autorizada de Sala.

**Origen:** Solicitud explícita del usuario, 2026-09-13.  
**Verificación:** Demostración: cargar una proyección con mesas asignadas y comprobar que no se muestran mesas fuera del conjunto recibido.  
**Estado:** Confirmado para la UI; datos externos definidos provisionalmente en `ASSUMPTION-EXT-001`.

### UI-REQ-002 — Distinción de mesa con orden

**Requisito:** La UI deberá distinguir visualmente una mesa sin orden de una mesa con orden.

**Origen:** Solicitud explícita del usuario, 2026-09-13.  
**Verificación:** Demostración: mostrar ambas proyecciones y comprobar que cada una presenta el estado y la acción correspondientes.  
**Estado:** Confirmado para la UI; relación Mesa–Order definida provisionalmente en `ASSUMPTION-EXT-001`.

### UI-REQ-003 — Agregado a orden existente

**Requisito:** La UI deberá permitir preparar productos nuevos para agregarlos a la orden asociada con una mesa que ya tiene orden.

**Origen:** Solicitud explícita del usuario, 2026-09-13.  
**Verificación:** Demostración: abrir una orden existente, crear un borrador no confirmado y conservar separadas las líneas confirmadas.  
**Estado:** Confirmado para la UI; operación de Orders definida provisionalmente en `ASSUMPTION-EXT-002`.

### UI-REQ-004 — Catálogo de venta

**Requisito:** La UI deberá permitir seleccionar `MenuItem` `STOCKED`, `PREPARED` y `COMBO` desde el catálogo comercial de Menu.

**Origen:** Solicitud explícita del usuario y E-02/E-03.  
**Verificación:** Demostración: cargar `MenuItem` de los tres tipos y comprobar que cada uno puede abrir la configuración correspondiente cuando sea elegible.
**Estado:** Confirmado para la UI; el tipo debe obtenerse del detalle o de una proyección ampliada.

### UI-REQ-005 — Filtros y búsqueda del catálogo

**Requisito:** La UI deberá permitir buscar por nombre y filtrar el catálogo por categoría, tipo de `MenuItem` y clasificación visual; la clasificación visual de un item hoja no se asigna automáticamente por su tipo contractual.

**Origen:** Solicitud explícita del usuario, 2026-09-13.  
**Verificación:** Demostración: aplicar cada filtro individualmente y en combinación, verificando que las tarjetas visibles corresponden al filtro y que los combos no reciben una clasificación de item hoja por inferencia.
**Estado:** Confirmado para la UI; el catálogo externo y el mapeo de categorías se describen provisionalmente en `ASSUMPTION-EXT-003`.

### UI-REQ-006 — Cantidad y borrador local

**Requisito:** La UI deberá permitir cambiar la cantidad, reconfigurar y quitar cada `DraftOrderLine` antes de confirmar la orden.

**Origen:** Solicitud explícita del usuario, 2026-09-13.  
**Verificación:** Demostración: modificar una `DraftOrderLine`, recalcular su resolución y comprobar que las líneas confirmadas y el catálogo no se alteran.
**Estado:** Confirmado como interacción local; la cantidad definitiva y el envío pertenecen a Orders.

### UI-REQ-007 — Configuración antes de agregar

**Requisito:** La UI deberá permitir configurar, antes de agregar una línea al borrador, las características de presentación y personalizaciones de un item hoja, o los slots, opciones y personalizaciones de sus componentes cuando el item sea `COMBO`, conforme a la definición disponible de Menu.

**Origen:** Solicitud explícita del usuario y modelos de `Selection`.  
**Verificación:** Demostración: configurar un item hoja y un combo, resolverlos con E-16 y comprobar que el borrador conserva `variantId`, identificadores y cantidades.
**Estado:** Confirmado para la UI; la resolución autoritativa continúa siendo E-16.

### UI-REQ-008 — Gestión administrativa del catálogo

**Requisito:** La UI deberá proporcionar una vista administrativa del catálogo con creación, edición, búsqueda y los mismos filtros de categoría, tipo y clasificación visual que el catálogo de venta.

**Origen:** Solicitud explícita del usuario, 2026-09-13.  
**Verificación:** Demostración: aplicar los filtros en ambas superficies y comprobar que la intención del filtro es la misma, aunque cada fuente tenga permisos distintos.  
**Estado:** Confirmado para la UI; proyección administrativa provisional en `ASSUMPTION-EXT-004`.

### UI-REQ-009 — Separación de estados administrativos

**Requisito:** La UI deberá separar `MenuItem.status` (`ACTIVE`/`INACTIVE`), el estado de revisión del combo (`REVIEW_REQUIRED`/`UP_TO_DATE`) y `ARCHIVED` de una variante o del apartado externo de items archivados; no deberá presentar la revisión como un estado de MenuItem.

**Origen:** Solicitud explícita del usuario y semántica actual de Menu.  
**Verificación:** Inspección: comprobar que el filtro de `MenuItem.status` solo usa `ACTIVE`/`INACTIVE`, que la revisión solo aparece para combos y que `ARCHIVED` se atribuye a la entidad correspondiente y se distingue de `INACTIVE`.
**Estado:** Confirmado para la UI; el ciclo de vida y las operaciones de archivado del item son una dependencia externa descrita en `ASSUMPTION-EXT-005`.

### UI-REQ-010 — Acciones de archivo suave

**Requisito:** La UI deberá permitir gestionar el apartado externo de items archivados mediante una acción de retiro suave sobre un item, varios items seleccionados o todos los items incluidos en el alcance seleccionado, sin presentarla como borrado físico.

**Origen:** Solicitud explícita del usuario, 2026-09-13.  
**Verificación:** Demostración: ejecutar los alcances individual, selección múltiple y todos, comprobar que la UI refleja el resultado y que no representa borrado físico del historial.
**Estado:** Confirmado para la UI; la semántica de persistencia de archivado y eliminación suave está definida como supuesto externo en `ASSUMPTION-EXT-005`, porque no existe aún en la interfaz actual de Menu.

### UI-REQ-011 — Wizard de creación

**Requisito:** La UI deberá representar la creación de un `MenuItem` mediante cuatro pasos: (1) tipo de `MenuItem` y clasificación comercial cuando aplique, (2) configuración específica del item y su suministro, (3) configuración de modificadores y (4) resumen con aceptación.

**Origen:** Solicitud explícita del usuario, 2026-09-13.  
**Verificación:** Demostración: iniciar una creación de cada tipo, recorrer exactamente esos cuatro pasos y comprobar que el resumen contiene la configuración completa antes de aceptar.
**Estado:** Confirmado como estructura visual; los contratos de persistencia siguen siendo E-07, E-11/E-13 y sus validaciones.

### UI-REQ-012 — Wizard de edición

**Requisito:** La UI deberá representar la edición de un item mediante tres pasos: item, modificadores y confirmación.

**Origen:** Solicitud explícita del usuario, 2026-09-13.  
**Verificación:** Demostración: abrir un item existente, comprobar que los datos están precargados y que la edición no presenta el paso de selección inicial del tipo.  
**Estado:** Confirmado como estructura visual; E-09 continúa requiriendo la definición completa y `If-Match`.

### UI-REQ-013 — Distinción de creación y edición

**Requisito:** La UI deberá distinguir visualmente las acciones de crear y editar mediante títulos, acciones primarias, estado inicial del formulario y datos precargados.

**Origen:** Solicitud explícita del usuario, 2026-09-13.  
**Verificación:** Inspección: comparar las composiciones `CREATE` y `EDIT` y comprobar que no se presentan como la misma operación.  
**Estado:** Confirmado para la UI.

### UI-REQ-014 — Revisión pendiente

**Requisito:** La UI deberá presentar en `V-ADM-03`, separado del editor ordinario `V-ADM-02`, un combo con revisión pendiente, sus `ComboConfiguration` afectadas y los cambios de dependencia observados, y deberá permitir confirmar la revisión desde ese contexto administrativo.

**Origen:** Solicitud explícita del usuario y E-19/E-20/E-21.  
**Verificación:** Demostración: cargar cambios pendientes, mostrar sus configuraciones/componentes afectados, confirmar las configuraciones seleccionadas con sus tokens, refrescar E-20 y ocultar el indicador solo cuando Menu devuelva `UP_TO_DATE`. Si Menu devuelve nuevamente `REVIEW_REQUIRED` por cambios nuevos, conservar el indicador y explicar que la confirmación anterior sí fue aplicada.
**Estado:** Confirmado para la UI; el trabajo local y sus límites están en `ASSUMPTION-EXT-006`.

### UI-REQ-015 — Precio acumulado de preorden

**Requisito:** La UI deberá mostrar el importe acumulado de las selecciones del borrador como la suma de los costos de sus líneas configuradas.

**Origen:** Solicitud explícita del usuario y resumen monetario de E-16.  
**Verificación:** Demostración: modificar cantidades y configuraciones, comprobar `preorderTotal = Σ(quantity × resolvedUnitSubtotal)` y verificar que Billing se reserva para ajustes posteriores del importe final.  
**Estado:** Confirmado para la UI; el contrato externo de Billing solo afecta el importe final posterior.

### 15.1 Formalización en la ERS

Las decisiones de esta especificación se formalizan normativamente en la ERS canónica y su traducción:

| UI-REQ | Formalización canónica | Alcance |
|---|---|---|
| `UI-REQ-001` | [`REQ-UI-001`](../ers/02-functional-requirements.md#req-ui-001) | Mesas asignadas |
| `UI-REQ-002` | [`REQ-UI-002`](../ers/02-functional-requirements.md#req-ui-002) | Distinción de mesa con orden |
| `UI-REQ-003` | [`REQ-UI-003`](../ers/02-functional-requirements.md#req-ui-003) | Agregado a orden existente |
| `UI-REQ-004` | [`REQ-UI-004`](../ers/02-functional-requirements.md#req-ui-004) | Catálogo STOCKED/PREPARED/COMBO |
| `UI-REQ-005` | [`REQ-UI-005`](../ers/02-functional-requirements.md#req-ui-005), [`DATA-UI-003`](../ers/04-data-requirements.md#data-ui-003) | Búsqueda, filtros y clasificación |
| `UI-REQ-006` | [`REQ-UI-006`](../ers/02-functional-requirements.md#req-ui-006), [`DATA-UI-002`](../ers/04-data-requirements.md#data-ui-002) | Borrador local |
| `UI-REQ-007` | [`REQ-UI-007`](../ers/02-functional-requirements.md#req-ui-007) | Configuración antes de agregar |
| `UI-REQ-008` | [`REQ-UI-008`](../ers/02-functional-requirements.md#req-ui-008), [`DATA-UI-004`](../ers/04-data-requirements.md#data-ui-004) | Gestión administrativa |
| `UI-REQ-009` | [`REQ-UI-009`](../ers/02-functional-requirements.md#req-ui-009), [`DATA-UI-004`](../ers/04-data-requirements.md#data-ui-004) | Estados administrativos |
| `UI-REQ-010` | [`REQ-UI-010`](../ers/02-functional-requirements.md#req-ui-010) | Eliminación suave |
| `UI-REQ-011` | [`REQ-UI-011`](../ers/02-functional-requirements.md#req-ui-011) | Wizard de creación |
| `UI-REQ-012` | [`REQ-UI-012`](../ers/02-functional-requirements.md#req-ui-012) | Wizard de edición |
| `UI-REQ-013` | [`REQ-UI-013`](../ers/02-functional-requirements.md#req-ui-013) | Distinción crear/editar |
| `UI-REQ-014` | [`REQ-UI-014`](../ers/02-functional-requirements.md#req-ui-014), [`DATA-UI-005`](../ers/04-data-requirements.md#data-ui-005) | Presentación de revisión |
| `UI-REQ-014` confirmación | [`REQ-UI-015`](../ers/02-functional-requirements.md#req-ui-015) | Confirmación de revisión |
| `UI-REQ-015` | [`REQ-UI-016`](../ers/02-functional-requirements.md#req-ui-016), [`BR-UI-001`](../ers/03-business-rules.md#br-ui-001), [`DATA-UI-006`](../ers/04-data-requirements.md#data-ui-006) | Acumulado de preorden |

Los nueve asuntos que siguen siendo abiertos son externos: [`OPEN-011` a `OPEN-019`](../ers/09-conflicts-and-open-items.md#open-011). No representan decisiones pendientes del mockup.

| UI-OPEN | Registro canónico en la ERS | Dependencia |
|---|---|---|
| `UI-OPEN-001` | [`OPEN-011`](../ers/09-conflicts-and-open-items.md#open-011) | Sala |
| `UI-OPEN-002` | [`OPEN-012`](../ers/09-conflicts-and-open-items.md#open-012) | Orders |
| `UI-OPEN-003` | [`OPEN-013`](../ers/09-conflicts-and-open-items.md#open-013) | Categorías y mapeo externo; clasificación UI confirmada |
| `UI-OPEN-004` | [`OPEN-014`](../ers/09-conflicts-and-open-items.md#open-014) | Proyección administrativa |
| `UI-OPEN-005` | [`OPEN-015`](../ers/09-conflicts-and-open-items.md#open-015) | Archivado y retiro suave |
| `UI-OPEN-006` | Sin OPEN adicional | E-19/E-20/E-21; el estado local es decisión de UI |
| `UI-OPEN-007` | [`OPEN-016`](../ers/09-conflicts-and-open-items.md#open-016) | Recipe y MenuItem |
| `UI-OPEN-008` | [`OPEN-017`](../ers/09-conflicts-and-open-items.md#open-017) | Inventory |
| `UI-OPEN-009` | [`OPEN-018`](../ers/09-conflicts-and-open-items.md#open-018) | Imágenes |
| `UI-OPEN-010` | [`OPEN-019`](../ers/09-conflicts-and-open-items.md#open-019) | Billing |

## 16. Puntos de integración externos y contratos faltantes

Estos identificadores conservan el prefijo `UI-OPEN` por trazabilidad, pero no representan decisiones pendientes del mockup. Las decisiones de UI ya están incorporadas en las secciones anteriores; cada identificador señala únicamente una dependencia externa o un contrato faltante. No bloquean la construcción de mockups: cada uno tiene un tratamiento explícito en [Supuestos externos para los mockups](./external-assumptions.md). Sí bloquean la implementación de integraciones hasta que el contrato propietario sea confirmado.

### UI-OPEN-001 — Proyección de Sala

**Conocido:** Sala debe proveer el conjunto limitado de mesas asignadas y permitir distinguir mesas con y sin orden, según la solicitud de UI.  
**Falta:** campos exactos, estado de asignación, identidad de orden y contrato de consulta.  
**Afecta:** `V-MES-01` y contexto de `V-MES-02`/`V-MES-03`.

**Supuesto aplicado:** [ASSUMPTION-EXT-001](./external-assumptions.md).

### UI-OPEN-002 — Proyección de Orders

**Conocido:** Orders posee cantidades de línea, snapshot monetario y orden; Menu resuelve una unidad y no crea la orden.  
**Falta externamente:** lectura de orden activa, creación, agregado, estado de líneas, total de la orden existente/confirmada y permisos de mesero. El cálculo del acumulado de la preorden está definido en esta especificación y no es un punto abierto.  
**Afecta:** `V-MES-02`, las operaciones de `V-MES-03` y la posterior confirmación en Orders.

**Supuesto aplicado:** [ASSUMPTION-EXT-002](./external-assumptions.md).

### UI-OPEN-003 — Fuente externa de categorías y mapeo de clasificación visual

**Estado:** Resuelto para la UI; pendiente únicamente como dependencia externa.  
**Conocido:** La UI debe usar las cinco clasificaciones `DISH`, `BEVERAGE`, `COMBO`, `DESSERT` y `COMPLEMENT`, con sus etiquetas en español. `categoryId` y `fulfillmentType` siguen siendo datos diferentes.  
**Falta:** proveedor del catálogo de categorías y mapeo de cada `categoryId` a la clasificación visual.  
**Afecta:** origen de las opciones de filtro y de las etiquetas descriptivas, no la existencia de la clasificación.

**Supuesto aplicado:** [ASSUMPTION-EXT-003](./external-assumptions.md).

### UI-OPEN-004 — Listado administrativo filtrable

**Conocido:** E-19 lista items administrativos y filtra `reviewState`; E-08 entrega el detalle completo.  
**Falta:** filtros administrativos contractuales por `status`, `categoryId`, `fulfillmentType` y texto, además de los campos de tarjeta.  
**Afecta:** `V-ADM-01`, paginación e implementación de búsqueda.

**Supuesto aplicado:** [ASSUMPTION-EXT-004](./external-assumptions.md).

### UI-OPEN-005 — Contrato externo de archivado y eliminación suave

**Estado:** Resuelto para la UI; pendiente únicamente como dependencia externa.  
**Conocido:** la UI debe separar `ACTIVE`, `INACTIVE`, `REVIEW_REQUIRED` y `ARCHIVED`; el apartado `ARCHIVED` debe permitir `Eliminar uno`, `Eliminar seleccionados` y `Eliminar todos`. “Eliminar” significa retiro suave y no destrucción física del historial.  
**Falta:** contrato externo para el estado archivado del item raíz, las operaciones de retiro suave y su respuesta posterior.  
**Restricción:** no se representa borrado físico ni reactivación de una variante archivada con los contratos actuales.

**Supuesto aplicado:** [ASSUMPTION-EXT-005](./external-assumptions.md).

### UI-OPEN-006 — Alcance de la revisión

**Estado:** Resuelto para la UI; pendiente únicamente como dependencia externa si se solicita un contrato distinto.  
**Conocido:** la UI presenta las componentes afectadas como filas informativas con estado local (`UNSEEN`, `SEEN`, `SELECTED_FOR_CONFIRMATION`), pero la unidad confirmable es la variante completa mediante `variantId + reviewToken`.  
**Falta externamente:** solo sería necesario un contrato adicional si se quisiera confirmar componentes individualmente.  
**Restricción:** `verified` no puede escribirse en `MenuItemWrite`.

**Supuesto aplicado:** [ASSUMPTION-EXT-006](./external-assumptions.md).

### UI-OPEN-007 — Guardado conjunto de Recipe y MenuItem

**Conocido:** Recipe tiene revisiones independientes y la variante adopta explícitamente una revisión.  
**Falta:** comportamiento del wizard si crear/editar Recipe funciona pero editar MenuItem falla, o viceversa.

**Supuesto aplicado:** [ASSUMPTION-EXT-007](./external-assumptions.md).

### UI-OPEN-008 — Catálogo de Inventory para selectores

**Conocido:** Inventory debe aportar ID, nombre, unidad y búsqueda para ingredientes y referencias STOCKED.  
**Falta:** rutas, paginación, límites de cantidad, conversiones y cambio de unidad.

**Supuesto aplicado:** [ASSUMPTION-EXT-008](./external-assumptions.md).

### UI-OPEN-009 — Imágenes

**Conocido:** Menu almacena `imageRef` string o null.  
**Falta:** proveedor, carga, validación, eliminación y resolución de la referencia para el mockup.

**Supuesto aplicado:** [ASSUMPTION-EXT-009](./external-assumptions.md).

### UI-OPEN-010 — Ajustes finales de Billing

**Estado:** No bloquea la vista de preorden.  
**Conocido:** La UI muestra `preorderTotal` como suma de costos de líneas configuradas.  
**Falta:** contrato exterior de Billing para aplicar ajustes posteriores al importe final de la orden.

**Supuesto aplicado:** [ASSUMPTION-EXT-010](./external-assumptions.md).

## 17. Matriz de trazabilidad vista → contrato

| Vista | Contratos principales | Evidencia de alcance |
|---|---|---|
| `V-MES-01` | Sala, pendiente | No hay contrato de Sala en `output/interfaces/`. |
| `V-MES-02` | Orders/Sala, pendiente | Menu no recibe `orderId` ni crea líneas. |
| `V-MES-03` | E-02, E-03, E-16, Orders | E-02 lista catálogo; E-03 detalle; E-16 resuelve una unidad. |
| `O-MES-01` | E-03, E-16, `Selection`, `ModifierConfig`, `ComboSlot` | La selección usa IDs y cantidades configuradas. |
| `V-ADM-01` | E-19, E-08, E-03 | E-19 resume administración; E-08 detalla; E-03 aporta disponibilidad/precio comercial. |
| `V-ADM-02` | E-07, E-09, E-11, E-13, E-17 | Creación/edición de definiciones, recetas y copias. |
| `V-ADM-03` | E-19, E-20, E-21, E-14 | Revisión de combos por observación y confirmación. |
| `V-ADM-04` | Respuestas E-07/E-09/E-11/E-13/E-21 | Estado visual de una mutación concluida. |

## 18. Decisiones activas incorporadas

- El tipo de `MenuItem` (`fulfillmentType`) es `STOCKED`, `PREPARED` o `COMBO` y no se cambia como una edición ordinaria.
- `MenuItemVariant` es la unidad vendible concreta y tiene precio absoluto.
- `MenuItemVersion` y `recipeVersion` fijan definiciones; no se sustituyen silenciosamente.
- E-16 resuelve la selección y devuelve un resumen monetario por unidad; no crea una orden.
- Los combos no tienen cargos por opción; los precios de componentes aparecen solo como referencia administrativa de revisión.
- `REVIEW_REQUIRED`/`UP_TO_DATE` aplican a combos; no son estados de STOCKED/PREPARED.
- `ARCHIVED` retira variantes de nuevas ventas y no se reactiva en esta versión.
- La clasificación visual de catálogo es obligatoria y usa `Platillo`, `Bebida`, `Combo`, `Postre` y `Complemento`, independientemente de `categoryId` y `fulfillmentType`.
- El total mostrado durante la preorden es la suma de los costos de las líneas configuradas; Billing interviene después para los ajustes finales.
- Las recetas, el catálogo de Inventory, las mesas y las órdenes conservan sus fronteras de propiedad.

## 19. Decisiones no trasladadas de `secuence-v5.md`

La versión anterior contiene flujo y decisiones visuales que ya no deben usarse automáticamente. En particular, `ComboPricingMode = AUTO | MANUAL | DISCOUNT` no forma parte del contrato actual: la versión vigente establece `unitPrice` explícito por variante de combo y no expone términos de precio en E-16.

El documento anterior también trataba `ARCHIVED` y eliminación desde una perspectiva de UI que no coincide con el ciclo de vida actual. En esta especificación se conservaron solo las intenciones compatibles y se señalaron las diferencias como restricciones o `UI-OPEN`.
