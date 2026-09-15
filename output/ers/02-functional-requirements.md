[← Index](./index.md)

# Functional requirements

Each block states one primary obligation. Enumerated attributes describe one fact or operation, not independent steps. Verification entries are proposed acceptance criteria, not executed software tests. Model names identify domain concepts, not required technologies. `Auditoria-4.md` is the active source for the corrected `MenuItem`, modifier, combo and order-line model.

---

<a id="req-menu-001"></a>
### REQ-MENU-001 — Commercial MenuItem definition

**Requirement:**
The Menu service shall create a `MenuItem` with its name, description, image reference, owning `Menu`, a `MenuItem` type (`PREPARED`, `STOCKED`, or `COMBO`), and an initial administrative status (`ACTIVE` or `INACTIVE`).

**Type:** Functional

**Source:** `docs/md/Modelo-Final.md` pp. 36–37


**Verification:** Demonstration: Record a `MenuItem` with each permitted type and initial status and compare the recorded information with the submitted definition.

**Status:** Confirmed

<a id="req-menu-002"></a>
### REQ-MENU-002 — Administrative status

**Requirement:**
The Menu service shall allow changing the administrative status of a `MenuItem` between `ACTIVE` and `INACTIVE`.

**Type:** Functional

**Source:** `docs/md/Modelo-Final.md` pp. 18–19


**Verification:** Test: Exercise both status transitions and inspect the resulting status.

**Status:** Confirmed

---

<a id="req-menu-003"></a>
### REQ-MENU-003 — Sellable leaf presentation

**Requirement:**
The Menu service shall provide at least one concrete sellable `MenuItemVariant` for every leaf `MenuItem` whose type is `PREPARED` or `STOCKED`.

**Type:** Functional

**Source:** `docs/md/Modelo-Final.md` pp. 7–8


**Verification:** Test: Define a PREPARED or STOCKED `MenuItem` and verify that it has at least one concrete sellable presentation, including when no presentation choice is shown to the customer.

**Status:** Confirmed

---

<a id="req-menu-004"></a>
### REQ-MENU-004 — Dimension variant definition

**Requirement:**
The Menu service shall allow defining a named dimension variant for a leaf `MenuItem`.

**Type:** Functional

**Source:** `docs/md/Modelo-Final.md` pp. 21, 36–37


**Verification:** Demonstration: Define a characteristic such as size, verify its name and verify that it belongs to the selected leaf `MenuItem`.

**Status:** Confirmed

**Related:** REQ-MENU-024

---

<a id="req-menu-005"></a>
### REQ-MENU-005 — Sellable presentation definition

**Requirement:**
The Menu service shall allow defining a sellable `MenuItemVariant` by associating dimension variants values belonging to its leaf `MenuItem`, with at most one value per characteristic and without repeating the same combination, subject to BR-MENU-002 through BR-MENU-004.

**Type:** Functional

**Source:** `docs/md/Modelo-Final.md` pp. 21


**Verification:** Test: Register a valid presentation and attempt two values for one characteristic, a value from another `MenuItem`, and a duplicate presentation.

**Status:** Confirmed

---

<a id="req-menu-006"></a>
### REQ-MENU-006 — Absolute variant price

**Requirement:**
The Menu service shall allow assigning an absolute selling price to each sellable `MenuItemVariant`.

**Type:** Functional

**Source:** `docs/md/Modelo-Final.md` pp. 26–28


**Verification:** Test: Assign different prices to two variants and verify each assigned price independently.

**Status:** Confirmed

---

<a id="req-menu-007"></a>
### REQ-MENU-007 — Catalog price display

**Requirement:**
The Menu service shall display a catalog price from the eligible sellable units of a `MenuItem`: for a leaf item, use its eligible `MenuItemVariant.unitPrice`; for a combo, use its eligible `ComboConfiguration.unitPrice`. It shall show `Desde $X` when those eligible units have different prices, show `$X` when they all have the same price, and show no numeric price when none is eligible.

**Type:** Functional

**Source:** [ADR-008 — Eligibility, catalog price and default presentation](../../docs/md/Decisiones-cierre-invariantes.md#adr-008), together with `docs/md/Auditoria-4.md`, items 8–10 and 23–32.


**Verification:** Show a catalog item with two eligible sellable units at different prices, then with equal prices, then with no eligible units; verify `Desde $X`, `$X`, and no numeric price respectively.

**Status:** Confirmed

---

---

<a id="req-menu-008"></a>
### REQ-MENU-008 — Stocked fulfillment configuration

**Requirement:**
The Menu service shall allow specifying, for each STOCKED `MenuItemVariant`, the Inventory item, withdrawal quantity, and measurement unit that fulfill it.

**Type:** Functional

**Source:** `docs/md/Modelo-Final.md` pp. 8–9, 37


**Verification:** Test: Configure different inventory references and quantities for two presentations and verify their independent retrieval.

**Status:** Confirmed

---

<a id="req-menu-009"></a>
### REQ-MENU-009 — Prepared presentation recipe

**Requirement:**
The Menu service shall allow associating each PREPARED `MenuItemVariant` with a concrete recipe revision containing the ingredients, quantities and units used to prepare that presentation.

**Type:** Functional

**Source:** `docs/md/Modelo-Final.md` pp. 8–9, 35–37; `docs/md/Auditoria-4.md`, items 11–13


**Verification:** Test: Define two PREPARED presentations, associate each with a recipe revision, and verify that each presentation exposes the corresponding ingredient list. The same recipe revision may be used when both presentations use the same ingredients and quantities.

**Status:** Confirmed

---

<a id="req-menu-010"></a>
### REQ-MENU-010 — Combo configuration

**Requirement:**
The Menu service shall allow defining one or more `ComboConfiguration` records for a COMBO `MenuItem`, each with a name, absolute unit price, and one or more `ComboSlot` selection slots.

**Type:** Functional

**Source:** `docs/md/Modelo-Final.md` pp. 9–10, 37


**Verification:** Demonstration: Define distinct slot configurations for two ComboConfiguration records and verify each configuration.

**Status:** Confirmed

---

<a id="req-menu-011"></a>
### REQ-MENU-011 — Combo slot definition

**Requirement:**
The Menu service shall allow configuring each `ComboSlot` with a name and integer `minSelections` and `maxSelections` limits for the options a customer may select, satisfying `0 <= minSelections <= maxSelections` under BR-MENU-024.

**Type:** Functional

**Source:** `docs/md/Modelo-Final.md` pp. 10


**Verification:** Demonstration: Configure a named slot, choose its minimum and maximum number of options, and verify that both limits are shown in the combo configuration.

**Status:** Confirmed

---

<a id="req-menu-012"></a>
### REQ-MENU-012 — Combo option definition

**Requirement:**
The Menu service shall allow adding to a combo slot an option that points to a concrete leaf `MenuItemVariant`, records a positive included quantity, and records an explicit `priceDelta`.

**Type:** Functional

**Source:** `docs/md/Auditoria-4.md`, items 23–32; supersedes the fixed-price option interpretation in the previous alignment package.


**Verification:** Test: Configure options with different included quantities and `priceDelta` values; verify that changing quantity alone does not change `ComboConfiguration.unitPrice`, while the combo subtotal changes only through the configured option deltas and selected leaf modifiers, never through component `unitPrice`.

**Status:** Confirmed

---

<a id="req-menu-013"></a>
### REQ-MENU-013 — Modifier group definition

**Requirement:**
The Menu service shall allow defining a named `ModifierGroup` directly on a PREPARED or STOCKED `MenuItem`, with integer `minSelections` and `maxSelections` limits for selected units in the group, satisfying `0 <= minSelections <= maxSelections` under BR-MENU-024. The group is shared by the item's leaf variants and is not attached to a COMBO.

**Type:** Functional

**Source:** `docs/md/Modelo-Final.md` pp. 12–13, 48; `docs/md/Auditoria-4.md`, items 14–20


**Verification:** Demonstration: Define a `ModifierGroup` on a PREPARED or STOCKED `MenuItem`, verify the owning item and name, and verify its `minSelections` and `maxSelections` limits.

**Status:** Confirmed

---

<a id="req-menu-014"></a>
### REQ-MENU-014 — Modifier option definition

**Requirement:**
The Menu service shall allow defining a named `ModifierOption` inside a `ModifierGroup` owned by the same PREPARED or STOCKED `MenuItem`, with a general `defaultConfig` used by that item's variants.

**Type:** Functional

**Source:** `docs/md/Modelo-Final.md` pp. 42–44; `docs/md/Auditoria-4.md`, items 14–18


**Verification:** Demonstration: Define a `ModifierOption` on a leaf `MenuItem`, verify its name and owning `ModifierGroup`, and verify that the option has `defaultConfig`.

**Status:** Confirmed

---

<a id="req-menu-015"></a>
### REQ-MENU-015 — Variant modifier price

**Requirement:**
The Menu service shall allow configuring the `priceDelta` of `ModifierOption.defaultConfig` and, when a presentation's effective behavior differs from the general behavior, a `VariantModifierConfig` for that leaf `MenuItemVariant` with the specific adjustment.

**Type:** Functional

**Source:** `docs/md/Auditoria-4.md`, items 14–18


**Verification:** Test: Define a general option price adjustment, add an exception for one leaf presentation, and verify that presentations without an exception use the general value while the exceptional presentation uses its own value.

**Status:** Confirmed

**Related:** REQ-MENU-025

---

<a id="req-menu-016"></a>
### REQ-MENU-016 — Copy modifier configurations

**Requirement:**
The Menu service shall allow copying, through E-17, selected customization exceptions—including price adjustments, quantity limits, and ingredient effects—from a source leaf `MenuItemVariant` to one or more target leaf variants of the same `MenuItem`, applying the requested `FAIL` or `REPLACE` policy.

**Type:** Functional

**Source:** `docs/md/Modelo-Final.md` pp. 45–46


**Verification:** Test: Run E-17 in `dryRun` and application mode, compare copied parameters with the source, and verify that a `FAIL` conflict leaves no partial effects.

**Status:** Confirmed

**Related:** REQ-MENU-026

**Active contract:** [E-17](../interfaces/apis/entrada/E-17.md); [ALIGN](../../docs/reviews/ers-interfaces-alignment/decisions.md)

---

<a id="req-menu-017"></a>
### REQ-MENU-017 — Ingredient addition directive

**Requirement:**
The Menu service shall allow configuring an ingredient addition in `ModifierOption.defaultConfig` or `VariantModifierConfig`, identifying the Inventory item, quantity to add, and measurement unit.

**Type:** Functional

**Source:** `docs/md/Modelo-Final.md` pp. 34, 42–43


**Verification:** Test: Configure additions of different quantities for the same option on two variants and verify each effect.

**Status:** Confirmed

---

<a id="req-menu-018"></a>
### REQ-MENU-018 — Ingredient omission directive

**Requirement:**
The Menu service shall allow configuring an ingredient omission in `ModifierOption.defaultConfig` or `VariantModifierConfig` by identifying the Inventory item to omit from preparation.

**Type:** Functional

**Source:** `docs/md/Modelo-Final.md` pp. 33–34, 46


**Verification:** Test: Configure an omission and verify the identified ingredient and omission directive.

**Status:** Confirmed

---

<a id="req-menu-019"></a>
### REQ-MENU-019 — Preparation customization without ingredient effects

**Requirement:**
The Menu service shall allow defining a preparation customization for a leaf `MenuItem` without any associated ingredient effects.

**Type:** Functional

**Source:** `docs/md/Problema-Inicial.md` pp. 108–110; `docs/md/Modelo-Final.md` pp. 42


**Verification:** Test: Define a cooking instruction with no ingredient effects and verify that the configuration is accepted.

**Status:** Confirmed

---

<a id="req-menu-020"></a>
### REQ-MENU-020 — Recipe definition

**Requirement:**
The Menu service shall allow defining a culinary recipe with a name and ingredient composition specifying each Inventory item, required quantity, and measurement unit; Menu shall assign the recipe's initial revision.

**Type:** Functional

**Source:** `docs/md/Modelo-Final.md` pp. 20–23, 37–38


**Verification:** Demonstration: Define a recipe with several components, verify the `recipeId` and `recipeVersion` assigned by Menu, and compare the recorded composition with the supplied definition.

**Status:** Confirmed

---

<a id="req-menu-021"></a>
### REQ-MENU-021 — Recipe version history

**Requirement:**
The Menu service shall preserve an accepted change to a recipe name or ingredient list as a new immutable recipe revision.

**Type:** Functional

**Source:** [ADR-006 — MenuItem and recipe versions](../../docs/md/Decisiones-cierre-invariantes.md#adr-006).


**Verification:** Change a recipe name and then its ingredient list; verify that each accepted change creates a new recipe revision and that earlier revisions remain unchanged. This requirement concerns recipe version history; combo review is specified separately in REQ-MENU-035 through REQ-MENU-039.

**Status:** Confirmed

---

---

<a id="req-menu-022"></a>
### REQ-MENU-022 — Catalog publication

**Requirement:**
The Menu service shall expose current definitions through E-01 through E-03 and publish M-07 invalidations for effective commercial changes and M-08 invalidations for effective availability changes so consumer views can refresh.

**Type:** Functional

**Source:** [ALIGN](../../docs/reviews/ers-interfaces-alignment/decisions.md)


**Verification:** Demonstration: publish a price change and an availability change, verify that catalog consumers receive the updated definition or availability, and verify that an availability-only change does not create a new commercial `MenuItem` revision.

**Status:** Confirmed

---

<a id="req-menu-024"></a>
### REQ-MENU-024 — dimension variant value

**Requirement:**
The Menu service shall allow defining named values, such as Small or Large, within a dimension variant of a leaf `MenuItem`.

**Type:** Functional

**Source:** `docs/md/Modelo-Final.md` pp. 21, 36–37


**Verification:** Demonstration: Define two values for one dimension variant and verify that both belong to the selected leaf `MenuItem`.

**Status:** Confirmed

---

<a id="req-menu-025"></a>
### REQ-MENU-025 — Variant modifier quantity cap

**Requirement:**
The Menu service shall allow setting the maximum number of units a customer may choose for a `ModifierOption` and, when a presentation's effective maximum differs from the general maximum, a different maximum for a leaf `MenuItemVariant` through an exception.

**Type:** Functional

**Source:** `docs/md/Auditoria-4.md`, items 15–18


**Verification:** Test: Set a general maximum, add a different maximum for one leaf presentation, and verify that presentations without an exception use the general maximum.

**Status:** Confirmed

<a id="req-menu-026"></a>
### REQ-MENU-026 — Copy combo configuration

**Requirement:**
The Menu service shall allow copying, through E-17, `ComboSlot` records and their `ComboOption` records from a source `ComboConfiguration` to a target `ComboConfiguration` of the same COMBO `MenuItem`, creating new target identities.

**Type:** Functional

**Source:** `docs/md/Modelo-Final.md` pp. 30–31


**Verification:** Test: Run the copy in `dryRun` and application mode, compare the resulting slots and options with the source, and verify that a `FAIL` conflict leaves no partial configuration.

**Status:** Confirmed

**Active contract:** [E-17](../interfaces/apis/entrada/E-17.md); [ALIGN](../../docs/reviews/ers-interfaces-alignment/decisions.md)

---

<a id="req-menu-027"></a>
### REQ-MENU-027 — Bulk combo option assignment

**Requirement:**
The Menu service shall allow applying, through E-17 and using explicit IDs for each destination, a selected set of `ComboOption` records to multiple `ComboConfiguration` records of the same COMBO `MenuItem` in one atomic administrative operation.

**Type:** Functional

**Source:** `docs/md/Modelo-Final.md` pp. 31


**Verification:** Demonstration: Apply a selected set to two `ComboConfiguration` records, verify associations by `configurationId` and `slotId`, and verify there are no partial effects when a destination fails.

**Status:** Confirmed

**Active contract:** [E-17](../interfaces/apis/entrada/E-17.md); [ALIGN](../../docs/reviews/ers-interfaces-alignment/decisions.md)

---

<a id="req-menu-028"></a>
### REQ-MENU-028 — Archive variant

**Requirement:**
The Menu service shall allow withdrawing a `MenuItemVariant` by transitioning it to ARCHIVED; if a dependent active `ComboConfiguration` loses valid capacity, Menu shall reject the withdrawal or require the dependent `MenuItem` to be deactivated first.

**Type:** Functional

**Source:** [ADR-003](../../docs/md/Decisiones-cierre-invariantes.md#adr-003)


**Verification:** Archive a variant with historical orders, verify retained history and exclusion from new offers, and verify rejection or required deactivation when an active dependent configuration can no longer satisfy its minimums.

**Status:** Confirmed

---

<a id="req-menu-029"></a>
### REQ-MENU-029 — Save incomplete selection rules

**Requirement:**
The Menu service shall allow saving an incomplete definition when the context containing the rule is `INACTIVE`: for a `ModifierGroup`, the context may be its `MenuItem` or the corresponding leaf `MenuItemVariant`; for a `ComboSlot`, it is the COMBO `MenuItem` because `ComboConfiguration` has no own status. Capacity is below `minSelections` when, for a `ModifierGroup`, it is below the sum of `maxQuantity` across enabled `ModifierOption` records or, for a `ComboSlot`, below the number of enabled `ComboOption` records whose component `MenuItemVariant` is `ACTIVE`.

**Type:** Functional

**Source:** [ADR-005](../../docs/md/Decisiones-cierre-invariantes.md#adr-005)


**Verification:** Save an `INACTIVE` leaf `MenuItem` with a group whose minimum is 2 and calculated capacity is 1, save an `INACTIVE` leaf `MenuItemVariant` with the same insufficiency, and save an `INACTIVE` COMBO `MenuItem` with a slot whose minimum is 2 and one enabled option with an `ACTIVE` component; verify they save with an identifiable warning and are not offered as `ACTIVE`.

**Status:** Confirmed

---

<a id="req-menu-030"></a>
### REQ-MENU-030 — Report missing selections

**Requirement:**
When saving an `INACTIVE` `MenuItem` or `MenuItemVariant`, the Menu service shall include in the incomplete-capacity warning the identity and type of every `ModifierGroup` or `ComboSlot` that cannot satisfy its `minSelections`, together with the minimum and calculated capacity: the `maxQuantity` sum for a group or the number of enabled options with an `ACTIVE` component for a slot.

**Type:** Functional

**Source:** [ADR-005](../../docs/md/Decisiones-cierre-invariantes.md#adr-005)


**Verification:** Verify that each warning exposes the identity, type (`ModifierGroup` or `ComboSlot`), `minSelections`, and corresponding calculated capacity.

**Status:** Confirmed

---

<a id="req-menu-031"></a>
### REQ-MENU-031 — No eligible catalog price

**Requirement:**
The Menu service shall present a `MenuItem` as unavailable and without a numeric catalog price when it has no eligible `MenuItemVariant` or `ComboConfiguration`.

**Type:** Functional

**Source:** [ADR-008 — Eligibility, catalog price and default presentation](../../docs/md/Decisiones-cierre-invariantes.md#adr-008).


**Verification:** Make every sellable unit ineligible; verify that the catalog shows unavailable and no numeric price, rather than zero or the price of an archived presentation.

**Status:** Confirmed

---

<a id="req-menu-032"></a>
### REQ-MENU-032 — Net ingredient resolution

**Requirement:**
The Menu service shall calculate the ingredient list for an order line from the recipe revision pinned to each PREPARED `MenuItemVariant`, the Inventory item and withdrawal quantity of each STOCKED `MenuItemVariant`, the physical `ComboOption.quantity` of each selected combo component, and selected ADD or OMIT customizations in their owning component.

**Type:** Functional

**Source:** [ADR-003](../../docs/md/Decisiones-cierre-invariantes.md#adr-003)


**Verification:** Resolve a PREPARED line, a STOCKED line, and a COMBO line; verify their recipe and withdrawal results, physical multiplication by `ComboOption.quantity`, OMIT-before-ADD ordering, and confinement of each effect to its owning component.

**Status:** Confirmed

---

<a id="req-menu-033"></a>
### REQ-MENU-033 — MenuItem revision

**Requirement:**
The Menu service shall create a new immutable `MenuItem` revision for each accepted change to its commercial definition, including administrative status, a leaf presentation, recipe reference, combo configuration, combo option, or modifier configuration.

**Type:** Functional

**Source:** [ADR-006](../../docs/md/Decisiones-cierre-invariantes.md#adr-006)


**Verification:** Change a leaf presentation price, recipe reference, combo option, and modifier configuration; verify that each accepted change creates a new `MenuItem` revision and that the previous revision remains unchanged. An availability-only derived update does not create a `MenuItem` revision.

**Status:** Confirmed

---

<a id="req-menu-034"></a>
### REQ-MENU-034 — Default variant migration

**Requirement:**
The Menu service shall replace, in a leaf `MenuItem`, the technical `DEFAULT` `MenuItemVariant` with `MenuItemVariant` records having explicit presentation values as one `MenuItem` revision.

**Type:** Functional

**Source:** [ADR-008](../../docs/md/Decisiones-cierre-invariantes.md#adr-008)


**Verification:** Attempt an incomplete migration, then publish a valid migration; verify that no partially migrated sellable revision is visible.

**Status:** Confirmed

---

<a id="req-menu-035"></a>
### REQ-MENU-035 — Combo review detection

**Requirement:**
The Menu service shall mark a `ComboConfiguration` as `REVIEW_REQUIRED` when a configured `ComboOption`—including a disabled option—points to a leaf `MenuItemVariant` with an unacknowledged change having one or more `PRICE`, `COMPOSITION`, `MODIFIERS`, or `STATUS` reasons; it shall ignore cosmetic, stock, and unreferenced-variant changes, and shall not warn for a new recipe revision until the variant explicitly adopts it.

**Type:** Functional

**Source:** [ALIGN](../../docs/reviews/ers-interfaces-alignment/decisions.md)


**Verification:** Query E-20 after each case and verify that the listed reasons yield `REVIEW_REQUIRED`, disabled options remain dependencies, cosmetic/stock/unrelated-variant changes yield no warning, and a new recipe revision yields a warning only after variant adoption.

**Status:** Confirmed

---

<a id="req-menu-036"></a>
### REQ-MENU-036 — Administrative review visibility

**Requirement:**
The Menu service shall expose through E-19 and E-20 the `ComboConfiguration` records whose review state is `REVIEW_REQUIRED` and an aggregate state for each COMBO `MenuItem`; this review state shall remain separate from `MenuItem.status`, each `MenuItemVariant` status, and availability.

**Type:** Functional

**Source:** [ALIGN](../../docs/reviews/ers-interfaces-alignment/decisions.md)


**Verification:** Inspect E-19/E-20, verify configuration-level and combo-level states, and verify that a non-COMBO `MenuItem` receives no combo-review state.

**Status:** Confirmed

---

<a id="req-menu-037"></a>
### REQ-MENU-037 — Observed review acknowledgement

**Requirement:**
The Menu service shall confirm only the `changeId` values identified by each observed `reviewToken` submitted with the `configurationId` of explicitly selected `ComboConfiguration` records in E-21; changes after observation shall remain pending.

**Type:** Functional

**Source:** [ALIGN](../../docs/reviews/ers-interfaces-alignment/decisions.md)


**Verification:** Confirm one or more configurations with their observed tokens, verify that “all” enumerates the displayed configurations explicitly, and verify that concurrent new changes remain pending.

**Status:** Confirmed

---

<a id="req-menu-038"></a>
### REQ-MENU-038 — Preserve reviewed configuration

**Requirement:**
The Menu service shall allow confirming a `ComboConfiguration` review token without changing its `unitPrice`, `ComboSlot` records, `ComboOption` records, or retired-option status; confirmation only records the observed changes as acknowledged.

**Type:** Functional

**Source:** [ALIGN](../../docs/reviews/ers-interfaces-alignment/decisions.md)


**Verification:** Confirm a review and compare `unitPrice`, slots, options, and statuses before and after; verify no commercial revision, no retired-option reactivation, and a receipt listing the acknowledged `changeId` values.

**Status:** Confirmed

---

<a id="req-menu-039"></a>
### REQ-MENU-039 — Visual slot reference

**Requirement:**
The Menu service shall expose, for each `ComboSlot` and its administrative `baseOptionIds`, the `saved` sum of pinned `MenuItemVariant.unitPrice` values multiplied by `ComboOption.quantity`, the `current` sum of current prices for the same `itemVariantId` values, and the signed `current - saved` difference; these values are administrative references only and shall not change the combo selling price.

**Type:** Functional

**Source:** [ALIGN](../../docs/reviews/ers-interfaces-alignment/decisions.md)


**Verification:** Query E-20 with a base selection containing multiple options, verify use of `itemVariantId` and `ComboOption.quantity` in `saved` and `current`, verify `difference = current - saved`, and verify that `ComboConfiguration.unitPrice` is unchanged.

**Status:** Confirmed

---

<a id="req-menu-040"></a>
### REQ-MENU-040 — Published effective modifier projection

**Requirement:**
The Menu service shall materialize, for each published leaf `MenuItemVariant` and each applicable `ModifierOption`, a `ResolvedVariantModifier` containing `enabled`, `priceDelta`, `maxQuantity`, and `ingredientEffects`, applying `VariantModifierConfig` when present and `ModifierOption.defaultConfig` otherwise.

**Type:** Functional

**Source:** `docs/md/Auditoria-4.md`, items 14–18 and 21–22.


**Verification:** Analysis: Publish an item with one default modifier and one variant exception; verify one `ResolvedVariantModifier` per variant/option with all four effective fields and correct inheritance when no exception exists.

**Status:** Confirmed

---
## Confirmed consumer UI requirements

The following requirements formalize the confirmed UI obligations requested for the waiter and administrator surfaces. They do not transfer ownership of external data to Menu; their missing external projections are recorded in OPEN-011 through OPEN-019.

<a id="req-ui-001"></a>
### REQ-UI-001 — Assigned table set

**Requirement:**
The ordering UI shall display only the tables included in the authorized table-assignment projection for the current waiter.

**Type:** Functional

**Source:** Explicit UI decision in the user request dated 2026-09-13; consolidated as UI-REQ-001 in `output/ui-spec/ui-data-spec.md`.


**Verification:** Demonstration: load a projection containing assigned and unassigned tables and verify that only assigned tables are displayed.

**Status:** Confirmed

---

<a id="req-ui-002"></a>
### REQ-UI-002 — Table order distinction

**Requirement:**
The ordering UI shall distinguish a table with an associated order from a table without an associated order.

**Type:** Functional

**Source:** Explicit UI decision in the user request dated 2026-09-13; consolidated as UI-REQ-002 in `output/ui-spec/ui-data-spec.md`.


**Verification:** Demonstration: display both table states and verify that each state has a distinct visual indication.

**Status:** Confirmed

---

<a id="req-ui-003"></a>
### REQ-UI-003 — Append to existing order

**Requirement:**
The ordering UI shall allow preparing additional `MenuItem` selections for the order associated with a table that already has an order.

**Type:** Functional

**Source:** Explicit UI decision in the user request dated 2026-09-13; consolidated as UI-REQ-003 in `output/ui-spec/ui-data-spec.md`.


**Verification:** Demonstration: open an existing order, create new draft lines and verify that confirmed lines remain identifiable and unchanged.

**Status:** Confirmed

---

<a id="req-ui-004"></a>
### REQ-UI-004 — Sellable catalog types

**Requirement:**
The ordering UI shall allow selecting catalog `MenuItem` records by type (`STOCKED`, `PREPARED` or `COMBO`).

**Type:** Functional

**Source:** Explicit UI decision in the user request dated 2026-09-13; consolidated as UI-REQ-004 in `output/ui-spec/ui-data-spec.md`.


**Verification:** Demonstration: display one eligible `MenuItem` of each type and verify that each opens the configuration corresponding to its type.

**Status:** Confirmed

---

<a id="req-ui-005"></a>
### REQ-UI-005 — Catalog search and filters

**Requirement:**
The ordering and administrative UIs shall provide name search, category filtering, and visual-classification filtering; a leaf `MenuItem` uses its commercial classification, while a `COMBO` is identified by its type rather than assigned a leaf classification.

**Type:** Functional

**Source:** Explicit UI decision in the user request dated 2026-09-13; consolidated as UI-REQ-005 in `output/ui-spec/ui-data-spec.md`.


**Verification:** Demonstration: apply each filter alone and in combination and verify that displayed cards satisfy the criteria without assigning a leaf classification to a `COMBO`.

**Status:** Confirmed

---

<a id="req-ui-006"></a>
### REQ-UI-006 — Local order draft editing

**Requirement:**
The ordering UI shall allow changing quantity, reconfiguring and removing each `DraftOrderLine` before order confirmation.

**Type:** Functional

**Source:** Explicit UI decision in the user request dated 2026-09-13; consolidated as UI-REQ-006 in `output/ui-spec/ui-data-spec.md`.


**Verification:** Demonstration: change, reconfigure and remove a `DraftOrderLine`, recalculate its resolution, and verify that confirmed lines and the catalog are unaffected.

**Status:** Confirmed

---

<a id="req-ui-007"></a>
### REQ-UI-007 — Item configuration before addition

**Requirement:**
The ordering UI shall allow configuring, before adding a `MenuItem` to the draft, the dimension variants and `ModifierGroup`/`ModifierOption` records of a leaf item, or the `ComboSlot`/`ComboOption` records and component customizations when the item is `COMBO`, using the Menu definition available for that selection.

**Type:** Functional

**Source:** Explicit UI decision in the user request dated 2026-09-13; consolidated as UI-REQ-007 in `output/ui-spec/ui-data-spec.md`.


**Verification:** Demonstration: configure a leaf item and a combo, resolve both through E-16, add both to the draft, and verify that `variantId`, selections and quantities are retained.

**Status:** Confirmed

---

<a id="req-ui-008"></a>
### REQ-UI-008 — Administrative catalog management

**Requirement:**
The administrative UI shall provide catalog creation, editing, name search, and the same category, visual-classification, and `MenuItem`-type filters defined for the sales catalog.

**Type:** Functional

**Source:** Explicit UI decision in the user request dated 2026-09-13; consolidated as UI-REQ-008 in `output/ui-spec/ui-data-spec.md`.


**Verification:** Demonstration: open the administrative catalog, apply the confirmed filters and open both create and edit actions.

**Status:** Confirmed

---

<a id="req-ui-009"></a>
### REQ-UI-009 — Administrative lifecycle sections

**Requirement:**
The administrative UI shall present `MenuItem.status` (`ACTIVE` or `INACTIVE`) separately from a COMBO review state (`REVIEW_REQUIRED` or `UP_TO_DATE`) and from `ARCHIVED` on a `MenuItemVariant` or the external archived-items section; `REVIEW_REQUIRED` is not a `MenuItem.status` and `ARCHIVED` is not `INACTIVE`.

**Type:** Functional

**Source:** Explicit UI decision in the user request dated 2026-09-13 and current Menu lifecycle semantics; consolidated as UI-REQ-009 in `output/ui-spec/ui-data-spec.md`.


**Verification:** Inspection: verify that the `MenuItem.status` filter uses only `ACTIVE`/`INACTIVE`, that `REVIEW_REQUIRED`/`UP_TO_DATE` is shown only for combos, and that `ARCHIVED` is attributed to the correct entity and distinguished from `INACTIVE`.

**Status:** Confirmed

---

<a id="req-ui-010"></a>
### REQ-UI-010 — Soft removal from archived section

**Requirement:**
The administrative UI shall manage the external archived-items section through a soft-removal action for one item, selected items, or all items within the selected result scope, without presenting it as physical deletion.

**Type:** Functional

**Source:** Explicit UI decision in the user request dated 2026-09-13; consolidated as UI-REQ-010 in `output/ui-spec/ui-data-spec.md`.


**Verification:** Demonstration: execute the individual, selected-items and all-results scopes, verify that the UI reflects the result, and verify that it neither sends nor represents physical history deletion.

**Status:** Confirmed

---

<a id="req-ui-011"></a>
### REQ-UI-011 — Item creation wizard

**Requirement:**
The administrative UI shall represent `MenuItem` creation in four steps: (1) `MenuItem` type and commercial classification when applicable, (2) item-specific configuration and fulfillment, (3) modifier configuration, and (4) configuration summary with acceptance.

**Type:** Functional

**Source:** Explicit UI decision in the user request dated 2026-09-13; consolidated as UI-REQ-011 in `output/ui-spec/ui-data-spec.md`.


**Verification:** Demonstration: start creation for each type, traverse exactly those four steps, and verify the complete summary before acceptance.

**Status:** Confirmed

---

<a id="req-ui-012"></a>
### REQ-UI-012 — Item editing wizard

**Requirement:**
The administrative UI shall represent item editing in three steps: item configuration, modifier configuration and confirmation.

**Type:** Functional

**Source:** Explicit UI decision in the user request dated 2026-09-13; consolidated as UI-REQ-012 in `output/ui-spec/ui-data-spec.md`.


**Verification:** Demonstration: open an existing item, verify preloaded data and verify that the editor exposes exactly the three editing steps.

**Status:** Confirmed

---

<a id="req-ui-013"></a>
### REQ-UI-013 — Create and edit distinction

**Requirement:**
The administrative UI shall distinguish create and edit actions through their title, primary action, initial form state, and presence of preloaded data.

**Type:** Functional

**Source:** Explicit UI decision in the user request dated 2026-09-13; consolidated as UI-REQ-013 in `output/ui-spec/ui-data-spec.md`.


**Verification:** Inspection: compare CREATE and EDIT compositions and verify that they are not presented as the same operation.

**Status:** Confirmed

---

<a id="req-ui-014"></a>
### REQ-UI-014 — Pending review presentation

**Requirement:**
The administrative UI shall present, in `V-ADM-03` and separate from the ordinary `V-ADM-02` editor, a pending `COMBO` that identifies its affected `ComboConfiguration` records and observed dependency changes.

**Type:** Functional

**Source:** Explicit UI decision in the user request dated 2026-09-13 and E-19/E-20 review contracts; consolidated as UI-REQ-014 in `output/ui-spec/ui-data-spec.md`.


**Verification:** Demonstration: load a pending combo and verify a distinct review state, affected variants and observed changes.

**Status:** Confirmed

---

<a id="req-ui-015"></a>
### REQ-UI-015 — Pending review acknowledgement

**Requirement:**
The administrative UI shall allow confirming selected pending `ComboConfiguration` records in E-21 with their `reviewToken` values and hide the indicator only after an updated E-20 read reports `UP_TO_DATE` for the combo; new changes shall keep `REVIEW_REQUIRED`.

**Type:** Functional

**Source:** Explicit UI decision in the user request dated 2026-09-13 and E-20/E-21 review contracts; consolidated as UI-REQ-014 in `output/ui-spec/ui-data-spec.md`.


**Verification:** Demonstration: confirm one or more configurations with their tokens, refresh E-20, and verify that `REVIEW_REQUIRED` remains when new changes are pending.

**Status:** Confirmed

---

<a id="req-ui-016"></a>
### REQ-UI-016 — Pre-order accumulated cost

**Requirement:**
The ordering UI shall display the accumulated pre-order cost as the sum of the costs of its configured lines, while treating later Billing adjustments as outside that displayed accumulation.

**Type:** Functional

**Source:** Explicit price clarification in the user request dated 2026-09-13 and the E-16 monetary summary; consolidated as UI-REQ-015 in `output/ui-spec/ui-data-spec.md`.


**Verification:** Demonstration: change quantities and configurations and verify `preorderTotal = Σ(quantity × resolvedUnitSubtotal)`; later Billing adjustments do not change the meaning of the displayed pre-order accumulation.

**Status:** Confirmed

---
