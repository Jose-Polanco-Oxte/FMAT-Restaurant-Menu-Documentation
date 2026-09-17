# Auditoría final de spec.md

## Objetivo

Realizar una auditoría final completa de `/docs/md/spec.md`.

Este run no tiene como objetivo ampliar ni rediseñar la especificación, sino confirmar que todas las modificaciones anteriores quedaron correctamente integradas y que el documento puede utilizarse como fuente consolidada de verdad.

## Revisar

Comprobar de forma transversal:

### Fuentes

- no existen referencias a fuentes históricas no autorizadas;
- las decisiones vigentes pueden justificarse mediante las fuentes permitidas o mediante decisiones explícitas de la revisión actual.

### Requisitos

- todos utilizan la nomenclatura:

  `REQ-MENU-{ABREVIACION_APARTADO}-{NNN}`;

- las numeraciones son consecutivas dentro de cada apartado;
- no existen IDs duplicados;
- no existen referencias a IDs antiguos;
- las referencias cruzadas apuntan a requisitos existentes.

### Modelo

- requisitos, invariantes y modelo de dominio son compatibles;
- el modelo de datos representa correctamente el dominio;
- ownership y límites entre bounded contexts son consistentes;
- no existen conceptos obsoletos provenientes de iteraciones anteriores.

### Disponibilidad

Confirmar que todo el documento utiliza la estrategia vigente:

- disponibilidad granular por unidad seleccionable;
- `MenuItemVariant` como nivel principal para hojas;
- disponibilidad individual o cantidad disponible de modificadores;
- propagación al padre sólo cuando ya no existe una configuración válida;
- `ComboOption` derivada de la variante referenciada;
- `ComboConfiguration` disponible sólo cuando sus slots pueden cumplir sus restricciones;
- disponibilidad agregada de `MenuItem` derivada;
- disponibilidad separada de elegibilidad y estado administrativo.

Buscar específicamente cualquier texto incompatible con esta estrategia.

### Diagramas

- los diagramas coinciden con el texto;
- relaciones y cardinalidades son correctas;
- Mermaid es válido;
- el diagrama de la sección 8.1 representa correctamente el modelo vigente.

### Interfaces y eventos

- utilizan entidades y estados existentes;
- no contradicen requisitos;
- las dependencias externas tienen ownership claro.

### Formato

- jerarquía de encabezados correcta;
- tablas válidas;
- expresiones de restricciones legibles;
- enlaces internos funcionales;
- ausencia de errores Markdown evidentes.

## Tratamiento de hallazgos

Corregir directamente únicamente problemas inequívocos, como:

- referencia rota;
- ID antiguo;
- error tipográfico;
- contradicción evidente causada por una versión anterior ya reemplazada;
- diagrama que no coincide con una definición explícita del mismo documento.

No tomar nuevas decisiones de arquitectura o dominio durante esta auditoría.

Si aparece un problema que requiere una decisión nueva, registrarlo como cuestión abierta y no inventar la solución en `/docs/reviews/spec-review.md`.

## Resultado esperado

Si la auditoría pasa, indicar explícitamente que no se detectaron inconsistencias bloqueantes.

Si existen problemas, entregar un resumen corto clasificado en:

- bloqueantes;
- inconsistencias menores;
- cuestiones abiertas.

El objetivo final es que `spec.md` quede internamente consistente y utilizable como fuente de verdad sin depender de documentos históricos para interpretar su significado.
