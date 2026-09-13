# Cierre documental de alineación ERS–interfaces

**Fecha:** 2026-09-13. **Resultado:** corrección documental implementada; verificaciones estructurales PASS. No constituye aceptación de implementación ni auditoría independiente.

**Verificación posterior:** la [auditoría de ejecución](./execution-audit.md) confirmó la interrupción por límite y su continuación, corrigió fichas administrativas e invariantes de estado y amplió la cobertura. El resultado actual de alineación es 278 checks PASS; los 228 de la tabla siguiente corresponden al cierre inicial.

El [reporte original](./report.md) se conserva como antecedente. La autoridad de corrección está en las [decisiones aprobadas](./decisions.md). ERS revisión 5: inglés canónico y español sincronizado. Interfaces v4 sobre contratos v1 aún en diseño.

## Resultado principal

E-16 devuelve un único objeto `pricing` por unidad de la variante vendible solicitada con `basePrice`, `extrasTotal`, `unitSubtotal` y `currency`. No devuelve términos monetarios por slot, componente ni modificador. Preparación e ingredientes permanecen separados. Menu calcula el subtotal; Orders aplica cantidad y reglas externas y conserva el resumen histórico.

Los combos tienen precio fijo manual, componentes STOCKED/PREPARED y extras por unidad personalizada. Los precios por slot son referencias administrativas; no cambian automáticamente el precio de venta. E-19/E-20/E-21 permiten consultar y atender avisos por variantes, preservando cambios concurrentes no observados. Reconocer un aviso no modifica versiones comerciales ni rehabilita opciones retiradas.

## Hallazgos del reporte original

| Hallazgo | Resultado documental | Evidencia |
| --- | --- | --- |
| F-001 | Corregido: inglés canónico y enlaces de autoridad; comparación estructural de ediciones | [Índice ERS](../../../output/ers/index.md), [traducción](../../../output/ers-es/index.md), [trazabilidad](../../../output/interfaces/trazabilidad.md) |
| F-002 | Corregido: OPEN-002 cerrado, E-17 trazado a REQ-MENU-016/026/027 e INT-MENU-005 | [OPEN](../../../output/ers/09-conflicts-and-open-items.md), [copias](../../../output/interfaces/apis/entrada/configuraciones.md) |
| F-003 | Corregido para frontera Menu: catálogo, invalidaciones, resolución y recuperación definidos; Orders orquesta Cocina | [Integraciones](../../../output/ers/05-interfaces-integrations.md), [flujo](../../diagrams/flujo-ordenar.md) |
| F-004 | Corregido: D-01…D-09 con autoridad y anclaje, D-04 actualizado al subtotal agregado | [Trazabilidad](../../../output/interfaces/trazabilidad.md), [decisiones](./decisions.md) |
| F-005 | Corregido: E-10/M-05/M-06 retirados, sin reutilización; E-16 activo | [Historial](../../../output/ers/08-superseded-decisions.md), [catálogo activo](../../../output/interfaces/contracts.json) |
| F-006 | Corregido: obligaciones INT-MENU-021/022/023 para tombstones, conflicto de contenido y recuperación | [Integraciones](../../../output/ers/05-interfaces-integrations.md) |
| F-007 | Corregido: DATA-MENU-013/024 y E-17 precisan referencias fijadas e identidades | [Datos](../../../output/ers/04-data-requirements.md), [modelos](../../../output/interfaces/03-tipos.md) |
| F-008 | Corregido: CON-MENU-013 outbox Menu separado de CON-MENU-011 Orders | [Restricciones](../../../output/ers/07-constraints.md) |
| F-009 | Corregido: convenciones aprobadas y estados OPEN propagados | [Convenciones](../../../output/interfaces/02-convenciones.md), [OPEN](../../../output/ers/09-conflicts-and-open-items.md) |
| F-010 | Corregido: evidencia estructural, revisión documental y pruebas de implementación separadas | [Verificación](../../../output/interfaces/verificacion.md), [aceptación futura](./acceptance.md) |

La comparación semántica fue realizada durante esta corrección: se sustituyeron también el vocabulario antiguo de opciones con recargo, el rechazo de retirada por dependencias y la exigencia de precios individuales de modificadores en el snapshot de Orders. La paridad automatizada verifica identificadores y estados, no demuestra por sí sola equivalencia lingüística.

## Estado de los OPEN

| OPEN | Estado final | Alcance |
| --- | --- | --- |
| 001 | Cerrado | Disponibilidad; protecciones de mensajes propagadas |
| 002 | Cerrado | Copias locales E-17, IDs, FAIL/REPLACE, simulación y atomicidad |
| 003 | Cerrado | Retención de historia; snapshot monetario agregado actualizado |
| 004 | Cerrado como criterio | Rendimiento no medido |
| 005 | Cerrado | Conteos y capacidad conservados; retiro afecta elegibilidad de opciones |
| 006 | Cerrado | Versiones fijadas y adopción explícita |
| 007 | Cerrado en Menu | Contratos Menu definidos; contrato externo Orders–Cocina y topología se integrarán fuera de este paquete |
| 008 | Cerrado | Ciclo de variantes y precio desde conservados |
| 009 | Cerrado | Base fija, extras por unidad y resumen monetario mínimo |
| 010 | Parcial | Políticas de negocio decididas; límites físicos, unidades, retención/dimensionamiento e integración de configuración monetaria pendientes |

## Evidencia ejecutada

| Comando | Resultado y alcance |
| --- | --- |
| `python output/interfaces/validate.py` | PASS: 20 endpoints, 6 mensajes, 53 schemas, 35 ejemplos asociados a schemas; enlaces y formato. PriceTerm se conserva como schema retirado que rechaza todo payload. |
| `python output/interfaces/validate_alignment.py` | PASS: 228 checks de schemas, negativos, aritmética de ejemplos, aislamiento de datos administrativos, inventario y paridad de IDs/estados. Incluye combo completo con dos unidades personalizadas y rechazo de filtración de precios en preparación. |
| `python output/review/validate.py` | PASS: 2 ediciones, 191 identificadores por edición, 161 obligaciones confirmadas; 9 OPEN cerrados y 1 parcial. |
| `node output/interfaces/render-diagrams.cjs` | PASS: 4 diagramas compilados y renderizados; el conceptual modificado fue inspeccionado visualmente. |

Resultados: [contratos](../../../output/interfaces/validation.json), [alineación estructural](../../../output/interfaces/alignment-validation.json), [ERS](../../../output/review/validation.json), [Mermaid](../../../output/interfaces/validation/mermaid.json).

No se ejecutaron servicios, autorización real, base de datos, outbox, broker, concurrencia real, UI, integración ni rendimiento. Los [23 escenarios de aceptación](./acceptance.md) especifican esas expectativas y no están marcados como pruebas de servicio ejecutadas.

## Entrega y límites

Se actualizaron directamente los contratos v1 por estar en diseño. No se implementó una capa de compatibilidad con consumidores antiguos. No se crearon commits ni se modificó el reporte original. El detalle técnico pendiente permanece explícito en OPEN-010; cerrar los hallazgos documentales no implica cerrar esos trabajos de integración.
