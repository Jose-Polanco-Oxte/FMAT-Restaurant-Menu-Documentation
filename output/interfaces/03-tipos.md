[Índice](./index.md)

# Modelos de Menu

Los contratos completos están divididos por tipo en JSON Schema. Todos los ejemplos HTTP se validan contra ellos. Las tablas resumen relaciones; no sustituyen los esquemas enlazados. required enumera obligatoriedad, anyOf con null indica nulo permitido; ningún campo se supone opcional por omisión del ejemplo.

| Modelo | Contrato |
| --- | --- |
| Menu / MenuWrite | [Lectura](./schemas/Menu.schema.json), [escritura](./schemas/MenuWrite.schema.json) |
| MenuItem | [Definición](./schemas/MenuItemDefinition.schema.json), [escritura](./schemas/MenuItemWrite.schema.json) |
| MenuItemVariant | [Variante hoja](./schemas/MenuItemVariant.schema.json), [suministro discriminado](./schemas/Fulfillment.schema.json) |
| Personalización | [Grupo](./schemas/ModifierGroup.schema.json), [configuración por variante](./schemas/ModifierConfig.schema.json), [configuración general](./schemas/ModifierDefaultConfig.schema.json), [proyección publicada](./schemas/ResolvedVariantModifier.schema.json), [efecto](./schemas/IngredientEffect.schema.json) |
| Combo | [Configuración](./schemas/ComboConfiguration.schema.json), [slot](./schemas/ComboSlot.schema.json), [opción](./schemas/ComboOption.schema.json) |
| Recipe | [Definición](./schemas/RecipeDefinition.schema.json), [escritura](./schemas/RecipeWrite.schema.json) |
| Medidas | [Importe](./schemas/Money.schema.json), [insumo](./schemas/Ingredient.schema.json) |
| Resolución | [Solicitud](./schemas/ResolutionRequest.schema.json), [respuesta](./schemas/Resolution.schema.json), [selección](./schemas/Selection.schema.json) |
| Preparación | [Unidad resuelta](./schemas/PreparationUnit.schema.json) |
| Disponibilidad | [Estado](./schemas/Availability.schema.json) |

## Identidad y revisiones

D-07: Backoffice propone IDs opacos para entidades anidadas en una escritura de MenuItem, nuevos y únicos dentro del restaurante. Menu genera las identidades de raíces Menu, MenuItem y Recipe. Reemplazos conservan IDs existentes; copias generan IDs nuevos. No hay mezcla ambigua entre clientKey e id. El esquema y las fichas usan la misma convención.

D-08: ComboOption referencia directamente un `itemVariantId` concreto de un `MenuItem` hoja. La opción además conserva `quantity` positiva y `priceDelta` relativo a la ComboConfiguration. RecipeRef siempre fija revisión exacta. No se infieren correspondencias de tamaño por nombre. La elegibilidad se consulta contra identidades actuales, sin reescribir referencias fijadas.

## Resolución de una unidad vendible

Menu recibe menuItemId en la ruta HTTP, menuItemVersion, y una referencia vendible: `variantId` para PREPARED/STOCKED o `configurationId` para COMBO, además de Selection. No recibe orderId, lineId, estado de comanda ni importe cobrado. requestId es correlación de resolución, no identidad de orden. Resuelve una unidad vendible; cantidad de líneas/orden pertenece al consumidor y no se impone aquí.

Selection contiene `modifiers` y `components`. Cada configId aparece una vez por ámbito con quantity entero entre 0 y maxQuantity; SUM cantidades cumple min/max del grupo y solo configuraciones habilitadas. Cada optionId aparece una vez por slot. `units` se usa para personalizar individualmente las unidades indicadas por `ComboOption.quantity`; el slot cuenta elecciones de opciones, no unidades físicas. El MenuItem COMBO no posee ModifierGroups ni modifica ingredientes de hijos: los modificadores pertenecen al MenuItem hoja seleccionado. Sin combo, components está vacío.

Menu comprueba variantes/componentes ACTIVE y disponibilidad vigente de las opciones seleccionadas para su `quantity`. Una definición histórica sin correspondencia vigente devuelve NOT_ELIGIBLE. D-09 exige verificar semáforo actual conservando composición fijada; no es reserva ni garantía de stock del contenido histórico. El descuento real posterior no está contratado por Menu.

OMIT elimina aportación base por ámbito antes de ADD multiplicado por selección. Resolver cada unidad componente, luego agrupar por inventoryItemId y unit. No sumar unidades incompatibles, no producir neto negativo. Cero neto se omite. STOCKED usa insumo directo, PREPARED receta fijada, COMBO hijos no COMBO. Preparación enumera ámbitos root o slotId/optionId/unitIndex, receta base y efectos seleccionados. Texto libre de cliente pertenece al consumidor, Menu no lo necesita para resolver ni lo convierte en efectos.

E-16 devuelve pricing: `unitPrice`, `extrasTotal`, `unitSubtotal` y `currency` de una unidad de la referencia solicitada. En COMBO, `unitPrice` es el precio absoluto de ComboConfiguration y `unitSubtotal` incluye los `priceDelta` de sus ComboOption y modificadores de MenuItem hoja; nunca se agregan precios base de componentes. Orders conserva el resumen y orquesta Cocina. Véase [precio y revisión](./05-revision-combos.md).

Reglas intercampo (pertenencia, unicidad por ID, min<=max, cardinalidad units, positividad física, cumplimiento de selección y elegibilidad) se verifican semánticamente, además del esquema. El JSON Schema no prueba por sí solo estas invariantes.
