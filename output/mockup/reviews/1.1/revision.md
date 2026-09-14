# Revisión de mockups — versión 1.1

**Fecha:** 2026-09-14  
**Dictamen:** **NO APROBADO** como línea base visual  
**Alcance:** auditoría de las 30 composiciones incluidas en output/mockup/1.1/. Se utilizó el HTML como fuente primaria para comprender contenido, estados y acciones; el PNG se utilizó como apoyo para revisar composición y jerarquía visual.
**Fuentes:** output/ui-spec/ui-data-spec.md, revisión 2; output/mockup/reviews/1.0/revision.md; .stitch/DESIGN.md; .stitch/metadata.json; y output/mockup/1.1/README.md como índice de la entrega.
**Método:** revisión de estructura de archivos, dimensiones raster, metadatos de viewport, texto visible, clases de estilo, coherencia entre vista base y variantes, y contraste visual de una muestra representativa.

## Resumen

La versión 1.1 incorpora avances semánticos: el catálogo distingue mejor los tipos de suministro, las variantes administrativas separan estados y el flujo de revisión de combos intenta representar la secuencia E-21 seguida de la actualización E-20. Sin embargo, el conjunto todavía no está alineado con ui-data-spec.md ni puede aceptarse como baseline.

Los incumplimientos principales son:

1. Ninguna de las 30 imágenes está estandarizada a 1024 × 768. Todas fueron generadas con ancho 2560 y alturas variables entre 2048 y 3014. En Stitch, las pantallas de esta entrega también aparecen como DESKTOP y con ancho 2560.
2. V-MES-02-orden-actual todavía mezcla líneas confirmadas con un borrador local y muestra Editar selección, Eliminar línea y Enviar a la orden. La especificación indica que la vista solo debe mostrar las líneas ya confirmadas y ofrecer Agregar productos.
3. V-MES-03-append-order-catalogo conserva el texto Enviar a la orden. En el modo de agregar productos, la acción de los elementos del catálogo debe ser Añadir a la orden; la confirmación del agregado debe quedar en el flujo de la orden.
4. Varias vistas exponen infraestructura, contratos, códigos HTTP, tokens, sincronización, esquemas y nombres de servicios como contenido principal de la experiencia. Esto hace que el mockup explique la implementación en lugar de guiar al usuario.
5. Las variantes de V-ADM-01 y V-ADM-02 no parten de una misma composición. En especial, archivados y review-required en V-ADM-01 parecen productos distintos, y V-ADM-02 alterna editores con dimensiones, densidad y jerarquía incompatibles.
6. El idioma no es completamente español. Permanecen ACTIVE, INACTIVE, ARCHIVED, STATUS, REVIEW_REQUIRED, APPEND_TO_ORDER, HTTP IN-FLIGHT, LOCAL_STAGED, UP_TO_DATE y otros identificadores técnicos visibles.
7. La organización prioriza bordes, paneles y campos de diagnóstico sobre las decisiones que debe tomar la persona usuaria. Hay espacios desaprovechados en unas variantes y saturación de información en otras.
8. Hay inconsistencia de geometría y color: se mezclan esquinas cuadradas, radios distintos, controles tipo píldora y acentos ámbar/amarillos que no corresponden al sistema monocromático definido.

Sí se considera aprovechable:

- La separación conceptual entre CREATE_ORDER y APPEND_TO_ORDER en V-MES-03.
- La intención de distinguir líneas confirmadas y selecciones locales.
- La representación del catálogo por clasificación y tipo de suministro.
- La secuencia explícita de revisión confirmada y refresco posterior en V-ADM-03.
- La separación de los cuatro pasos de alta y los tres pasos de edición en V-ADM-02.

Estos aciertos requieren una segunda iteración visual y de contenido antes de constituir una versión aprobada.

## Evidencia de formato y sincronización

| Validación | Resultado | Evidencia |
|---|---|---|
| Carpetas de mockup | PASS | 30 carpetas de vista dentro de output/mockup/1.1/ |
| Pareja HTML/PNG | PASS | Cada carpeta contiene un HTML y un PNG con el mismo nombre base |
| Resolución objetivo | FAIL | 0 de 30 PNG están en 1024 × 768 |
| Resolución observada | FAIL | 30 de 30 PNG tienen ancho 2560; alturas de 2048 a 3014 |
| Consistencia interna de viewport | FAIL | Los HTML declaran viewport adaptable, pero sus marcos, alturas mínimas y máximos internos son distintos |
| Sincronización de Stitch | FAIL | Las 30 pantallas 1.1 aparecen como DESKTOP y con ancho 2560 |
| Sistema de diseño local | PASS PARCIAL | .stitch/DESIGN.md fue actualizado localmente hacia TABLET LANDSCAPE, 1024 × 768 y español |
| Sistema de diseño remoto | PASS | .stitch/DESIGN.md fue subido como asset fc6c6059ff814e4aa5853866ef6d47a9 y aplicado al asset activo 4921283958737766649 |

La existencia de un meta viewport adaptable no resuelve la auditoría: el entregable debe tener un marco de referencia común para que el espaciado, el tamaño de los paneles y la composición sean comparables.

## Hallazgos por mockup

### V-MES-01-mesas-asignadas

**Prioridad:** P1  
**Resultado:** Requiere corrección.

- La vista utiliza tableId, WITHOUT_ORDER, WITH_ORDER y una fuente técnica de Sala como contenido visible.
- Los estados pueden expresarse como Mesa 12, Sin orden y Con orden, dejando el identificador técnico como detalle secundario solo si es necesario.
- El pie En servicio activo y la nota Sincronizadas desde servicio Sala no aportan una decisión al mesero.
- Las tarjetas de mesa ocupan una fracción reducida de la pantalla y dejan una zona inferior amplia sin función.
- Debe conservarse una sola composición de tarjetas, con diferencia visual clara entre mesa disponible y mesa con orden, y con una acción principal de abrir la mesa.
- El listado debe caber en el marco 1024 × 768 sin convertir la fuente del servicio en un bloque protagonista.

### V-MES-01-estado-vacio

**Prioridad:** P1  
**Resultado:** Requiere corrección.

- EMPTY_RESULT_SET y view_variant son identificadores de implementación, no mensajes para la persona usuaria.
- La explicación Sala no entregó mesas y la hipótesis sobre un filtro oculto están redactadas como diagnóstico técnico.
- El estado vacío debe decir que no hay mesas para mostrar y ofrecer una acción de limpiar filtros o actualizar, según corresponda.
- Debe conservar la misma barra superior, filtros, tarjetas y espaciado que V-MES-01-mesas-asignadas.
- El estado vacío debe aprovechar el espacio central con una explicación breve, sin agregar paneles de arquitectura.

### V-MES-01-error-sala

**Prioridad:** P1  
**Resultado:** Requiere corrección.

- SALA_UNAVAILABLE, UTC, frontera técnica y diagnóstico del servicio hacen que el error parezca una consola operativa.
- El mensaje principal debe indicar que no se pudieron cargar las mesas y explicar en lenguaje simple qué puede intentar el usuario.
- La causa técnica puede quedar fuera del mockup de operación o en un detalle secundario destinado a soporte.
- La variante debe conservar la estructura de V-MES-01 y cambiar únicamente el estado del contenido.
- Debe evitarse un segundo panel con información que no habilita ninguna acción.

### V-MES-02-orden-actual

**Prioridad:** P0  
**Resultado:** No cumple el flujo normativo.

- La vista sí presenta Líneas confirmadas, lo cual es correcto, pero después agrega un borrador local con una variante de 2 tacos.
- Editar selección y Eliminar línea contradicen la regla de que las líneas ya confirmadas quedan bloqueadas en esta pestaña.
- Enviar a la orden no debe existir en esta vista.
- La vista debe limitarse a la orden actual, sus líneas confirmadas, cantidades, precios y total de preorden.
- La única acción de continuación debe ser Agregar productos.
- Al activar Agregar productos se debe abrir V-MES-03 en modo append, mostrando allí la lista elegida y el total; los elementos ya confirmados deben aparecer como bloqueados.
- tableId, orderId, Fuente Orders/Sala y la coordinación entre Menu y Orders no deben ocupar espacio de la interfaz de operación.

### V-MES-02-orden-sin-lineas

**Prioridad:** P0  
**Resultado:** Requiere corrección.

- Es correcto comunicar que todavía no hay líneas confirmadas y ofrecer Agregar productos.
- DraftOrderLines, preorderTotal, syncStatus e Impuestos proyectados son campos de contrato que no deben aparecer como etiquetas principales.
- Confirmar a Cocina introduce una acción no definida para esta vista y no corresponde al único flujo indicado por ui-data-spec.md.
- Debe mostrarse un estado vacío de líneas confirmadas, total en cero y Agregar productos.
- La composición debe ser la misma de V-MES-02-orden-actual, con el estado vacío reemplazando la tabla.

### V-MES-02-error-lectura

**Prioridad:** P1  
**Resultado:** Requiere corrección.

- El error debe conservar la identidad visual de V-MES-02 y diferenciar con claridad que falló la lectura de la orden.
- No debe exponer códigos, nombres de endpoints, tokens o diagnóstico de proveedor como contenido para el mesero.
- Debe incluir un mensaje breve, una acción de reintentar y una salida coherente hacia la vista de mesas.
- No se deben mostrar botones de edición, eliminación o envío mientras la orden no fue cargada.
- La variante necesita el mismo marco 1024 × 768 y la misma posición de encabezado que el resto de V-MES-02.

### V-MES-03-create-order-catalogo

**Prioridad:** P1  
**Resultado:** Requiere corrección.

- La separación Crear orden y modo CREATE_ORDER es entendible, pero DraftOrderLine[], cache, sincronización y otros datos técnicos saturan el encabezado y el panel.
- El catálogo debe priorizar búsqueda, filtros permitidos, tarjetas de producto, configuración y selección temporal.
- El panel lateral debe mostrar Selección actual, cantidad y total en lenguaje de negocio.
- Las acciones deben distinguir configurar un producto, agregarlo a la selección y crear la orden.
- Debe adoptar la misma rejilla y proporción que el modo append; únicamente cambia el título y la acción final.
- La vista debe poder leerse en 1024 × 768 sin que el usuario tenga que recorrer una página alta.

### V-MES-03-append-order-catalogo

**Prioridad:** P0  
**Resultado:** No cumple completamente el flujo solicitado.

- La estructura catálogo más panel de selecciones nuevas es una base adecuada para APPEND_TO_ORDER.
- El panel muestra el total, pero la acción Enviar a la orden no coincide con la semántica solicitada. En las tarjetas y acciones de agregado debe decir Añadir a la orden.
- La vista debe recibir desde V-MES-02 las líneas ya confirmadas y mostrarlas bloqueadas; solo las nuevas selecciones son editables.
- Seguir agregando puede conservarse si funciona como acción secundaria para volver al catálogo.
- DraftOrderLine[] y mode=APPEND_TO_ORDER deben ser secundarios o desaparecer de la superficie operativa.
- La confirmación debe comunicar qué se añadirá y cuánto suma, sin exponer el contrato entre Menu y Orders.

### V-MES-03-estado-catalogo-vacio

**Prioridad:** P1  
**Resultado:** Requiere corrección.

- Debe mantener el mismo catálogo, encabezado, filtros y panel lateral de V-MES-03.
- El estado vacío debe explicar que no hay productos disponibles con los filtros actuales.
- Debe ofrecer limpiar filtros y, si aplica, una búsqueda alternativa.
- No debe convertir el estado vacío en una explicación de cache, proveedor o disponibilidad técnica.
- La proporción del panel y el uso del espacio deben permanecer estables respecto de CREATE_ORDER y APPEND_TO_ORDER.

### V-MES-03-resolving

**Prioridad:** P1  
**Resultado:** Requiere corrección.

- HTTP IN-FLIGHT, pipeline, requestId, RESOLVING y Target Order Session son detalles de implementación.
- El usuario necesita una confirmación breve de que el producto se está preparando para la orden.
- La animación o indicador de progreso debe ocupar una zona pequeña y preservar el contexto del producto seleccionado.
- No deben mostrarse pasos técnicos ni campos de petición en la vista del mesero.
- La variante debe partir del mismo layout de V-MES-03 y cambiar solo el estado del botón y del indicador.

### V-MES-03-seleccion-no-disponible

**Prioridad:** P1  
**Resultado:** Requiere corrección.

- MENU_RESOLUTION_REJECTED, NOT_ELIGIBLE y RESOLUTION_ERROR son códigos y no deben ser el título principal.
- PREPARED_ON_DEMAND y THIRD_PARTY no pertenecen al conjunto canónico de tipos de suministro visible en el catálogo.
- El mensaje debe indicar que el producto no puede agregarse en este momento y explicar una alternativa sencilla.
- Debe conservarse el producto, su configuración y el catálogo alrededor del mensaje, evitando una pantalla de diagnóstico.
- Si se muestra un detalle técnico, debe estar oculto o reservado a soporte.

### O-MES-01-configuracion-item-simple

**Prioridad:** P1  
**Resultado:** Requiere corrección.

- El modal cumple la intención de configurar un producto simple y ofrece Agregar a la orden.
- STATUS 200, MOD-0, requestId, validUntil, E-16 e IVA 16% incl. son metadatos que distraen y algunos pertenecen a otras fronteras.
- Debe priorizar nombre, descripción, imagen, precio, cantidad y la acción Agregar a la orden.
- La nota de resolución debe eliminarse de la superficie principal.
- El modal debe ajustarse a la misma geometría que los modales de preparado, combo y edición.

### O-MES-01-configuracion-item-prepared

**Prioridad:** P1  
**Resultado:** Requiere corrección.

- La coherencia de la selección mejoró: la lechuga con cantidad cero no aparece seleccionada y OMIT cebolla se representa como opción binaria activa.
- priceDelta, basePrice, extrasTotal, unitSubtotal, requestId, validUntil, status y E-16 siguen expuestos como etiquetas técnicas.
- Debe expresarse la opción seleccionada con nombres de negocio, precio adicional cuando exista y cantidad.
- La vista debe conservar el mismo encabezado, pie, ancho y acción del modal simple.
- No debe presentar información de inventario exacto ni explicar la resolución interna de Menu.

### O-MES-01-configuracion-item-combo

**Prioridad:** P1  
**Resultado:** Requiere corrección.

- La selección por grupos de componentes es comprensible como concepto, pero slotId, baseOptionIds, componentRef, optionId y uId no son labels de usuario.
- Debe agrupar componentes por nombre legible y mostrar restricciones solo cuando afectan la decisión.
- El estado RESOLVED y requestId deben sustituirse por una confirmación clara de disponibilidad o desaparecer.
- El modal debe seguir la misma base visual y los mismos márgenes que simple y preparado.
- Agregar a la orden debe quedar como acción final única, con una vista previa breve del total.

### O-MES-01-edicion-linea

**Prioridad:** P1  
**Resultado:** Requiere corrección.

- La intención de editar una selección existente es válida.
- draftLineId, orderId, enabled, groupId, configId, la delimitación contractual, E-09 y E-17 pertenecen a diagnóstico o contrato.
- Debe comunicarse qué producto se está modificando, qué opciones tenía y qué cambios puede guardar la persona usuaria.
- No deben duplicarse acciones de editar, guardar o agregar en el mismo nivel.
- Debe compartir la geometría de los otros modales de O-MES-01 y conservar una acción principal clara.

### V-ADM-01-gestion-catalogo-active

**Prioridad:** P1  
**Resultado:** Requiere corrección.

- La tabla y las pestañas Activos, Inactivos y Archivados proporcionan una base útil.
- ACTIVE, INACTIVE, ARCHIVED, pendingVariantIds, schema, tenant_node y la nota de interpretación arquitectónica deben pasar a labels en español o a documentación fuera de la vista.
- REVIEW_REQUIRED no debe comportarse como un estado base equivalente a Activos, Inactivos y Archivados; es un filtro o indicador de revisión de combos.
- La columna de estado debe usar Activo, Inactivo, Archivado y Revisión requerida, con una explicación corta si hace falta.
- Las variantes administrativas deben mantener el mismo encabezado, tabla, filtros y panel de detalle.

### V-ADM-01-gestion-catalogo-inactive

**Prioridad:** P1  
**Resultado:** Requiere corrección.

- STATUS: INACTIVE y las notas operativas en inglés deben convertirse en Inactivo y una descripción de negocio.
- Los paréntesis que explican modos operativos de forma técnica pueden eliminarse o resumirse en una ayuda contextual.
- Debe ser visualmente la misma vista que Activos, con el filtro Inactivos seleccionado.
- La tabla debe aprovechar el ancho disponible sin aumentar la cantidad de paneles.
- El pie de especificación no debe competir con las filas del catálogo.

### V-ADM-01-gestion-catalogo-archived

**Prioridad:** P0  
**Resultado:** La variante no es consistente con la vista base.

- La composición cambia a una consola de auditoría de dos paneles con encabezado AR, CAT-AUDIT, permiso de retiro y una confirmación de eliminación embebida.
- El usuario observa un resultado de búsqueda, selección masiva, panel de auditoría y operación de archivado en una estructura distinta al resto de V-ADM-01.
- La especificación requiere archivado lógico, sin eliminación física ni reactivación de la variante desde esa operación.
- Debe reutilizar la misma shell de V-ADM-01: encabezado, pestañas, filtros, tabla y panel de detalle.
- La acción de archivar debe ser puntual y confirmable; no se necesita una consola de permisos ni controles masivos si no están respaldados por el alcance.
- Archivado debe mostrarse como Archivado, con el detalle de la variante y la trazabilidad mínima necesaria, no con un bloque de protocolo.

### V-ADM-01-gestion-catalogo-review-required

**Prioridad:** P0  
**Resultado:** La variante no es consistente con la vista base.

- Revisión de combos requerida usa otra estructura de página, otro peso visual y otro panel técnico.
- La duplicación de Tipo de suministro y la mezcla de combos archivados con pendientes generan ambigüedad sobre el filtro.
- REVIEW_REQUIRED debe ser una vista filtrada o un indicador de combos que necesitan revisión, manteniendo la shell de gestión de catálogo.
- El panel de revisión debe mostrar la acción Abrir revisión masiva solo si ese flujo está definido y debe dejar claro que la confirmación requiere variantId y reviewToken.
- pendingVariantIds y el panel de arquitectura no deben ser el centro de la pantalla.
- El resultado de una revisión debe coordinarse con V-ADM-03, sin inventar un estado administrativo nuevo.

### V-ADM-02-create-step1-classification

**Prioridad:** P1  
**Resultado:** Requiere corrección de contenido.

- Los cuatro pasos del alta están bien identificados y el primer paso separa clasificación y tipo de suministro.
- [CREATE], SPEC, SYNC STATUS, SCHEMA, SUPPLY_TYPE, STAGED_OBJ, INACTIVE_DRAFT, CLIENT SESSION, OPERATOR AUTH y BUFFER CHECKSUM son visibles sin aportar a la decisión.
- Debe usar Alta de producto, Clasificación, Tipo de suministro y una explicación breve de por qué se solicita cada campo.
- El paso activo debe distinguirse por estado visual, no por etiquetas de protocolo.
- La estructura debe ser la base reutilizable para las variantes stocked, prepared y combo.

### V-ADM-02-create-stocked-editor

**Prioridad:** P1  
**Resultado:** Requiere corrección.

- La vista comunica la intención de vincular un producto con un suministro existente.
- LOCAL_STAGED, schema, variantId, basePrice, inventoryItemId, OPERATOR y STAGE deben ocultarse o convertirse en información secundaria.
- La zona inferior izquierda queda demasiado vacía mientras el panel derecho concentra campos y estados.
- Debe organizarse el contenido por bloques de Producto, Suministro y Precio, con una jerarquía equilibrada.
- Debe preservar la shell y el stepper de CREATE para que las variantes no parezcan pantallas distintas.

### V-ADM-02-create-prepared-recipe

**Prioridad:** P1  
**Resultado:** Requiere corrección.

- La diferencia entre un producto preparado y uno abastecido se entiende por la receta y el destino operativo.
- recipeId null, baseRecipeVersion null, KITCHEN_PREPARED, RECIPE_DRIVEN y la separación de operaciones son demasiado técnicos para la superficie principal.
- Debe hablar de Preparado en cocina, Receta y Destino de preparación, con estados legibles.
- El warning no debe presentarse como una explicación de transacción o servicio; debe indicar qué falta completar para continuar.
- Debe conservar la misma distribución que el editor de abastecido.

### V-ADM-02-create-combo-editor

**Prioridad:** P1  
**Resultado:** Requiere corrección.

- La idea de configurar grupos y opciones es adecuada para un combo.
- ADMIN_SLOTS, baseOptionIds, slotId, suppliedQty, COMBO_AGGREGATED y SLOT_COMPOSITION no son labels de administración de catálogo.
- Estado aparece junto a controles de selección y puede confundirse con la selección de la opción; se debe separar Selección de Estado.
- Deben mostrarse nombres de grupo, mínimo, máximo y opciones en lenguaje español.
- El editor de combo debe conservar el mismo stepper, ancho, encabezado y acciones que los otros tipos de alta.

### V-ADM-02-create-modificadores

**Prioridad:** P1  
**Resultado:** Requiere corrección.

- La tabla de opciones aporta valor, pero mezcla ADD, OMIT, Habilitada, Deshabilitada, Activo y campos como priceDelta y maxQuantity sin una jerarquía clara.
- PANEL TÉCNICO, CONFIG_HASH, DECLARATIVE y referencias de Inventory no deben ser contenido principal.
- Debe usar Modificadores, Disponible, Precio adicional y Cantidad máxima.
- Debe distinguir una opción habilitada de una opción seleccionada para la configuración actual.
- El pie debe comunicar la siguiente acción del alta, no un contrato de servicios.

### V-ADM-02-create-summary-acceptance

**Prioridad:** P0  
**Resultado:** Contiene una contradicción de estado.

- La pantalla muestra PROPUESTO: ACTIVE mientras el aviso indica que la política obliga INACTIVE hasta homologar suministro o receta.
- La decisión de aceptación no puede mostrar simultáneamente dos estados incompatibles.
- Debe definirse y representar un único resultado: por ejemplo, Guardar como inactivo hasta completar homologación, o Activo si todas las condiciones ya se cumplieron.
- LOCAL_STAGED, version#staged, CANONICAL y DEFAULT deben eliminarse de la superficie operativa.
- El resumen debe presentar datos del producto, suministro, precio, modificadores y condición de publicación, con una sola acción de guardar o regresar a editar.

### V-ADM-02-edit-modificadores

**Prioridad:** P1  
**Resultado:** Requiere corrección.

- La variante respeta la idea de tres pasos de EDIT y distingue que se edita un catálogo existente.
- SYNC, SCHEMA, IN-MEMORY MUTATION ACTIVE, If-Match, Idempotency-Key, E-09, E-17 e Impuesto 16% incl. sobrecargan la interfaz.
- Debe usar Editar producto, Producto y suministro, Modificadores y Confirmar cambios.
- La edición debe mostrar qué campos son editables y cuáles están bloqueados, sin desplegar el mecanismo HTTP.
- La shell debe corresponder a la del alta, ajustando únicamente el stepper y las acciones.

### V-ADM-02-edit-conflicto-revision

**Prioridad:** P1  
**Resultado:** Requiere corrección fuerte de lenguaje y jerarquía.

- HTTP 412 PRECONDITION FAILED, ETag mismatch, RFC-7232, SERVER LIVE, LOCAL CLIENT, telemetry y last commit convierten el estado de conflicto en una consola de protocolo.
- El mensaje útil es que otra persona modificó el producto y los cambios locales no pueden guardarse sobre esa versión.
- Deben ofrecerse acciones claras: cargar la versión actual, revisar diferencias y volver a intentar; solo las que el flujo soporte.
- Debe conservar la misma shell de edición con un aviso destacado, no un diseño completamente alternativo.
- La información de diagnóstico puede existir en una ayuda secundaria destinada a administración técnica.

### V-ADM-03-revision-combo-pendiente

**Prioridad:** P1  
**Resultado:** Requiere corrección.

- Es correcto distinguir estados locales como no visto, visto y seleccionado para confirmación.
- reviewToken, reviewTokenExpiresAt, changeId, Scope, Hash, REST-POS-SYNC, Pipeline y E-19/E-20 no deben ser la lectura principal.
- La pantalla debe decir Combos pendientes de revisión y explicar qué requiere atención.
- La confirmación debe asociarse a la variante seleccionada; no debe hablar de emisión de ticket mediante reviewToken.
- Debe existir una acción de revisar y otra de confirmar únicamente cuando el flujo las respalde.

### V-ADM-03-revision-combo-up-to-date

**Prioridad:** P1  
**Resultado:** La secuencia es aprovechable, pero el contenido debe simplificarse.

- Es correcto representar que E-21 confirma la revisión y que después E-20 actualiza la disponibilidad.
- Gateway READY, checksum, scopeToken, AUTO INVALIDATION ON y LIFECYCLE TRIGGER son detalles de infraestructura.
- La confirmación visible debe ser Al día, con una explicación breve y la fecha o momento de actualización si aporta valor.
- UP_TO_DATE puede quedar como identificador secundario o no mostrarse.
- La vista debe compartir la misma lista y panel de V-ADM-03-pendiente, cambiando el estado y la acción.

### V-ADM-04-confirmacion-guardado

**Prioridad:** P1  
**Resultado:** Requiere redefinir la superficie.

- Los cuatro estados seleccionables convierten la pantalla en un selector de demostración en lugar de una confirmación de resultado.
- CatalogEntrySavedView, STATUS_CODE, E-09, HTTP If-Match, mutation y CATALOG_SPEC_SYNC son detalles técnicos.
- Debe mostrarse un resultado concreto por vista: Alta guardada, Edición guardada, Receta guardada o Revisión confirmada.
- El resultado debe distinguirse de un borrador local y comunicar si existe una advertencia accionable.
- La estructura debe reutilizar una confirmación compacta, no un panel técnico de gran altura.
- Si se requieren variantes para documentar estados, cada una debe conservar la misma composición base y cambiar solo el contenido de resultado.

## Llamado general y convenciones para corregir el set

1. **Marco único:** todas las vistas deben diseñarse y exportarse dentro de 1024 × 768, tablet horizontal. Si una vista necesita desplazamiento interno, debe justificarse y conservar la misma anchura visible.
2. **Una responsabilidad por vista:** cada pantalla debe responder qué puede consultar o decidir la persona usuaria. Los paneles de contrato, protocolo y arquitectura no deben aparecer como contenido de operación.
3. **Flujo de mesas y órdenes:** V-MES-02 solo muestra líneas confirmadas bloqueadas, total y Agregar productos. V-MES-03 recibe el contexto y permite construir o añadir una selección local.
4. **Acciones mínimas:** cada vista debe tener una acción principal y las acciones secundarias estrictamente necesarias. No duplicar editar, eliminar, enviar o confirmar.
5. **Español primero:** traducir estados, modos, filtros y acciones. Los identificadores técnicos solo pueden permanecer como detalle de soporte, nunca como label principal.
6. **Dos niveles de información:** datos de negocio en la superficie; identificadores y diagnósticos en ayuda contextual o fuera del mockup operativo.
7. **Familia visual:** variantes de una misma vista deben reutilizar shell, encabezado, rejilla, tabla, panel, radios, botones y espaciado. Un cambio de estado no justifica rediseñar toda la página.
8. **Jerarquía y densidad:** agrupar por tarea y relación semántica; usar espacio en blanco para separar grupos y reservar el área principal para la decisión actual.
9. **Estados explícitos:** distinguir Activo, Inactivo, Archivado, Revisión requerida, Disponible, No disponible, Bloqueado y Borrador local. No mezclar estado de catálogo, elegibilidad y estado de revisión.
10. **Sistema monocromático:** mantener blanco, grises y negro como base; usar color solo si se define como una excepción funcional. Evitar acentos ámbar/amarillos aislados.
11. **No inventar resultados:** cuando una decisión de arquitectura no está definida por ui-data-spec.md, dejarla como OPEN en la especificación y no cristalizarla en un botón o estado del mockup.

## Orden recomendado de corrección

1. Regenerar el marco de las 30 vistas a 1024 × 768 y retirar alturas mínimas/maximizadas que producen páginas de 2000 a 3000 píxeles.
2. Corregir primero el flujo V-MES-02 → V-MES-03: bloquear líneas confirmadas, eliminar Enviar a la orden de V-MES-02 y usar Añadir a la orden en modo append.
3. Unificar V-MES-01 y V-MES-02 con una shell común para estado normal, vacío y error.
4. Rediseñar V-ADM-01 como una única shell de gestión con filtros o pestañas para Activos, Inactivos, Archivados y revisión de combos.
5. Rediseñar V-ADM-02 con una base común para alta y edición, manteniendo únicamente la diferencia de pasos definida por la especificación.
6. Retirar texto de infraestructura de la superficie principal y sustituirlo por mensajes de negocio breves.
7. Aplicar español completo, labels significantes y el sistema geométrico/colorimétrico actualizado en .stitch/DESIGN.md.
8. Volver a ejecutar la auditoría estructural y visual, y actualizar el resultado solo cuando las 30 vistas y sus variantes compartan evidencia de resolución y coherencia.

## Validaciones ejecutadas y límites

### Validaciones con resultado positivo

- Se localizaron las 30 carpetas de la entrega 1.1.
- Cada carpeta contiene exactamente un HTML y un PNG.
- El nombre base del HTML coincide con el nombre base del PNG.
- Se leyó el HTML para identificar textos, acciones, estados, filtros y tamaños internos.
- Se revisaron visualmente muestras de V-MES-01, V-MES-02, V-MES-03, O-MES-01, V-ADM-01, V-ADM-02 y V-ADM-04.
- Se actualizó localmente .stitch/DESIGN.md para tablet horizontal 1024 × 768, español, geometría menos rígida y jerarquía por grupos.
- Se subió .stitch/DESIGN.md a Stitch, se creó el asset fc6c6059ff814e4aa5853866ef6d47a9 y se actualizó el asset activo 4921283958737766649 con la misma guía.

### Validaciones fallidas o pendientes

- La resolución no cumple 1024 × 768.
- Los metadatos de Stitch de las pantallas 1.1 no cumplen el objetivo de TABLET LANDSCAPE.
- V-MES-02 conserva acciones y datos que contradicen la regla de líneas confirmadas bloqueadas.
- El modo append de V-MES-03 no usa la acción solicitada Añadir a la orden.
- Persisten mensajes y labels técnicos en las 30 vistas.
- Persisten inconsistencias de composición entre las variantes de V-ADM-01 y V-ADM-02.
- Persisten inconsistencias geométricas y acentos cromáticos fuera del sistema monocromático.
- No se ejecutaron pruebas de servicios, integración con Menu/Orders/Sala/Inventory/Billing, accesibilidad, interacción real, rendimiento ni validación de render en navegador. Esta revisión es documental, estructural y visual del artefacto de mockups.
- La sincronización remota del sistema de diseño quedó completada en Stitch: el documento fue cargado como fc6c6059ff814e4aa5853866ef6d47a9 y la instancia activa 4921283958737766649 recibió los tokens actualizados.

**Conclusión:** la versión 1.1 no está alineada de forma suficiente con output/ui-spec/ui-data-spec.md. Debe corregirse la resolución, el flujo de agregado a órdenes, el lenguaje visible y la consistencia entre variantes antes de aprobarla. El archivo .stitch/DESIGN.md local contiene la dirección de corrección y fue sincronizado con Stitch mediante el asset cargado y la actualización de la instancia activa; esa sincronización no modifica el dictamen de los mockups 1.1.
