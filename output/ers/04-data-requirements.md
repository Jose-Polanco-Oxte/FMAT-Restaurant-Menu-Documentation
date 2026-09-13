[← Index](./index.md)

# Data requirements

Each block states one primary obligation. Enumerated attributes describe one fact or operation, not independent steps. Verification entries are proposed acceptance criteria, not executed software tests. Model names identify domain concepts, not required technologies.

---

<a id="data-menu-001"></a>
### DATA-MENU-001 — Menu

**Requirement:**
The Menu service shall retain a menu by its identifier, restaurant reference, name and description.

**Type:** Data requirements

**Source:** `docs/md/Modelo-Final.md` pp. 22

**Rationale:** Preserves the cited source fact or behavior within its stated scope without imposing an additional mechanism.

**Verification:** Demonstration: Record the described fact and retrieve it, comparing each listed datum and association. No storage type, default or deletion cascade is prescribed.

**Status:** Confirmed

---

<a id="data-menu-002"></a>
### DATA-MENU-002 — Commercial product

**Requirement:**
The Menu service shall retain a product by its identifier, parent menu reference, name, description, image reference, category reference, administrative status and fulfillment classification.

**Type:** Data requirements

**Source:** `docs/md/Modelo-Final.md` pp. 36–37

**Rationale:** Preserves the cited source fact or behavior within its stated scope without imposing an additional mechanism.

**Verification:** Demonstration: Record the described fact and retrieve it, comparing each listed datum and association. No storage type, default or deletion cascade is prescribed.

**Status:** Confirmed

---

<a id="data-menu-003"></a>
### DATA-MENU-003 — Variant dimension

**Requirement:**
The Menu service shall retain a variant dimension by its identifier, name and owning product.

**Type:** Data requirements

**Source:** `docs/md/Modelo-Final.md` pp. 21, 36–37

**Rationale:** Preserves the cited source fact or behavior within its stated scope without imposing an additional mechanism.

**Verification:** Demonstration: Record the described fact and retrieve it, comparing each listed datum and association. No storage type, default or deletion cascade is prescribed.

**Status:** Confirmed

---

<a id="data-menu-004"></a>
### DATA-MENU-004 — Sellable variant

**Requirement:**
The Menu service shall retain a sellable variant by its identifier, owning product, absolute selling price and selected dimension values.

**Type:** Data requirements

**Source:** `docs/md/Modelo-Final.md` pp. 21, 26–28, 36–37

**Rationale:** Preserves the cited source fact or behavior within its stated scope without imposing an additional mechanism.

**Verification:** Demonstration: Record the described fact and retrieve it, comparing each listed datum and association. No storage type, default or deletion cascade is prescribed.

**Status:** Confirmed

---

<a id="data-menu-005"></a>
### DATA-MENU-005 — Stocked variant definition

**Requirement:**
The Menu service shall retain a stocked variant fulfillment definition by its variant reference, inventory item reference and withdrawal quantity.

**Type:** Data requirements

**Source:** `docs/md/Modelo-Final.md` pp. 8–9, 37

**Rationale:** Preserves the cited source fact or behavior within its stated scope without imposing an additional mechanism.

**Verification:** Demonstration: Record the described fact and retrieve it, comparing each listed datum and association. No storage type, default or deletion cascade is prescribed.

**Status:** Confirmed

---

<a id="data-menu-006"></a>
### DATA-MENU-006 — Combo slot

**Requirement:**
The Menu service shall retain a combo slot by its identifier, owning combo variant, name and minimum and maximum selection counts.

**Type:** Data requirements

**Source:** `docs/md/Modelo-Final.md` pp. 9–10, 30–31

**Rationale:** Preserves the cited source fact or behavior within its stated scope without imposing an additional mechanism.

**Verification:** Demonstration: Record the described fact and retrieve it, comparing each listed datum and association. No storage type, default or deletion cascade is prescribed.

**Status:** Confirmed

---

<a id="data-menu-007"></a>
### DATA-MENU-007 — Modifier group

**Requirement:**
The Menu service shall retain a modifier group by its identifier, owning product, name and minimum and maximum selection counts.

**Type:** Data requirements

**Source:** `docs/md/Modelo-Final.md` pp. 12–13, 48

**Rationale:** Preserves the cited source fact or behavior within its stated scope without imposing an additional mechanism.

**Verification:** Demonstration: Record the described fact and retrieve it, comparing each listed datum and association. No storage type, default or deletion cascade is prescribed.

**Status:** Confirmed

---

<a id="data-menu-008"></a>
### DATA-MENU-008 — Variant modifier configuration

**Requirement:**
The Menu service shall retain a modifier configuration for a variant-option pair by its price adjustment, maximum selectable quantity and associated ingredient effects.

**Type:** Data requirements

**Source:** `docs/md/Modelo-Final.md` pp. 42–47

**Rationale:** Preserves the cited source fact or behavior within its stated scope without imposing an additional mechanism.

**Verification:** Demonstration: Record the described fact and retrieve it, comparing each listed datum and association. No storage type, default or deletion cascade is prescribed.

**Status:** Confirmed

---

<a id="data-menu-009"></a>
### DATA-MENU-009 — Ingredient effect

**Requirement:**
The Menu service shall retain an ingredient effect by its owning variant modifier configuration, inventory item reference, addition or omission type and the quantity and measurement unit when applicable under BR-MENU-013 and BR-MENU-019.

**Type:** Data requirements

**Source:** `docs/md/Modelo-Final.md` pp. 34, 42–46

**Rationale:** Preserves the cited source fact or behavior within its stated scope without imposing an additional mechanism.

**Verification:** Demonstration: Record the described fact and retrieve it, comparing each listed datum and association. No storage type, default or deletion cascade is prescribed.

**Status:** Confirmed

---

<a id="data-menu-010"></a>
### DATA-MENU-010 — Recipe identity

**Requirement:**
The Menu service shall retain a recipe by its identifier, name and version.

**Type:** Data requirements

**Source:** `docs/md/Modelo-Final.md` pp. 23, 37–38

**Rationale:** Preserves the cited source fact or behavior within its stated scope without imposing an additional mechanism.

**Verification:** Demonstration: Record the described fact and retrieve it, comparing each listed datum and association. No storage type, default or deletion cascade is prescribed.

**Status:** Confirmed

---

<a id="data-menu-011"></a>
### DATA-MENU-011 — Dimension value

**Requirement:**
The Menu service shall retain a dimension value by its identifier, name and parent dimension.

**Type:** Data requirements

**Source:** `docs/md/Modelo-Final.md` pp. 21, 36–37

**Rationale:** Preserves the cited source fact or behavior within its stated scope without imposing an additional mechanism.

**Verification:** Demonstration: Record the described fact and retrieve it, comparing each listed datum and association. No storage type, default or deletion cascade is prescribed.

**Status:** Confirmed

---

<a id="data-menu-012"></a>
### DATA-MENU-012 — Prepared variant definition

**Requirement:**
The Menu service shall retain a prepared variant fulfillment definition by its variant reference and recipe reference.

**Type:** Data requirements

**Source:** `docs/md/Modelo-Final.md` pp. 8–9, 37

**Rationale:** Preserves the cited source fact or behavior within its stated scope without imposing an additional mechanism.

**Verification:** Demonstration: Record the described fact and retrieve it, comparing each listed datum and association. No storage type, default or deletion cascade is prescribed.

**Status:** Confirmed

---

<a id="data-menu-013"></a>
### DATA-MENU-013 — Combo option reference

**Requirement:**
The Menu service shall retain each combo option identity, parent slot, exact component MenuItem version and variant, enabled state and supplied quantity without an option price adjustment.

**Type:** DATA

**Source:** [ALIGN](../../docs/reviews/ers-interfaces-alignment/decisions.md)

**Rationale:** Explicit user decision in ALIGN; supersedes incompatible earlier wording.

**Verification:** Inspect ComboOption; reject priceDelta and nested COMBO references.

**Status:** Confirmed

---

<a id="data-menu-014"></a>
### DATA-MENU-014 — Modifier option

**Requirement:**
The Menu service shall retain a modifier option by its identifier, name and owning modifier group.

**Type:** Data requirements

**Source:** `docs/md/Modelo-Final.md` pp. 42–44, 50

**Rationale:** Preserves the cited source fact or behavior within its stated scope without imposing an additional mechanism.

**Verification:** Demonstration: Record the described fact and retrieve it, comparing each listed datum and association. No storage type, default or deletion cascade is prescribed.

**Status:** Confirmed

---

<a id="data-menu-015"></a>
### DATA-MENU-015 — Recipe component

**Requirement:**
The Menu service shall retain a recipe component by its parent recipe, inventory item reference, required quantity and measurement unit.

**Type:** Data requirements

**Source:** `docs/md/Modelo-Final.md` pp. 20–21, 37–38

**Rationale:** Preserves the cited source fact or behavior within its stated scope without imposing an additional mechanism.

**Verification:** Demonstration: Record the described fact and retrieve it, comparing each listed datum and association. No storage type, default or deletion cascade is prescribed.

**Status:** Confirmed

---

<a id="data-menu-016"></a>
### DATA-MENU-016 — Variant lifecycle

**Requirement:**
The Menu service shall retain the INACTIVE, ACTIVE or ARCHIVED state of each variant.

**Type:** DATA

**Source:** [ADR-003](../../docs/md/Decisiones-cierre-invariantes.md#adr-003)

**Rationale:** Closure decision adopted under user delegation; the cited decision records its basis, limits and alternatives.

**Verification:** Record and retrieve all specified information without changing history.

**Status:** Confirmed

---

<a id="data-menu-017"></a>
### DATA-MENU-017 — Immutable definition version

**Requirement:**
The Menu service shall retain each immutable product and recipe revision with identity, version, timezone-qualified timestamp and definition content.

**Type:** DATA

**Source:** [ADR-006](../../docs/md/Decisiones-cierre-invariantes.md#adr-006)

**Rationale:** Closure decision adopted under user delegation; the cited decision records its basis, limits and alternatives.

**Verification:** Record and retrieve all specified information without changing history.

**Status:** Confirmed

---

<a id="data-menu-018"></a>
### DATA-MENU-018 — Recipe revision reference

**Requirement:**
The Menu service shall retain the exact recipe identity and version referenced by each prepared variant definition.

**Type:** DATA

**Source:** [ADR-006](../../docs/md/Decisiones-cierre-invariantes.md#adr-006)

**Rationale:** Closure decision adopted under user delegation; the cited decision records its basis, limits and alternatives.

**Verification:** Record and retrieve all specified information without changing history.

**Status:** Confirmed

---

<a id="data-menu-019"></a>
### DATA-MENU-019 — Availability projection

**Requirement:**
The Menu service shall retain the mapping of each variant or supplied option to an opaque key, definition revision and flat list of inventory items, quantities and units.

**Type:** DATA

**Source:** [ADR-001](../../docs/md/Decisiones-cierre-invariantes.md#adr-001)

**Rationale:** Closure decision adopted under user delegation; the cited decision records its basis, limits and alternatives.

**Verification:** Record and retrieve all specified information without changing history.

**Status:** Confirmed

---

<a id="data-menu-020"></a>
### DATA-MENU-020 — Availability evaluation

**Requirement:**
The Menu service shall retain the latest accepted evaluation per key with definition revision, evaluation revision, result and expiry instant.

**Type:** DATA

**Source:** [ADR-001](../../docs/md/Decisiones-cierre-invariantes.md#adr-001)

**Rationale:** Closure decision adopted under user delegation; the cited decision records its basis, limits and alternatives.

**Verification:** Record and retrieve all specified information without changing history.

**Status:** Confirmed

---

<a id="data-menu-021"></a>
### DATA-MENU-021 — Configuration enablement

**Requirement:**
The Menu service shall retain the enablement state of each modifier configuration and combo option.

**Type:** DATA

**Source:** [ADR-005](../../docs/md/Decisiones-cierre-invariantes.md#adr-005)

**Rationale:** Closure decision adopted under user delegation; the cited decision records its basis, limits and alternatives.

**Verification:** Record and retrieve all specified information without changing history.

**Status:** Confirmed

---

<a id="data-menu-022"></a>
### DATA-MENU-022 — Order fulfillment snapshot

**Requirement:**
The Orders service shall retain per line and revision its net inventory item list, quantities, units, pinned versions and preparation instructions when confirmation is requested.

**Type:** DATA

**Source:** [ADR-003](../../docs/md/Decisiones-cierre-invariantes.md#adr-003)

**Rationale:** Closure decision adopted under user delegation; the cited decision records its basis, limits and alternatives.

**Verification:** Change the live catalog after capture; retained line data stays identical.

**Status:** Confirmed

---

<a id="data-menu-023"></a>
### DATA-MENU-023 — Movement identity

**Requirement:**
The Orders service shall retain each movement with a unique identity per line, revision and operation, inventory content and original movement reference for a reversal.

**Type:** DATA

**Source:** [ADR-003](../../docs/md/Decisiones-cierre-invariantes.md#adr-003)

**Rationale:** Closure decision adopted under user delegation; the cited decision records its basis, limits and alternatives.

**Verification:** Two lines of one order have distinct movement identities; a reversal references its original.

**Status:** Confirmed

---

<a id="data-menu-024"></a>
### DATA-MENU-024 — Identity ownership

**Requirement:**
The Menu service shall enforce root IDs generated by Menu, new nested IDs proposed by Backoffice, preserved replacement IDs and new copied IDs.

**Type:** DATA

**Source:** [ALIGN](../../docs/reviews/ers-interfaces-alignment/decisions.md)

**Rationale:** Explicit user decision in ALIGN; supersedes incompatible earlier wording.

**Verification:** Inspect D-07 and E-17 mappings; new nested IDs unique within restaurant.

**Status:** Confirmed

---

<a id="data-menu-025"></a>
### DATA-MENU-025 — Separate review audit

**Requirement:**
The Menu service shall retain acknowledgement actor, timestamp, variant identities and observed change identities separately from commercial revisions.

**Type:** DATA

**Source:** [ALIGN](../../docs/reviews/ers-interfaces-alignment/decisions.md)

**Rationale:** Explicit user decision in ALIGN; supersedes incompatible earlier wording.

**Verification:** Client cannot write state; no M-07 from acknowledgement; idempotent receipt.

**Status:** Confirmed

---

<a id="data-menu-026"></a>
### DATA-MENU-026 — Administrative base selection

**Requirement:**
The Menu service shall retain a unique selection of own enabled option IDs within slot bounds as its administrative price-reference base.

**Type:** DATA

**Source:** [ALIGN](../../docs/reviews/ers-interfaces-alignment/decisions.md)

**Rationale:** Explicit user decision in ALIGN; supersedes incompatible earlier wording.

**Verification:** INACTIVE incomplete base warns; ACTIVE requires valid base; not a customer default.

**Status:** Confirmed
