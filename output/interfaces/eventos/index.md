[Índice general](../index.md)

# Mensajería desde la frontera de Menu

Todos los contratos siguientes tienen a Menu como emisor o receptor. Cada ficha especifica canal versionado, autorización, envelope y data completos, tratamiento y resultado esperado. Ninguno contrata un movimiento Orders–Inventory o un trabajo Orders–Cocina.

| ID | Dirección Menu | Canal |
| --- | --- | --- |
| [M-01](./salida/M-01.md) | salida | `menu.availability-definition.changed.v1` |
| [M-02](./salida/M-02.md) | salida | `menu.availability-definition.withdrawn.v1` |
| [M-03](./entrada/M-03.md) | entrada | `inventory.availability.evaluated.v1` |
| [M-04](./salida/M-04.md) | salida | `menu.availability.reevaluation-requested.v1` |
| [M-07](./salida/M-07.md) | salida | `menu.menu-item.changed.v1` |
| [M-08](./salida/M-08.md) | salida | `menu.menu-item.availability-changed.v1` |

[Coherencia y reconciliación de disponibilidad](./disponibilidad.md). [Resolución HTTP solicitada por Orders](../apis/entrada/E-16.md). Endpoints de salida HTTP: ninguno.

M-05 y M-06 fueron retirados: la resolución del flujo interactivo se solicita por E-16. Sus números no se reutilizan. [Guía de campos](../04-guia-de-campos.md).
