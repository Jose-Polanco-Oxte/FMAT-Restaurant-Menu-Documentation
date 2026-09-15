[← Índice](./index.md)

# Estado de decisiones

Los asuntos originales de cierre de Menu permanecen documentados; `Auditoria-4.md` cierra las correcciones del modelo de producto, variante, modificador y combo, pero no define contratos de transporte externos faltantes. OPEN-010 es parcial únicamente por límites de Inventory pendientes. OPEN-011 a OPEN-019 siguen siendo proyecciones externas requeridas por las UI consumidoras confirmadas. Ninguna decisión de UI permanece abierta en esos registros.

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

**Decisión:** Cada cambio efectivo aceptado genera revisión inmutable por identidad con contador y fecha ISO8601 con zona. `MenuItem` y receta tienen secuencias independientes. Las líneas existentes conservan versiones fijadas; las presentaciones adoptan revisiones de receta explícitamente.

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

### OPEN-008 — Elegibilidad de unidades vendibles y precio de catálogo

**Evidencia:** `docs/md/Modelo-Final.md` pp. 7–8, 18–19, 27

**Estado:** Cerrado

**Decisión:** Para un `MenuItem` hoja, el precio de catálogo usa solo valores `MenuItemVariant.unitPrice` actualmente elegibles; para un `MenuItem` COMBO, usa solo valores `ComboConfiguration.unitPrice` actualmente elegibles. Si los valores elegibles difieren, el catálogo muestra `Desde $X` con el menor valor; si son iguales, muestra `$X`; si no hay unidades elegibles, no muestra precio numérico y marca el item como no disponible. `DEFAULT` conserva su identidad histórica y se archiva al publicar valores explícitos de características de presentación, sin revisión comercial intermedia inválida.

**Fuente de cierre:** [ADR-008](../../docs/md/Decisiones-cierre-invariantes.md#adr-008)

**Documentación afectada:** REQ-MENU-007, REQ-MENU-031, REQ-MENU-034, BR-MENU-023, BR-MENU-038, BR-MENU-040, DATA-MENU-016.

---

<a id="open-009"></a>

### OPEN-009 — Multiplicidad de precios y alcance de copias

**Estado:** Cerrado

**Decisión:** ComboConfiguration tiene unitPrice absoluto; ComboOption puede agregar priceDelta; no se agregan precios base de componentes. Los extras de modificadores siguen agregándose por cantidad y unidad personalizada en E-16, y Orders conserva el resumen.

**Fuente de cierre:** `docs/md/Auditoria-4.md`, items 26 y 31–32; las decisiones previas de precio siguen siendo fuente para agregación y snapshot.

**Documentación afectada:** BR-MENU-008, BR-MENU-016, BR-MENU-017, INT-MENU-004, INT-MENU-020, SUPERSEDED-020

---

<a id="open-010"></a>

### OPEN-010 — Políticas de validación de datos

**Estado:** Parcial

**Decisión:** Resuelto: moneda externa única, precisión monetaria sin redondeo, precios no negativos, físicos positivos, nombres repetibles y tipo inmutable. Inventory proporciona catálogo de ingredientes/STOCKED con al menos ID, nombre y unidad de medida, y búsqueda (INT-MENU-024/025). Magnitud/precisión de cantidades permanece abierta hasta conocer sus especificaciones. La propiedad de unidades está resuelta; rutas, conversiones y cambios de unidad esperan su contrato. Retención de tokens/idempotencia de siete días (B) e integración monetaria aprobadas. Dentro del alcance original de Menu, solo quedan abiertos acuerdos con Inventory; los contratos externos de UI se rastrean por separado abajo. La capacidad es dimensionamiento operativo, no una cuota comercial pendiente. Ver [decisión aprobada](../../docs/reviews/ers-interfaces-alignment/open-010-proposals.md). No se inventan umbrales.

**Fuente de cierre:** [ALIGN](../../docs/reviews/ers-interfaces-alignment/decisions.md)

**Documentación afectada:** BR-MENU-041, BR-MENU-042, BR-MENU-043, BR-MENU-044

---

## Contratos externos requeridos por las UI consumidoras confirmadas

Los siguientes asuntos están abiertos únicamente porque el servicio o proveedor propietario no está especificado en este repositorio. No vuelven provisional la decisión de UI correspondiente.

<a id="open-011"></a>
### OPEN-011 — Proyección de mesas asignadas

**Evidencia:** Decisión explícita de UI de mesero en la solicitud del 2026-09-13; V-MES-01 en `output/ui-spec/ui-data-spec.md`.

**Información conocida:** Sala proporciona al mesero un conjunto limitado de mesas asignadas. La UI distingue mesas con y sin orden.

**Información faltante:** Identificador exacto de mesa, etiqueta visible, representación de asignación, estado de mesa, referencia de orden activa y contrato de consulta/actualización.

**Pregunta por resolver:** ¿Qué proyección y contrato proporcionará Sala a la UI de orden para las mesas asignadas y su relación con la orden?

**Estado:** Abierto — contrato externo

---

<a id="open-012"></a>
### OPEN-012 — Proyección de orden activa y agregado

**Evidencia:** Decisión explícita de UI de mesero en la solicitud del 2026-09-13; V-MES-02/V-MES-03 en `output/ui-spec/ui-data-spec.md`.

**Información conocida:** Orders posee las órdenes existentes, líneas confirmadas, cantidades de línea y totales de orden. La UI prepara líneas locales de borrador y puede agregarlas a una orden existente.

**Información faltante:** Lectura de orden activa, creación de orden, operación de agregado, estados de línea, política de duplicados, permisos del mesero y respuesta autoritativa posterior al agregado.

**Pregunta por resolver:** ¿Qué contrato de Orders soportará leer, crear y agregar a la orden conservando el borrador local si falla una operación?

**Estado:** Abierto — contrato externo

---

<a id="open-013"></a>
### OPEN-013 — Fuente de categorías y mapeo de clasificación visual

**Evidencia:** Aclaración explícita de UI en la solicitud del 2026-09-13; UI-OPEN-003 y sección 3.6 de `output/ui-spec/ui-data-spec.md`.

**Información conocida:** Los valores y etiquetas de clasificación de UI para productos hoja están confirmados: DISH/Platillo, BEVERAGE/Bebida, DESSERT/Postre y COMPLEMENT/Complemento. COMBO es Tipo de producto, no clasificación comercial. ItemCategory se comparte por productos PREPARED/STOCKED; ComboCategory es separado y aplica a COMBO.

**Información faltante:** Propietario del catálogo de categorías, etiquetas de categorías, contrato externo de transporte y versionado de cambios. La semántica de la clasificación hoja quedó resuelta por Auditoria-4.

**Pregunta por resolver:** ¿Qué catálogo externo proporciona las categorías y cómo relaciona cada identidad de categoría con la clasificación visual confirmada?

**Estado:** Abierto — contrato externo

---

<a id="open-014"></a>
### OPEN-014 — Proyección administrativa del catálogo

**Evidencia:** Decisión explícita de UI administrativa en la solicitud del 2026-09-13; V-ADM-01 en `output/ui-spec/ui-data-spec.md`.

**Información conocida:** La UI administrativa usa la misma intención de búsqueda y filtros que el catálogo de venta y muestra datos de gestión en tarjetas.

**Información faltante:** Endpoint o proyección de listado administrativo, filtros admitidos, paginación, campos de tarjeta y propietario de clasificación y ciclo de vida.

**Pregunta por resolver:** ¿Qué contrato proporcionará a la UI la proyección administrativa con los filtros y campos requeridos?

**Estado:** Abierto — contrato externo

---

<a id="open-015"></a>
### OPEN-015 — Archivado de item raíz y retiro suave

**Evidencia:** Decisión explícita de UI administrativa en la solicitud del 2026-09-13; UI-REQ-009/UI-REQ-010 en `output/ui-spec/ui-data-spec.md`.

**Información conocida:** La UI separa ACTIVE, INACTIVE, REVIEW_REQUIRED y ARCHIVED y ofrece retiro de un item, items seleccionados o todos los resultados del apartado archivado. “Retiro” es suave y no borra físicamente la historia. Los contratos actuales de Menu definen ARCHIVED para variantes, no para MenuItems raíz ni retiro suave masivo.

**Información faltante:** Estado de ciclo de vida del item raíz, operación de archivado, operaciones de retiro suave, estado de respuesta, política de restauración y comportamiento de referencias históricas.

**Pregunta por resolver:** ¿Qué contrato externo de Menu o administrativo persistirá el archivado del item raíz y los tres alcances de retiro suave?

**Estado:** Abierto — contrato externo

---

<a id="open-016"></a>
### OPEN-016 — Resultado coordinado de guardado de Recipe y MenuItem

**Evidencia:** Decisión explícita de UI de alta/edición en la solicitud del 2026-09-13; V-ADM-02 en `output/ui-spec/ui-data-spec.md`.

**Información conocida:** Las revisiones de Recipe y MenuItem son conceptos separados. El editor debe mostrar por separado sus identidades resultantes.

**Información faltante:** Atomicidad, compensación y semántica de respuesta cuando una operación de persistencia tiene éxito y la otra falla.

**Pregunta por resolver:** ¿La UI administrativa coordinará operaciones separadas o existirá un contrato externo con resultado combinado atómico?

**Estado:** Abierto — contrato externo

---

<a id="open-017"></a>
### OPEN-017 — Proyección del selector de Inventory

**Evidencia:** Decisión explícita de UI administrativa en la solicitud del 2026-09-13; V-ADM-02 e INT-MENU-024/025.

**Información conocida:** Inventory proporciona referencias seleccionables de ingredientes y STOCKED con al menos identificador, nombre, unidad y búsqueda.

**Información faltante:** Rutas, paginación, límites y precisión de cantidad, conversiones y semántica de cambio de unidad. La política de cantidades complementa el estado parcial de OPEN-010.

**Pregunta por resolver:** ¿Qué contrato de Inventory soportará los selectores del editor y sus controles de cantidad/unidad?

**Estado:** Abierto — contrato externo

---

<a id="open-018"></a>
### OPEN-018 — Proveedor de carga y previsualización de imágenes

**Evidencia:** Decisión explícita de UI de gestión de catálogo en la solicitud del 2026-09-13; manejo de `imageRef` en `output/ui-spec/ui-data-spec.md`.

**Información conocida:** Menu conserva una referencia de imagen string o null; la UI necesita selección de imagen, estado de carga y previsualización.

**Información faltante:** Proveedor, operaciones de carga y eliminación, validación, autorización y vigencia de la referencia de previsualización.

**Pregunta por resolver:** ¿Qué contrato externo proporciona y resuelve la referencia de imagen utilizada por la UI?

**Estado:** Abierto — contrato externo

---

<a id="open-019"></a>
### OPEN-019 — Ajustes finales de Billing

**Evidencia:** Aclaración explícita de precio en la solicitud del 2026-09-13; BR-UI-001 y DATA-UI-006.

**Información conocida:** La UI muestra el costo acumulado de preorden como `Σ(quantity × resolvedUnitSubtotal)`. Billing puede ajustar después el importe final; esos ajustes no forman parte del acumulado de preorden.

**Información faltante:** Contrato de Billing para descuentos, impuestos, cargos, redondeo, recálculo final y exposición del importe definitivo.

**Pregunta por resolver:** ¿Qué respuesta de Billing proporcionará el importe final y sus ajustes después de confirmar la preorden?

**Estado:** Abierto — contrato externo
