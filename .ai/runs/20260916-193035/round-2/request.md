# Revisión de consistencia del modelo vigente

## Objetivo

Revisar `/docs/md/spec.md` después de haber aplicado las correcciones semánticas anteriores, especialmente la nueva estrategia de disponibilidad granular.

El objetivo de este run es asegurar que todo el modelo textual describa una única solución coherente.

## Tarea

Revisar de forma transversal:

- requisitos funcionales;
- reglas de negocio;
- invariantes;
- modelo de dominio;
- estados;
- modelo de datos;
- contratos;
- eventos;
- dependencias con otros servicios.

Buscar referencias o comportamientos que hayan quedado obsoletos después de las últimas decisiones.

Prestar especial atención a disponibilidad.

La estrategia vigente establece que:

- la disponibilidad operacional se determina principalmente por `MenuItemVariant` para items hoja;
- las personalizaciones opcionales pueden tener disponibilidad propia y no deben bloquear automáticamente la variante;
- `ModifierOption` puede tener disponibilidad y `availableMaxQuantity` en el contexto de una variante;
- una variante queda no disponible cuando ya no existe una configuración válida capaz de satisfacer sus restricciones obligatorias;
- `ComboOption` deriva su disponibilidad de la `MenuItemVariant` hoja referenciada;
- una `ComboConfiguration` permanece disponible mientras todos sus `ComboSlot` puedan satisfacer sus mínimos con las opciones actualmente disponibles;
- la disponibilidad agregada de `MenuItem` es derivada y no constituye la fuente autoritativa del estado operacional;
- disponibilidad, elegibilidad y estado administrativo son conceptos diferentes.

Eliminar o corregir cualquier definición anterior incompatible con esta estrategia.

También revisar que no exista duplicidad conceptual entre:

- estado administrativo;
- elegibilidad;
- disponibilidad;
- estado de revisión.

## Criterio

No rediseñar partes del sistema que ya sean consistentes.

No introducir nuevas capacidades ni patrones por iniciativa propia.

Cuando una inconsistencia pueda resolverse directamente a partir de las decisiones ya confirmadas, corregirla.

Cuando no pueda resolverse sin tomar una nueva decisión, registrarla como cuestión abierta.

## Restricciones de este run

No renombrar ni renumerar todavía los identificadores `REQ-*`.

No realizar cambios puramente cosméticos salvo que sean necesarios para corregir significado.

No rehacer todavía diagramas únicamente por estilo; sólo identificar inconsistencias que deberán corregirse en el siguiente run.

## Resultado

Modificar `/docs/md/spec.md` directamente.

