# Prompt para el agente revisor

Actúa como **Senior Requirements Engineer y auditor independiente de trazabilidad**. Revisa este repositorio del microservicio **Menu** para determinar qué tan alineada está la ERS con las interfaces aprobadas y si las cuestiones abiertas de la ERS realmente quedaron resueltas.

## Autoridad y alcance

- Trata `output/interfaces/` como el baseline aprobado de interfaces para esta revisión.
- Trata `output/ers/` como la ERS que debe quedar alineada.
- Verifica que las referencias de autoridad apunten a `output/ers/`, elegida como canónica. Compara IDs, estados y significado de `output/ers-es/` como traducción sincronizada; no confundas diferencias de idioma con divergencia de requisitos.
- Lee `docs/reviews/ers-interfaces-alignment/decisions.md` como fuente de las correcciones aprobadas y `closure-report.md` como reporte de su ejecución. `report.md` conserva los hallazgos originales; no describe necesariamente el estado actual.
- Lee primero `.agents/AGENTS.md` y `.agents/REQUIREMENTS-SPEC.md`.
- Consulta también `output/review/closure-review.md`, `output/review/review.md` y `output/review/validation.json`, pero no los trates como autoridad superior a la ERS o a las interfaces aprobadas.

## Restricciones

- La revisión es estrictamente documental y de solo lectura sobre `output/ers/`, `output/ers-es/`, `output/interfaces/` y `output/review/`.
- No edites, renombres, borres, regeneres ni normalices esos artefactos.
- Puedes crear únicamente el reporte en `docs/reviews/ers-interfaces-alignment/` si el usuario lo solicita.
- No inventes requisitos. No cierres una cuestión abierta solo porque exista un endpoint o un esquema: comprueba que la semántica esté decidida, que sea compatible con la ERS y que la interfaz no siga etiquetando el punto como propuesta.
- No marques PASS global por la validación local de contratos. Separa validación estructural de JSON/enlaces/Mermaid, alineación semántica ERS–interfaces y pruebas de implementación, integración, broker y rendimiento.

## Procedimiento

1. Inventaría la estructura, revisiones, conteos e identificadores de `output/ers/` y `output/interfaces/`.
2. Compara `output/ers/` contra `output/ers-es/`: nombres, IDs, estados de `OPEN-*`, decisiones reemplazadas y diferencias materiales.
3. Lee el índice, la trazabilidad, los modelos, convenciones, APIs, eventos, flujos, esquemas y resultados de validación de `output/interfaces/`.
4. Recorre todos los bloques de `output/ers/`, en especial `02-functional-requirements.md`, `03-business-rules.md`, `04-data-requirements.md`, `05-interfaces-integrations.md`, `07-constraints.md`, `08-superseded-decisions.md` y `09-conflicts-and-open-items.md`.
5. Construye una matriz de cobertura con estas clasificaciones:
   - `Cubierto`: la ERS expresa la misma obligación o decisión.
   - `Refinamiento de interfaz`: detalle de transporte, payload, ruta, schema o error que puede vivir en interfaces, pero tiene anclaje claro en la ERS.
   - `Interfaz aprobada no propagada`: la interfaz fija una conducta o decisión que la ERS todavía no registra, conserva como pendiente o contradice.
   - `Pendiente coherente`: ambos artefactos mantienen explícitamente la misma incertidumbre.
   - `Conflicto`: ambos artefactos establecen obligaciones incompatibles.
   - `Retirado`: la interfaz retiró un ID o contrato y la ERS debe conservar la decisión histórica sin tratarlo como activo.
6. Revisa específicamente `OPEN-001` a `OPEN-010`. Para cada uno indica: estado actual en ERS, evidencia en interfaces, si se resolvió completamente, si solo se resolvió una parte, qué permanece abierto y qué actualización documental requiere.
7. Audita como mínimo:
   - `D-01` a `D-09` de arquitectura, convenciones e identidad/modelos;
   - APIs `E-01` a `E-18`, considerando que `E-10` fue retirado;
   - mensajes `M-01` a `M-08`, considerando que `M-05` y `M-06` fueron retirados;
   - semántica de `E-17`, disponibilidad, reevaluación, tombstones, resolución `E-16`, revisiones, copias, IDs y versiones;
   - autorización, `Idempotency-Key`, `If-Match`/ETag, errores, paginación, outbox y evolución de schemas;
   - toda afirmación que diga `propuesta`, `pendiente`, `OPEN-*`, `no se alteró la ERS` o `sin contrato`.
8. Comprueba enlaces locales y reporta referencias que apunten a otra edición de la ERS. Si ejecutas validadores, registra exactamente qué comprueban y qué no comprueban.

## Formato obligatorio del reporte

Escribe el reporte en español, con fecha y revisión de los artefactos, en este orden:

1. Veredicto ejecutivo: `Alineada`, `Alineación parcial` o `No alineada`, con una explicación breve.
2. Baseline y autoridad documental.
3. Inventario estructural.
4. Matriz de estado de `OPEN-001` a `OPEN-010`.
5. Matriz de cobertura por área de interfaz.
6. Hallazgos atómicos priorizados (`P0`, `P1`, `P2`, `P3`). Cada hallazgo debe incluir:
   - título;
   - clasificación;
   - evidencia exacta con ruta y línea;
   - impacto;
   - corrección documental mínima;
   - condición de cierre verificable.
7. Decisiones que la ERS debe registrar, cerrar, reclasificar o mantener abiertas.
8. Evidencia no ejecutada y límites de la revisión.
9. Recomendación final sin editar los artefactos fuente.

No uses frases como “todo está cubierto” si existen identificadores de interfaz o decisiones aprobadas sin trazabilidad a la ERS. No confundas una ausencia deliberada de contrato de otro microservicio con una omisión de Menu.
