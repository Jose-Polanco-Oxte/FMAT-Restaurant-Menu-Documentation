[Índice](./index.md)

# Interacciones de Menu

## Actualizar definición y recibir disponibilidad

```mermaid
sequenceDiagram
  participant A as Backoffice
  participant M as Menu
  participant Q as Broker
  participant I as Inventory
  A->>M: E-09 Editar MenuItem
  M->>M: Validar y persistir revisión con outbox
  M-->>A: Definición y advertencias
  M->>Q: M-01 Necesidades planas
  Q->>I: Necesidades por clave opaca
  I-->>Q: M-03 Evaluación con vigencia
  Q-->>M: Evaluación recibida
  M->>M: Verificar revisión y caducidad
```

Sin evaluación positiva vigente la nueva definición no se ofrece como disponible. La operación administrativa no espera una llamada HTTP a Inventory.

## Resolución interactiva solicitada por Orders

```mermaid
sequenceDiagram
  participant C as Orders
  participant M as Menu
  C->>M: E-16 Resolver MenuItem
  M->>M: Comprobar versiones y selección
  M-->>C: Resolución o error de dominio
  Note over C,M: No reserva stock ni confirma una venta
```

Orders solicita esta resolución por HTTP. M-05/M-06 se retiran del catálogo de mensajes. La disponibilidad sigue siendo temporal. La habilitación administrativa se observa al resolver, sin promesa de atomicidad con una futura venta externa.

## Recuperar evaluaciones

```mermaid
sequenceDiagram
  participant M as Menu
  participant Q as Broker
  participant I as Inventory
  M->>M: Caducidad o caída detectada
  M->>M: Marcar no disponible
  M->>Q: M-04 Reevaluar claves
  Q->>I: Solicitud correlacionada
  opt Recuperar definiciones publicadas
    I->>M: E-18 Leer definiciones de disponibilidad
    M-->>I: Página consistente con revisiones
  end
  I->>Q: M-03 Evaluación nueva
  Q->>M: Evaluación con reevaluationRequestId
  M->>M: Aceptar solo si vigente y actual
```

Los mensajes usan líneas separadas y evitan punto y coma literal en etiquetas. [Mermaid documenta](https://mermaid.js.org/syntax/sequenceDiagram) que ese carácter separa instrucciones y requiere escape si se incluye en un texto. El fallo reportado provenía de esa ambigüedad.

El flujo completo entre UI, Orders, Menu, Inventory y Kitchen está separado en [diagrama conceptual de ordenar](../../docs/diagrams/flujo-ordenar.md).

La respuesta E-16 contiene un único resumen pricing de la referencia vendible: unitPrice, extrasTotal, unitSubtotal y currency. Para COMBO, unitPrice corresponde a ComboConfiguration y unitSubtotal incorpora priceDelta de opciones y modificadores, nunca precios base de componentes. Las unidades de preparación no contienen desglose monetario.

## Revisión administrativa

Cambio relevante de variante componente → combos dependientes REVIEW_REQUIRED → lectura E-19/E-20 → confirmación E-21 de tokens observados. Cambios posteriores permanecen pendientes. Confirmación sin edición no emite M-07.
