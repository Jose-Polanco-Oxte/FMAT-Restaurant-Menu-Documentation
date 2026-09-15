[← Índice](./index.md)

# Requisitos de calidad

Cada bloque establece una obligación primaria. Los atributos enumerados describen un mismo dato u operación; no son pasos independientes. Las verificaciones son criterios propuestos, no pruebas de software ejecutadas. Los términos del modelo identifican conceptos del dominio, no tecnologías exigidas.

---

<a id="qa-menu-001"></a>
### QA-MENU-001 — Resolución determinista de selecciones

**Requisito:**
El sistema deberá resolver las selecciones de combo permitidas y el comportamiento de modificadores por variante a partir de ComboConfiguration, ComboOption y la proyección publicada de modificadores efectivos, sin inferir correspondencias de tamaños ni resolver defaults durante la toma de órdenes.

**Tipo:** Requisitos de calidad

**Fuente:** `docs/md/Auditoria-4.md`, items 14–22 y 23–32.


**Verificación:** Análisis: Rastrear una selección hasta la configuración explícita que la determina. Este requisito no prescribe O(1) ni plan de índices; los criterios de aceptación de latencia están en QA-MENU-004 a QA-MENU-017.

**Estado:** Confirmado

---

<a id="qa-menu-002"></a>
### QA-MENU-002 — Continuidad histórica del suministro

**Requisito:**
El servicio Orders deberá completar el procesamiento de una línea confirmada utilizando su snapshot persistido aunque las variantes, recetas o configuraciones originales se archiven o cambien.

**Tipo:** QA

**Fuente:** [ADR-003](../../docs/md/Decisiones-cierre-invariantes.md#adr-003)


**Verificación:** Confirmar una línea, archivar su variante y cambiar su receta; procesar y revertir un movimiento autorizado usando cantidades originales.

**Estado:** Confirmado

---

---

<a id="qa-menu-003"></a>
### QA-MENU-003 — Consistencia del catálogo

**Requisito:**
El servicio Menu deberá impedir aceptar configuraciones de variantes que infrinjan BR-MENU-002, BR-MENU-003 o BR-MENU-004.

**Tipo:** Requisitos de calidad

**Fuente:** `docs/md/Modelo-Final.md` pp. 21


**Verificación:** Prueba: Intentar cada configuración prohibida mediante operaciones de catálogo y verificar su rechazo sin aceptar el estado inválido. Es una propiedad de consistencia de las reglas referidas, no una regla adicional ni mandato de base de datos.

**Estado:** Confirmado

---

<a id="qa-menu-004"></a>
### QA-MENU-004 — Consulta de menú p95

**Requisito:**
El sistema deberá cumplir p95 <= 200 ms para búsqueda y cambio de categoría bajo el perfil nominal de ADR-004.

**Tipo:** QA

**Fuente:** [ADR-004](../../docs/md/Decisiones-cierre-invariantes.md#adr-004)


**Verificación:** Medir la clase de extremo a extremo con 40 clientes, 30 solicitudes/s durante 30 min y la mezcla ADR-004.

**Estado:** Confirmado

---

<a id="qa-menu-005"></a>
### QA-MENU-005 — Disponibilidad p95

**Requisito:**
El sistema deberá cumplir p95 <= 300 ms para consulta de disponibilidad proyectada bajo el perfil nominal de ADR-004.

**Tipo:** QA

**Fuente:** [ADR-004](../../docs/md/Decisiones-cierre-invariantes.md#adr-004)


**Verificación:** Medir la clase de extremo a extremo con 40 clientes, 30 solicitudes/s durante 30 min y la mezcla ADR-004.

**Estado:** Confirmado

---

<a id="qa-menu-006"></a>
### QA-MENU-006 — Configuración p95

**Requisito:**
El sistema deberá cumplir p95 <= 300 ms para validación y recálculo de precio bajo el perfil nominal de ADR-004.

**Tipo:** QA

**Fuente:** [ADR-004](../../docs/md/Decisiones-cierre-invariantes.md#adr-004)


**Verificación:** Medir la clase de extremo a extremo con 40 clientes, 30 solicitudes/s durante 30 min y la mezcla ADR-004.

**Estado:** Confirmado

---

<a id="qa-menu-007"></a>
### QA-MENU-007 — Línea de orden p95

**Requisito:**
El sistema deberá cumplir p95 <= 300 ms para edición de línea de comanda bajo el perfil nominal de ADR-004.

**Tipo:** QA

**Fuente:** [ADR-004](../../docs/md/Decisiones-cierre-invariantes.md#adr-004)


**Verificación:** Medir la clase de extremo a extremo con 40 clientes, 30 solicitudes/s durante 30 min y la mezcla ADR-004.

**Estado:** Confirmado

---

<a id="qa-menu-008"></a>
### QA-MENU-008 — Interacción p99

**Requisito:**
El sistema deberá cumplir p99 <= 1 s para cada clase de operación de QA-MENU-004 a QA-MENU-007 bajo el perfil nominal de ADR-004.

**Tipo:** QA

**Fuente:** [ADR-004](../../docs/md/Decisiones-cierre-invariantes.md#adr-004)


**Verificación:** Medir la clase de extremo a extremo con 40 clientes, 30 solicitudes/s durante 30 min y la mezcla ADR-004.

**Estado:** Confirmado

---

<a id="qa-menu-009"></a>
### QA-MENU-009 — Acuse Orders p95

**Requisito:**
El sistema deberá cumplir p95 <= 500 ms para envío a cocina hasta acuse de Orders bajo el perfil nominal de ADR-004.

**Tipo:** QA

**Fuente:** [ADR-004](../../docs/md/Decisiones-cierre-invariantes.md#adr-004)


**Verificación:** Medir la clase de extremo a extremo con 40 clientes, 30 solicitudes/s durante 30 min y la mezcla ADR-004.

**Estado:** Confirmado

---

<a id="qa-menu-010"></a>
### QA-MENU-010 — Acuse Orders p99

**Requisito:**
El sistema deberá cumplir p99 <= 1 s para envío a cocina hasta acuse de Orders bajo el perfil nominal de ADR-004.

**Tipo:** QA

**Fuente:** [ADR-004](../../docs/md/Decisiones-cierre-invariantes.md#adr-004)


**Verificación:** Medir la clase de extremo a extremo con 40 clientes, 30 solicitudes/s durante 30 min y la mezcla ADR-004.

**Estado:** Confirmado

---

<a id="qa-menu-011"></a>
### QA-MENU-011 — Visibilidad cocina p95

**Requisito:**
El sistema deberá cumplir p95 <= 1 s para envío desde POS hasta visibilidad en KDS bajo el perfil nominal de ADR-004.

**Tipo:** QA

**Fuente:** [ADR-004](../../docs/md/Decisiones-cierre-invariantes.md#adr-004)


**Verificación:** Medir la clase de extremo a extremo con 40 clientes, 30 solicitudes/s durante 30 min y la mezcla ADR-004.

**Estado:** Confirmado

---

<a id="qa-menu-012"></a>
### QA-MENU-012 — Visibilidad cocina p99

**Requisito:**
El sistema deberá cumplir p99 <= 2 s para envío desde POS hasta visibilidad en KDS bajo el perfil nominal de ADR-004.

**Tipo:** QA

**Fuente:** [ADR-004](../../docs/md/Decisiones-cierre-invariantes.md#adr-004)


**Verificación:** Medir la clase de extremo a extremo con 40 clientes, 30 solicitudes/s durante 30 min y la mezcla ADR-004.

**Estado:** Confirmado

---

<a id="qa-menu-013"></a>
### QA-MENU-013 — Errores nominales

**Requisito:**
El sistema deberá mantener errores internos por debajo de 0.1% de solicitudes ofrecidas bajo el perfil nominal ADR-004.

**Tipo:** QA

**Fuente:** [ADR-004](../../docs/md/Decisiones-cierre-invariantes.md#adr-004)


**Verificación:** Contar errores internos contra solicitudes nominales ofrecidas; entradas inválidas deliberadas se ensayan aparte.

**Estado:** Confirmado

---

<a id="qa-menu-014"></a>
### QA-MENU-014 — Sin órdenes perdidas

**Requisito:**
El sistema deberá soportar la ráfaga ADR-004 de 100 solicitudes/s durante 60 segundos sin pérdida de órdenes aceptadas.

**Tipo:** QA

**Fuente:** [ADR-004](../../docs/md/Decisiones-cierre-invariantes.md#adr-004)


**Verificación:** Conciliar cada solicitud aceptada con resultados persistidos y verificar la propiedad; no se exige latencia nominal durante ráfaga.

**Estado:** Confirmado

---

<a id="qa-menu-015"></a>
### QA-MENU-015 — Sin órdenes duplicadas

**Requisito:**
El sistema deberá soportar la ráfaga ADR-004 de 100 solicitudes/s durante 60 segundos sin duplicación de órdenes aceptadas.

**Tipo:** QA

**Fuente:** [ADR-004](../../docs/md/Decisiones-cierre-invariantes.md#adr-004)


**Verificación:** Conciliar cada solicitud aceptada con resultados persistidos y verificar la propiedad; no se exige latencia nominal durante ráfaga.

**Estado:** Confirmado

---

<a id="qa-menu-016"></a>
### QA-MENU-016 — Sin corrupción de órdenes

**Requisito:**
El sistema deberá soportar la ráfaga ADR-004 de 100 solicitudes/s durante 60 segundos sin corrupción del contenido de órdenes aceptadas.

**Tipo:** QA

**Fuente:** [ADR-004](../../docs/md/Decisiones-cierre-invariantes.md#adr-004)


**Verificación:** Conciliar cada solicitud aceptada con resultados persistidos y verificar la propiedad; no se exige latencia nominal durante ráfaga.

**Estado:** Confirmado

---

<a id="qa-menu-017"></a>
### QA-MENU-017 — Continuidad en ráfaga

**Requisito:**
El sistema deberá soportar la ráfaga ADR-004 de 100 solicitudes/s durante 60 segundos sin caídas del servicio.

**Tipo:** QA

**Fuente:** [ADR-004](../../docs/md/Decisiones-cierre-invariantes.md#adr-004)


**Verificación:** Conciliar cada solicitud aceptada con resultados persistidos y verificar la propiedad; no se exige latencia nominal durante ráfaga.

**Estado:** Confirmado
