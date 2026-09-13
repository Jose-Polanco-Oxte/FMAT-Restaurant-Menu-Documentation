[← Índice](./index.md)

# Estado de decisiones

Nueve asuntos cerrados; OPEN-010 parcial únicamente por límites técnicos pendientes.

---

<a id="open-001"></a>

### OPEN-001 — Disponibilidad operativa

**Evidencia:** `docs/md/Modelo-Final.md` pp. 18–19

**Estado:** Cerrado

**Decisión:** Inventory evalúa insumos planos con claves opacas; Menu conserva la correspondencia y expone disponibilidad vigente. Sin evaluación válida o ante caída detectada se muestra no disponible. El descuento usa la lista neta de la línea, no la proyección.

**Fuente de cierre:** [ADR-001](../../docs/md/Decisiones-cierre-invariantes.md#adr-001)

**Documentación afectada:** INT-MENU-008, INT-MENU-009, INT-MENU-010, INT-MENU-011, INT-MENU-017, INT-MENU-019, BR-MENU-023, DATA-MENU-019, DATA-MENU-020, CON-MENU-009, CON-MENU-010.

---

<a id="open-002"></a>

### OPEN-002 — Semántica de copia y operaciones múltiples

**Estado:** Cerrado

**Decisión:** E-17: mismo MenuItem, IDs, FAIL/REPLACE, dryRun, concurrencia y todo-o-nada.

**Fuente de cierre:** [ALIGN](../../docs/reviews/ers-interfaces-alignment/decisions.md)

**Documentación afectada:** INT-MENU-005, REQ-MENU-016, REQ-MENU-026, REQ-MENU-027

---

<a id="open-003"></a>

### OPEN-003 — Retención de configuraciones

**Evidencia:** `docs/md/Auditoria-3.md` pp. 8–9

**Estado:** Cerrado

**Decisión:** ARCHIVED retira variantes de nuevas ventas. Se conserva historia sin purga en esta versión. Orders persiste insumos netos y trabajo de entrega; Inventory aplica movimientos idempotentes y reversiones exactas autorizadas.

**Fuente de cierre:** [ADR-003](../../docs/md/Decisiones-cierre-invariantes.md#adr-003)

**Documentación afectada:** REQ-MENU-028, REQ-MENU-032, DATA-MENU-022, DATA-MENU-023, INT-MENU-012, INT-MENU-013, INT-MENU-014, INT-MENU-015, INT-MENU-018, QA-MENU-002, CON-MENU-008, CON-MENU-011.

---

<a id="open-004"></a>

### OPEN-004 — Criterios de aceptación de rendimiento

**Evidencia:** `docs/md/Modelo-Final.md` pp. 49–50

**Estado:** Cerrado

**Decisión:** Se adopta el perfil de aceptación ADR-004: 40 clientes, 30 solicitudes/s durante 30 minutos y ráfaga de 100 solicitudes/s durante 60 segundos, con percentiles por operación. No son mediciones reales.

**Fuente de cierre:** [ADR-004](../../docs/md/Decisiones-cierre-invariantes.md#adr-004)

**Documentación afectada:** QA-MENU-004, QA-MENU-005, QA-MENU-006, QA-MENU-007, QA-MENU-008, QA-MENU-009, QA-MENU-010, QA-MENU-011, QA-MENU-012, QA-MENU-013, QA-MENU-014, QA-MENU-015, QA-MENU-016, QA-MENU-017.

---

<a id="open-005"></a>

### OPEN-005 — Conteo de selecciones y fase de validación

**Evidencia:** `docs/md/Auditoria-3.md` pp. 8

**Estado:** Cerrado

**Decisión:** Los modificadores cuentan unidades seleccionadas; los slots cuentan opciones elegidas una vez, no unidades suministradas. Capacidad por suma de máximos en grupos y opciones habilitadas en slots. INACTIVE admite trabajo incompleto con advertencia; ACTIVE exige configuración viable.

**Fuente de cierre:** [ADR-005](../../docs/md/Decisiones-cierre-invariantes.md#adr-005)

**Documentación afectada:** BR-MENU-011, BR-MENU-012, BR-MENU-024, BR-MENU-025, BR-MENU-026, BR-MENU-027, BR-MENU-028, BR-MENU-029, BR-MENU-030, BR-MENU-031, BR-MENU-033, BR-MENU-039, REQ-MENU-029, REQ-MENU-030, DATA-MENU-021.

---

<a id="open-006"></a>

### OPEN-006 — Ciclo de revisión de recetas

**Evidencia:** `docs/md/Modelo-Final.md` pp. 23, 37–38

**Estado:** Cerrado

**Decisión:** Cada cambio efectivo aceptado genera revisión inmutable por identidad con contador y fecha ISO8601 con zona. Producto y receta tienen secuencias independientes. Las líneas existentes conservan versiones fijadas; las variantes adoptan revisiones de receta explícitamente.

**Fuente de cierre:** [ADR-006](../../docs/md/Decisiones-cierre-invariantes.md#adr-006)

**Documentación afectada:** REQ-MENU-021, REQ-MENU-033, BR-MENU-035, BR-MENU-036, BR-MENU-037, DATA-MENU-017, DATA-MENU-018, INT-MENU-016.

---

<a id="open-007"></a>

### OPEN-007 — Contratos de consumo y publicación

**Estado:** Cerrado

**Decisión:** Catálogo E-01–E-03 e invalidaciones M-07/M-08 definidos; resolución E-16 y recuperación E-18 definidas. Orders envía preparación a Cocina. Topología de broker y contrato externo de Cocina pertenecen a integración externa, no a una interfaz directa Menu–Cocina.

**Fuente de cierre:** [ALIGN](../../docs/reviews/ers-interfaces-alignment/decisions.md)

**Documentación afectada:** REQ-MENU-022, INT-MENU-001, INT-MENU-002

---

<a id="open-008"></a>

### OPEN-008 — Ciclo de variantes y mínimo mostrado

**Evidencia:** `docs/md/Modelo-Final.md` pp. 7–8, 18–19, 27

**Estado:** Cerrado

**Decisión:** El mínimo usa solo variantes elegibles ahora; sin candidatas no se muestra precio desde. DEFAULT conserva su identidad histórica y se archiva al publicar nuevas variantes dimensionales, sin revisión comercial intermedia inválida.

**Fuente de cierre:** [ADR-008](../../docs/md/Decisiones-cierre-invariantes.md#adr-008)

**Documentación afectada:** REQ-MENU-007, REQ-MENU-031, REQ-MENU-034, BR-MENU-023, BR-MENU-038, BR-MENU-040, DATA-MENU-016.

---

<a id="open-009"></a>

### OPEN-009 — Multiplicidad de precios y alcance de copias

**Estado:** Cerrado

**Decisión:** Precio fijo sin cargos por opciones; extras por cantidad en cada unidad; resumen agregado por variante en E-16, conservado por Orders.

**Fuente de cierre:** [ALIGN](../../docs/reviews/ers-interfaces-alignment/decisions.md)

**Documentación afectada:** BR-MENU-008, BR-MENU-016, BR-MENU-017, INT-MENU-004, INT-MENU-020

---

<a id="open-010"></a>

### OPEN-010 — Políticas de validación de datos

**Estado:** Parcial

**Decisión:** Resuelto: moneda externa única, precisión monetaria sin redondeo, precios no negativos, físicos positivos, nombres repetibles y tipo inmutable. Inventory proporciona catálogo de ingredientes/STOCKED con al menos ID, nombre y unidad de medida, y búsqueda (INT-MENU-024/025). Magnitud/precisión de cantidades permanece abierta hasta conocer sus especificaciones. La propiedad de unidades está resuelta; rutas, conversiones y cambios de unidad esperan su contrato. Retención de tokens/idempotencia de siete días (B) e integración monetaria aprobadas. Solo quedan abiertos acuerdos con Inventory; capacidad es dimensionamiento operativo, no una cuota comercial pendiente. Ver [decisión aprobada](../../docs/reviews/ers-interfaces-alignment/open-010-proposals.md). No se inventan umbrales.

**Fuente de cierre:** [ALIGN](../../docs/reviews/ers-interfaces-alignment/decisions.md)

**Documentación afectada:** BR-MENU-041, BR-MENU-042, BR-MENU-043, BR-MENU-044
