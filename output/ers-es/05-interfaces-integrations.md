[← Índice](./index.md)

# Obligaciones de integración

Cada bloque establece una obligación primaria. Los atributos enumerados describen un mismo dato u operación; no son pasos independientes. Las verificaciones son criterios propuestos, no pruebas de software ejecutadas. Los términos del modelo identifican conceptos del dominio, no tecnologías exigidas.

---

Las obligaciones de Orders/comandas se identifican como responsabilidades externas a Menu.
---

<a id="int-menu-001"></a>
### INT-MENU-001 — Contratos de catálogo

**Requisito:**
El servicio Menu deberá exponer lecturas de catálogo mediante E-01–E-03 e invalidaciones mediante M-07/M-08.

**Tipo:** INT

**Fuente:** [ALIGN](../../docs/reviews/ers-interfaces-alignment/decisions.md)

**Justificación:** Decisión explícita del usuario en ALIGN; sustituye formulaciones incompatibles anteriores.

**Verificación:** Inspeccionar contratos completos y autorización.

**Estado:** Confirmado

---

<a id="int-menu-002"></a>
### INT-MENU-002 — Orquestación de preparación

**Requisito:**
El servicio Orders deberá entregar a Cocina la información de preparación resuelta por Menu como orquestador de la orden.

**Tipo:** INT

**Fuente:** [ALIGN](../../docs/reviews/ers-interfaces-alignment/decisions.md)

**Justificación:** Decisión explícita del usuario en ALIGN; sustituye formulaciones incompatibles anteriores.

**Verificación:** Inspeccionar E-16 como frontera Menu; sin contrato directo Menu–Cocina.

**Estado:** Confirmado

---

<a id="int-menu-003"></a>
### INT-MENU-003 — Referencias lógicas de inventario

**Requisito:**
El servicio Menu deberá identificar los artículos de inventario de propiedad externa mediante referencias lógicas de inventario en el suministro almacenado, componentes de recetas y efectos sobre ingredientes.

**Tipo:** Obligaciones de integración

**Fuente:** `docs/md/Modelo-Final.md` pp. 19–21, 37–38

**Justificación:** Conserva el hecho o comportamiento de la fuente citada dentro de su alcance, sin imponer un mecanismo adicional.

**Verificación:** Inspección: Verificar que los tres tipos de referencia identifiquen artículos de Inventory sin incorporar su modelo interno de entidades.

**Estado:** Confirmado

---

<a id="int-menu-004"></a>
### INT-MENU-004 — Resumen monetario unitario inmutable

**Requisito:**
El servicio Orders deberá conservar precio base, extras agregados, subtotal unitario y moneda resueltos para la variante vendible seleccionada al crear su línea.

**Tipo:** INT

**Fuente:** [ALIGN](../../docs/reviews/ers-interfaces-alignment/decisions.md)

**Justificación:** Decisión explícita del usuario en ALIGN; sustituye formulaciones incompatibles anteriores.

**Verificación:** Cambiar precios del catálogo y verificar resumen conservado; no se exigen precios individuales de modificadores.

**Estado:** Confirmado

---

<a id="int-menu-005"></a>
### INT-MENU-005 — Contrato administrativo de copia

**Requisito:**
El servicio Menu deberá exponer por E-17 copias y asignaciones atómicas del mismo MenuItem con correspondencia por IDs, FAIL/REPLACE, simulación y validación concurrente.

**Tipo:** INT

**Fuente:** [ALIGN](../../docs/reviews/ers-interfaces-alignment/decisions.md)

**Justificación:** Decisión explícita del usuario en ALIGN; sustituye formulaciones incompatibles anteriores.

**Verificación:** Inspeccionar configuraciones.md; probar destinos en conflicto y ausencia de escrituras parciales.

**Estado:** Confirmado

---

<a id="int-menu-006"></a>
### INT-MENU-006 — Referencias de auditoría de selección

**Requisito:**
El servicio Orders deberá conservar referencias versionadas de selección junto con su resumen monetario unitario resuelto.

**Tipo:** INT

**Fuente:** [ALIGN](../../docs/reviews/ers-interfaces-alignment/decisions.md)

**Justificación:** Decisión explícita del usuario en ALIGN; sustituye formulaciones incompatibles anteriores.

**Verificación:** Verificar que no se reconstruyan importes cobrados desde el catálogo actual.

**Estado:** Confirmado

---

<a id="int-menu-007"></a>
### INT-MENU-007 — Instrucciones libres en comanda

**Requisito:**
El servicio Orders deberá conservar las instrucciones de preparación no preconfiguradas del cliente como texto libre en el artículo correspondiente de la comanda.

**Tipo:** Obligaciones de integración

**Fuente:** `docs/md/Problema-Inicial.md` pp. 109–111

**Justificación:** Conserva el hecho o comportamiento de la fuente citada dentro de su alcance, sin imponer un mecanismo adicional.

**Verificación:** Demostración: Registrar una instrucción libre en un artículo de comanda y verificar su asociación con ese artículo.

**Estado:** Confirmado

---

<a id="int-menu-008"></a>
### INT-MENU-008 — Publicar necesidades

**Requisito:**
El servicio Menu deberá publicar cambios y retiradas de necesidades planas de inventario con clave opaca y revisión de definición.

**Tipo:** INT

**Fuente:** [ADR-001](../../docs/md/Decisiones-cierre-invariantes.md#adr-001)

**Justificación:** Decisión de cierre adoptada por delegación del usuario; véanse fundamento, límites y alternativas en la decisión citada.

**Verificación:** Editar referencia de receta o cantidad almacenada; verificar necesidades cambiadas, no eco de disponibilidad.

**Estado:** Confirmado

---

<a id="int-menu-009"></a>
### INT-MENU-009 — Evaluación de inventario

**Requisito:**
El servicio Inventory deberá emitir disponibilidad de las necesidades recibidas con su clave, revisión de definición, revisión creciente de evaluación y caducidad explícita.

**Tipo:** INT

**Fuente:** [ADR-001](../../docs/md/Decisiones-cierre-invariantes.md#adr-001)

**Justificación:** Decisión de cierre adoptada por delegación del usuario; véanse fundamento, límites y alternativas en la decisión citada.

**Verificación:** Verificar correlación y campos de vigencia.

**Estado:** Confirmado

---

<a id="int-menu-010"></a>
### INT-MENU-010 — Aceptar evaluación actual

**Requisito:**
El servicio Menu deberá ignorar evaluaciones de disponibilidad de otra revisión de definición o anteriores a la última evaluación aceptada.

**Tipo:** INT

**Fuente:** [ADR-001](../../docs/md/Decisiones-cierre-invariantes.md#adr-001)

**Justificación:** Decisión de cierre adoptada por delegación del usuario; véanse fundamento, límites y alternativas en la decisión citada.

**Verificación:** Entregar evaluación nueva, luego antigua y de definición distinta; ninguna obsoleta sustituye el estado.

**Estado:** Confirmado

---

<a id="int-menu-011"></a>
### INT-MENU-011 — Disponibilidad ante fallo

**Requisito:**
El servicio Menu deberá presentar como no disponible una variante sin evaluación positiva vigente o cuando detecte pérdida de disponibilidad del servicio Inventory.

**Tipo:** INT

**Fuente:** [ADR-001](../../docs/md/Decisiones-cierre-invariantes.md#adr-001)

**Justificación:** Decisión de cierre adoptada por delegación del usuario; véanse fundamento, límites y alternativas en la decisión citada.

**Verificación:** Probar ausencia, vencimiento, negativo y caída detectada; recuperación exige evaluación positiva vigente.

**Estado:** Confirmado

---

<a id="int-menu-012"></a>
### INT-MENU-012 — Movimiento desde snapshot

**Requisito:**
El servicio Orders deberá enviar a Inventory el contenido del movimiento persistido de la línea sin reconstruirlo desde la proyección actual de disponibilidad.

**Tipo:** INT

**Fuente:** [ADR-003](../../docs/md/Decisiones-cierre-invariantes.md#adr-003)

**Justificación:** Decisión de cierre adoptada por delegación del usuario; véanse fundamento, límites y alternativas en la decisión citada.

**Verificación:** Cambiar proyección antes de entregar; cantidades enviadas coinciden con movimiento persistido.

**Estado:** Confirmado

---

<a id="int-menu-013"></a>
### INT-MENU-013 — Movimiento idempotente

**Requisito:**
El servicio Inventory deberá aplicar como máximo una vez cada identidad de movimiento.

**Tipo:** INT

**Fuente:** [ADR-003](../../docs/md/Decisiones-cierre-invariantes.md#adr-003)

**Justificación:** Decisión de cierre adoptada por delegación del usuario; véanse fundamento, límites y alternativas en la decisión citada.

**Verificación:** Entregar dos veces el movimiento idéntico y verificar un solo efecto.

**Estado:** Confirmado

---

<a id="int-menu-014"></a>
### INT-MENU-014 — Conflicto de contenido por identidad

**Requisito:**
El servicio Inventory deberá rechazar reutilizar una identidad de movimiento con contenido diferente.

**Tipo:** INT

**Fuente:** [ADR-003](../../docs/md/Decisiones-cierre-invariantes.md#adr-003)

**Justificación:** Decisión de cierre adoptada por delegación del usuario; véanse fundamento, límites y alternativas en la decisión citada.

**Verificación:** Reintentar identidad con otra cantidad; verificar rechazo e inventario sin cambio.

**Estado:** Confirmado

---

<a id="int-menu-015"></a>
### INT-MENU-015 — Reversión exacta

**Requisito:**
El servicio Inventory deberá limitar una reversión autorizada a los insumos y cantidades aún no revertidos del movimiento aplicado original.

**Tipo:** INT

**Fuente:** [ADR-003](../../docs/md/Decisiones-cierre-invariantes.md#adr-003)

**Justificación:** Decisión de cierre adoptada por delegación del usuario; véanse fundamento, límites y alternativas en la decisión citada.

**Verificación:** Rechazar reversión anterior a aplicación y exceso; una válida usa cantidades originales.

**Estado:** Confirmado

---

<a id="int-menu-016"></a>
### INT-MENU-016 — Versión fijada en orden

**Requisito:**
El servicio Orders deberá conservar la versión de producto seleccionada al crear una línea existente hasta una modificación explícita de esa línea.

**Tipo:** INT

**Fuente:** [ADR-006](../../docs/md/Decisiones-cierre-invariantes.md#adr-006)

**Justificación:** Decisión de cierre adoptada por delegación del usuario; véanse fundamento, límites y alternativas en la decisión citada.

**Verificación:** Crear línea en v1, publicar v2 y verificar línea existente sin cambio.

**Estado:** Confirmado

---

<a id="int-menu-017"></a>
### INT-MENU-017 — Aceptación atómica de stock

**Requisito:**
El servicio Inventory deberá aceptar un descuento solo si puede aplicar íntegramente la lista neta solicitada contra las existencias actuales.

**Tipo:** INT

**Fuente:** [ADR-001](../../docs/md/Decisiones-cierre-invariantes.md#adr-001)

**Justificación:** Decisión de cierre adoptada por delegación del usuario; véanse fundamento, límites y alternativas en la decisión citada.

**Verificación:** Dos solicitudes compiten por último stock; sin descuento parcial ni sobreventa por la proyección.

**Estado:** Confirmado

---

<a id="int-menu-018"></a>
### INT-MENU-018 — Resultado de confirmación

**Requisito:**
El servicio Orders deberá confirmar la solicitud de línea solo después de recibir la aceptación de su descuento por Inventory.

**Tipo:** INT

**Fuente:** [ADR-003](../../docs/md/Decisiones-cierre-invariantes.md#adr-003)

**Justificación:** Decisión de cierre adoptada por delegación del usuario; véanse fundamento, límites y alternativas en la decisión citada.

**Verificación:** Demorar respuesta mantiene pendiente; rechazo impide confirmar; aceptación repetida no duplica confirmación.

**Estado:** Confirmado

---

<a id="int-menu-019"></a>
### INT-MENU-019 — Disponibilidad de combo

**Requisito:**
El servicio Menu deberá considerar disponible un combo solo si cada espacio puede satisfacer su mínimo con opciones elegibles para su cantidad suministrada.

**Tipo:** INT

**Fuente:** [ADR-001](../../docs/md/Decisiones-cierre-invariantes.md#adr-001)

**Justificación:** Decisión de cierre adoptada por delegación del usuario; véanse fundamento, límites y alternativas en la decisión citada.

**Verificación:** Espacio obligatorio vacío bloquea; opcional vacío no; stock conjunto se revalida al confirmar.

**Estado:** Confirmado

---

<a id="int-menu-020"></a>
### INT-MENU-020 — Respuesta monetaria unitaria mínima

**Requisito:**
El servicio Menu deberá devolver únicamente basePrice, extrasTotal, unitSubtotal y currency en la sección pricing de E-16 para la unidad de variante vendible solicitada.

**Tipo:** INT

**Fuente:** [ALIGN](../../docs/reviews/ers-interfaces-alignment/decisions.md)

**Justificación:** Decisión explícita del usuario en ALIGN; sustituye formulaciones incompatibles anteriores.

**Verificación:** Schema cerrado PriceSummary rechaza términos monetarios de componentes/slots/modificadores; preparación separada.

**Estado:** Confirmado

---

<a id="int-menu-021"></a>
### INT-MENU-021 — Tombstones de retirada

**Requisito:**
El servicio Menu deberá conservar revisiones de retirada para impedir que evaluaciones tardías resuciten definiciones retiradas.

**Tipo:** INT

**Fuente:** [ALIGN](../../docs/reviews/ers-interfaces-alignment/decisions.md)

**Justificación:** Decisión explícita del usuario en ALIGN; sustituye formulaciones incompatibles anteriores.

**Verificación:** Inspeccionar M-02/M-03 y entregar positivo tardío tras retirada.

**Estado:** Confirmado

---

<a id="int-menu-022"></a>
### INT-MENU-022 — Conflictos de evaluación

**Requisito:**
El servicio Menu deberá tratar revisiones de evaluación iguales con contenido distinto como conflictos sin sustituir disponibilidad aceptada.

**Tipo:** INT

**Fuente:** [ALIGN](../../docs/reviews/ers-interfaces-alignment/decisions.md)

**Justificación:** Decisión explícita del usuario en ALIGN; sustituye formulaciones incompatibles anteriores.

**Verificación:** M-03 duplicado idéntico ignorado; duplicado distinto rechazado/en cuarentena.

**Estado:** Confirmado

---

<a id="int-menu-023"></a>
### INT-MENU-023 — Identidad de recuperación

**Requisito:**
El servicio Menu deberá exigir una evaluación válida nueva con reevaluationRequestId pendiente antes de completar la recuperación solicitada.

**Tipo:** INT

**Fuente:** [ALIGN](../../docs/reviews/ers-interfaces-alignment/decisions.md)

**Justificación:** Decisión explícita del usuario en ALIGN; sustituye formulaciones incompatibles anteriores.

**Verificación:** Respuesta antigua y positivo vencido no desbloquean recuperación; inspeccionar M-04/M-03/E-18.

**Estado:** Confirmado

---

<a id="int-menu-024"></a>
### INT-MENU-024 — Catálogo de ingredientes de Inventory

**Requisito:**
El servicio Inventory deberá proporcionar un catálogo de artículos utilizables como ingredientes o referencias STOCKED con al menos identificador, nombre y unidad de medida.

**Tipo:** INT — Dependencia externa

**Fuente:** [Aclaración de Inventory](../../docs/reviews/ers-interfaces-alignment/decisions.md)

**Justificación:** Inventory posee las referencias seleccionables y sus unidades; Menu no prescribe un catálogo independiente de unidades.

**Verificación:** Inspeccionar el contrato de Inventory cuando exista; cada artículo seleccionable incluye los tres datos requeridos. Límites de cantidades y conversiones permanecen en OPEN-010.

**Estado:** Confirmado

---

<a id="int-menu-025"></a>
### INT-MENU-025 — Búsqueda del catálogo de Inventory

**Requisito:**
El servicio Inventory deberá proporcionar búsqueda sobre el catálogo utilizado para seleccionar ingredientes y referencias STOCKED durante la administración.

**Tipo:** INT — Dependencia externa

**Fuente:** [Aclaración de Inventory](../../docs/reviews/ers-interfaces-alignment/decisions.md)

**Justificación:** El administrador necesita encontrar artículos sin recorrer todo el catálogo de inventario.

**Verificación:** Demostrar búsqueda en el catálogo suministrado y selección por identificador y unidad. Coincidencias, ruta y paginación esperan el contrato de Inventory.

**Estado:** Confirmado
