[Índice](./index.md)

# Trazabilidad aprobada

La [ERS canónica](../ers/index.md) prevalece sobre su traducción sincronizada. Fuentes de cambios: [decisiones](../../docs/reviews/ers-interfaces-alignment/decisions.md) y [Auditoria-4](../../docs/md/Auditoria-4.md).

| Decisión / contratos | Obligaciones ERS |
| --- | --- |
| D-01, E-16; E-10/M-05/M-06 retirados | INT-MENU-002, INT-MENU-020; SUPERSEDED-018 |
| D-02/D-03, frontera e identidad | CON-MENU-001, CON-MENU-012, DATA-MENU-024 |
| D-04 actualizado: subtotal, no cobro externo | BR-MENU-008, INT-MENU-004, INT-MENU-020 |
| D-05 autorización y convenciones aprobadas | CON-MENU-012 |
| D-06 validación aprobada | BR-MENU-041, BR-MENU-042 |
| D-07/D-08 identidades y versiones | DATA-MENU-013, DATA-MENU-024 |
| D-09 disponibilidad vigente con composición fijada | INT-MENU-010/011/019, BR-MENU-031 |
| E-01–E-03, M-07/M-08 | REQ-MENU-022, INT-MENU-001 |
| E-17 copias locales | INT-MENU-005, REQ-MENU-016/026/027 |
| E-18, M-01–M-04 | INT-MENU-008/009/010/011/019/021/022/023 |
| E-19/E-20/E-21 | REQ-MENU-035/036/037/038/039, DATA-MENU-025 |
| Auditoria-4, tipos de MenuItem y categorías | REQ-MENU-001/003, DATA-MENU-002/004/027/028, CON-MENU-014/015 |
| Auditoria-4, modificadores default/excepción/proyección | REQ-MENU-013/015/016/017/018/025/040, DATA-MENU-008/009/014/029/030, INT-MENU-026 |
| Auditoria-4, combos y precio | REQ-MENU-010/012/026/027, DATA-MENU-006/013/028, INT-MENU-004/019/020/027, BR-MENU-008/016/017 |
| Auditoria-4, resolución y líneas de Orders | REQ-MENU-040, DATA-MENU-031/032, INT-MENU-028/029, CON-MENU-005 |
| Outbox Menu / Orders | CON-MENU-013 / CON-MENU-011 |

D-01…D-09 son decisiones activas con autoridad del usuario; la forma HTTP/schema se mantiene en interfaces y sus obligaciones se trazan a ERS. E-10/M-05/M-06 permanecen retirados sin reutilización. OPEN-002, OPEN-007 y OPEN-009 cerrados; OPEN-010 parcial solo por acuerdos con Inventory. No hay contrato directo Menu–Cocina: Orders orquesta el envío.

## Cobertura por contrato activo

Dependencia administrativa externa confirmada: INT-MENU-024/025 exige a Inventory catálogo con ID, nombre, unidad y búsqueda. No se asigna una ruta de Inventory al catálogo de APIs de Menu ni se decide aún si la consume directamente el backoffice u otro componente. Límites físicos y conversiones dependen del contrato de Inventory. Las [propuestas de OPEN-010](../../docs/reviews/ers-interfaces-alignment/open-010-proposals.md) quedan aprobadas en su alternativa B y contrato monetario; CON-MENU-012 y las convenciones incorporan esa decisión.

Cada fila identifica un contrato activo y obligaciones existentes de la ERS canónica; los contratos retirados quedan fuera de este inventario.

| Contrato activo | Obligaciones |
| --- | --- |
| E-01 | INT-MENU-001 |
| E-02 | INT-MENU-001, REQ-MENU-007 |
| E-03 | INT-MENU-001, REQ-MENU-007, DATA-MENU-002/004/027/028 |
| E-04 | DATA-MENU-001, CON-MENU-012 |
| E-05 | DATA-MENU-001, CON-MENU-012 |
| E-06 | DATA-MENU-001, CON-MENU-012 |
| E-07 | REQ-MENU-001, REQ-MENU-005, BR-MENU-001/043, DATA-MENU-002/004/006/014/027/028/029 |
| E-08 | REQ-MENU-001, DATA-MENU-013 |
| E-09 | REQ-MENU-002, REQ-MENU-033, BR-MENU-031, BR-MENU-043 |
| E-11 | REQ-MENU-020 |
| E-12 | REQ-MENU-020 |
| E-13 | REQ-MENU-021 |
| E-14 | REQ-MENU-033, CON-MENU-008 |
| E-15 | REQ-MENU-021, CON-MENU-008 |
| E-16 | INT-MENU-020/027/028, BR-MENU-008/017, REQ-MENU-032/040, DATA-MENU-031 |
| E-17 | INT-MENU-005, REQ-MENU-016, REQ-MENU-026, REQ-MENU-027 |
| E-18 | INT-MENU-008, INT-MENU-023 |
| E-19 | REQ-MENU-036, DATA-MENU-025 |
| E-20 | REQ-MENU-036, REQ-MENU-039, DATA-MENU-026/028 |
| E-21 | REQ-MENU-037, REQ-MENU-038, DATA-MENU-025/028 |
| M-01 | INT-MENU-008, CON-MENU-013 |
| M-02 | INT-MENU-008, INT-MENU-021 |
| M-03 | INT-MENU-009, INT-MENU-010, INT-MENU-011, INT-MENU-022 |
| M-04 | INT-MENU-023 |
| M-07 | REQ-MENU-022, INT-MENU-001 |
| M-08 | REQ-MENU-022, INT-MENU-001 |
