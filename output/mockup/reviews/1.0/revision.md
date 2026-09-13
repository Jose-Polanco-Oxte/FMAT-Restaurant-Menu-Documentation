# Revisión de mockups — versión 1.0

**Fecha:** 2026-09-13  
**Alcance:** revisión visual y semántica de los 15 PNG incluidos en `output/mockup/1.0/`.  
**Fuentes:** `output/ui-spec/ui-data-spec.md` revisión 2 y `output/mockup/style-spec.json`.  
**Método:** inspección visual directa de cada imagen y contraste con las composiciones, campos, estados y reglas de presentación de la especificación. No se evaluó una implementación navegable ni la resolución real de datos externos.

## Resumen

El set tiene una base visual sólida: conserva el lenguaje monocromático, la geometría rectangular, la jerarquía tipográfica y la separación entre datos confirmados y borradores en varias vistas. También representa correctamente varios límites importantes: `Menu` no crea órdenes, E-16 no reserva stock, los combos no agregan cargos por opción y `ARCHIVED` se trata como retiro suave.

Sin embargo, la versión 1.0 no debe considerarse lista para usar como baseline final. Los problemas más importantes son:

- **P0 — Organización de la vista:** los 15 mockups incluyen sidebars o shells de navegación que representan cómo se accedería a la sección. Eso desplaza el foco de la vista principal y hace que cada mockup parezca una pantalla de una aplicación ya definida.
- **P0 — Estado de revisión prematuro:** `V-ADM-03` muestra `Estado posterior: UP_TO_DATE` antes de ejecutar la confirmación y antes de refrescar E-20. La especificación prohíbe presentar ese resultado antes de leer el estado posterior.
- **P0 — Confirmación ambigua:** `V-ADM-04` mezcla alta, edición, receta, revisión y borrador local dentro de una única operación aparentemente completada. El usuario no puede saber cuál fue el resultado real.
- **P1 — Wizard inconsistente:** los mocks de creación PREPARED y COMBO cambian los nombres de los pasos respecto al wizard definido en `UI-REQ-011`; no deben existir variantes paralelas de la secuencia.
- **P1 — Nomenclatura técnica expuesta como UX principal:** campos como `classification`, `fulfillmentType`, `recipeId`, `baseRecipeVersion`, `priceDelta`, `reviewToken` y nombres de microservicios aparecen como labels primarios. Deben conservarse como metadatos secundarios cuando aporten trazabilidad, pero la acción y el apartado deben tener una etiqueta comprensible para el actor.
- **P1 — Ambigüedad en selección y datos:** hay controles cuyo estado no coincide con su cantidad (`Lechuga adicional` en la configuración PREPARED), checkboxes que no se relacionan claramente con `baseOptionIds` en el editor COMBO y personalizaciones de combo presentadas como `Unidad 1`/`Unidad 2` sin indicar a qué slot o componente pertenecen.
- **P1 — Filtros administrativos incompletos:** `V-ADM-01` rotula `Tipo de cumplimiento` en vez de `Tipo de suministro` y no muestra el filtro `COMBO` junto con `STOCKED` y `PREPARED`.

La recomendación general es corregir primero la estructura de las vistas y los estados engañosos; después normalizar labels y controles; finalmente hacer una pasada de consistencia entre todos los mockups.

## Hallazgos por mockup

### `V-MES-01-mesas-asignadas.png` — Mesas asignadas

- **P0 — Sidebar fuera de alcance:** aparecen `Mesas`, `Pedidos`, `Menú`, `Reportes` y `Configuración`. El mockup debe concentrarse en la vista de mesas asignadas; la navegación, la URL o la decisión de single page se deja para después.
- **P1 — Lenguaje de fuente mezclado con UX:** `Sala` y `Orders` aparecen como apartados visibles del card y también en el footer. Sirven para trazabilidad, pero para un mesero sería más claro mostrar `Mesa`, `Orden` y un metadato discreto de origen, no presentar nombres de servicios como navegación.
- **P1 — Acción duplicada por estado sin explicación de prioridad:** `Crear orden` y `Abrir orden` son correctas, pero el estado podría expresarse como `Sin orden`/`Con orden` en el título de la tarjeta y dejar el badge técnico fuera del camino principal.
- **P2 — Datos de ejemplo repetidos:** `orderId: ORD-2048` aparece en más de una mesa con orden. Si es contenido ficticio, cada orden debería tener una referencia distinta para no sugerir que dos mesas comparten la misma orden.
- **P2 — Conteo visible:** `5 mesas asignadas` es correcto como ejemplo, pero debe entenderse como resultado de Sala y no como una cuota fija. Conviene marcarlo como total recibido o evitar que parezca una capacidad del sistema.

**Lo que funciona:** la vista distingue correctamente `SIN ORDEN`/`CON ORDEN`, restringe visualmente el conjunto a mesas asignadas y usa acciones distintas para ambos estados.

### `V-MES-02-orden-actual.png` — Orden actual

- **P0 — Sidebar fuera de alcance:** el panel lateral vuelve a convertir la vista en un shell de aplicación, aunque la especificación solo pide la orden actual de la mesa seleccionada.
- **P1 — `ACTIVA` no está respaldado por una enumeración del repositorio:** el estado de la orden pertenece a Orders y su enumeración está abierta. Debe mostrarse como `Estado recibido` o como un valor explícitamente proveniente de Orders, hasta que el contrato defina los estados.
- **P1 — Acción demasiado técnica:** `Confirmar con Orders` expone el propietario del servicio y puede hacer pensar que la UI envía una petición directa a un microservicio. Para el mesero debe ser `Enviar a la orden` o `Agregar a la orden`; Orders puede conservarse como metadato secundario.
- **P1 — Fórmula en la superficie principal:** `lineCost = quantity × resolvedUnitSubtotal` es útil para trazabilidad, pero no es una label de operación. Debe quedar en ayuda contextual o en la documentación; la vista debe priorizar `Total de preorden`.
- **P2 — Label abreviado:** `P. unitario` no es tan claro como `Precio unitario` y rompe la convención de labels descriptivos.

**Lo que funciona:** las líneas confirmadas están separadas de la preorden local, se indica que las primeras no son editables desde ahí y el `preorderTotal` está separado del total confirmado.

### `V-MES-03-catalogo-preorden.png` — Catálogo y preorden

- **P0 — Sidebar fuera de alcance:** debe eliminarse para dejar el catálogo como vista principal.
- **P1 — Modo técnico como encabezado:** `APPEND_TO_ORDER` es útil como estado de trazabilidad, pero el encabezado principal debería decir `Agregar productos a la orden` y conservar `APPEND_TO_ORDER` como metadato secundario.
- **P1 — Filtro no completamente contractual:** `Tipo de suministro` se ofrece como filtro de primer nivel, aunque E-02 no lo incluye en `MenuItemCard`. Debe marcarse como filtro dependiente de hidratación E-03, de una proyección ampliada o de una decisión UI-OPEN; no debe parecer un filtro respaldado directamente por E-02.
- **P1 — `Disponible` puede confundirse con stock:** la especificación define `eligible` y prohíbe inferir stock exacto. Es preferible `Elegible para ordenar` o `No elegible`, dejando `Disponible` solo si se acompaña de esa aclaración.
- **P1 — `RESUELTO` es demasiado técnico:** para el mesero sería más comprensible `Configuración válida`; `resolution` y E-16 pueden permanecer en un detalle secundario.
- **P2 — Total técnico:** `preorderTotal` debe acompañarse de `Total de preorden` como label visible. El nombre canónico puede aparecer debajo como metadato.

**Lo que funciona:** las cinco clasificaciones comerciales aparecen separadas de los productos, el card no elegible no permite configurar, `fromPrice=null` no se convierte en cero y el panel de borrador distingue líneas locales.

### `ui-states-alternos.png` — Estados alternos

- **P1 — No es una vista principal:** la lámina combina cuatro pantallas en una sola composición. Es útil como hoja de estados, pero no debe presentarse como mockup final de una pantalla navegable.
- **P0 — Sidebars repetidos:** cada mini-vista incluye navegación lateral, multiplicando el problema de organización y consumiendo espacio que debería usarse para el estado que se revisa.
- **P1 — Consistencia de idioma:** `resolving` aparece en el título (`Catálogo · resolving`) mientras el resto de la interfaz está en español. Debe ser `Catálogo · resolviendo`; el enum `RESOLVING` puede permanecer como badge técnico.
- **P1 — Error de Sala:** `SALA_UNAVAILABLE` es útil como código, pero la acción debe priorizar `No se pudieron cargar tus mesas` y dejar el código en detalles expandibles.
- **P2 — Nota global demasiado larga:** `Estados de presentación UI · no son estados persistidos de Menu` es correcta, pero puede moverse al encabezado de la lámina para no competir con los estados.

**Lo que funciona:** diferencia correctamente vacío por causa, indisponibilidad externa, carga en curso y error de resolución; ninguno de esos estados se presenta como estado persistido de Menu.

### `O-MES-01-configuracion-item-prepared.png` — Configuración de item no combo

- **P0 — Sidebar y shell fuera de alcance:** el overlay debería poder evaluarse como composición de configuración sobre la vista principal, no como una navegación completa del producto.
- **P1 — Control inconsistente:** `Lechuga adicional` aparece sin seleccionar pero con cantidad `1`. La cantidad debe ser `0` cuando la opción no está seleccionada, o el control debe mostrarse seleccionado.
- **P1 — Semántica de omisión:** `Sin cebolla` está seleccionada con cantidad `0`. Si la selección se expresa mediante `configId` y `quantity`, conviene mostrar una selección binaria de omisión o usar cantidad `1` para indicar que el efecto `OMIT` fue elegido; la convención debe ser explícita y consistente.
- **P1 — Label técnico:** `PrecioDelta` debe ser `Ajuste de precio` y, si se requiere trazabilidad, mostrar `priceDelta` como texto secundario.
- **P2 — Falta el costo de línea:** se muestra `unitSubtotal` y `Cantidad 2`, pero no el costo de la línea. Como la vista de preorden usa `quantity × resolvedUnitSubtotal`, conviene añadir `Costo de línea: $336.00 MXN` sin confundirlo con `unitSubtotal`.

**Lo que funciona:** se muestran variante, dimensiones, mínimos/máximos, opciones, `ADD`/`OMIT`, moneda, vigencia y la separación entre formulario y resultado E-16.

### `O-MES-01-configuracion-combo.png` — Configuración de combo

- **P0 — Sidebar y shell fuera de alcance:** el overlay debe permanecer enfocado en selección de slots y resolución.
- **P1 — Falta `optionId`:** se muestran nombre y referencia del componente, pero la especificación pide que cada opción pueda distinguirse también por `optionId`.
- **P1 — Personalización por unidad ambigua:** `Unidad 1` y `Unidad 2` no indican si pertenecen a la bebida, al acompañamiento o a otra unidad suministrada. La label debe ser específica, por ejemplo `Bebida · unidad 1` y `Acompañamiento · unidad 1`.
- **P1 — `unitPrice` técnico:** debe presentarse como `Precio de la variante` y dejar `unitPrice` en metadato; lo mismo aplica a `basePrice` y `extrasTotal` del panel E-16.
- **P2 — Botón de entrada:** `Agregar al borrador` es correcto, pero conviene mantener visible que la acción agrega una línea configurada y no modifica la composición del combo.

**Lo que funciona:** distingue selección del slot frente a `suppliedQuantity`, no muestra cargos por opción, conserva referencias de item/versión/variante y separa E-16 de los controles de selección.

### `V-ADM-01-gestion-catalogo-activo.png` — Gestión del catálogo activa

- **P0 — Sidebar fuera de alcance:** la vista administrativa debe mostrar el catálogo y sus apartados; la navegación lateral no es parte de este mockup.
- **P1 — Label incorrecto:** `Tipo de cumplimiento` no describe `fulfillmentType`. Debe ser `Tipo de suministro`.
- **P1 — Filtro incompleto:** solo aparecen `STOCKED` y `PREPARED`; falta `COMBO`, aunque el propio listado incluye un combo.
- **P1 — Cobertura insuficiente del conjunto:** `INACTIVE` aparece como una tarjeta dentro de ACTIVE y `UP_TO_DATE` solo aparece como tab. Para validar la separación de apartados, hace falta una composición que demuestre cada filtro o indicar claramente que se trata de pestañas no activas.
- **P2 — `eligible` como badge primario:** en administración puede mostrarse como disponibilidad temporal, pero debe quedar más separado de `status` para que `ACTIVE` no se interprete como elegible.
- **P2 — Copy técnico:** `status ≠ eligible` y `No es stock exacto` son buenas advertencias, pero conviene usar una frase orientada al administrador: `El estado administrativo no determina la elegibilidad de venta`.

**Lo que funciona:** separa `ACTIVE`, `INACTIVE`, `REVIEW_REQUIRED` y `ARCHIVED`; el combo muestra la revisión como estado superpuesto y no como sustituto de `status`.

### `V-ADM-01-gestion-catalogo-archived.png` — Gestión del catálogo archivado

- **P0 — Sidebar fuera de alcance:** aplica el mismo ajuste que al resto del set.
- **P1 — Label técnico como contenido principal:** `classification:`, `archivedAt:` y `archivedBy:` deberían verse como `Clasificación`, `Archivado el` y `Archivado por`; los nombres de campo se pueden conservar en un detalle técnico.
- **P1 — Mensaje mezclado:** `Una variante ARCHIVED no se reactiva en esta versión` aparece en el listado de items archivados. El apartado contiene `MenuItem` archivados; el mensaje sobre variantes debe aparecer en el detalle de una variante o decir explícitamente `Las variantes ARCHIVED no se reactivan desde esta versión`.
- **P1 — Acción potencialmente destructiva:** `Eliminar uno`, `Eliminar seleccionados` y `Eliminar todos` están exigidos por la especificación, pero deben tener una confirmación contextual que repita `retiro suave` antes de ejecutar, no solo una nota estática al pie.
- **P2 — `Apartado ARCHIVED`:** como encabezado para un administrador sería más natural `Archivados`, con `ARCHIVED` como estado canónico en el tab o badge.

**Lo que funciona:** muestra selección individual y múltiple, conserva fecha/actor de archivo y deja claro que no existe borrado físico.

### `V-ADM-02-create-step1-classification.png` — CREATE, clasificación y tipo

- **P0 — Sidebar fuera de alcance:** el wizard debe mostrar el paso actual, no una arquitectura de navegación completa.
- **P1 — Mismo texto para dos dimensiones:** `Combo` está seleccionado tanto en `Clasificación comercial` como en `Tipo de suministro`. Es válido que coincidan, pero visualmente parece que una elección deriva automáticamente en la otra. Debe haber una ayuda más explícita: `Son dimensiones independientes`.
- **P1 — Labels de resumen técnicos:** `classification`, `fulfillmentType`, `menuId` y `status` deben tener labels amigables (`Clasificación`, `Tipo de suministro`, `Menú`, `Estado`) y valores técnicos en segundo nivel.
- **P2 — `Guardar borrador` sin estado:** si se permite guardar desde el paso 1, debe aclararse `Guardar borrador local` o `Guardar como INACTIVE`; de lo contrario el usuario puede creer que ya existe un MenuItem persistido.

**Lo que funciona:** representa claramente CREATE, usa un stepper de cuatro pasos y mantiene clasificación comercial separada del tipo de suministro en la estructura.

### `V-ADM-02-create-stocked-editor.png` — CREATE, editor STOCKED

- **P0 — Sidebar fuera de alcance:** debe retirarse.
- **P1 — Metadatos y labels mezclados:** `unitPrice.amount`, `unitPrice.currency`, `fulfillmentType`, `inventoryItemId` y `categoryId` aparecen como labels principales. Deben ser labels de usuario con el campo canónico debajo cuando sea necesario.
- **P1 — `categoryId` y `Clasificación` bloqueados sin explicación:** ambos parecen valores persistidos, pero la fuente y el mapeo de clasificación son externos. Se necesita una ayuda breve que diferencie `Categoría externa` de `Clasificación comercial`.
- **P2 — `imageRef` como control de imagen:** el icono puede sugerir carga de bytes, aunque la especificación solo define una referencia string/null. Debe rotularse `Referencia de imagen` y explicar que la carga/resolución depende de un proveedor externo.
- **P2 — Mensaje de validez prematuro:** `Configuración válida para continuar` debe depender de las validaciones visibles; si todavía no se ha resuelto Inventory, sería más seguro `Datos mínimos completos` o `Pendiente validar con Inventory`.

**Lo que funciona:** muestra precio absoluto de variante, tipo de suministro inmutable, referencia de Inventory, unidad y cantidad de consumo sin convertirla en stock.

### `V-ADM-02-create-prepared-recipe.png` — CREATE, editor PREPARED

- **P0 — Stepper inconsistente:** el mockup usa `Información general`, `Item y suministro`, `Precios y disponibilidad`, `Revisión y confirmación`, mientras `UI-REQ-011` exige `Clasificación y tipo`, `Item y suministro`, `Modificadores`, `Resumen y aceptación`. Debe usar exactamente la misma secuencia que `create-step1`.
- **P0 — Sidebar fuera de alcance:** debe retirarse.
- **P1 — Labels técnicos primarios:** `classification`, `status`, `fulfillmentType`, `variantId`, `recipeId` y `baseRecipeVersion` deben ser secundarios frente a labels orientados al administrador.
- **P1 — El título `RecipeDraft (receta en edición)` puede confundir:** en este ejemplo `recipeId: null` y `baseRecipeVersion: null` indican receta nueva. Debe decir `Nueva receta` o `Borrador de receta` y reservar `en edición` para una revisión existente.
- **P2 — Botón `Editar receta` ambiguo:** si el panel ya es editable, el botón debe ser `Modificar componentes` o abrir una edición claramente separada. Si es solo lectura, entonces el panel no debe parecer un formulario editable.

**Lo que funciona:** mantiene separadas la receta, su revisión y la adopción en MenuItem; muestra componentes con unidad y cantidad.

### `V-ADM-02-create-combo-editor.png` — CREATE, editor COMBO

- **P0 — Stepper inconsistente:** `Precios y reglas` no corresponde al paso `Modificadores`, y `Revisión y confirmación` no corresponde al paso `Resumen y aceptación`. Debe alinearse con los otros mocks CREATE.
- **P0 — Sidebar fuera de alcance:** debe retirarse.
- **P1 — Checkboxes sin semántica clara:** la primera columna puede parecer selección masiva, edición de `baseOptionIds` o habilitación. Como `baseOptionIds` ya aparece en un bloque separado, las filas deberían mostrar `enabled` y una indicación explícita de `baseOption` solo cuando corresponda.
- **P1 — Inconsistencia con `baseOptionIds`:** `baseOptionIds: [BEB-01, ACC-01]` contiene opciones base, pero las casillas visibles no muestran qué filas están seleccionadas. La representación actual no permite verificar que la base esté dentro de límites y habilitada.
- **P1 — Falta `optionId`:** se muestra el nombre y el componente, pero no la identidad propia de la opción.
- **P2 — `unitPrice.amount` técnico:** utilizar `Precio de venta de la variante` como label principal para reforzar que es precio absoluto y no suma de componentes.

**Lo que funciona:** muestra slots, límites, referencias fijadas, `suppliedQuantity`, `enabled` y la regla de que las opciones incluidas no agregan cargos.

### `V-ADM-02-edit-modificadores.png` — EDIT, modificadores

- **P0 — Sidebar y header oscuro fuera del lenguaje común:** además de la navegación innecesaria, el header oscuro rompe la regla transversal de barra horizontal blanca.
- **P1 — Paso 1 genérico:** `Item y suministro` no muestra la definición precargada en este mock; el usuario debe poder confirmar que la edición reemplazará la definición completa y conservará variantes no modificadas.
- **P1 — Labels técnicos densos:** `optionId`, `configId`, `priceDelta`, `maxQuantity` y `If-Match` son correctos como trazabilidad, pero no deben dominar la tabla. Usar `Opción`, `Ajuste`, `Cantidad máxima` y un panel técnico expandible.
- **P1 — Falta estado de conflicto:** la vista menciona `If-Match`, pero no muestra cómo se conserva el borrador si la definición cambió. Hace falta una variante de `conflicto de revisión` o una nota explícita de esa conducta.
- **P2 — `Salsas` no muestra el mismo nivel de detalle que `Extras`:** las tablas equivalentes deberían conservar las mismas columnas o indicar por qué el grupo tiene menos información.

**Lo que funciona:** distingue EDIT de CREATE, conserva `menuItemVersion`, muestra `ADD`/`OMIT`, el estado `disabled` y la clave de idempotencia.

### `V-ADM-03-revision-combo.png` — Revisión administrativa de combo

- **P0 — Estado posterior mostrado antes de tiempo:** `Estado posterior: UP_TO_DATE tras refrescar E-20` aparece antes de pulsar `Confirmar variantes seleccionadas`. Esto contradice la regla de que `UP_TO_DATE` solo se muestra después de confirmar y volver a consultar E-20. Debe ser un mock separado de resultado posterior o un panel inicialmente vacío que se llena después.
- **P0 — Sidebar fuera de alcance:** debe retirarse.
- **P1 — `Confirmar variantes seleccionadas` no explica token:** la pantalla muestra `reviewToken`, pero la acción debería indicar en ayuda que confirma por `variantId + reviewToken`, no por componente ni mediante `verified=true`.
- **P1 — `SEEN` solo está en la leyenda:** si el flujo necesita distinguir `UNSEEN`, `SEEN` y `SELECTED_FOR_CONFIRMATION`, la lista debería incluir al menos una fila realmente `SEEN` o la leyenda debe llamarse `Estados posibles`.
- **P2 — Labels técnicos:** `slotId`, `optionId`, `observedVersion` y `reviewTokenExpiresAt` son adecuados como detalle técnico, pero falta una traducción primaria como `Slot`, `Opción`, `Versión observada` y `Vigencia del token`.

**Lo que funciona:** distingue la unidad revisable por variante, conserva token opaco, changeId, motivo, referencia de componente y evita presentar la diferencia de precio como precio de venta del combo.

### `V-ADM-04-confirmacion-guardado.png` — Confirmación de guardado

- **P0 — Cuatro resultados presentados como una sola operación:** `Alta guardada`, `Edición guardada`, `Receta guardada` y `Revisión confirmada` aparecen bajo `Operación completada`. Son estados alternativos, no cuatro subresultados simultáneos. Debe existir una composición por resultado o un selector de tipo de operación.
- **P0 — Sidebar fuera de alcance:** debe retirarse.
- **P1 — Éxito y warning con la misma jerarquía:** `Edición guardada` usa el mismo icono de éxito que los resultados plenamente completados aunque conserva warnings. Debe diferenciar `Guardado con advertencias` de `Guardado confirmado`.
- **P1 — Borrador local mezclado con persistencia:** la nota `No persistido` es correcta, pero dentro de una pantalla de éxito puede interpretarse como parte de la operación. Debe aparecer como estado alternativo o como sección de recuperación claramente separada.
- **P2 — Campos técnicos como contenido dominante:** los IDs y versiones son necesarios para auditoría, pero falta un resumen humano del item/receta afectado junto con el detalle técnico.

**Lo que funciona:** conserva versiones, warnings, actor, instante, cambios reconocidos y la advertencia de que Menu no confirma Orders ni descuenta Inventory.

## Llamado general y convenciones para corregir el set

**Sidebars representando el apartado deben evitarse, se supone que estamos interpretando un borrador de la vista principal, el como se accede a ella o si va a ser una single page o vistas como tal por url es problema para después por lo tanto hay que corregirlo**

Además de esa corrección obligatoria, todas las siguientes convenciones deberían aplicarse al set completo:

1. **Mockup = vista principal.** Eliminar sidebars, menús globales, breadcrumbs de arquitectura y shells que no aporten a la responsabilidad de la vista. Mantener solo título, contexto, filtros, contenido y acciones propias del caso.
2. **Dos niveles de lenguaje.** Usar labels de negocio en primer nivel (`Tipo de suministro`, `Ajuste de precio`, `Total de preorden`, `Archivados`) y reservar nombres canónicos (`fulfillmentType`, `priceDelta`, `preorderTotal`, `ARCHIVED`) para metadatos, tooltips o paneles de detalle.
3. **Estados sin inferencias.** No usar `ACTIVE` como sinónimo de elegible, `Disponible` como sinónimo de stock, `REVIEW_REQUIRED` como estado de producto ni `UP_TO_DATE` antes de refrescar. Las dimensiones `status`, `eligible`, `reviewState` y `ARCHIVED` deben permanecer separadas.
4. **Acciones orientadas al actor.** No usar nombres de microservicios como acción principal (`Confirmar con Orders`). El actor debe ver la intención (`Agregar a la orden`, `Enviar a la orden`, `Confirmar revisión`). El proveedor puede quedar como metadato.
5. **Wizard único y estable.** CREATE debe usar siempre: `1 Clasificación y tipo`, `2 Item y suministro`, `3 Modificadores`, `4 Resumen y aceptación`. EDIT debe usar siempre: `1 Item y suministro`, `2 Modificadores`, `3 Confirmación`. Los editores STOCKED, PREPARED y COMBO cambian el contenido del paso, no el significado del stepper.
6. **Estados alternos separados.** Vacío, error, `RESOLVING`, `RESOLUTION_ERROR`, guardado con advertencias y `UP_TO_DATE` posterior deben ser composiciones independientes o estados claramente seleccionables; nunca deben parecer hechos simultáneos.
7. **Selección coherente.** Checkbox/radio, cantidad y estado deben representar la misma decisión. Una opción no seleccionada no puede tener cantidad positiva; `baseOptionIds` debe corresponder visualmente con opciones habilitadas; la personalización por unidad debe indicar slot y componente.
8. **Borrador frente a persistencia.** Todo `DraftOrderLine`, `RecipeDraft` y `Guardar borrador` debe mostrar explícitamente si es local o persistido. La confirmación de Menu no debe sugerir éxito de Orders, Billing o Inventory.
9. **Combo sin cargos implícitos.** `unitPrice` es el precio absoluto de la variante; los precios guardado/actual de componentes solo son referencia administrativa de revisión. No mostrar extras de combo como si fueran cargos al cliente.
10. **Densidad y consistencia.** Mantener el marco, espaciado, botones y estados en escala de grises, pero reducir contenido técnico visible cuando no sea necesario para la decisión del actor. Los campos equivalentes deben usar el mismo label, orden y componente en todos los mockups.

## Orden recomendado de corrección

1. Retirar sidebars y shells de las 15 imágenes.
2. Separar `UP_TO_DATE` posterior y corregir la composición de `V-ADM-04`.
3. Unificar los steppers CREATE/EDIT.
4. Corregir selección/cantidad de O-MES-01 y la representación de `baseOptionIds`/`optionId` del editor COMBO.
5. Normalizar labels de negocio, filtros, acciones y estados técnicos.
6. Generar una nueva versión y repetir esta auditoría, incluyendo una variante de `INACTIVE`, `UP_TO_DATE` y conflicto de edición donde sea necesario.
