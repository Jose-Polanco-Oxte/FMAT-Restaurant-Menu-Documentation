[← Back to Index](./index.md)

# 08. Superseded Decisions Log

This module documents all architectural proposals, discarded alternatives, and earlier domain modeling decisions that were explicitly modified, corrected, or replaced during the multi-round review and expert audit process, in accordance with the temporal authority principle of ISO/IEC/IEEE 29148:2018.

---

<a id="superseded-001"></a>
### SUPERSEDED-001 — Generic Polymorphic Effect Contract

**Previous Decision:**
The system initially proposed a generic polymorphic `Effect` entity containing vague fields such as `target` (could refer to an ingredient, meat, order, or kitchen station) and a dynamic polymorphic `config` payload depending on an arbitrary `type`.

**Original Source:** `docs/md/Problema-Inicial.md` pp. 103–104
**Superseded By:** Explicit, typed `IngredientEffect` restricted strictly to inventory/recipe material consequences, paired with non-ingredient personalizations modeled as empty-effect `ModifierOption` instances.
**Superseding Source:** `docs/md/Problema-Inicial.md` pp. 104–106, 109–110; `docs/md/Modelo-Final.md` pp. 13–14
**Impact:** See [REQ-MENU-017](./02-functional-requirements.md#req-menu-017), [REQ-MENU-019](./02-functional-requirements.md#req-menu-019), [DATA-MENU-009](./04-data-requirements.md#data-menu-009).

---

<a id="superseded-002"></a>
### SUPERSEDED-002 — Separate PreparationInstruction Entity and Hierarchy

**Previous Decision:**
The domain model contemplated introducing a separate entity and hierarchy (`PreparationInstruction` and `PreparationInstructionGroup`) to represent culinary cooking instructions (e.g., "Well Done", "Dressing on the Side") parallel to modifiers.

**Original Source:** `docs/md/Problema-Inicial.md` pp. 103, 107–108
**Superseded By:** Collapsing all structured item customizations into `ModifierOption` instances carrying zero `IngredientEffect` records, while handling freeform diner notes as unstructured text on the order line (`OrderItem.specialInstructions`).
**Superseding Source:** `docs/md/Problema-Inicial.md` pp. 108–111
**Impact:** See [REQ-MENU-019](./02-functional-requirements.md#req-menu-019), [INT-MENU-007](./05-interfaces-integrations.md#int-menu-007).

---

<a id="superseded-003"></a>
### SUPERSEDED-003 — Fulfillment Configuration at MenuItem Level

**Previous Decision:**
The initial model placed fulfillment definitions (`StockedDefinition`, `PreparedDefinition`, `ComboDefinition`) directly on `MenuItem`, treating `MenuItemVariant` merely as a pricing and display tag.

**Original Source:** `docs/md/Problema-Inicial.md` pp. 111–115; `docs/md/Modelo-Final.md` pp. 1–5
**Superseded By:** Retaining PREPARED and STOCKED as leaf product types with concrete fulfillment configurations on `MenuItemVariant`, while representing COMBO as a composition of `ComboConfiguration`, `ComboSlot` and `ComboOption`.
**Superseding Source:** `docs/md/Auditoria-4.md`, items 1, 11 and 23–32
**Impact:** See [REQ-MENU-008](./02-functional-requirements.md#req-menu-008), [REQ-MENU-009](./02-functional-requirements.md#req-menu-009), [REQ-MENU-010](./02-functional-requirements.md#req-menu-010), [CON-MENU-014](./07-constraints.md#con-menu-014).

---

<a id="superseded-004"></a>
### SUPERSEDED-004 — Optional Variants with Conditional Branching

**Previous Decision:**
Products without multiple sizes were designed without variants (`variant == null`), requiring downstream code (checkout, KDS, inventory deduction) to branch using `if (item.hasVariants)`.

**Original Source:** `docs/md/Problema-Inicial.md` pp. 111–113
**Superseded By:** Universal adoption of the Default Variant pattern, mandating that every `MenuItem` contains at least one concrete `MenuItemVariant` (e.g., `DEFAULT`).
**Superseding Source:** `docs/md/Modelo-Final.md` pp. 7–8, 24–25; `docs/md/Auditoria-3.md` pp. 1–2
**Impact:** See [REQ-MENU-003](./02-functional-requirements.md#req-menu-003), [BR-MENU-001](./03-business-rules.md#br-menu-001), [CON-MENU-005](./07-constraints.md#con-menu-005).

---

<a id="superseded-005"></a>
### SUPERSEDED-005 — Anemic AllowedVariant and Complex Relational Combo Rules

**Previous Decision:**
The initial model utilized an anemic `AllowedVariant` entity (`variantId`) and proposed a complex relational configuration of size-mapping rules (`ComboSlotVariantRule`, `ComboOptionVariant`) to evaluate allowed combo components dynamically.

**Original Source:** `docs/md/Problema-Inicial.md` pp. 115–116, 120–121
**Superseded By:** Radical combo simplification: eliminating `AllowedVariant` and making `ComboOption` point directly to a concrete `MenuItemVariant` with explicit `quantity` and `priceDelta`.
**Superseding Source:** `docs/md/Modelo-Final.md` pp. 9–11, 28–31; `docs/md/Auditoria-3.md` pp. 2–4
**Impact:** See [REQ-MENU-012](./02-functional-requirements.md#req-menu-012), [BR-MENU-020](./03-business-rules.md#br-menu-020).

---

<a id="superseded-006"></a>
### SUPERSEDED-006 — Delta Pricing on Variants (basePrice + priceDelta)

**Previous Decision:**
Iteration 2 proposed calculating product prices as `MenuItem.basePrice + MenuItemVariant.priceDelta`.

**Original Source:** `docs/md/Problema-Inicial.md` pp. 127–128; `docs/md/Modelo-Final.md` pp. 16–17, 23
**Superseded By:** Establishing absolute `unitPrice` directly on `MenuItemVariant` and relegating `MenuItem.basePrice` to an informative non-authoritative projection ($\min(\text{variant.unitPrice})$).
**Superseding Source:** `docs/md/Modelo-Final.md` pp. 25–28, 38–40; `docs/md/Auditoria-3.md` pp. 2–4
**Impact:** See [REQ-MENU-006](./02-functional-requirements.md#req-menu-006), [REQ-MENU-007](./02-functional-requirements.md#req-menu-007), [CON-MENU-004](./07-constraints.md#con-menu-004).

---

<a id="superseded-007"></a>
### SUPERSEDED-007 — Modifiers Directly Owning Pricing and Effects

**Previous Decision:**
The model previously placed `priceDelta`, `maxQuantity`, and `IngredientEffect[]` directly within `ModifierOption`, implying that customization prices and quantities were identical across all variant presentations.

**Original Source:** `docs/md/Problema-Inicial.md` p. 106, 126; `docs/md/Modelo-Final.md` pp. 15–16, 36–37
**Superseded By:** Keeping the general/default `priceDelta`, `maxQuantity` and `IngredientEffect[]` on `ModifierOption.defaultConfig`, with optional `VariantModifierConfig` records only for variant-specific exceptions.
**Superseding Source:** `docs/md/Auditoria-4.md`, items 14–18
**Impact:** See [REQ-MENU-015](./02-functional-requirements.md#req-menu-015), [REQ-MENU-025](./02-functional-requirements.md#req-menu-025), [DATA-MENU-008](./04-data-requirements.md#data-menu-008), [DATA-MENU-029](./04-data-requirements.md#data-menu-029).

---

<a id="superseded-008"></a>
### SUPERSEDED-008 — VariantModifierOverride Fallback Pattern

**Previous Decision:**
An external consultant suggested an optional override entity (`VariantModifierOverride`) that would hold overrides only when a variant differed from default values in `ModifierOption`.

**Original Source:** `docs/md/Auditoria-3.md` p. 6
**Superseded By:** `VariantModifierConfig` is optional and stores only an exception. Publication resolves the exception over `ModifierOption.defaultConfig` into an effective per-variant projection.
**Superseding Source:** `docs/md/Auditoria-4.md`, items 16–22
**Impact:** See [CON-MENU-003](./07-constraints.md#con-menu-003), [REQ-MENU-040](./02-functional-requirements.md#req-menu-040) and [DATA-MENU-030](./04-data-requirements.md#data-menu-030).

---

<a id="superseded-009"></a>
### SUPERSEDED-009 — Mathematical Recipe Deductions (REMOVE / SET_QUANTITY)

**Previous Decision:**
Earlier iterations explored mathematical recipe alterations such as `REMOVE cebolla 10g` or `SET_QUANTITY queso 0g`.

**Original Source:** `docs/md/Problema-Inicial.md` p. 105; `docs/md/Modelo-Final.md` p. 14, 33–35
**Superseded By:** Realistic culinary directives: `ADD` (requiring explicit quantity and unit) and `OMIT` (exclusion directive without numeric quantity deduction). `REMOVE` and `SET_QUANTITY` were rejected.
**Superseding Source:** `docs/md/Modelo-Final.md` pp. 33–35; `docs/md/Auditoria-3.md` pp. 4–5
**Impact:** See [REQ-MENU-018](./02-functional-requirements.md#req-menu-018), [BR-MENU-022](./03-business-rules.md#br-menu-022).

---

<a id="superseded-010"></a>
### SUPERSEDED-010 — Linear Recipe Scaling Factor (scaleFactor)

**Previous Decision:**
The review briefly considered introducing a `scaleFactor` attribute in `PreparedVariantDefinition` to automatically scale recipe quantities linearly across sizes (e.g., 1.0x, 1.5x, 2.0x).

**Original Source:** `docs/md/Modelo-Final.md` p. 35; `docs/md/Auditoria-3.md` pp. 4–5
**Superseded By:** Deferral of linear scaling in favor of explicit `recipeId` references per variant, acknowledging that culinary recipes scale non-linearly (e.g., pizza dough scales by area $\pi r^2$, while sauce and cheese follow distinct ratios).
**Superseding Source:** `docs/md/Modelo-Final.md` pp. 35–36; `docs/md/Auditoria-3.md` p. 5
**Impact:** See [REQ-MENU-009](./02-functional-requirements.md#req-menu-009).

---


Proportional scaling is outside the current scope, not prohibited for future explicit needs; duplicating a shared recipe is not mandatory.

---

<a id="superseded-020"></a>
### SUPERSEDED-020 — Fixed-price combo options

**Previous Decision:**
The interface alignment package treated ComboOption as a fixed-price inclusion and prohibited an option price adjustment.

**Original Source:** `docs/reviews/ers-interfaces-alignment/decisions.md` and the prior v8 ERS/interface package.
**Superseded By:** Each ComboOption may carry a priceDelta. The combo subtotal still starts from ComboConfiguration.unitPrice and does not add component base prices.
**Superseding Source:** `docs/md/Auditoria-4.md`, items 26 and 31–32.
**Impact:** See [REQ-MENU-012](./02-functional-requirements.md#req-menu-012), [BR-MENU-016](./03-business-rules.md#br-menu-016) and [DATA-MENU-013](./04-data-requirements.md#data-menu-013).

---

<a id="superseded-021"></a>
### SUPERSEDED-021 — Combo modeled as MenuItemVariant

**Previous Decision:**
The active v8 model represented the sellable configurations of a combo as MenuItemVariant records with combo fulfillment.

**Original Source:** `docs/md/Modelo-Final.md` pp. 6–10 and the prior v8 ERS/interface package.
**Superseded By:** A combo owns one or more ComboConfiguration records with an absolute unitPrice and ComboSlot records; ItemVariant remains the shared sellable unit only for PREPARED and STOCKED leaf products.
**Superseding Source:** `docs/md/Auditoria-4.md`, items 1–2 and 23–32.
**Impact:** See [DATA-MENU-027](./04-data-requirements.md#data-menu-027), [DATA-MENU-028](./04-data-requirements.md#data-menu-028), [CON-MENU-014](./07-constraints.md#con-menu-014) and [INT-MENU-027](./05-interfaces-integrations.md#int-menu-027).
<a id="superseded-011"></a>
### SUPERSEDED-011 — Ambiguous MenuItem.availability Flag

**Previous Decision:**
A single boolean or enum attribute `MenuItem.availability` conflated administrative catalog activation with real-time operational inventory stock.

**Original Source:** `docs/md/Problema-Inicial.md` p. 111, 128–129
**Superseded By:** Decoupling into an administrative catalog flag `MenuItem.status` (`ACTIVE`/`INACTIVE`) and dynamically derived operational availability calculated per `MenuItemVariant` using inventory data.
**Superseding Source:** `docs/md/Problema-Inicial.md` pp. 128–129; `docs/md/Modelo-Final.md` pp. 18–19, 23
**Impact:** See [REQ-MENU-002](./02-functional-requirements.md#req-menu-002), [OPEN-001](./09-conflicts-and-open-items.md#open-001).

---

<a id="superseded-012"></a>
### SUPERSEDED-012 — In-Memory / Cross-Database Inventory Entities in Menu Domain

**Previous Decision:**
The initial Menu class diagram directly embedded `InventorySKU` and `InventoryIngredient` as internal entities with relational associations.

**Original Source:** `docs/md/Problema-Inicial.md` pp. 112, 114–115, 117
**Superseded By:** Removing all external inventory entities from the Menu bounded context, maintaining only an logical identifier `inventoryItemId`.
**Superseding Source:** `docs/md/Problema-Inicial.md` p. 117, 129–130; `docs/md/Modelo-Final.md` pp. 19–21, 37–38; `docs/md/Auditoria-3.md` pp. 2–3
**Impact:** See [INT-MENU-003](./05-interfaces-integrations.md#int-menu-003), [CON-MENU-001](./07-constraints.md#con-menu-001), [CON-MENU-006](./07-constraints.md#con-menu-006).

---

<a id="superseded-013"></a>
### SUPERSEDED-013 — Monolithic Menu Aggregate Root

**Previous Decision:**
The domain diagram initially suggested a single monolithic aggregate root where `Menu` encapsulated all items, variants, modifier groups, and recipes in one persistent boundary.

**Original Source:** `docs/md/Modelo-Final.md` pp. 21–22
**Superseded By:** Partitioning into three distinct Aggregate Roots: `Menu` (lightweight catalog group), `MenuItem` (commercial item root), and `Recipe` (culinary recipe root).
**Superseding Source:** `docs/md/Modelo-Final.md` pp. 21–23, 36–37; `docs/md/Auditoria-3.md` pp. 2–3
**Impact:** See [CON-MENU-002](./07-constraints.md#con-menu-002).

---

<a id="superseded-014"></a>

### SUPERSEDED-014 — Group capacity

**Previous decision:** COUNT(configured options) >= minimum.

**Original Source:** Revision 3, BR-MENU-012; Auditoria-3 p. 8.

**Superseded by:** SUM(enabled maxQuantity) >= minimum.

**Superseding Source:** [ADR-005](../../docs/md/Decisiones-cierre-invariantes.md#adr-005).

---

<a id="superseded-015"></a>

### SUPERSEDED-015 — Live catalog fulfillment

**Previous decision:** Retaining catalog references as operational dependency.

**Original Source:** Revision 3, QA-MENU-002; 2026-09-11.

**Superseded by:** Persisted net line snapshot for deduction and reversal.

**Superseding Source:** [ADR-003](../../docs/md/Decisiones-cierre-invariantes.md#adr-003).

---

<a id="superseded-016"></a>

### SUPERSEDED-016 — Unknown starting price eligibility

**Previous decision:** Minimum over all variants without eligibility semantics.

**Original Source:** Revision 3, REQ-MENU-007; 2026-09-11.

**Superseded by:** Minimum over currently eligible variants, absent if none.

**Superseding Source:** [ADR-008](../../docs/md/Decisiones-cierre-invariantes.md#adr-008).

---

<a id="superseded-017"></a>

### SUPERSEDED-017 — Missing performance targets

**Previous decision:** No adopted quantitative targets.

**Original Source:** Revision 3, QA-MENU-004; 2026-09-11.

**Superseded by:** ADR-004 initial project acceptance profile.

**Superseding Source:** [ADR-004](../../docs/md/Decisiones-cierre-invariantes.md#adr-004).


---

<a id="superseded-018"></a>
### SUPERSEDED-018 — Former resolution

**Previous Decision:** E-10 exposed a separate prevalidation operation; M-05/M-06 represented interactive message resolution.

**Superseded By:** E-09 validates edits; E-16 resolves interactive selections. E-10/M-05/M-06 remain retired without ID reuse.

**Source:** [ALIGN](../../docs/reviews/ers-interfaces-alignment/decisions.md); interface v3 is the historical antecedent.


---

<a id="superseded-019"></a>
### SUPERSEDED-019 — Former pricing and dependencies

**Previous Decision:** Option charges, detailed pricingInputs, delegated subtotal and dependent withdrawal blocking.

**Superseded By:** Fixed price, Menu unit summary, separate review and per-option eligibility.

**Source:** [ALIGN](../../docs/reviews/ers-interfaces-alignment/decisions.md); interfaces v3 como antecedente histórico.
