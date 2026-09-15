# Requirements specification — Menu

**Revision:** 11 — 2026-09-15

This revision incorporates `Auditoria-4.md` as the active correction to the MenuItem, sellable presentation, modifier, combo, category and order-line model. It also standardizes the domain language, removes repetitive rationale fields, clarifies the functional requirements, adds an implementability review of all 55 functional requirements, and adds explanatory architecture/domain diagrams. Menu ownership is not transferred to Sala, Orders, Inventory, Billing or image providers; missing external projections remain open in OPEN-011 through OPEN-019. Acceptance criteria are not implementation test results.

| Category | Confirmed |
| --- | ---: |
| REQ | 55 |
| BR | 45 |
| DATA | 38 |
| INT | 29 |
| QA | 17 |
| CON | 15 |
| **Total** | **199** |

0 pending requirements; continuity retention is represented by QA-MENU-002 and CON-MENU-008; 21 historical decisions; 9 external UI contract topics open.

- [Scope and vocabulary](./01-scope-and-actors.md)
- [Functional requirements](./02-functional-requirements.md)
- [Business rules](./03-business-rules.md)
- [Data requirements](./04-data-requirements.md)
- [Integration obligations](./05-interfaces-integrations.md)
- [Quality requirements](./06-quality-requirements.md)
- [Architecture and design constraints](./07-constraints.md)
- [08. Superseded Decisions Log](./08-superseded-decisions.md)
- [Decision status](./09-conflicts-and-open-items.md)
- [Traceability matrix](./10-traceability-matrix.md)
- [Architecture and domain diagrams](./11-diagrams.md)

The confirmed consumer UI requirements use the `REQ-UI-*`, `BR-UI-*` and `DATA-UI-*` prefixes. Their visual descriptor is [the UI data specification](../ui-spec/ui-data-spec.md); it does not define navigation flow.

Sources and active decisions:

- [Problema-Inicial.md](../../docs/md/Problema-Inicial.md)
- [Modelo-Final.md](../../docs/md/Modelo-Final.md)
- [Auditoria-3.md](../../docs/md/Auditoria-3.md)
- [Consultoria-2.md](../../docs/md/Consultoria-2.md)
- [Consultoria-rendimiento.md](../../docs/md/Consultoria-rendimiento.md)
- [Decisiones-cierre-invariantes.md](../../docs/md/Decisiones-cierre-invariantes.md)
- [Auditoria-4.md](../../docs/md/Auditoria-4.md)
- Explicit UI decisions in the request dated 2026-09-13, consolidated in `output/ui-spec/ui-data-spec.md`

[Informe de cierre](../reviews/2026-09-12/closure-review.md)

Canonical English edition; [synchronized Spanish translation](../ers-es/index.md).

[ALIGN](../../docs/reviews/ers-interfaces-alignment/decisions.md)
