# Revisión de diagramas de spec.md

## Objetivo

Revisar todos los diagramas de `/docs/md/spec.md` una vez consolidado el modelo textual.

Los diagramas deben ser una representación del modelo vigente, no una fuente independiente de decisiones.

## Tarea

Revisar todos los diagramas Mermaid del documento y compararlos contra:

- modelo de dominio;
- invariantes;
- relaciones;
- cardinalidades;
- estados;
- ownership;
- disponibilidad;
- integraciones externas.

Prestar especial atención al diagrama de la sección 8.1, ya que actualmente contiene errores.

Corregir:

- entidades inexistentes o desactualizadas;
- relaciones incorrectas;
- cardinalidades incorrectas;
- ownership incorrecto;
- atributos que ya no formen parte del modelo;
- relaciones de disponibilidad que contradigan la estrategia vigente;
- conceptos pertenecientes a versiones anteriores del diseño;
- referencias directas entre bounded contexts que no correspondan al modelo actual.

La estrategia vigente de disponibilidad debe verse reflejada cuando corresponda:

```text
Inventory
    ↓
MenuItemVariant availability
    ↓
Modifier availability / availableMaxQuantity
    ↓
ComboOption availability
    ↓
ComboSlot available capacity
    ↓
ComboConfiguration availability
    ↓
MenuItem aggregate availability
```

Esto no implica que necesariamente toda esta cadena deba aparecer en un único diagrama. Representarla sólo donde aporte información relevante.

## Criterio

Primero utilizar el texto consolidado de spec.md como fuente de verdad.

Si un diagrama contradice el texto, corregir el diagrama.

Si durante la revisión se descubre que el texto y el modelo siguen siendo ambiguos, no inventar una solución: registrar el problema.

Evitar diagramas excesivamente grandes si pueden dividirse en representaciones más claras.

## Restricciones de este run

No renumerar todavía los requisitos.

No cambiar decisiones de dominio únicamente para hacer más sencillo un diagrama.

No introducir nuevos componentes arquitectónicos.

## Resultado

Actualizar directamente los diagramas de /docs/md/spec.md.

Comprobar después de cada modificación que el Mermaid sea sintácticamente válido.
