[← Volver al Índice](./index.md)

# 08. Registro de Decisiones Reemplazadas

Este módulo documenta todas las propuestas arquitectónicas, alternativas descartadas y decisiones tempranas de modelado de dominio que fueron explícitamente modificadas, corregidas o sustituidas durante el proceso de auditoría y revisión de expertos, conforme al principio de autoridad temporal de la norma ISO/IEC/IEEE 29148:2018.

---

<a id="superseded-001"></a>
### SUPERSEDED-001 — Contrato Polimórfico Genérico de Efectos

**Decisión Anterior:**
El sistema propuso inicialmente una entidad polimórfica genérica `Effect` con campos ambiguos como `target` (que podía apuntar a ingrediente, carne, comanda o cocina) y un payload `config` que dependía mágicamente de un atributo `type`.

**Origen Inicial:** `docs/md/Problema-Inicial.md` págs. 103–104
**Sustituida Por:** Una entidad explícita y tipada `IngredientEffect` restringida a impactos cuantitativos y cualitativos sobre inventario/recetas, combinada con el modelado de personalizaciones sin impacto de insumos como instancias de `ModifierOption` con lista vacía de efectos.
**Fuente Sustitutoria:** `docs/md/Problema-Inicial.md` págs. 104–106, 109–110; `docs/md/Modelo-Final.md` págs. 13–14
**Impacto:** Véanse [REQ-MENU-017](./02-functional-requirements.md#req-menu-017), [REQ-MENU-019](./02-functional-requirements.md#req-menu-019), [DATA-MENU-009](./04-data-requirements.md#data-menu-009).

---

<a id="superseded-002"></a>
### SUPERSEDED-002 — Jerarquía Separada para Instrucciones de Preparación

**Decisión Anterior:**
El modelo contempló introducir una jerarquía independiente (`PreparationInstruction` y `PreparationInstructionGroup`) para modelar directivas de cocina (ej. "Bien Cocida", "Salsa Aparte") de forma paralela a los modificadores de producto.

**Origen Inicial:** `docs/md/Problema-Inicial.md` págs. 103, 107–108
**Sustituida Por:** Unificar todas las personalizaciones estructuradas dentro de `ModifierOption` con lista vacía de `IngredientEffect`, delegando notas libres no configuradas al campo `OrderItem.specialInstructions` de la comanda.
**Fuente Sustitutoria:** `docs/md/Problema-Inicial.md` págs. 108–111
**Impacto:** Véanse [REQ-MENU-019](./02-functional-requirements.md#req-menu-019), [INT-MENU-007](./05-interfaces-integrations.md#int-menu-007).

---

<a id="superseded-003"></a>
### SUPERSEDED-003 — Configuración de Fulfillment al Nivel de MenuItem

**Decisión Anterior:**
El modelo original situó las definiciones de fulfillment (`StockedDefinition`, `PreparedDefinition`, `ComboDefinition`) directamente en `MenuItem`, relegando a `MenuItemVariant` a un rol puramente visual y de precios.

**Origen Inicial:** `docs/md/Problema-Inicial.md` págs. 111–115; `docs/md/Modelo-Final.md` págs. 1–5
**Sustituida Por:** Mantener PREPARED y STOCKED como tipos de producto hoja con configuraciones concretas en `MenuItemVariant`, y representar COMBO como composición de `ComboConfiguration`, `ComboSlot` y `ComboOption`.
**Fuente Sustitutoria:** `docs/md/Auditoria-4.md`, items 1, 11 y 23–32
**Impacto:** Véanse [REQ-MENU-008](./02-functional-requirements.md#req-menu-008), [REQ-MENU-009](./02-functional-requirements.md#req-menu-009), [REQ-MENU-010](./02-functional-requirements.md#req-menu-010), [CON-MENU-014](./07-constraints.md#con-menu-014).

---

<a id="superseded-004"></a>
### SUPERSEDED-004 — Variantes Opcionales y Bifurcación Condicional en Comandas

**Decisión Anterior:**
Los artículos sin múltiples tamaños se modelaron sin variantes (`variant == null`), obligando a los módulos de comanda, cocina y stock a evaluar condicionales del tipo `if (item.hasVariants)`.

**Origen Inicial:** `docs/md/Problema-Inicial.md` págs. 111–113
**Sustituida Por:** Adopción obligatoria del patrón de Variante por Defecto, exigiendo que todo `MenuItem` contenga al menos una `MenuItemVariant` concreta (ej. `DEFAULT`).
**Fuente Sustitutoria:** `docs/md/Modelo-Final.md` págs. 7–8, 24–25; `docs/md/Auditoria-3.md` págs. 1–2
**Impacto:** Véanse [REQ-MENU-003](./02-functional-requirements.md#req-menu-003), [BR-MENU-001](./03-business-rules.md#br-menu-001), [CON-MENU-005](./07-constraints.md#con-menu-005).

---

<a id="superseded-005"></a>
### SUPERSEDED-005 — Entidad Anémica AllowedVariant y Reglas Relacionales de Combos

**Decisión Anterior:**
El modelo temprano usó una entidad anémica `AllowedVariant` (`variantId`) y propuso complejas matrices relacionales de asignación de tamaño (`ComboSlotVariantRule`, `ComboOptionVariant`) para deducir componentes válidos en combos.

**Origen Inicial:** `docs/md/Problema-Inicial.md` págs. 115–116, 120–121
**Sustituida Por:** Simplificación radical: eliminar `AllowedVariant` y hacer que cada `ComboOption` apunte directamente a una `MenuItemVariant` vendible con cantidad y `priceDelta` explícitos.
**Fuente Sustitutoria:** `docs/md/Modelo-Final.md` págs. 9–11, 28–31; `docs/md/Auditoria-3.md` págs. 2–4
**Impacto:** Véanse [REQ-MENU-012](./02-functional-requirements.md#req-menu-012), [BR-MENU-020](./03-business-rules.md#br-menu-020).

---

<a id="superseded-006"></a>
### SUPERSEDED-006 — Precios por Delta en Variantes (basePrice + priceDelta)

**Decisión Anterior:**
La segunda iteración propuso calcular los precios de los productos sumando `MenuItem.basePrice + MenuItemVariant.priceDelta`.

**Origen Inicial:** `docs/md/Problema-Inicial.md` págs. 127–128; `docs/md/Modelo-Final.md` págs. 16–17, 23
**Sustituida Por:** Asignar un precio unitario absoluto (`unitPrice`) directamente a `MenuItemVariant`, relegando `MenuItem.basePrice` a una proyección informativa derivada ($\min(\text{variant.unitPrice})$).
**Fuente Sustitutoria:** `docs/md/Modelo-Final.md` págs. 25–28, 38–40; `docs/md/Auditoria-3.md` págs. 2–4
**Impacto:** Véanse [REQ-MENU-006](./02-functional-requirements.md#req-menu-006), [REQ-MENU-007](./02-functional-requirements.md#req-menu-007), [CON-MENU-004](./07-constraints.md#con-menu-004).

---

<a id="superseded-007"></a>
### SUPERSEDED-007 — Modificadores con Precios y Efectos Directos

**Decisión Anterior:**
El modelo ubicó inicialmente `priceDelta`, `maxQuantity` e `IngredientEffect[]` directamente en `ModifierOption`, asumiendo que el costo y consumo de insumos eran idénticos para todos los tamaños del ítem.

**Origen Inicial:** `docs/md/Problema-Inicial.md` pág. 106, 126; `docs/md/Modelo-Final.md` págs. 15–16, 36–37
**Sustituida Por:** Mantener el `priceDelta`, `maxQuantity` e `IngredientEffect[]` general/default en `ModifierOption.defaultConfig`, con registros `VariantModifierConfig` opcionales solo para excepciones de variante.
**Fuente Sustitutoria:** `docs/md/Auditoria-4.md`, items 14–18
**Impacto:** Véanse [REQ-MENU-015](./02-functional-requirements.md#req-menu-015), [REQ-MENU-025](./02-functional-requirements.md#req-menu-025), [DATA-MENU-008](./04-data-requirements.md#data-menu-008), [DATA-MENU-029](./04-data-requirements.md#data-menu-029).

---

<a id="superseded-008"></a>
### SUPERSEDED-008 — Patrón de Sobreescritura VariantModifierOverride

**Decisión Anterior:**
Un consultor externo propuso usar una entidad opcional `VariantModifierOverride` que actuaría solo cuando los valores de una variante difirieran de los valores por defecto almacenados en `ModifierOption`.

**Origen Inicial:** `docs/md/Auditoria-3.md` pág. 6
**Sustituida Por:** `VariantModifierConfig` es opcional y guarda solo una excepción. La publicación resuelve la excepción sobre `ModifierOption.defaultConfig` en una proyección efectiva por variante.
**Fuente Sustitutoria:** `docs/md/Auditoria-4.md`, items 16–22
**Impacto:** Véanse [CON-MENU-003](./07-constraints.md#con-menu-003), [REQ-MENU-040](./02-functional-requirements.md#req-menu-040) y [DATA-MENU-030](./04-data-requirements.md#data-menu-030).

---

<a id="superseded-009"></a>
### SUPERSEDED-009 — Deducción Aritmética en Recetas (REMOVE / SET_QUANTITY)

**Decisión Anterior:**
Las primeras discusiones consideraron operaciones de modificación matemática sobre recetas como `REMOVE cebolla 10g` o `SET_QUANTITY queso 0g`.

**Origen Inicial:** `docs/md/Problema-Inicial.md` pág. 105; `docs/md/Modelo-Final.md` pág. 14, 33–35
**Sustituida Por:** Operaciones culinarias directas: `ADD` (que requiere cantidad y unidad física) y `OMIT` (directiva de exclusión visual en cocina sin descuento matemático). `REMOVE` y `SET_QUANTITY` fueron descartadas.
**Fuente Sustitutoria:** `docs/md/Modelo-Final.md` págs. 33–35; `docs/md/Auditoria-3.md` págs. 4–5
**Impacto:** Véanse [REQ-MENU-018](./02-functional-requirements.md#req-menu-018), [BR-MENU-022](./03-business-rules.md#br-menu-022).

---

<a id="superseded-010"></a>
### SUPERSEDED-010 — Factor de Escalado Lineal en Recetas (scaleFactor)

**Decisión Anterior:**
Se evaluó incluir un atributo `scaleFactor` en `PreparedVariantDefinition` para escalar automáticamente los ingredientes de una receta por tamaño (ej. 1.0x, 1.5x, 2.0x).

**Origen Inicial:** `docs/md/Modelo-Final.md` pág. 35; `docs/md/Auditoria-3.md` págs. 4–5
**Sustituida Por:** Aplazamiento del escalado lineal en favor de referencias explícitas a `recipeId` independientes por variante, dado que los insumos culinarios no escalan de forma proporcional (ej. la masa de pizza escala por área $\pi r^2$, mientras que salsas y condimentos siguen proporciones no lineales).
**Fuente Sustitutoria:** `docs/md/Modelo-Final.md` págs. 35–36; `docs/md/Auditoria-3.md` pág. 5
**Impacto:** Véanse [REQ-MENU-009](./02-functional-requirements.md#req-menu-009).

---


El escalado proporcional queda fuera del alcance actual, no prohibido para futuras necesidades explícitas; tampoco se exige duplicar una receta compartida.
<a id="superseded-011"></a>
### SUPERSEDED-011 — Bandera Ambigua MenuItem.availability

**Decisión Anterior:**
Un atributo booleano o enum `MenuItem.availability` agrupaba de forma confusa la activación comercial en carta con la disponibilidad operativa real por existencias.

**Origen Inicial:** `docs/md/Problema-Inicial.md` pág. 111, 128–129
**Sustituida Por:** Desacoplamiento en un estado administrativo `MenuItem.status` (`ACTIVE`/`INACTIVE`) y una disponibilidad operativa proyectada dinámicamente por cada `MenuItemVariant` a partir de inventario.
**Fuente Sustitutoria:** `docs/md/Problema-Inicial.md` págs. 128–129; `docs/md/Modelo-Final.md` págs. 18–19, 23
**Impacto:** Véanse [REQ-MENU-002](./02-functional-requirements.md#req-menu-002), [OPEN-001](./09-conflicts-and-open-items.md#open-001).

---

<a id="superseded-012"></a>
### SUPERSEDED-012 — Entidades de Inventario Cross-Database en el Dominio de Menú

**Decisión Anterior:**
El diagrama de dominio de Menú incluía originalmente entidades como `InventorySKU` e `InventoryIngredient` como clases persistidas internamente.

**Origen Inicial:** `docs/md/Problema-Inicial.md` págs. 112, 114–115, 117
**Sustituida Por:** Retirar las entidades del esquema de Menú y mantener únicamente el identificador opaco en cadena `inventoryItemId`.
**Fuente Sustitutoria:** `docs/md/Problema-Inicial.md` pág. 117, 129–130; `docs/md/Modelo-Final.md` págs. 19–21, 37–38; `docs/md/Auditoria-3.md` págs. 2–3
**Impacto:** Véanse [INT-MENU-003](./05-interfaces-integrations.md#int-menu-003), [CON-MENU-001](./07-constraints.md#con-menu-001), [CON-MENU-006](./07-constraints.md#con-menu-006).

---

<a id="superseded-013"></a>
### SUPERSEDED-013 — Raíz de Agregado Monolítica Menu

**Decisión Anterior:**
El modelo conceptual inicial insinuaba que `Menu` encapsulaba todos los ítems, variantes, personalizaciones y recetas bajo un único límite transaccional.

**Origen Inicial:** `docs/md/Modelo-Final.md` págs. 21–22
**Sustituida Por:** Partición en tres Raíces de Agregado independientes: `Menu` (agrupador ligero), `MenuItem` (producto comercial y variantes) y `Recipe` (fórmulas culinarias).
**Fuente Sustitutoria:** `docs/md/Modelo-Final.md` págs. 21–23, 36–37; `docs/md/Auditoria-3.md` págs. 2–3
**Impacto:** Véanse [CON-MENU-002](./07-constraints.md#con-menu-002).

---

<a id="superseded-014"></a>

### SUPERSEDED-014 — Capacidad de grupo

**Decisión anterior:** COUNT(opciones configuradas) >= mínimo.

**Fuente original:** Revision 3, BR-MENU-012; Auditoria-3 p. 8.

**Sustituida por:** SUM(maxQuantity habilitados) >= mínimo.

**Fuente sustitutoria:** [ADR-005](../../docs/md/Decisiones-cierre-invariantes.md#adr-005).

---

<a id="superseded-015"></a>

### SUPERSEDED-015 — Suministro desde catálogo vigente

**Decisión anterior:** Retener referencias de catálogo como dependencia operativa.

**Fuente original:** Revision 3, QA-MENU-002; 2026-09-11.

**Sustituida por:** Snapshot neto persistido de línea para descuento y reversión.

**Fuente sustitutoria:** [ADR-003](../../docs/md/Decisiones-cierre-invariantes.md#adr-003).

---

<a id="superseded-016"></a>

### SUPERSEDED-016 — Elegibilidad de mínimo no definida

**Decisión anterior:** Mínimo de todas las variantes sin semántica de elegibilidad.

**Fuente original:** Revision 3, REQ-MENU-007; 2026-09-11.

**Sustituida por:** Mínimo de variantes elegibles actuales, ausente sin candidatas.

**Fuente sustitutoria:** [ADR-008](../../docs/md/Decisiones-cierre-invariantes.md#adr-008).

---

<a id="superseded-017"></a>

### SUPERSEDED-017 — Objetivos de rendimiento no definidos

**Decisión anterior:** Sin objetivos cuantitativos adoptados.

**Fuente original:** Revision 3, QA-MENU-004; 2026-09-11.

**Sustituida por:** Perfil inicial de aceptación del proyecto ADR-004.

**Fuente sustitutoria:** [ADR-004](../../docs/md/Decisiones-cierre-invariantes.md#adr-004).


---

<a id="superseded-018"></a>
### SUPERSEDED-018 — Resolución anterior

**Decisión anterior:** E-10 exponía una prevalidación separada; M-05/M-06 representaban resolución interactiva por mensajes.

**Sustituida por:** E-09 valida ediciones; E-16 resuelve selecciones interactivas. E-10/M-05/M-06 permanecen retirados sin reutilizar IDs.

**Fuente:** [ALIGN](../../docs/reviews/ers-interfaces-alignment/decisions.md); interfaces v3 como antecedente histórico.

---

<a id="superseded-020"></a>
### SUPERSEDED-020 — Opciones de combo con precio delta

**Decisión Anterior:**
El paquete de alineación de interfaces trataba ComboOption como inclusión de precio fijo y prohibía un ajuste de precio de opción.

**Sustituida Por:** Cada ComboOption puede llevar priceDelta. El subtotal comienza en ComboConfiguration.unitPrice y no agrega precios base de componentes.
**Fuente Sustitutoria:** `docs/md/Auditoria-4.md`, items 26 y 31–32.
**Impacto:** Véanse [REQ-MENU-012](./02-functional-requirements.md#req-menu-012), [BR-MENU-016](./03-business-rules.md#br-menu-016) y [DATA-MENU-013](./04-data-requirements.md#data-menu-013).

---

<a id="superseded-021"></a>
### SUPERSEDED-021 — Combo modelado como MenuItemVariant

**Decisión Anterior:**
El modelo activo v8 representaba las configuraciones vendibles de un combo como MenuItemVariant con fulfillment COMBO.

**Sustituida Por:** Un combo posee una o más ComboConfiguration con unitPrice absoluto y ComboSlot; MenuItemVariant sigue siendo la unidad vendible compartida solo por productos hoja PREPARED y STOCKED.
**Fuente Sustitutoria:** `docs/md/Auditoria-4.md`, items 1–2 y 23–32.
**Impacto:** Véanse [DATA-MENU-027](./04-data-requirements.md#data-menu-027), [DATA-MENU-028](./04-data-requirements.md#data-menu-028), [CON-MENU-014](./07-constraints.md#con-menu-014) e [INT-MENU-027](./05-interfaces-integrations.md#int-menu-027).


---

<a id="superseded-019"></a>
### SUPERSEDED-019 — Precios y dependencias anteriores

**Decisión anterior:** Ajustes por opción, pricingInputs detallado, cálculo delegado y bloqueo de retirada dependiente.

**Sustituida por:** Precio fijo, resumen unitario Menu, revisión separada y elegibilidad por opción.

**Fuente:** [ALIGN](../../docs/reviews/ers-interfaces-alignment/decisions.md); interfaces v3 como antecedente histórico.
