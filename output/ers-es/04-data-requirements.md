[← Índice](./index.md)

# Requisitos de datos

Cada bloque establece una obligación primaria. Los atributos enumerados describen un mismo dato u operación; no son pasos independientes. Las verificaciones son criterios propuestos, no pruebas de software ejecutadas. Los términos del modelo identifican conceptos del dominio, no tecnologías exigidas.

---

<a id="data-menu-001"></a>
### DATA-MENU-001 — Menú

**Requisito:**
El servicio Menu deberá conservar un menú mediante su identificador, referencia de restaurante, nombre y descripción.

**Tipo:** Requisitos de datos

**Fuente:** `docs/md/Modelo-Final.md` pp. 22


**Verificación:** Demostración: Registrar el hecho descrito y recuperarlo, comparando cada dato y asociación enumerados. No se prescribe tipo de almacenamiento, valor predeterminado ni borrado en cascada.

**Estado:** Confirmado

---

<a id="data-menu-002"></a>
### DATA-MENU-002 — MenuItem comercial

**Requisito:**
El servicio Menu deberá conservar un `MenuItem` mediante su identificador, referencia al `Menu` propietario, nombre, descripción, referencia de imagen, tipo de MenuItem y estado administrativo, con `ItemCategory` y clasificación comercial para items hoja o `ComboCategory` para items COMBO.

**Tipo:** Requisitos de datos

**Fuente:** `docs/md/Modelo-Final.md` pp. 36–37


**Verificación:** Demostración: Registrar el hecho descrito y recuperarlo, comparando cada dato y asociación enumerados. No se prescribe tipo de almacenamiento, valor predeterminado ni borrado en cascada.

**Estado:** Confirmado

---

<a id="data-menu-003"></a>
### DATA-MENU-003 — Característica de presentación

**Requisito:**
El servicio Menu deberá conservar una característica de presentación con nombre mediante su identificador, nombre y `MenuItem` hoja propietario.

**Tipo:** Requisitos de datos

**Fuente:** `docs/md/Modelo-Final.md` pp. 21, 36–37


**Verificación:** Demostración: Registrar el hecho descrito y recuperarlo, comparando cada dato y asociación enumerados. No se prescribe tipo de almacenamiento, valor predeterminado ni borrado en cascada.

**Estado:** Confirmado

---

<a id="data-menu-004"></a>
### DATA-MENU-004 — Variante vendible

**Requisito:**
El servicio Menu deberá conservar una `MenuItemVariant` vendible de PREPARED/STOCKED mediante su identificador, `MenuItem` propietario, precio unitario absoluto, suministro concreto y valores de características de presentación seleccionados.

**Tipo:** Requisitos de datos

**Fuente:** `docs/md/Modelo-Final.md` pp. 21, 26–28, 36–37


**Verificación:** Demostración: Registrar el hecho descrito y recuperarlo, comparando cada dato y asociación enumerados. No se prescribe tipo de almacenamiento, valor predeterminado ni borrado en cascada.

**Estado:** Confirmado

---

<a id="data-menu-005"></a>
### DATA-MENU-005 — Definición de variante almacenada

**Requisito:**
El servicio Menu deberá conservar una definición de suministro de variante almacenada mediante su referencia de variante, referencia de artículo de Inventory, cantidad de retiro y unidad de medida.

**Tipo:** Requisitos de datos

**Fuente:** `docs/md/Modelo-Final.md` pp. 8–9, 37


**Verificación:** Demostración: Registrar el hecho descrito y recuperarlo, comparando cada dato y asociación enumerados. No se prescribe tipo de almacenamiento, valor predeterminado ni borrado en cascada.

**Estado:** Confirmado

---

<a id="data-menu-006"></a>
### DATA-MENU-006 — Espacio de combo

**Requisito:**
El servicio Menu deberá conservar un ComboSlot mediante su identificador, ComboConfiguration propietaria, nombre y límites mínimo y máximo de selecciones.

**Tipo:** Requisitos de datos

**Fuente:** `docs/md/Modelo-Final.md` pp. 9–10, 30–31


**Verificación:** Demostración: Registrar el hecho descrito y recuperarlo, comparando cada dato y asociación enumerados. No se prescribe tipo de almacenamiento, valor predeterminado ni borrado en cascada.

**Estado:** Confirmado

---

<a id="data-menu-007"></a>
### DATA-MENU-007 — Grupo de modificadores

**Requisito:**
El servicio Menu deberá conservar un grupo de modificadores mediante su identificador, `MenuItem` PREPARED o STOCKED propietario, nombre y límites mínimo y máximo de selecciones.

**Tipo:** Requisitos de datos

**Fuente:** `docs/md/Modelo-Final.md` pp. 12–13, 48


**Verificación:** Demostración: Registrar el hecho descrito y recuperarlo, comparando cada dato y asociación enumerados. No se prescribe tipo de almacenamiento, valor predeterminado ni borrado en cascada.

**Estado:** Confirmado

---

<a id="data-menu-008"></a>
### DATA-MENU-008 — Configuración de modificador por variante

**Requisito:**
El servicio Menu deberá conservar una excepción opcional de modificador para un par variante hoja-opción mediante su ajuste de precio, cantidad máxima seleccionable y efectos sobre ingredientes asociados.

**Tipo:** Requisitos de datos

**Fuente:** `docs/md/Modelo-Final.md` pp. 42–47


**Verificación:** Demostración: Registrar el hecho descrito y recuperarlo, comparando cada dato y asociación enumerados. No se prescribe tipo de almacenamiento, valor predeterminado ni borrado en cascada.

**Estado:** Confirmado

---

<a id="data-menu-009"></a>
### DATA-MENU-009 — Efecto sobre ingrediente

**Requisito:**
El servicio Menu deberá conservar un efecto sobre ingrediente mediante su comportamiento general o excepción de modificador propietaria, referencia de artículo de inventario, tipo ADD u OMIT y cantidad y unidad de medida cuando correspondan según BR-MENU-013 y BR-MENU-019.

**Tipo:** Requisitos de datos

**Fuente:** `docs/md/Modelo-Final.md` pp. 34, 42–46


**Verificación:** Demostración: Registrar el hecho descrito y recuperarlo, comparando cada dato y asociación enumerados. No se prescribe tipo de almacenamiento, valor predeterminado ni borrado en cascada.

**Estado:** Confirmado

---

<a id="data-menu-010"></a>
### DATA-MENU-010 — Identidad de receta

**Requisito:**
El servicio Menu deberá conservar una receta mediante su identificador, nombre y versión.

**Tipo:** Requisitos de datos

**Fuente:** `docs/md/Modelo-Final.md` pp. 23, 37–38


**Verificación:** Demostración: Registrar el hecho descrito y recuperarlo, comparando cada dato y asociación enumerados. No se prescribe tipo de almacenamiento, valor predeterminado ni borrado en cascada.

**Estado:** Confirmado

---

<a id="data-menu-011"></a>
### DATA-MENU-011 — Valor de característica de presentación

**Requisito:**
El servicio Menu deberá conservar un valor con nombre de característica de presentación mediante su identificador, nombre y característica de presentación a la que pertenece.

**Tipo:** Requisitos de datos

**Fuente:** `docs/md/Modelo-Final.md` pp. 21, 36–37


**Verificación:** Demostración: Registrar el hecho descrito y recuperarlo, comparando cada dato y asociación enumerados. No se prescribe tipo de almacenamiento, valor predeterminado ni borrado en cascada.

**Estado:** Confirmado

---

<a id="data-menu-012"></a>
### DATA-MENU-012 — Definición de variante preparada

**Requisito:**
El servicio Menu deberá conservar una definición de suministro de variante preparada mediante su referencia de variante y referencia de receta.

**Tipo:** Requisitos de datos

**Fuente:** `docs/md/Modelo-Final.md` pp. 8–9, 37


**Verificación:** Demostración: Registrar el hecho descrito y recuperarlo, comparando cada dato y asociación enumerados. No se prescribe tipo de almacenamiento, valor predeterminado ni borrado en cascada.

**Estado:** Confirmado

---

<a id="data-menu-013"></a>
### DATA-MENU-013 — Referencia de opción de combo

**Requisito:**
El servicio Menu deberá conservar identidad, slot padre, itemVariantId concreto, habilitación, quantity positiva y priceDelta de cada ComboOption.

**Tipo:** DATA

**Fuente:** [ALIGN](../../docs/reviews/ers-interfaces-alignment/decisions.md)


**Verificación:** Inspeccionar ComboOption; exigir itemVariantId, quantity positiva y priceDelta, y rechazar componentes COMBO.

**Estado:** Confirmado

---

<a id="data-menu-014"></a>
### DATA-MENU-014 — Opción de modificador

**Requisito:**
El servicio Menu deberá conservar una opción de modificador mediante su identificador, nombre, grupo propietario y configuración general defaultConfig.

**Tipo:** Requisitos de datos

**Fuente:** `docs/md/Modelo-Final.md` pp. 42–44, 50


**Verificación:** Demostración: Registrar el hecho descrito y recuperarlo, comparando cada dato y asociación enumerados. No se prescribe tipo de almacenamiento, valor predeterminado ni borrado en cascada.

**Estado:** Confirmado

---

<a id="data-menu-015"></a>
### DATA-MENU-015 — Componente de receta

**Requisito:**
El servicio Menu deberá conservar un componente de receta mediante su receta, referencia de artículo de inventario, cantidad requerida y unidad de medida.

**Tipo:** Requisitos de datos

**Fuente:** `docs/md/Modelo-Final.md` pp. 20–21, 37–38


**Verificación:** Demostración: Registrar el hecho descrito y recuperarlo, comparando cada dato y asociación enumerados. No se prescribe tipo de almacenamiento, valor predeterminado ni borrado en cascada.

**Estado:** Confirmado

---

<a id="data-menu-016"></a>
### DATA-MENU-016 — Ciclo de variante

**Requisito:**
El servicio Menu deberá conservar el estado INACTIVE, ACTIVE o ARCHIVED de cada variante.

**Tipo:** DATA

**Fuente:** [ADR-003](../../docs/md/Decisiones-cierre-invariantes.md#adr-003)


**Verificación:** Registrar y recuperar la información indicada sin cambiar la historia.

**Estado:** Confirmado

---

<a id="data-menu-017"></a>
### DATA-MENU-017 — Versión inmutable de definición

**Requisito:**
El servicio Menu deberá conservar cada revisión inmutable de `MenuItem` y receta con identidad, versión, fecha con zona y contenido de definición.

**Tipo:** DATA

**Fuente:** [ADR-006](../../docs/md/Decisiones-cierre-invariantes.md#adr-006)


**Verificación:** Registrar y recuperar la información indicada sin cambiar la historia.

**Estado:** Confirmado

---

<a id="data-menu-018"></a>
### DATA-MENU-018 — Referencia de revisión de receta

**Requisito:**
El servicio Menu deberá conservar la identidad y versión exacta de la receta referida por cada definición de variante preparada.

**Tipo:** DATA

**Fuente:** [ADR-006](../../docs/md/Decisiones-cierre-invariantes.md#adr-006)


**Verificación:** Registrar y recuperar la información indicada sin cambiar la historia.

**Estado:** Confirmado

---

<a id="data-menu-019"></a>
### DATA-MENU-019 — Proyección de disponibilidad

**Requisito:**
El servicio Menu deberá conservar la correspondencia de cada variante u opción suministrada con clave opaca, revisión de definición, lista plana de insumos, cantidades y unidades.

**Tipo:** DATA

**Fuente:** [ADR-001](../../docs/md/Decisiones-cierre-invariantes.md#adr-001)


**Verificación:** Registrar y recuperar la información indicada sin cambiar la historia.

**Estado:** Confirmado

---

<a id="data-menu-020"></a>
### DATA-MENU-020 — Evaluación de disponibilidad

**Requisito:**
El servicio Menu deberá conservar la última evaluación aceptada por clave con revisión de definición, revisión de evaluación, resultado e instante de caducidad.

**Tipo:** DATA

**Fuente:** [ADR-001](../../docs/md/Decisiones-cierre-invariantes.md#adr-001)


**Verificación:** Registrar y recuperar la información indicada sin cambiar la historia.

**Estado:** Confirmado

---

<a id="data-menu-021"></a>
### DATA-MENU-021 — Habilitación de configuración

**Requisito:**
El servicio Menu deberá conservar la habilitación de cada configuración de modificador y opción de combo.

**Tipo:** DATA

**Fuente:** [ADR-005](../../docs/md/Decisiones-cierre-invariantes.md#adr-005)


**Verificación:** Registrar y recuperar la información indicada sin cambiar la historia.

**Estado:** Confirmado

---

<a id="data-menu-022"></a>
### DATA-MENU-022 — Snapshot de suministro de orden

**Requisito:**
El servicio Orders deberá conservar por línea y revisión su lista neta de insumos, cantidades, unidades, versiones fijadas e instrucciones de preparación al solicitar confirmación.

**Tipo:** DATA

**Fuente:** [ADR-003](../../docs/md/Decisiones-cierre-invariantes.md#adr-003)


**Verificación:** Cambiar catálogo tras capturar; los datos conservados siguen idénticos.

**Estado:** Confirmado

---

<a id="data-menu-023"></a>
### DATA-MENU-023 — Identidad de movimiento

**Requisito:**
El servicio Orders deberá conservar cada movimiento con identidad única por línea, revisión y operación, contenido de insumos y referencia al movimiento original cuando sea una reversión.

**Tipo:** DATA

**Fuente:** [ADR-003](../../docs/md/Decisiones-cierre-invariantes.md#adr-003)


**Verificación:** Dos líneas de una orden tienen identidades distintas; la reversión refiere al original.

**Estado:** Confirmado

---

<a id="data-menu-024"></a>
### DATA-MENU-024 — Propiedad de identidades

**Requisito:**
El servicio Menu deberá aplicar IDs raíz generados por Menu, IDs anidados nuevos propuestos por Backoffice, IDs conservados al reemplazar e IDs nuevos al copiar.

**Tipo:** DATA

**Fuente:** [ALIGN](../../docs/reviews/ers-interfaces-alignment/decisions.md)


**Verificación:** Inspeccionar D-07 y mappings E-17; IDs anidados nuevos únicos en restaurante.

**Estado:** Confirmado

---

<a id="data-menu-025"></a>
### DATA-MENU-025 — Auditoría de revisión separada

**Requisito:**
El servicio Menu deberá conservar actor, fecha, identidades de variantes y cambios observados atendidos separados de revisiones comerciales.

**Tipo:** DATA

**Fuente:** [ALIGN](../../docs/reviews/ers-interfaces-alignment/decisions.md)


**Verificación:** Cliente no escribe state; sin M-07 al confirmar; recibo idempotente.

**Estado:** Confirmado

---

<a id="data-menu-026"></a>
### DATA-MENU-026 — Selección base administrativa

**Requisito:**
El servicio Menu deberá conservar una selección única de IDs de opciones propias habilitadas dentro de límites del slot, perteneciente a una ComboConfiguration, como base administrativa de referencia de precio.

**Tipo:** DATA

**Fuente:** [ALIGN](../../docs/reviews/ers-interfaces-alignment/decisions.md)


**Verificación:** Base incompleta INACTIVE advierte; ACTIVE exige base válida; no es selección de cliente por defecto.

**Estado:** Confirmado

---

<a id="data-menu-027"></a>
### DATA-MENU-027 — MenuItem COMBO

**Requisito:**
El servicio Menu deberá conservar un `MenuItem` COMBO con una referencia única a `ComboCategory` y una o más `ComboConfiguration`, sin usar `MenuItemVariant` como tipo de configuración del combo.

**Tipo:** Requisitos de datos

**Fuente:** `docs/md/Auditoria-4.md`, items 1, 23 y 29–37.


**Verificación:** Inspección: exigir ComboCategory y ComboConfiguration en COMBO, y rechazar ItemCategory, clasificación de hoja, variantes o ModifierGroups propios.

**Estado:** Confirmado

---

<a id="data-menu-028"></a>
### DATA-MENU-028 — Configuración de combo

**Requisito:**
El servicio Menu deberá conservar cada ComboConfiguration mediante su identificador, nombre, unitPrice absoluto y uno o más ComboSlot.

**Tipo:** Requisitos de datos

**Fuente:** `docs/md/Auditoria-4.md`, items 23–32.


**Verificación:** Inspección: exigir unitPrice y slots, y resolver el subtotal como unitPrice más priceDelta de opciones y modificadores de hojas.

**Estado:** Confirmado

---

<a id="data-menu-029"></a>
### DATA-MENU-029 — Configuración default de modificador

**Requisito:**
El servicio Menu deberá conservar en cada ModifierOption.defaultConfig el priceDelta general, maxQuantity e ingredientEffects aplicables cuando una variante no declara excepción.

**Tipo:** Requisitos de datos

**Fuente:** `docs/md/Auditoria-4.md`, items 14–18.


**Verificación:** Inspección: comprobar que cada opción tiene defaultConfig completo y que los efectos solo son ADD u OMIT.

**Estado:** Confirmado

---

<a id="data-menu-030"></a>
### DATA-MENU-030 — Modificador efectivo publicado

**Requisito:**
El servicio Menu deberá conservar en la publicación el ResolvedVariantModifier efectivo por variante hoja, opción y configuración, incluyendo habilitación, priceDelta, maxQuantity e ingredientEffects.

**Tipo:** Requisitos de datos

**Fuente:** `docs/md/Auditoria-4.md`, items 16–22.


**Verificación:** Inspección: una variante sin excepción usa defaultConfig y una variante con excepción usa sus valores efectivos.

**Estado:** Confirmado

---

<a id="data-menu-031"></a>
### DATA-MENU-031 — Referencia concreta de línea hoja

**Requisito:**
El servicio Orders deberá conservar un `variantId` no nulo en cada línea que represente un `MenuItem` PREPARED o STOCKED; una línea COMBO deberá conservar `configurationId`.

**Tipo:** Requisitos de datos

**Fuente:** `docs/md/Auditoria-4.md`, items 43–45.


**Verificación:** Inspección: rechazar una línea hoja sin variantId y una línea combo sin configurationId.

**Estado:** Confirmado

---

<a id="data-menu-032"></a>
### DATA-MENU-032 — Líneas separadas por personalización

**Requisito:**
El servicio Orders deberá conservar líneas distintas cuando existan personalizaciones diferentes del mismo MenuItem y MenuItemVariant.

**Tipo:** Requisitos de datos

**Fuente:** `docs/md/Auditoria-4.md`, items 44–46.


**Verificación:** Inspección: persistir dos personalizaciones distintas y comprobar que no se fusionan en una sola línea.

**Estado:** Confirmado

---

## Requisitos confirmados de datos de las UI consumidoras

Estos requisitos de datos formalizan la información que deben representar las superficies confirmadas de mesero y administrador. La propiedad de los campos externos permanece en sus respectivos servicios.

<a id="data-ui-001"></a>
### DATA-UI-001 — Contexto de mesa asignada

**Requisito:**
La UI de orden deberá representar un contexto de mesa asignada con identificador de mesa, etiqueta visible, alcance de asignación al mesero, estado de presencia de orden y referencia de la orden activa cuando exista una orden.

**Tipo:** Datos — UI consumidora

**Fuente:** Decisión explícita de UI en la solicitud del 2026-09-13; consolidada en `output/ui-spec/ui-data-spec.md`, V-MES-01 y V-MES-02.


**Verificación:** Inspección: comparar el contexto de mesa renderizado con la proyección suministrada de mesas asignadas y orden activa.

**Estado:** Confirmado

---

<a id="data-ui-002"></a>
### DATA-UI-002 — Distinción entre orden existente y borrador local

**Requisito:**
La UI de orden deberá representar las líneas confirmadas de la orden separadas de las líneas del borrador local, incluyendo sus identidades distintas, cantidades, configuración seleccionada y costo de línea.

**Tipo:** Datos — UI consumidora

**Fuente:** Decisión explícita de UI en la solicitud del 2026-09-13; consolidada en `output/ui-spec/ui-data-spec.md`, V-MES-02 y V-MES-03.


**Verificación:** Demostración: mostrar una orden existente con un borrador local y comprobar que sus identidades y valores confirmados y de borrador permanecen distinguibles.

**Estado:** Confirmado

---

<a id="data-ui-003"></a>
### DATA-UI-003 — Vocabulario de clasificación visual comercial

**Requisito:**
Las UI de orden y administrativa deberán representar los valores de clasificación comercial de items hoja DISH, BEVERAGE, DESSERT y COMPLEMENT con las etiquetas Platillo, Bebida, Postre y Complemento, respectivamente, y deberán representar COMBO como tipo de `MenuItem`.

**Tipo:** Datos — UI consumidora

**Fuente:** Aclaración explícita de UI en la solicitud del 2026-09-13; consolidada en `output/ui-spec/ui-data-spec.md`, sección 3.6.


**Verificación:** Inspección: verificar los cinco valores estables y sus etiquetas en filtros, badges y editor de creación del catálogo.

**Estado:** Confirmado

---

<a id="data-ui-004"></a>
### DATA-UI-004 — Proyección del ciclo de vida administrativo

**Requisito:**
La UI administrativa deberá representar cada `MenuItem` del catálogo con su identidad, nombre, `ItemCategory` o `ComboCategory` según corresponda, clasificación comercial de hoja cuando aplique, tipo de `MenuItem`, estado administrativo, estado de revisión cuando aplique, referencias de variantes o configuraciones afectadas cuando esté pendiente y estado local de selección.

**Tipo:** Datos — UI consumidora

**Fuente:** Decisión explícita de UI en la solicitud del 2026-09-13; consolidada en `output/ui-spec/ui-data-spec.md`, V-ADM-01.


**Verificación:** Demostración: representar items en cada apartado administrativo y comprobar que los campos de tarjeta y selección soportan las acciones indicadas.

**Estado:** Confirmado

---

<a id="data-ui-005"></a>
### DATA-UI-005 — Elemento de trabajo de revisión pendiente

**Requisito:**
La UI administrativa deberá representar la revisión pendiente de un combo con la identidad del combo, identidad de ComboConfiguration afectada, token y caducidad de revisión, identidad del cambio, ubicación de slot y opción, referencia itemVariantId del componente, versión observada, motivos y estado local de verificación.

**Tipo:** Datos — UI consumidora

**Fuente:** Decisión explícita de UI en la solicitud del 2026-09-13 y E-19/E-20/E-21; consolidada en `output/ui-spec/ui-data-spec.md`, V-ADM-03.


**Verificación:** Demostración: cargar una revisión pendiente y verificar cada identidad, motivo y estado local sin enviar el estado local de verificación como campo de Menu.

**Estado:** Confirmado

---

<a id="data-ui-006"></a>
### DATA-UI-006 — Representación monetaria de la preorden

**Requisito:**
La UI de orden deberá representar por separado el subtotal unitario resuelto, cantidad de línea, costo de línea, costo acumulado de preorden y moneda respecto del total de la orden existente y de los ajustes posteriores de Billing.

**Tipo:** Datos — UI consumidora

**Fuente:** Aclaración explícita de precio en la solicitud del 2026-09-13 y E-16; consolidada en `output/ui-spec/ui-data-spec.md`, sección 6.3.


**Verificación:** Demostración: cambiar cantidad y configuración y verificar costo de línea y acumulado mostrados; verificar que un ajuste posterior de Billing no se represente como parte del acumulado de preorden.

**Estado:** Confirmado
