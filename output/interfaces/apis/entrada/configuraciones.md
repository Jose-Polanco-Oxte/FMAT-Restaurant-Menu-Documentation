[Entradas](./index.md)

# Semántica de E-17

Contrato aprobado para OPEN-002, limitada al agregado MenuItem de la ruta. Se revalida If-Match antes de aplicar. Origen y destinos distintos, sin IDs repetidos y del mismo MenuItem. Arreglos de objetivos/elementos seleccionados no vacíos. No se corresponden slots por nombre.

COPY_MODIFIERS: copiar excepciones seleccionadas a cada MenuItemVariant hoja destino. Conserva modifierOptionId del grupo propio; copia enabled, priceDelta, máximo y ingredientEffects. FAIL rechaza si existe el par variante-opción. REPLACE reemplaza contenido de la excepción destino conservando su identidad. Nuevas configuraciones reciben ID de Menu.

COPY_COMBO_SLOTS: origen y destinos ComboConfiguration del mismo COMBO. Crear nuevas identidades de slots/opciones. FAIL exige destinos sin slots; REPLACE sustituye todos los slots destino por los seleccionados del origen. Versiones anteriores permanecen en historia.

ASSIGN_COMBO_OPTIONS: targets identifica configurationId y slotId exactos. FAIL exige slots vacíos; REPLACE sustituye todas sus opciones. optionId recibido identifica la plantilla de entrada, Menu crea identidades distintas por destino y devuelve mappings. Cada ComboOption referencia un itemVariantId hoja y conserva quantity positiva y priceDelta; dos opciones distintas pueden señalar la misma variante.

dryRun=true devuelve 200 applied=false y violations si no es aplicable. dryRun=false con infracción devuelve 422 y ninguna escritura; éxito 200 applied=true, mappings y una sola revisión efectiva. Simular y aplicar son peticiones diferentes y usan claves idempotentes distintas. Ante revisión concurrente aplicar falla con 412. No se permiten efectos parciales en varias variantes.

Un cuerpo válido con dryRun=true no consume ni asigna IDs definitivos. El nombre de cada opción copiada se conserva desde su definición; no se comparten entidades entre agregados.

La selección base administrativa se remapea al copiar slots y se invalida al sustituir opciones. Véase [regla completa](../../05-revision-combos.md).
