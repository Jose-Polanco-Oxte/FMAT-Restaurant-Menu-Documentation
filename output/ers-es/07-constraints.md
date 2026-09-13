[← Índice](./index.md)

# Restricciones de arquitectura y diseño

Cada bloque establece una obligación primaria. Los atributos enumerados describen un mismo dato u operación; no son pasos independientes. Las verificaciones son criterios propuestos, no pruebas de software ejecutadas. Los términos del modelo identifican conceptos del dominio, no tecnologías exigidas.

---

Estas decisiones de arquitectura provienen de las fuentes; no se presentan como restricciones inevitables del dominio restaurantero.
---

<a id="con-menu-001"></a>
### CON-MENU-001 — Límite de base de datos de inventario

**Requisito:**
El servicio Menu deberá mantener sus datos sin relaciones de clave foránea hacia datos propiedad de Inventory.

**Tipo:** Restricciones de arquitectura y diseño

**Fuente:** `docs/md/Modelo-Final.md` pp. 19

**Justificación:** Conserva el hecho o comportamiento de la fuente citada dentro de su alcance, sin imponer un mecanismo adicional.

**Verificación:** Inspección: Comparar el modelo de dominio y los contratos pertinentes con el límite o representación indicados.

**Estado:** Confirmado

---

<a id="con-menu-002"></a>
### CON-MENU-002 — Límites de agregados

**Requisito:**
El modelo de dominio de Menu deberá separar Menu, MenuItem y Recipe en raíces de agregado independientes.

**Tipo:** Restricciones de arquitectura y diseño

**Fuente:** `docs/md/Modelo-Final.md` pp. 21–23

**Justificación:** Conserva el hecho o comportamiento de la fuente citada dentro de su alcance, sin imponer un mecanismo adicional.

**Verificación:** Inspección: Comparar el modelo de dominio y los contratos pertinentes con el límite o representación indicados.

**Estado:** Confirmado

---

<a id="con-menu-003"></a>
### CON-MENU-003 — Configuración explícita de modificadores

**Requisito:**
El modelo de dominio de Menu deberá situar los parámetros de ejecución de modificadores específicos de variante en VariantModifierConfig en lugar de una sobrescritura opcional de valores predeterminados de ModifierOption.

**Tipo:** Restricciones de arquitectura y diseño

**Fuente:** `docs/md/Modelo-Final.md` pp. 41–44, 51–52

**Justificación:** Conserva el hecho o comportamiento de la fuente citada dentro de su alcance, sin imponer un mecanismo adicional.

**Verificación:** Inspección: Comparar el modelo de dominio y los contratos pertinentes con el límite o representación indicados.

**Estado:** Confirmado

---

<a id="con-menu-004"></a>
### CON-MENU-004 — Precio autoritativo por variante

**Requisito:**
El modelo de dominio de Menu deberá utilizar MenuItemVariant.unitPrice como único precio base autoritativo del producto.

**Tipo:** Restricciones de arquitectura y diseño

**Fuente:** `docs/md/Modelo-Final.md` pp. 26–28

**Justificación:** Conserva el hecho o comportamiento de la fuente citada dentro de su alcance, sin imponer un mecanismo adicional.

**Verificación:** Inspección: Comparar el modelo de dominio y los contratos pertinentes con el límite o representación indicados.

**Estado:** Confirmado

---

<a id="con-menu-005"></a>
### CON-MENU-005 — Referencia vendible universal

**Requisito:**
El contrato de comandas deberá identificar la MenuItemVariant concreta de cada producto pedido, incluidos los productos sin dimensiones seleccionables.

**Tipo:** Restricciones de arquitectura y diseño

**Fuente:** `docs/md/Modelo-Final.md` pp. 7–8

**Justificación:** Conserva el hecho o comportamiento de la fuente citada dentro de su alcance, sin imponer un mecanismo adicional.

**Verificación:** Inspección: Comparar el modelo de dominio y los contratos pertinentes con el límite o representación indicados.

**Estado:** Confirmado

---

<a id="con-menu-006"></a>
### CON-MENU-006 — Propiedad de entidades de inventario

**Requisito:**
El modelo de dominio de Menu deberá excluir entidades de Inventory y relaciones de objetos entre servicios de su modelo interno.

**Tipo:** Restricciones de arquitectura y diseño

**Fuente:** `docs/md/Modelo-Final.md` pp. 19–21

**Justificación:** Conserva el hecho o comportamiento de la fuente citada dentro de su alcance, sin imponer un mecanismo adicional.

**Verificación:** Inspección: Comparar el modelo de dominio y los contratos pertinentes con el límite o representación indicados.

**Estado:** Confirmado

---

<a id="con-menu-007"></a>
### CON-MENU-007 — Propiedad de recetas

**Requisito:**
El servicio Menu deberá ser propietario de las definiciones de recetas culinarias.

**Tipo:** Restricciones de arquitectura y diseño

**Fuente:** `docs/md/Modelo-Final.md` pp. 20–23

**Justificación:** Conserva el hecho o comportamiento de la fuente citada dentro de su alcance, sin imponer un mecanismo adicional.

**Verificación:** Inspección: Comparar el modelo de dominio y los contratos pertinentes con el límite o representación indicados.

**Estado:** Confirmado

---

<a id="con-menu-008"></a>
### CON-MENU-008 — Retención histórica

**Requisito:**
El servicio Menu deberá conservar sin depuración física las revisiones históricas de productos, variantes, recetas y configuraciones en el alcance de esta versión.

**Tipo:** CON

**Fuente:** [ADR-003](../../docs/md/Decisiones-cierre-invariantes.md#adr-003)

**Justificación:** Decisión de cierre adoptada por delegación del usuario; véanse fundamento, límites y alternativas en la decisión citada.

**Verificación:** Intentar borrado físico y verificar rechazo; los datos archivados siguen consultables.

**Estado:** Confirmado

---

---

<a id="con-menu-009"></a>
### CON-MENU-009 — Lenguaje de inventario

**Requisito:**
El servicio Inventory deberá interpretar las necesidades recibidas únicamente como insumos, cantidades y unidades, usando claves opacas sin semántica de producto o variante.

**Tipo:** CON

**Fuente:** [ADR-001](../../docs/md/Decisiones-cierre-invariantes.md#adr-001)

**Justificación:** Decisión de cierre adoptada por delegación del usuario; véanse fundamento, límites y alternativas en la decisión citada.

**Verificación:** Inspeccionar que Inventory no reciba reglas de resolución de recetas, modificadores o combos.

**Estado:** Confirmado

---

<a id="con-menu-010"></a>
### CON-MENU-010 — Suscripción de disponibilidad

**Requisito:**
La integración Menu-Inventory deberá intercambiar cambios de necesidades y evaluaciones de disponibilidad mediante publicación y suscripción.

**Tipo:** CON

**Fuente:** [ADR-001](../../docs/md/Decisiones-cierre-invariantes.md#adr-001)

**Justificación:** Decisión de cierre adoptada por delegación del usuario; véanse fundamento, límites y alternativas en la decisión citada.

**Verificación:** Inspeccionar ambos sentidos; ningún bucle republica disponibilidad como necesidades.

**Estado:** Confirmado

---

<a id="con-menu-011"></a>
### CON-MENU-011 — Outbox atómico

**Requisito:**
El servicio Orders deberá persistir el snapshot de la solicitud de confirmación y su trabajo de entrega de movimiento en una misma transacción local mediante outbox.

**Tipo:** CON

**Fuente:** [ADR-003](../../docs/md/Decisiones-cierre-invariantes.md#adr-003)

**Justificación:** Decisión de cierre adoptada por delegación del usuario; véanse fundamento, límites y alternativas en la decisión citada.

**Verificación:** Fallar antes y después del commit; no hay entrega sin snapshot y el trabajo confirmado puede reintentarse.

**Estado:** Confirmado

---

<a id="con-menu-012"></a>
### CON-MENU-012 — Convenciones de interfaz aprobadas

**Requisito:**
El servicio Menu deberá aplicar las convenciones aprobadas de autorización, ámbito de identidad, concurrencia e idempotencia del paquete de interfaces, incluida la retención de resultados completos por siete días y registros compactos durables que impidan reejecución silenciosa tras su vencimiento.

**Tipo:** CON

**Fuente:** [ALIGN](../../docs/reviews/ers-interfaces-alignment/decisions.md)

**Justificación:** Decisión explícita del usuario en ALIGN; sustituye formulaciones incompatibles anteriores.

**Verificación:** Inspeccionar D-01–D-09, permisos HTTP, ETags y canales lógicos; verificar vencimiento a siete días, conservación de auditoría y cambios pendientes, y rechazo de resultados vencidos según OPEN-010 aprobado. Sin imponer broker/almacenamiento.

**Estado:** Confirmado

---

<a id="con-menu-013"></a>
### CON-MENU-013 — Publicación durable de Menu

**Requisito:**
El servicio Menu deberá persistir atómicamente sus cambios efectivos y trabajo de publicación pendiente mediante su propio outbox.

**Tipo:** CON

**Fuente:** [ALIGN](../../docs/reviews/ers-interfaces-alignment/decisions.md)

**Justificación:** Decisión explícita del usuario en ALIGN; sustituye formulaciones incompatibles anteriores.

**Verificación:** Inspeccionar M-01 y convenciones; distinguir outbox Orders CON-MENU-011.

**Estado:** Confirmado
