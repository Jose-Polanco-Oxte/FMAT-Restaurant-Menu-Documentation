# Especificación de requisitos — Menu

**Revisión:** 11 — 2026-09-15

Esta revisión incorpora `Auditoria-4.md` como corrección activa del modelo de `MenuItem`, presentaciones vendibles, modificadores, combos, categorías y líneas de orden. También estandariza el lenguaje del dominio, elimina campos repetitivos de justificación, aclara los requisitos funcionales, revisa la implementabilidad de los 55 requisitos funcionales y agrega diagramas explicativos de arquitectura y dominio. La propiedad de Menu no se transfiere a Sala, Orders, Inventory, Billing ni a los proveedores de imágenes; las proyecciones externas faltantes permanecen abiertas en OPEN-011 a OPEN-019. Los criterios de aceptación no son resultados de pruebas de implementación.

| Categoría | Confirmados |
| --- | ---: |
| REQ | 55 |
| BR | 45 |
| DATA | 38 |
| INT | 29 |
| QA | 17 |
| CON | 15 |
| **Total** | **199** |

0 requisitos pendientes; la continuidad de retención está representada por QA-MENU-002 y CON-MENU-008; 21 decisiones históricas; 9 asuntos de contratos externos de UI abiertos.

- [Alcance y vocabulario](./01-scope-and-actors.md)
- [Requisitos funcionales](./02-functional-requirements.md)
- [Reglas de negocio](./03-business-rules.md)
- [Requisitos de datos](./04-data-requirements.md)
- [Obligaciones de integración](./05-interfaces-integrations.md)
- [Requisitos de calidad](./06-quality-requirements.md)
- [Restricciones de arquitectura y diseño](./07-constraints.md)
- [08. Registro de Decisiones Reemplazadas](./08-superseded-decisions.md)
- [Estado de decisiones](./09-conflicts-and-open-items.md)
- [Matriz de trazabilidad](./10-traceability-matrix.md)
- [Diagramas de arquitectura y del dominio](./11-diagrams.md)

Los requisitos confirmados de consumidor UI usan los prefijos `REQ-UI-*`, `BR-UI-*` y `DATA-UI-*`. Su descriptor visual es la [especificación de datos de UI](../ui-spec/ui-data-spec.md); no define el flujo de navegación.

Fuentes y decisiones vigentes:

- [Problema-Inicial.md](../../docs/md/Problema-Inicial.md)
- [Modelo-Final.md](../../docs/md/Modelo-Final.md)
- [Auditoria-3.md](../../docs/md/Auditoria-3.md)
- [Consultoria-2.md](../../docs/md/Consultoria-2.md)
- [Consultoria-rendimiento.md](../../docs/md/Consultoria-rendimiento.md)
- [Decisiones-cierre-invariantes.md](../../docs/md/Decisiones-cierre-invariantes.md)
- [Auditoria-4.md](../../docs/md/Auditoria-4.md)
- Decisiones explícitas de UI en la solicitud del 2026-09-13, consolidadas en `output/ui-spec/ui-data-spec.md`

[Informe de cierre](../reviews/2026-09-12/closure-review.md)

Traducción sincronizada de la [edición canónica inglesa](../ers/index.md).

[ALIGN](../../docs/reviews/ers-interfaces-alignment/decisions.md)
