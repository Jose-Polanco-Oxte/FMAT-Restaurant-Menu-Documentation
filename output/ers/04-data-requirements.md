[← Index](./index.md)

# Data requirements

Each block states one primary obligation. Enumerated attributes describe one fact or operation, not independent steps. Verification entries are proposed acceptance criteria, not executed software tests. Model names identify domain concepts, not required technologies. `Auditoria-4.md` is the active source for the corrected data model.

---

<a id="data-menu-001"></a>
### DATA-MENU-001 — Menu

**Requirement:**
The Menu service shall retain a menu by its identifier, restaurant reference, name and description.

**Type:** Data requirements

**Source:** `docs/md/Modelo-Final.md` pp. 22


**Verification:** Demonstration: Record the described fact and retrieve it, comparing each listed datum and association. No storage type, default or deletion cascade is prescribed.

**Status:** Confirmed

---

<a id="data-menu-002"></a>
### DATA-MENU-002 — Commercial MenuItem

**Requirement:**
The Menu service shall retain a `MenuItem` by its identifier, parent `Menu` reference, name, description, image reference, product type and administrative status, with an `ItemCategory` and commercial classification for leaf items or a `ComboCategory` for COMBO items.

**Type:** Data requirements

**Source:** `docs/md/Modelo-Final.md` pp. 36–37


**Verification:** Demonstration: Record the described fact and retrieve it, comparing each listed datum and association. No storage type, default or deletion cascade is prescribed.

**Status:** Confirmed

---

<a id="data-menu-003"></a>
### DATA-MENU-003 — Presentation characteristic

**Requirement:**
The Menu service shall retain a named presentation characteristic by its identifier, name and owning leaf `MenuItem`.

**Type:** Data requirements

**Source:** `docs/md/Modelo-Final.md` pp. 21, 36–37


**Verification:** Demonstration: Record the described fact and retrieve it, comparing each listed datum and association. No storage type, default or deletion cascade is prescribed.

**Status:** Confirmed

---

<a id="data-menu-004"></a>
### DATA-MENU-004 — Sellable variant

**Requirement:**
The Menu service shall retain a sellable `MenuItemVariant` by its identifier, owning PREPARED or STOCKED `MenuItem`, absolute `unitPrice` and selected presentation characteristic values.

**Type:** Data requirements

**Source:** `docs/md/Modelo-Final.md` pp. 21, 26–28, 36–37


**Verification:** Demonstration: Record the described fact and retrieve it, comparing each listed datum and association. No storage type, default or deletion cascade is prescribed.

**Status:** Confirmed

---

<a id="data-menu-005"></a>
### DATA-MENU-005 — Stocked variant definition

**Requirement:**
The Menu service shall retain a stocked variant fulfillment definition by its variant reference, Inventory item reference, withdrawal quantity, and measurement unit.

**Type:** Data requirements

**Source:** `docs/md/Modelo-Final.md` pp. 8–9, 37


**Verification:** Demonstration: Record the described fact and retrieve it, comparing each listed datum and association. No storage type, default or deletion cascade is prescribed.

**Status:** Confirmed

---

<a id="data-menu-006"></a>
### DATA-MENU-006 — Combo slot

**Requirement:**
The Menu service shall retain a combo slot by its identifier, owning ComboConfiguration, name and minimum and maximum selection counts.

**Type:** Data requirements

**Source:** `docs/md/Modelo-Final.md` pp. 9–10, 30–31


**Verification:** Demonstration: Record the described fact and retrieve it, comparing each listed datum and association. No storage type, default or deletion cascade is prescribed.

**Status:** Confirmed

---

<a id="data-menu-007"></a>
### DATA-MENU-007 — Modifier group

**Requirement:**
The Menu service shall retain a modifier group by its identifier, owning PREPARED or STOCKED `MenuItem`, name and minimum and maximum selection counts.

**Type:** Data requirements

**Source:** `docs/md/Modelo-Final.md` pp. 12–13, 48


**Verification:** Demonstration: Record the described fact and retrieve it, comparing each listed datum and association. No storage type, default or deletion cascade is prescribed.

**Status:** Confirmed

---

<a id="data-menu-008"></a>
### DATA-MENU-008 — Variant modifier configuration

**Requirement:**
The Menu service shall retain an optional VariantModifierConfig exception for a leaf variant and modifier option by its applicability, priceDelta, maximum selectable quantity and associated ingredient effects.

**Type:** Data requirements

**Source:** `docs/md/Modelo-Final.md` pp. 42–47


**Verification:** Demonstration: Record the described fact and retrieve it, comparing each listed datum and association. No storage type, default or deletion cascade is prescribed.

**Status:** Confirmed

---

<a id="data-menu-009"></a>
### DATA-MENU-009 — Ingredient effect

**Requirement:**
The Menu service shall retain an ingredient effect by its owning default or variant-specific modifier behavior, inventory item reference, addition or omission type and the quantity and measurement unit when applicable under BR-MENU-013 and BR-MENU-019.

**Type:** Data requirements

**Source:** `docs/md/Modelo-Final.md` pp. 34, 42–46


**Verification:** Demonstration: Record the described fact and retrieve it, comparing each listed datum and association. No storage type, default or deletion cascade is prescribed.

**Status:** Confirmed

---

<a id="data-menu-010"></a>
### DATA-MENU-010 — Recipe identity

**Requirement:**
The Menu service shall retain a recipe by its identifier, name and version.

**Type:** Data requirements

**Source:** `docs/md/Modelo-Final.md` pp. 23, 37–38


**Verification:** Demonstration: Record the described fact and retrieve it, comparing each listed datum and association. No storage type, default or deletion cascade is prescribed.

**Status:** Confirmed

---

<a id="data-menu-011"></a>
### DATA-MENU-011 — Presentation characteristic value

**Requirement:**
The Menu service shall retain a named presentation characteristic value by its identifier, name and parent presentation characteristic.

**Type:** Data requirements

**Source:** `docs/md/Modelo-Final.md` pp. 21, 36–37


**Verification:** Demonstration: Record the described fact and retrieve it, comparing each listed datum and association. No storage type, default or deletion cascade is prescribed.

**Status:** Confirmed

---

<a id="data-menu-012"></a>
### DATA-MENU-012 — Prepared variant definition

**Requirement:**
The Menu service shall retain a prepared variant fulfillment definition by its variant reference and recipe reference.

**Type:** Data requirements

**Source:** `docs/md/Modelo-Final.md` pp. 8–9, 37


**Verification:** Demonstration: Record the described fact and retrieve it, comparing each listed datum and association. No storage type, default or deletion cascade is prescribed.

**Status:** Confirmed

---

<a id="data-menu-013"></a>
### DATA-MENU-013 — Combo option reference

**Requirement:**
The Menu service shall retain each combo option identity, parent slot, concrete itemVariantId, enabled state, positive quantity and priceDelta.

**Type:** DATA

**Source:** `docs/md/Auditoria-4.md`, items 23–32


**Verification:** Inspect ComboOption; require itemVariantId, positive quantity and priceDelta, and reject a COMBO component.

**Status:** Confirmed

---

<a id="data-menu-014"></a>
### DATA-MENU-014 — Modifier option

**Requirement:**
The Menu service shall retain a modifier option by its identifier, name, owning modifier group and general/default configuration.

**Type:** Data requirements

**Source:** `docs/md/Auditoria-4.md`, items 14–16


**Verification:** Demonstration: Record the described fact and retrieve it, comparing each listed datum and association. No storage type, default or deletion cascade is prescribed.

**Status:** Confirmed

---

<a id="data-menu-015"></a>
### DATA-MENU-015 — Recipe component

**Requirement:**
The Menu service shall retain a recipe component by its parent recipe, inventory item reference, required quantity and measurement unit.

**Type:** Data requirements

**Source:** `docs/md/Modelo-Final.md` pp. 20–21, 37–38


**Verification:** Demonstration: Record the described fact and retrieve it, comparing each listed datum and association. No storage type, default or deletion cascade is prescribed.

**Status:** Confirmed

---

<a id="data-menu-016"></a>
### DATA-MENU-016 — Variant lifecycle

**Requirement:**
The Menu service shall retain the INACTIVE, ACTIVE or ARCHIVED state of each variant.

**Type:** DATA

**Source:** [ADR-003](../../docs/md/Decisiones-cierre-invariantes.md#adr-003)


**Verification:** Record and retrieve all specified information without changing history.

**Status:** Confirmed

---

<a id="data-menu-017"></a>
### DATA-MENU-017 — Immutable definition version

**Requirement:**
The Menu service shall retain each immutable `MenuItem` and recipe revision with identity, version, timezone-qualified timestamp and definition content.

**Type:** DATA

**Source:** [ADR-006](../../docs/md/Decisiones-cierre-invariantes.md#adr-006)


**Verification:** Record and retrieve all specified information without changing history.

**Status:** Confirmed

---

<a id="data-menu-018"></a>
### DATA-MENU-018 — Recipe revision reference

**Requirement:**
The Menu service shall retain the exact recipe identity and version referenced by each prepared variant definition.

**Type:** DATA

**Source:** [ADR-006](../../docs/md/Decisiones-cierre-invariantes.md#adr-006)


**Verification:** Record and retrieve all specified information without changing history.

**Status:** Confirmed

---

<a id="data-menu-019"></a>
### DATA-MENU-019 — Availability projection

**Requirement:**
The Menu service shall retain the mapping of each variant or supplied option to an opaque key, definition revision and flat list of inventory items, quantities and units.

**Type:** DATA

**Source:** [ADR-001](../../docs/md/Decisiones-cierre-invariantes.md#adr-001)


**Verification:** Record and retrieve all specified information without changing history.

**Status:** Confirmed

---

<a id="data-menu-020"></a>
### DATA-MENU-020 — Availability evaluation

**Requirement:**
The Menu service shall retain the latest accepted evaluation per key with definition revision, evaluation revision, result and expiry instant.

**Type:** DATA

**Source:** [ADR-001](../../docs/md/Decisiones-cierre-invariantes.md#adr-001)


**Verification:** Record and retrieve all specified information without changing history.

**Status:** Confirmed

---

<a id="data-menu-021"></a>
### DATA-MENU-021 — Configuration enablement

**Requirement:**
The Menu service shall retain the enablement state of each modifier configuration and combo option.

**Type:** DATA

**Source:** [ADR-005](../../docs/md/Decisiones-cierre-invariantes.md#adr-005)


**Verification:** Record and retrieve all specified information without changing history.

**Status:** Confirmed

---

<a id="data-menu-022"></a>
### DATA-MENU-022 — Order fulfillment snapshot

**Requirement:**
The Orders service shall retain per line and revision its net inventory item list, quantities, units, pinned versions and preparation instructions when confirmation is requested.

**Type:** DATA

**Source:** [ADR-003](../../docs/md/Decisiones-cierre-invariantes.md#adr-003)


**Verification:** Change the live catalog after capture; retained line data stays identical.

**Status:** Confirmed

---

<a id="data-menu-023"></a>
### DATA-MENU-023 — Movement identity

**Requirement:**
The Orders service shall retain each movement with a unique identity per line, revision and operation, inventory content and original movement reference for a reversal.

**Type:** DATA

**Source:** [ADR-003](../../docs/md/Decisiones-cierre-invariantes.md#adr-003)


**Verification:** Two lines of one order have distinct movement identities; a reversal references its original.

**Status:** Confirmed

---

<a id="data-menu-024"></a>
### DATA-MENU-024 — Identity ownership

**Requirement:**
The Menu service shall enforce root IDs generated by Menu, new nested IDs proposed by Backoffice, preserved replacement IDs and new copied IDs.

**Type:** DATA

**Source:** [ALIGN](../../docs/reviews/ers-interfaces-alignment/decisions.md)


**Verification:** Inspect D-07 and E-17 mappings; new nested IDs unique within restaurant.

**Status:** Confirmed

---

<a id="data-menu-025"></a>
### DATA-MENU-025 — Separate review audit

**Requirement:**
The Menu service shall retain acknowledgement actor, timestamp, variant identities and observed change identities separately from commercial revisions.

**Type:** DATA

**Source:** [ALIGN](../../docs/reviews/ers-interfaces-alignment/decisions.md)


**Verification:** Client cannot write state; no M-07 from acknowledgement; idempotent receipt.

**Status:** Confirmed

---

<a id="data-menu-026"></a>
### DATA-MENU-026 — Administrative base selection

**Requirement:**
The Menu service shall retain a unique selection of own enabled option IDs within slot bounds as the administrative price-reference base of each ComboConfiguration slot.

**Type:** DATA

**Source:** [ALIGN](../../docs/reviews/ers-interfaces-alignment/decisions.md)


**Verification:** INACTIVE incomplete base warns; ACTIVE requires valid base; the base belongs to a ComboConfiguration slot and is not a customer default.

**Status:** Confirmed

---

<a id="data-menu-027"></a>
### DATA-MENU-027 — COMBO MenuItem

**Requirement:**
The Menu service shall retain a COMBO `MenuItem` with its single `ComboCategory` reference and one or more `ComboConfiguration` records, without using `MenuItemVariant` as the combo configuration type.

**Type:** Data requirements

**Source:** `docs/md/Auditoria-4.md`, items 1, 23 and 29–37.


**Verification:** Inspection: Verify that a combo has a ComboCategory and ComboConfiguration records, while its variants and leaf ItemCategory/classification fields are not used.

**Status:** Confirmed

---

<a id="data-menu-028"></a>
### DATA-MENU-028 — Combo configuration

**Requirement:**
The Menu service shall retain each ComboConfiguration by its identifier, visible name, absolute unitPrice and selection slots, with an optional combo-level default configuration reference.

**Type:** Data requirements

**Source:** `docs/md/Auditoria-4.md`, items 23–32.


**Verification:** Demonstration: Record one default configuration and several named configurations; verify each price and slot composition independently.

**Status:** Confirmed

---

<a id="data-menu-029"></a>
### DATA-MENU-029 — Modifier default configuration

**Requirement:**
The Menu service shall retain the default priceDelta, maxQuantity and ingredientEffects of each ModifierOption.

**Type:** Data requirements

**Source:** `docs/md/Auditoria-4.md`, items 14–16.


**Verification:** Demonstration: Retrieve a modifier option without variant exceptions and verify its default behavior is complete.

**Status:** Confirmed

---

<a id="data-menu-030"></a>
### DATA-MENU-030 — Published resolved modifier

**Requirement:**
The Menu service shall retain or publish an effective modifier projection per leaf variant containing modifierOptionId, enabled, priceDelta, maxQuantity and ingredientEffects.

**Type:** Data requirements

**Source:** `docs/md/Auditoria-4.md`, items 17 and 21–22.


**Verification:** Analysis: Compare the published projection for a variant with and without an exception against the default and exception inputs.

**Status:** Confirmed

---

<a id="data-menu-031"></a>
### DATA-MENU-031 — Concrete leaf order reference

**Requirement:**
The Orders service shall retain a non-null `variantId` on every order line that represents a PREPARED or STOCKED `MenuItem`.

**Type:** Data requirements

**Source:** `docs/md/Auditoria-4.md`, item 43.


**Verification:** Inspection: Attempt to persist a leaf order line without variantId and verify rejection.

**Status:** Confirmed

---

<a id="data-menu-032"></a>
### DATA-MENU-032 — Distinct personalized order lines

**Requirement:**
The Orders service shall retain separate order lines for different customizations of the same MenuItem and MenuItemVariant.

**Type:** Data requirements

**Source:** `docs/md/Auditoria-4.md`, items 44–46.


**Verification:** Demonstration: Add two different modifier selections for the same item and variant and verify that two order lines remain distinguishable.

**Status:** Confirmed

---

## Confirmed consumer UI data requirements

These data requirements formalize the information that the confirmed waiter and administrator UI surfaces must represent. The ownership of external fields remains with their respective services.

<a id="data-ui-001"></a>
### DATA-UI-001 — Assigned table context

**Requirement:**
The ordering UI shall represent an assigned-table context with a table identifier, visible table label, waiter-assignment scope, order-presence state and active order reference when an order exists.

**Type:** Data — Consumer UI

**Source:** Explicit UI decision in the user request dated 2026-09-13; consolidated in `output/ui-spec/ui-data-spec.md`, V-MES-01 and V-MES-02.


**Verification:** Inspection: compare a rendered table context with the supplied assigned-table and active-order projection.

**Status:** Confirmed

---

<a id="data-ui-002"></a>
### DATA-UI-002 — Existing order and local draft distinction

**Requirement:**
The ordering UI shall represent confirmed order lines separately from local draft lines, including their distinct identities, quantities, selected configuration and line cost.

**Type:** Data — Consumer UI

**Source:** Explicit UI decision in the user request dated 2026-09-13; consolidated in `output/ui-spec/ui-data-spec.md`, V-MES-02 and V-MES-03.


**Verification:** Demonstration: display an existing order with a local draft and verify that confirmed and draft identities and values remain distinguishable.

**Status:** Confirmed

---

<a id="data-ui-003"></a>
### DATA-UI-003 — Commercial visual classification vocabulary

**Requirement:**
The ordering and administrative UIs shall represent the leaf commercial classification values DISH, BEVERAGE, DESSERT and COMPLEMENT with the labels Platillo, Bebida, Postre and Complemento, respectively, and shall represent COMBO as a `MenuItem` type.

**Type:** Data — Consumer UI

**Source:** Explicit UI clarification in the user request dated 2026-09-13; consolidated in `output/ui-spec/ui-data-spec.md`, section 3.6.


**Verification:** Inspection: verify the five stable values and their Spanish labels in catalog filters, badges and the creation editor.

**Status:** Confirmed

---

<a id="data-ui-004"></a>
### DATA-UI-004 — Administrative lifecycle projection

**Requirement:**
The administrative UI shall represent each catalog `MenuItem` with its identity, name, `ItemCategory` or `ComboCategory` as applicable, leaf commercial classification when applicable, `MenuItem` type, administrative status, review state when applicable, affected variant or configuration references when pending and local selection state.

**Type:** Data — Consumer UI

**Source:** Explicit UI decision in the user request dated 2026-09-13; consolidated in `output/ui-spec/ui-data-spec.md`, V-ADM-01.


**Verification:** Demonstration: render items in each administrative section and verify that the card fields and selection state support the specified actions.

**Status:** Confirmed

---

<a id="data-ui-005"></a>
### DATA-UI-005 — Pending review work item

**Requirement:**
The administrative UI shall represent pending combo review with the combo identity, affected ComboConfiguration identity, review token and expiry, change identity, slot and option location, itemVariantId component reference, observed version, reasons and local verification state.

**Type:** Data — Consumer UI

**Source:** Explicit UI decision in the user request dated 2026-09-13 and E-19/E-20/E-21; consolidated in `output/ui-spec/ui-data-spec.md`, V-ADM-03.


**Verification:** Demonstration: load a pending review and verify every listed identity, reason and local state without sending local verification state as a Menu field.

**Status:** Confirmed

---

<a id="data-ui-006"></a>
### DATA-UI-006 — Pre-order monetary representation

**Requirement:**
The ordering UI shall represent the resolved unit subtotal, line quantity, line cost, accumulated pre-order cost and currency separately from the existing order total and later Billing adjustments.

**Type:** Data — Consumer UI

**Source:** Explicit price clarification in the user request dated 2026-09-13 and E-16; consolidated in `output/ui-spec/ui-data-spec.md`, section 6.3.


**Verification:** Demonstration: change quantity and configuration and verify the displayed line cost and pre-order accumulation; verify that a later Billing adjustment is not represented as part of that pre-order accumulation.

**Status:** Confirmed
