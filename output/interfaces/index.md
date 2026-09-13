# Interfaces del microservicio Menu

Contrato aprobado v4. Alcance exclusivo: **Menu**. Fuente: [ERS](../ers/index.md). El vocabulario de transporte es Menu, MenuItem, MenuItemVariant y Recipe. La propuesta anterior queda sustituida por esta revisión.

| Sección | Qué contiene |
| --- | --- |
| [Límites y decisiones](./01-arquitectura.md) | Responsabilidades y preferencia por mensajes |
| [Convenciones](./02-convenciones.md) | Autorización, errores, headers y compatibilidad |
| [Guía de campos](./04-guia-de-campos.md) | Intención, origen y uso de nombres menos evidentes |
| [Modelos](./03-tipos.md) | Esquemas JSON completos y reglas semánticas |
| [API de entrada](./apis/entrada/index.md) | Una ficha por endpoint de Menu: parámetros, body, autorización y respuesta |
| [API de salida](./apis/salida/index.md) | Justificación de ausencia de HTTP saliente y enlaces a mensajería |
| [Mensajes de entrada y salida](./eventos/index.md) | Solo canales donde Menu publica o consume |
| [Diagramas de interacción](./flujos.md) | Anclajes de Menu, sin diseñar operaciones ajenas |
| [Trazabilidad](./trazabilidad.md) | Cobertura y decisiones aprobadas |
| [Verificación](./verificacion.md) | Esquemas, ejemplos, enlaces y renderizado Mermaid |

Cada ficha HTTP incluye su endpoint completo versionado. Los esquemas por tipo en schemas son parte de los contratos. Orders obtiene resolución por E-16 con resumen monetario único por variante. Esta revisión actualiza ambas ERS y cierra OPEN-002/007/009; OPEN-010 conserva pendientes técnicos. No se incorporan contratos externos de movimientos ni envío directo Menu–Cocina.


Contexto separado: [flujo conceptual de ordenar](../../docs/diagrams/flujo-ordenar.md). E-10 y M-05/M-06 se retiraron conforme a la revisión discutida; se conservan los IDs restantes.

[Precio y revisión administrativa](./05-revision-combos.md)
