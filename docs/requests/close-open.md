# Cerrar decisiones abiertas

## Objetivo

El objetivo de este documento es cerrar decisiones abiertas sobre el modelo, la API y el comportamiento de los combos, que no se han resuelto en la documentación de diseño original. Se debe propagar las decisiones y transformarlas en requisitos, contratos, invariantes y reglas de negocio que puedan ser implementadas y verificadas.

## Tarea

Modificar `/output/ers/spec.md` para reflejar las decisiones tomadas en este documento.

### Emparejamiento de slots y atomicidad de copia masiva (OPEN-002)

Las operaciones de copia entre `ComboConfiguration` no realizarán
emparejamiento automático de `ComboSlot` por nombre, posición u otra
heurística.

El nombre y el orden de un `ComboSlot` son propiedades descriptivas y no
constituyen su identidad.

Cuando se clone una configuración completa, sus slots se copiarán como nuevos
`ComboSlot` con nuevas identidades, conservando su estructura y orden.

Cuando se aplique una copia sobre una `ComboConfiguration` existente, el
mapeo entre slots origen y destino deberá proporcionarse explícitamente como
`sourceSlotId -> targetSlotId`. La creación de un nuevo slot destino también
deberá indicarse explícitamente.

Las políticas de conflicto `FAIL` y `REPLACE` se evaluarán dentro de cada
configuración destino.

Cada `ComboConfiguration` destino será una unidad atómica: una operación sobre
ella se aplicará completamente o no producirá cambios.

Un lote con múltiples configuraciones podrá producir éxito parcial entre
destinos independientes. Un fallo en un destino no revertirá modificaciones
ya confirmadas sobre otros destinos.

La operación deberá informar el resultado individual de cada destino y permitir
reintentos idempotentes.

Con esta decisión no se requiere una estrategia de rollback parcial por slot ni
un algoritmo de matching semántico.

### Porciones de componentes y modifiers repetidos en combos (OPEN-009)

`ComboOption.quantity` representará el número físico de unidades completas del
componente seleccionado y deberá ser un entero positivo.

El modelo de Combo no aplicará coeficientes fraccionarios de cantidad o precio
sobre una `MenuItemVariant`.

Cuando el negocio requiera una presentación fraccionada comercialmente
diferenciada, como media porción de un producto, ésta deberá representarse como
una unidad hoja concreta que pueda ser referenciada directamente por
`ComboOption`.

De esta forma, su composición, consumo de Inventory y comportamiento comercial
se mantienen definidos por la unidad hoja y no mediante inferencia dentro del
Combo.

Los modifiers seleccionados sobre componentes de un Combo se calcularán
independientemente por cada instancia del componente al que pertenecen.

La repetición de una misma `ModifierOption` en componentes distintos no
producirá deduplicación, bonificación ni agregación especial de precio.

Cada selección aplicará su `priceDelta` conforme a su cantidad efectiva.

Por tanto:

precio final =
`ComboConfiguration.unitPrice`

+ suma de `ComboOption.priceDelta`
+ suma de los ajustes de los modifiers efectivamente seleccionados en cada
componente.

Los precios normales `MenuItemVariant.unitPrice` de los componentes no se
sumarán al precio del Combo.

Cualquier descuento o bonificación entre modifiers repetidos deberá modelarse
como una regla comercial explícita distinta y no como comportamiento implícito
de la composición del Combo.

### Otros

Tomar una decisión sobre las decisiones habiertas con base a que es mejor para el negocio y la experiencia del usuario, y cerrar el resto de decisiones abiertas en la documentación de diseño original.
