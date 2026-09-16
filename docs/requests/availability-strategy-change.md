# Modificación de requisitos

## Objetivo

Busca todas las consecuencias de las modificaciones: requisitos existentes afectados, modelo de dominio, modelo de datos/proyecciones, contratos con Inventory, interfaces, eventos y texto explicativo. Integra estas decisiones y sustituye cualquier diseño incompatible.

## REQ-MENU-013

No decir que algo está “prohibido” en Combo si simplemente ese concepto no pertenece al modelo de Combo. Es una diferencia importante entre una regla negativa y ausencia del concepto.

## Estrategia de disponibilidad granular

La estrategia de disponibilidad deberá modificarse para evitar bloquear una
`MenuItemVariant` o una `ComboConfiguration` completa únicamente porque una
personalización u opción secundaria no pueda satisfacerse con el inventario
actual.

La disponibilidad operacional deberá evaluarse y materializarse en la menor
unidad seleccionable relevante, propagándose hacia niveles superiores sólo
cuando la indisponibilidad impida construir cualquier configuración válida.

### MenuItemVariant

Para `MenuItem` de tipo `PREPARED` o `STOCKED`, la disponibilidad principal
deberá calcularse por `MenuItemVariant`, no únicamente por `MenuItem`.

Una variante será `AVAILABLE` mientras exista al menos una configuración válida
de la misma que pueda satisfacerse con el inventario actual.

La disponibilidad agregada de `MenuItem` será derivada:

- un `MenuItem` hoja estará disponible si al menos una de sus
  `MenuItemVariant` está disponible;
- esta disponibilidad agregada se utilizará para presentación de catálogo, no
  como fuente autoritativa para bloquear variantes individuales.

### Modificadores

La falta de inventario necesaria únicamente para una personalización opcional
no deberá volver indisponible a toda la variante.

La disponibilidad deberá calcularse por `ModifierOption` en el contexto de una
`MenuItemVariant`, utilizando su configuración efectiva
(`ResolvedVariantModifier`).

Cuando sea aplicable, deberá calcularse también la cantidad máxima actualmente
seleccionable de la opción en función del inventario:

```text
configuredMaxQuantity = 3
availableMaxQuantity  = 2
```

La UI podrá bloquear la opción o limitar su cantidad sin bloquear la
`MenuItemVariant`.

Si un `ModifierGroup` exige una cantidad mínima de selecciones y las opciones
actualmente disponibles ya no permiten satisfacer `minSelections`, entonces la
`MenuItemVariant` completa se vuelve no disponible.

Por tanto:

```text
modifier opcional sin disponibilidad
→ no bloquea la variante

grupo obligatorio sin capacidad suficiente
→ bloquea la variante
```

### Requerimientos de Inventory

La proyección utilizada para disponibilidad deberá separar los requerimientos
base de una variante de los requerimientos incrementales introducidos por sus
modificadores.

Para una variante `PREPARED`:

```text
BaseRequirements
→ ingredientes requeridos por la revisión de receta

ModifierRequirements
→ incrementos de Inventory producidos por cada ModifierOption
```

Para una variante `STOCKED`:

```text
BaseRequirements
→ InventoryItem + cantidad de retiro
```

No deberá utilizarse como regla general el máximo global obtenido suponiendo
todos los modificadores simultáneamente activos, ya que esto bloquearía
productos que todavía pueden venderse válidamente.

Los requerimientos deberán expresarse mediante referencias a artículos de
Inventory y cantidades normalizadas/aplanadas cuando corresponda.

### Combo

La disponibilidad de un `COMBO` deberá calcularse por
`ComboConfiguration`.

Cada `ComboOption` heredará o derivará su disponibilidad de la
`MenuItemVariant` hoja que referencia.

La indisponibilidad de una `ComboOption` individual no deberá bloquear la
configuración mientras el `ComboSlot` todavía pueda satisfacer sus restricciones
de selección con otras opciones disponibles.

Para cada `ComboSlot` deberá comprobarse que su capacidad disponible permita
satisfacer al menos `minSelections`.

Conceptualmente:

```text
ComboOption unavailable
        ↓
reevaluar ComboSlot
        ↓
si availableCapacity >= minSelections
    ComboConfiguration continúa AVAILABLE
else
    ComboConfiguration pasa a UNAVAILABLE
```

Una `ComboConfiguration` estará disponible únicamente cuando todos sus slots
obligatorios puedan satisfacerse.

La disponibilidad agregada del `MenuItem` COMBO será derivada de sus
configuraciones:

```text
Combo AVAILABLE
↔ existe al menos una ComboConfiguration AVAILABLE
```

### Modelo de disponibilidad

La disponibilidad no deberá tratarse como estado comercial autoritativo dentro
de `MenuItem`.

Deberá mantenerse como información operacional derivada de Inventory mediante
proyecciones o estados materializados equivalentes.

El modelo deberá poder representar como mínimo:

```text
VariantAvailability
- variantId
- available

ModifierAvailability
- variantId
- modifierOptionId
- available
- availableMaxQuantity

ComboConfigurationAvailability
- configurationId
- available
```

La disponibilidad de `ComboOption`, `ComboSlot` y `MenuItem` podrá derivarse de
estas proyecciones cuando no sea necesario materializarla explícitamente.

### Propagación

La estrategia general de propagación será:

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

La indisponibilidad sólo deberá propagarse hacia un nivel superior cuando la
restricción impida satisfacer una configuración válida de ese nivel.

### Cambio respecto al diseño anterior

Reemplazar cualquier requisito o decisión existente que determine la
disponibilidad de una variante calculando el inventario necesario para el peor
caso de todos sus modificadores opcionales.

La nueva regla es:

> Una unidad vendible permanece disponible mientras exista al menos una
> configuración válida que pueda satisfacerse con el inventario actual. Las
> opciones o personalizaciones no satisfacibles deberán bloquearse o limitarse
> individualmente, y la indisponibilidad se propagará al padre únicamente cuando
> ya no pueda construirse ninguna configuración válida.

Esta modificación afecta al cálculo y proyección de disponibilidad, pero no
cambia el ownership comercial de `MenuItem`, `MenuItemVariant`,
`ModifierGroup`, `ModifierOption`, `ComboConfiguration`, `ComboSlot` o
`ComboOption`, ni convierte la disponibilidad operacional en estado
administrativo o elegibilidad estructural.

```txt
La parte clave para modificar el documento existente es esa última distinción: **no necesitas rehacer el dominio comercial**. Cambias principalmente el **contrato/proyección de disponibilidad y sus reglas de propagación**.

También reemplazaría cualquier requisito anterior equivalente a «calcular el máximo incluyendo todos los modificadores para decidir disponibilidad», en vez de conservar ambos, porque las dos políticas producen comportamientos incompatibles.
```