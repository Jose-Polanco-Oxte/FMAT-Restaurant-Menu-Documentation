# Reporte de alineación ERS–interfaces

**Sistema:** microservicio Menu de FMAT-Restaurant  
**Fecha de revisión:** 2026-09-12  
**Baseline de interfaces:** `output/interfaces/`, asumido aprobado para esta revisión por la solicitud del usuario  
**ERS objetivo:** `output/ers/`  
**Artefacto paralelo detectado:** `output/ers-es/`

## 1. Veredicto ejecutivo

**Resultado: Alineación parcial; no está lista para declararse cerrada.**

La ERS cubre buena parte del dominio y de la frontera Menu–Inventory: los identificadores `REQ`, `BR`, `DATA`, `INT`, `QA` y `CON` referenciados por las interfaces existen en `output/ers/`, y los asuntos cerrados `OPEN-001`, `003`, `004`, `005`, `006` y `008` tienen bloques de cierre en la ERS. Sin embargo, la propagación documental de la interfaz aprobada está incompleta:

1. `E-17` y su semántica concreta resuelven materialmente las preguntas de `OPEN-002`, pero la ERS todavía lo marca `Pending`.
2. `E-01..E-03`, `E-16`, `E-18`, `M-07` y `M-08` concretan parte de `OPEN-007`, pero la ERS conserva una formulación más amplia de “pendiente” sin separar lo resuelto de lo que aún falta.
3. Las decisiones `D-01..D-09` y varias conductas normativas de HTTP, mensajería, copias, identidad, versiones y recuperación no tienen una entrada equivalente en la ERS ni en su registro de decisiones reemplazadas.
4. Hay dos ediciones de la ERS. Las interfaces enlazan `output/ers-es/`, mientras la solicitud identifica `output/ers/`; las 11 parejas de archivos no son byte a byte iguales. El baseline canónico debe quedar explícito.

La validación local de interfaces es útil, pero no resuelve esta auditoría: reporta PASS para schemas, ejemplos, enlaces locales y estructura de contratos, y declara expresamente que no prueba el servicio, integración ni rendimiento (`output/interfaces/verificacion.md:5-15`, `output/interfaces/validation.json`).

## 2. Baseline y estructura observada

| Artefacto | Evidencia estructural | Lectura para la revisión |
| --- | --- | --- |
| `output/ers/` | 11 módulos; revisión 4 del 2026-09-11; 32 REQ, 40 BR, 23 DATA, 16 INT, 17 QA y 11 CON (`output/ers/index.md:1-14`) | ERS objetivo indicada por el usuario. |
| `output/ers/` abiertos | 10 `OPEN-*`: 6 cerrados, 1 pendiente y 3 parciales (`output/ers/09-conflicts-and-open-items.md:3-5`) | Estado que debe reconciliarse contra interfaces. |
| `output/ers-es/` | Edición paralela con los mismos conteos y estados; la validación previa de `output/review/validation.json` registra dos ediciones y 171 identificadores por edición | No debe ignorarse: interfaces la enlaza como fuente. |
| `output/interfaces/` | 17 fichas HTTP de entrada, 0 HTTP salientes y 6 mensajes (`output/interfaces/verificacion.md:11`) | Baseline aprobado de contratos. |
| `output/interfaces/schemas/` | 41 schemas validados según `output/interfaces/validation.json` | Evidencia estructural, no implementación. |
| Validación de interfaces | `PASS`, 236 enlaces locales, 31 ejemplos, 3 bloques Mermaid y 4 negativos en `output/interfaces/validation.json` | No comprueba alineación semántica con la ERS. |
| `output/review/` | Existe una revisión previa de cierres y propagación | Úsala como antecedente, no como sustituto de esta comparación. |

El índice de interfaces enlaza a `../ers-es/index.md` (`output/interfaces/index.md:3`) y su trazabilidad vuelve a enlazar cinco módulos bajo `../ers-es/` (`output/interfaces/trazabilidad.md:5`). La referencia existe, por lo que no es un enlace roto; sí es una ambigüedad de edición/canonicalidad frente a `output/ers/`.

## 3. Estado de cuestiones abiertas

| ID | Estado en `output/ers/` | Evidencia en interfaces | Evaluación | Acción documental mínima |
| --- | --- | --- | --- | --- |
| `OPEN-001` | Closed | M-01–M-04, E-18, expiración, no disponible y tombstones aparecen en `eventos/disponibilidad.md` y `M-03/M-04` | Cerrado en dominio y sustancialmente reflejado. Faltan en ERS varios detalles de recuperación y protección contra respuestas antiguas | Mantener cerrado; agregar trazas a M-01–M-04/E-18 si esos detalles son parte del contrato normativo de ERS. |
| `OPEN-002` | Pending (`output/ers/09-conflicts-and-open-items.md:25-33`) | E-17 define matching por IDs, `FAIL`/`REPLACE`, IDs nuevos, `dryRun`, todo-o-nada, 412 y ausencia de efectos parciales (`output/interfaces/apis/entrada/configuraciones.md:5-15`) | **Resuelto en la interfaz aprobada, no propagado a ERS.** La ficha aún dice “Propuesta”, por lo que también hay un problema de etiqueta de autoridad | Cerrar o reclasificar `OPEN-002`; actualizar `INT-MENU-005`, REQ-MENU-016/026/027 y la matriz con la semántica de E-17. Si no se quiere cerrar, explicar qué decisión concreta sigue faltando. |
| `OPEN-003` | Closed | Historia, archivado, revisiones e identidad histórica están presentes en modelos y eventos | Alineado a nivel de alcance; los contratos de movimientos externos fueron correctamente excluidos de Menu | Mantener cerrado; no convertir contratos Orders–Inventory en contratos propios de Menu. |
| `OPEN-004` | Closed | Interfaces declara que no ejecutó pruebas de rendimiento (`output/interfaces/verificacion.md:15`) | No contradice la ERS: los objetivos son criterios, no resultados | Mantener cerrado como decisión de criterios; conservar rendimiento no ejecutado como evidencia pendiente de aceptación. |
| `OPEN-005` | Closed | Reglas de escritura y schemas describen capacidad INACTIVE/ACTIVE, conteo y validación (`output/interfaces/apis/entrada/index.md:25-31`, `output/interfaces/03-tipos.md:30`) | Alineado | Mantener cerrado; verificar que límites físicos no se presenten como resueltos por el schema. |
| `OPEN-006` | Closed | E-14/E-15, revisiones independientes, `RecipeRef` fijada y adopción explícita aparecen en las interfaces | Alineado en lo esencial | Mantener cerrado; agregar anclajes de endpoints si la ERS debe trazar cada contrato. |
| `OPEN-007` | Partial (`output/ers/09-conflicts-and-open-items.md:101-111`) | Existen catálogo E-01–E-03, resolución E-16, recuperación E-18, invalidación M-07/M-08 y 6 mensajes activos (`output/interfaces/apis/entrada/index.md:7-29`, `output/interfaces/eventos/index.md:7-18`) | **Parcial más avanzado que la ERS.** Se concretó la frontera Menu y parte de catálogo/publicación, pero no existe contrato directo de Cocina y la propia interfaz conserva lenguaje de propuesta | Dividir el OPEN en subtemas: catálogo/invalidación Menu ya definido; contrato de Cocina y cualquier publicación restante siguen pendientes. Actualizar REQ-MENU-022 e INT-MENU-001/002. |
| `OPEN-008` | Closed | `fromPrice` nulo sin candidatas, variantes elegibles y migración de DEFAULT aparecen en modelos y APIs | Alineado | Mantener cerrado. |
| `OPEN-009` | Partial | `pricingInputs` entrega hechos, pero deja multiplicidad de precio al consumidor; no define snapshot Orders en Menu (`output/interfaces/03-tipos.md:36`) | Pendiente coherente | Mantener parcial. No convertir `pricingInputs` en política de precio final ni afirmar que el snapshot externo es contrato propio de Menu. |
| `OPEN-010` | Partial | Escala, moneda y redondeo siguen abiertos; positividad física se presenta como propuesta (`output/interfaces/02-convenciones.md:35`) | Pendiente coherente, con una propuesta no propagada | Mantener parcial y registrar si la positividad física fue aprobada. No cerrar por los `required`/tipos JSON. |

## 4. Cobertura por áreas

### 4.1 Bien cubierto

- La frontera del microservicio es consistente: Menu posee definiciones, variantes, personalizaciones, combos y recetas; no crea líneas, confirma ventas, descuenta existencias ni despacha Cocina (`output/interfaces/01-arquitectura.md:3-23`), coherente con `output/ers/01-scope-and-actors.md:5-9`.
- La disponibilidad por necesidades planas, claves opacas, revisiones, expiración y fail-closed tiene correspondencia directa con `INT-MENU-008..011`, `DATA-MENU-019/020` y `CON-MENU-009/010`.
- La resolución neta y el ámbito de efectos tienen base en `REQ-MENU-032` y `BR-MENU-018/019/022`, aunque la interfaz añade detalles de `scope`, unidades y agrupación que deben trazarse si se consideran normativos.
- La retirada de `E-10`, `M-05` y `M-06` está documentada en interfaces (`output/interfaces/apis/entrada/index.md:35`, `output/interfaces/eventos/index.md:16-18`) y no se observó reutilización activa de esos IDs en `contracts.json`/`events.json`.

### 4.2 Refinamientos válidos, pero sin anclaje explícito en ERS

Estos detalles pueden vivir en una especificación de interfaces sin duplicarse literalmente en la ERS, pero la relación debe quedar explícita:

- autorización Bearer, matriz de permisos y 401/403 (`output/interfaces/02-convenciones.md:5-19`);
- `Idempotency-Key`, `If-Match`, ETag, 409/412, paginación, `Cache-Control` y límites de transporte (`output/interfaces/02-convenciones.md:21-29`);
- JSON Schema 2020-12, campos desconocidos, versionado aditivo y compatibilidad (`output/interfaces/02-convenciones.md:31-35`);
- envelope de mensajes, `correlationId` opcional, eliminación de `causationId`, ACL y deduplicación (`output/interfaces/02-convenciones.md:37-41`).

La ERS no necesita repetir cada ruta o campo para ser válida, pero sí debe decir si estos son contratos derivados de requisitos confirmados, decisiones de diseño aprobadas o detalles exclusivos del paquete de interfaces. En el estado actual, `INT-MENU-005` sigue pending y no ofrece ese anclaje.

## 5. Hallazgos atómicos

### F-001 — Canonicalidad ambigua entre `ers` y `ers-es` — P1

**Clasificación:** Interfaz aprobada no propagada / problema de baseline.

**Evidencia:** `output/interfaces/index.md:3` y `output/interfaces/trazabilidad.md:5` apuntan a `output/ers-es/`, mientras la solicitud identifica `output/ers/`. Las dos ediciones tienen los mismos conteos generales, pero las 11 parejas de archivos no son byte a byte iguales.

**Impacto:** Un agente puede concluir que la interfaz está alineada con `ers-es` y no con la ERS que el usuario pidió revisar. Además, cualquier cambio futuro puede actualizar una edición y dejar la otra obsoleta.

**Corrección mínima:** Declarar una edición canónica. Si `output/ers/` es la canónica, cambiar los enlaces de interfaces y actualizar la edición española como traducción sincronizada; si `ers-es/` es la canónica, documentarlo y explicar por qué `ers/` no es el objetivo.

**Cierre verificable:** Todos los enlaces de autoridad apuntan a la edición seleccionada y una comparación de IDs/estados/contenido no deja diferencias materiales sin registrar.

### F-002 — `OPEN-002` sigue pendiente después de que E-17 fija su semántica — P1

**Clasificación:** Interfaz aprobada no propagada.

**Evidencia:** La ERS pregunta cómo se emparejan slots, se manejan destinos existentes, se rechazan incompatibilidades y se evitan fallos parciales (`output/ers/09-conflicts-and-open-items.md:25-33`). La interfaz define cada una de esas decisiones, incluidos `FAIL`, `REPLACE`, IDs nuevos, `dryRun`, 412 y todo-o-nada (`output/interfaces/apis/entrada/configuraciones.md:5-15`). Además, `E-17` tiene ruta, headers, esquema, respuesta y errores (`output/interfaces/apis/entrada/E-17.md:3-58`).

**Impacto:** La ERS afirma que el contrato administrativo exacto no existe (`output/ers/05-interfaces-integrations.md:86-100`), aunque el baseline aprobado sí lo especifica.

**Corrección mínima:** Cerrar `OPEN-002` para el alcance de E-17 y actualizar `INT-MENU-005`, REQ-MENU-016, REQ-MENU-026 y REQ-MENU-027 con referencias a la ficha. Mantener como OPEN únicamente cualquier decisión que el contrato todavía etiquete explícitamente como propuesta.

**Cierre verificable:** La matriz de trazabilidad muestra E-17 como fuente activa y no quedan en la ERS frases que describan como inexistente un contrato que la interfaz aprobada ya define.

### F-003 — `OPEN-007` no está descompuesto después de concretar catálogo, resolución y recuperación — P1

**Clasificación:** Interfaz aprobada no propagada / estado parcial desactualizado.

**Evidencia:** La ERS mantiene como pendientes los contratos completos de catálogo, Cocina, endpoints y transporte (`output/ers/09-conflicts-and-open-items.md:101-111`; `output/ers/05-interfaces-integrations.md:12-44`). La interfaz ahora define 17 endpoints de entrada, incluyendo catálogo, detalle, resolución y recuperación (`output/interfaces/apis/entrada/index.md:7-29`), y eventos de invalidación M-07/M-08 (`output/interfaces/eventos/index.md:7-18`).

**Impacto:** No se puede distinguir en la ERS qué parte de `OPEN-007` sigue abierta y qué parte ya tiene contrato Menu. Esto afecta REQ-MENU-022 e INT-MENU-001/002.

**Corrección mínima:** Dividir el asunto en: catálogo/invalidación de Menu definido; resolución E-16 definida; recuperación E-18 definida; contrato de Cocina no definido; cualquier publicación restante pendiente. No declarar que existe un contrato directo de Cocina solo por el modelo de preparación.

**Cierre verificable:** Cada subtema de `OPEN-007` tiene estado independiente, fuente de interfaz y condición de cierre.

### F-004 — Decisiones D-01 a D-09 no tienen registro equivalente en la ERS — P1

**Clasificación:** Interfaz aprobada no propagada.

**Evidencia:** Interfaces registra decisiones sobre transporte y frontera (`output/interfaces/01-arquitectura.md:15-23`), autorización y convenciones (`output/interfaces/02-convenciones.md:5-41`) e identidad/versiones/resolución (`output/interfaces/03-tipos.md:20-38`). La ERS conserva 17 decisiones históricas, pero ninguna entrada `SUPERSEDED-*` o bloque de decisión identifica D-01..D-09.

**Impacto:** No hay forma de distinguir qué detalles son solo diseño de contrato, cuáles son restricciones activas de Menu y cuáles siguen siendo propuestas. La trazabilidad actual solo cita IDs ERS (`output/interfaces/trazabilidad.md:7-26`).

**Corrección mínima:** Registrar cada D como restricción, decisión activa, propuesta o detalle exclusivo de interfaz. No es necesario convertirlos todos en requisitos funcionales.

**Cierre verificable:** Toda D-01..D-09 tiene estado, autoridad, fuente y enlace a la sección de interfaces o a un ID ERS.

### F-005 — Retirada de M-05/M-06 y resolución E-16 no se reflejan en decisiones superseded de ERS — P2

**Clasificación:** Retirado / trazabilidad incompleta.

**Evidencia:** Interfaces afirma que E-16 sustituye la resolución interactiva y que M-05/M-06 se retiran sin reutilizar IDs (`output/interfaces/01-arquitectura.md:15`, `output/interfaces/eventos/index.md:16-18`, `output/interfaces/flujos.md:25-37`). La ERS no menciona esos IDs al buscar en `output/ers/`; su registro histórico no contiene una decisión equivalente.

**Impacto:** La interfaz está correcta en su catálogo activo, pero la ERS no conserva la explicación de por qué esos contratos dejaron de ser activos.

**Corrección mínima:** Añadir una decisión superseded o una nota de alcance con la fuente aprobada, sin volver a introducir los IDs como contratos activos.

**Cierre verificable:** `E-10`, `M-05` y `M-06` aparecen solo como retirados/históricos y E-16 como contrato activo trazado.

### F-006 — Semántica de disponibilidad avanzada no está completamente propagada — P2

**Clasificación:** Refinamiento aprobado no anclado.

**Evidencia:** M-02 conserva tombstones y evita resurrección por mensajes retrasados (`output/interfaces/eventos/salida/M-02.md:32-34`); M-03 rechaza revisión vieja, contenido conflictivo y evaluaciones vencidas (`output/interfaces/eventos/entrada/M-03.md:36-64`); M-04 exige `reevaluationRequestId` nuevo y no acepta respuestas antiguas (`output/interfaces/eventos/salida/M-04.md:37-39`). La ERS solo expresa parte de estas condiciones en INT-MENU-010/011 y DATA-MENU-019/020 (`output/ers/05-interfaces-integrations.md:176-208`, `output/ers/04-data-requirements.md:333-365`).

**Impacto:** La ERS no especifica si conflicto de contenido, tombstone, identidad de reevaluación y no resurrección son obligaciones activas o detalles internos del contrato.

**Corrección mínima:** Añadir trazas a los IDs existentes o crear requisitos de interfaz separados; no duplicar toda la forma JSON en la ERS.

**Cierre verificable:** Cada regla de aceptación/rechazo relevante de M-02/M-03/M-04 tiene una obligación ERS o una declaración explícita de que pertenece exclusivamente al contrato de interfaz.

### F-007 — Identidad de copias y referencias históricas están más precisas en interfaces que en ERS — P2

**Clasificación:** Interfaz aprobada no propagada / dato ERS demasiado general.

**Evidencia:** Interfaces establece que Menu genera identidades raíz, que las copias generan IDs nuevos y los reemplazos conservan IDs (`output/interfaces/03-tipos.md:20-24`). También exige que ComboOption fije `MenuItemRef` completo con versión y variante y que RecipeRef fije revisión exacta. La ERS solo exige para `DATA-MENU-013` una “component variant reference” (`output/ers/04-data-requirements.md:225-239`) y para `DATA-MENU-018` la receta exacta (`output/ers/04-data-requirements.md:315-329`).

**Impacto:** Una implementación podría cumplir la ERS y todavía perder la identidad/versionado completo que la interfaz ya necesita para reproducibilidad histórica.

**Corrección mínima:** Ampliar DATA-MENU-013 o añadir una restricción de identidad/versionado; relacionarla con REQ-MENU-026/027 y la operación E-17.

**Cierre verificable:** La ERS especifica o referencia de manera inequívoca quién genera IDs, cuándo se conservan y qué identidad/versiones se fijan en ComboOption y RecipeRef.

### F-008 — Outbox de Menu aparece en interfaces, pero la ERS solo registra el outbox externo de Orders — P2

**Clasificación:** Interfaz aprobada no propagada / posible confusión de propiedad.

**Evidencia:** Interfaces propone persistir cambios y trabajo de publicación juntos (`output/interfaces/02-convenciones.md:37-41`) y M-01 indica publicar desde outbox junto al cambio de Menu (`output/interfaces/eventos/salida/M-01.md:39-41`). En cambio, `CON-MENU-011` exige el outbox de Orders para snapshot y movimientos (`output/ers/07-constraints.md:194-206`).

**Impacto:** La ERS no deja claro si Menu tiene una obligación de outbox, si es solo una opción de implementación o si el único outbox contractual es el de Orders.

**Corrección mínima:** Clasificar el outbox de Menu como restricción aprobada, propuesta no normativa o detalle de implementación. Si es aprobado, añadirlo a constraints/INT y distinguirlo de `CON-MENU-011`.

**Cierre verificable:** No hay dos lecturas posibles sobre qué servicio posee cada outbox.

### F-009 — D-05, D-06 y varias convenciones siguen etiquetadas como propuesta pese a la aprobación de interfaces — P2

**Clasificación:** Estado de autoridad inconsistente.

**Evidencia:** La interfaz llama “propuesta” a autorización y permisos (`output/interfaces/02-convenciones.md:5-19`), a positividad física (`output/interfaces/02-convenciones.md:35`) y a la semántica de E-17 (`output/interfaces/apis/entrada/configuraciones.md:5`). Además, el índice dice que no alteró la ERS ni cerró sus asuntos (`output/interfaces/index.md:18`) y la trazabilidad repite que OPEN-002 conserva una propuesta (`output/interfaces/trazabilidad.md:28-33`).

**Impacto:** El visto bueno del usuario y el estado textual del artefacto no coinciden. Un agente posterior no sabe si debe propagar esas decisiones o tratarlas como alternativas.

**Corrección mínima:** Después de confirmar autoridad, sustituir “propuesta” por “aprobada” donde corresponda; mantener explícitamente como pendiente solo lo que el usuario no haya aprobado.

**Cierre verificable:** La interfaz tiene un único vocabulario de estados (`aprobada`, `pendiente`, `retirada`) y la ERS refleja el mismo estado.

### F-010 — PASS de interfaces no equivale a alineación ERS–interfaces — P3

**Clasificación:** Límite de evidencia.

**Evidencia:** `output/interfaces/verificacion.md:5-15` limita el validador a schemas, ejemplos, enlaces, estructura y Mermaid; también declara que no se ejecutaron pruebas de integración ni rendimiento. `output/interfaces/validation.json` registra `PASS` dentro de ese alcance.

**Impacto:** Usar ese PASS como cierre global ocultaría precisamente las brechas de trazabilidad encontradas en este reporte.

**Corrección mínima:** Mantener tres estados separados: validación estructural de interfaces, alineación semántica documental y aceptación de implementación/integración/rendimiento.

**Cierre verificable:** El índice o reporte de revisión no presenta el PASS local como aceptación global.

## 6. Acciones recomendadas por prioridad

### P1 — Necesarias para declarar alineación documental

1. Elegir `output/ers/` o `output/ers-es/` como edición canónica y corregir la trazabilidad.
2. Propagar el cierre de `OPEN-002` a la ERS si la aprobación del usuario convierte E-17 en contrato activo.
3. Descomponer `OPEN-007` y actualizar REQ-MENU-022 e INT-MENU-001/002 según lo que ya está definido y lo que sigue pendiente.
4. Registrar el estado de D-01..D-09 sin convertir decisiones de transporte en requisitos funcionales por defecto.

### P2 — Necesarias para trazabilidad completa

1. Registrar como decisiones históricas la retirada de E-10/M-05/M-06.
2. Trazar tombstones, conflictos de contenido, reevaluación y no resurrección.
3. Precisar identidad/versiones de copias y referencias de ComboOption/RecipeRef.
4. Clasificar la propiedad del outbox de Menu.
5. Resolver las etiquetas “propuesta” que contradicen el visto bueno del usuario.

### P3 — Evidencia y mantenimiento

1. Conservar separado el PASS estructural de interfaces de la aceptación semántica y de implementación.
2. Añadir un verificador de cobertura que detecte IDs D/E/M activos, OPEN desactualizados y referencias a la edición equivocada de la ERS.

## 7. Límites de esta revisión

- No se ejecutó el servicio Menu.
- No se probó broker, autorización real, persistencia, integración entre microservicios ni rendimiento.
- La existencia de JSON Schema y ejemplos válidos no demuestra que una implementación respete las reglas intercampo ni los estados de negocio.
- La conclusión sobre `OPEN-002` depende de la premisa solicitada: el usuario dio visto bueno a `output/interfaces/`. Si ese visto bueno significaba únicamente aprobación visual y no autoridad normativa, `OPEN-002` debe permanecer pendiente y el reporte debe clasificar E-17 como propuesta.

## 8. Conclusión

La interfaz aprobada es una base más concreta que la ERS actual, no una simple representación de sus requisitos ya sincronizada. La siguiente acción correcta es propagar decisiones y estados —principalmente `OPEN-002`, la partición de `OPEN-007`, la edición canónica y D-01..D-09— manteniendo como pendientes reales `OPEN-009` y `OPEN-010` en los aspectos que la propia interfaz todavía no decide.
