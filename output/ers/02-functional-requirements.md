[← Index](./index.md)

# Functional requirements

Each block states one primary obligation. Enumerated attributes describe one fact or operation, not independent steps. Verification entries are proposed acceptance criteria, not executed software tests. Model names identify domain concepts, not required technologies.

---

<a id="req-menu-001"></a>
### REQ-MENU-001 — Commercial item definition

**Requirement:**
The Menu service shall record a commercial product with its name, description, image reference, category, parent menu and fulfillment classification (stocked, prepared or combo).

**Type:** Functional requirements

**Source:** `docs/md/Modelo-Final.md` pp. 36–37

**Rationale:** Preserves the cited source fact or behavior within its stated scope without imposing an additional mechanism.

**Verification:** Demonstration: Record a product and compare the recorded information with the submitted definition.

**Status:** Confirmed

---

## Confirmed consumer UI requirements

The following requirements formalize the confirmed UI obligations requested for the waiter and administrator surfaces. They do not transfer ownership of external data to Menu; their missing external projections are recorded in OPEN-011 through OPEN-019.

<a id="req-ui-001"></a>
### REQ-UI-001 — Assigned table set

**Requirement:**
The ordering UI shall display only the tables included in the authorized table-assignment projection for the current waiter.

**Type:** Functional — Consumer UI

**Source:** Explicit UI decision in the user request dated 2026-09-13; consolidated as UI-REQ-001 in `output/ui-spec/ui-data-spec.md`.

**Rationale:** The waiter receives a limited set of tables from Sala and must not be offered tables outside that assignment.

**Verification:** Demonstration: load a projection containing assigned and unassigned tables and verify that only assigned tables are displayed.

**Status:** Confirmed

---

<a id="req-ui-002"></a>
### REQ-UI-002 — Table order distinction

**Requirement:**
The ordering UI shall distinguish a table with an associated order from a table without an associated order.

**Type:** Functional — Consumer UI

**Source:** Explicit UI decision in the user request dated 2026-09-13; consolidated as UI-REQ-002 in `output/ui-spec/ui-data-spec.md`.

**Rationale:** The distinction determines whether the waiter starts a new order or adds products to an existing order.

**Verification:** Demonstration: display both table states and verify that each state has a distinct visual indication.

**Status:** Confirmed

---

<a id="req-ui-003"></a>
### REQ-UI-003 — Append to existing order

**Requirement:**
The ordering UI shall allow preparing additional products for the order associated with a table that already has an order.

**Type:** Functional — Consumer UI

**Source:** Explicit UI decision in the user request dated 2026-09-13; consolidated as UI-REQ-003 in `output/ui-spec/ui-data-spec.md`.

**Rationale:** A table with an existing order must continue to accept new products.

**Verification:** Demonstration: open an existing order, create new draft lines and verify that confirmed lines remain identifiable and unchanged.

**Status:** Confirmed

---

<a id="req-ui-004"></a>
### REQ-UI-004 — Sellable catalog types

**Requirement:**
The ordering UI shall allow selecting catalog items with fulfillment type STOCKED, PREPARED or COMBO.

**Type:** Functional — Consumer UI

**Source:** Explicit UI decision in the user request dated 2026-09-13; consolidated as UI-REQ-004 in `output/ui-spec/ui-data-spec.md`.

**Rationale:** The waiter can order each supported Menu fulfillment type through the same catalog surface.

**Verification:** Demonstration: display one eligible item of each fulfillment type and verify that each opens its applicable configuration.

**Status:** Confirmed

---

<a id="req-ui-005"></a>
### REQ-UI-005 — Catalog search and filters

**Requirement:**
The ordering and administrative UIs shall provide name search and filters for category and commercial classification.

**Type:** Functional — Consumer UI

**Source:** Explicit UI decision in the user request dated 2026-09-13; consolidated as UI-REQ-005 in `output/ui-spec/ui-data-spec.md`.

**Rationale:** Both waiter and administrator catalog views require the same discovery dimensions.

**Verification:** Demonstration: apply each filter alone and in combination and verify that displayed cards satisfy the selected criteria.

**Status:** Confirmed

---

<a id="req-ui-006"></a>
### REQ-UI-006 — Local order draft editing

**Requirement:**
The ordering UI shall allow changing quantity, reconfiguring and removing each selected product before order confirmation.

**Type:** Functional — Consumer UI

**Source:** Explicit UI decision in the user request dated 2026-09-13; consolidated as UI-REQ-006 in `output/ui-spec/ui-data-spec.md`.

**Rationale:** These interactions manage the waiter’s local pre-order composition and are not individual backend CRUD operations.

**Verification:** Demonstration: change, reconfigure and remove a draft line and verify that confirmed lines and the catalog are unaffected.

**Status:** Confirmed

---

<a id="req-ui-007"></a>
### REQ-UI-007 — Item configuration before addition

**Requirement:**
The ordering UI shall allow configuring the applicable dimensions, modifiers, combo slots and combo options before adding an item to the order draft.

**Type:** Functional — Consumer UI

**Source:** Explicit UI decision in the user request dated 2026-09-13; consolidated as UI-REQ-007 in `output/ui-spec/ui-data-spec.md`.

**Rationale:** The selected line must preserve the customer’s concrete configuration before it is added to the pre-order.

**Verification:** Demonstration: configure a prepared item and a combo, add both to the draft and verify that their selections and quantities are retained.

**Status:** Confirmed

---

<a id="req-ui-008"></a>
### REQ-UI-008 — Administrative catalog management

**Requirement:**
The administrative UI shall provide catalog creation, editing, name search, category filtering and commercial-classification filtering.

**Type:** Functional — Consumer UI

**Source:** Explicit UI decision in the user request dated 2026-09-13; consolidated as UI-REQ-008 in `output/ui-spec/ui-data-spec.md`.

**Rationale:** The administrator requires the same catalog discovery capabilities as the waiter plus management actions.

**Verification:** Demonstration: open the administrative catalog, apply the confirmed filters and open both create and edit actions.

**Status:** Confirmed

---

<a id="req-ui-009"></a>
### REQ-UI-009 — Administrative lifecycle sections

**Requirement:**
The administrative UI shall present active, inactive, review-required and archived items as distinguishable catalog sections or filters.

**Type:** Functional — Consumer UI

**Source:** Explicit UI decision in the user request dated 2026-09-13 and current Menu lifecycle semantics; consolidated as UI-REQ-009 in `output/ui-spec/ui-data-spec.md`.

**Rationale:** Administrative status, review state and archival are distinct presentation dimensions.

**Verification:** Inspection: verify that each item appears under the correct dimension and that REVIEW_REQUIRED and ARCHIVED are not presented as ordinary INACTIVE status.

**Status:** Confirmed

---

<a id="req-ui-010"></a>
### REQ-UI-010 — Soft removal from archived section

**Requirement:**
The administrative UI shall allow removing one archived item, selected archived items or all archived items within the selected result scope as a soft-removal operation.

**Type:** Functional — Consumer UI

**Source:** Explicit UI decision in the user request dated 2026-09-13; consolidated as UI-REQ-010 in `output/ui-spec/ui-data-spec.md`.

**Rationale:** The requested “delete” actions remove items from the visible management set without physical database deletion.

**Verification:** Demonstration: execute the one-item, selected-items and all-results actions and verify that the UI does not represent physical deletion or history destruction.

**Status:** Confirmed

---

<a id="req-ui-011"></a>
### REQ-UI-011 — Item creation wizard

**Requirement:**
The administrative UI shall represent item creation in four steps: commercial classification and fulfillment type, item-specific configuration, modifier configuration, and configuration summary with acceptance.

**Type:** Functional — Consumer UI

**Source:** Explicit UI decision in the user request dated 2026-09-13; consolidated as UI-REQ-011 in `output/ui-spec/ui-data-spec.md`.

**Rationale:** Item creation changes its controls according to the selected classification, fulfillment type and configuration.

**Verification:** Demonstration: start creation for each fulfillment type, inspect all four steps and verify the final summary before acceptance.

**Status:** Confirmed

---

<a id="req-ui-012"></a>
### REQ-UI-012 — Item editing wizard

**Requirement:**
The administrative UI shall represent item editing in three steps: item configuration, modifier configuration and confirmation.

**Type:** Functional — Consumer UI

**Source:** Explicit UI decision in the user request dated 2026-09-13; consolidated as UI-REQ-012 in `output/ui-spec/ui-data-spec.md`.

**Rationale:** Editing an existing item does not require a new-item type selection step and must begin with preloaded data.

**Verification:** Demonstration: open an existing item, verify preloaded data and verify that the editor exposes exactly the three editing steps.

**Status:** Confirmed

---

<a id="req-ui-013"></a>
### REQ-UI-013 — Create and edit distinction

**Requirement:**
The administrative UI shall distinguish create and edit actions through their title, primary action, initial state and presence of preloaded data.

**Type:** Functional — Consumer UI

**Source:** Explicit UI decision in the user request dated 2026-09-13; consolidated as UI-REQ-013 in `output/ui-spec/ui-data-spec.md`.

**Rationale:** Creation and editing have different intent and data state even when they use related controls.

**Verification:** Inspection: compare CREATE and EDIT compositions and verify that they are not presented as the same operation.

**Status:** Confirmed

---

<a id="req-ui-014"></a>
### REQ-UI-014 — Pending review presentation

**Requirement:**
The administrative UI shall present a combo with pending review in a distinct editing context that identifies its affected variants and dependency changes.

**Type:** Functional — Consumer UI

**Source:** Explicit UI decision in the user request dated 2026-09-13 and E-19/E-20 review contracts; consolidated as UI-REQ-014 in `output/ui-spec/ui-data-spec.md`.

**Rationale:** The administrator must be able to identify what changed before acknowledging the review.

**Verification:** Demonstration: load a pending combo and verify a distinct review state, affected variants and observed changes.

**Status:** Confirmed

---

<a id="req-ui-015"></a>
### REQ-UI-015 — Pending review acknowledgement

**Requirement:**
The administrative UI shall allow acknowledging selected pending combo variants and shall clear the review indicator only after a refreshed Menu state reports UP_TO_DATE.

**Type:** Functional — Consumer UI

**Source:** Explicit UI decision in the user request dated 2026-09-13 and E-20/E-21 review contracts; consolidated as UI-REQ-014 in `output/ui-spec/ui-data-spec.md`.

**Rationale:** The UI must not claim verification merely because the administrator pressed Save; the resulting Menu state is authoritative.

**Verification:** Demonstration: acknowledge one or more variants, refresh the review state and verify that REVIEW_REQUIRED remains when new changes are pending.

**Status:** Confirmed

---

<a id="req-ui-016"></a>
### REQ-UI-016 — Pre-order accumulated cost

**Requirement:**
The ordering UI shall display the accumulated pre-order cost as the sum of the costs of its configured lines, while treating later Billing adjustments as outside that displayed accumulation.

**Type:** Functional — Consumer UI

**Source:** Explicit price clarification in the user request dated 2026-09-13 and the E-16 monetary summary; consolidated as UI-REQ-015 in `output/ui-spec/ui-data-spec.md`.

**Rationale:** The catalog price represents the cost of ordering the configured item; the UI must expose the sum of selected item costs without waiting for final Billing.

**Verification:** Demonstration: change quantities and configurations and verify `preorderTotal = Σ(quantity × resolvedUnitSubtotal)`; later Billing adjustments do not change the meaning of the displayed pre-order accumulation.

**Status:** Confirmed

---

<a id="req-menu-002"></a>
### REQ-MENU-002 — Administrative status

**Requirement:**
The Menu service shall allow changing the commercial status of a product between active and inactive.

**Type:** Functional requirements

**Source:** `docs/md/Modelo-Final.md` pp. 18–19

**Rationale:** Preserves the cited source fact or behavior within its stated scope without imposing an additional mechanism.

**Verification:** Test: Exercise both status transitions and inspect the resulting status.

**Status:** Confirmed

---

<a id="req-menu-003"></a>
### REQ-MENU-003 — Default sellable presentation

**Requirement:**
The Menu service shall provide one default sellable presentation for a product that has no customer-selectable variant dimensions.

**Type:** Functional requirements

**Source:** `docs/md/Modelo-Final.md` pp. 7–8

**Rationale:** Preserves the cited source fact or behavior within its stated scope without imposing an additional mechanism.

**Verification:** Test: Define a product without dimensions and verify that it has one sellable presentation without requiring a customer variant choice.

**Status:** Confirmed

---

<a id="req-menu-004"></a>
### REQ-MENU-004 — Variant dimension definition

**Requirement:**
The Menu service shall allow defining a named variation dimension for a commercial product.

**Type:** Functional requirements

**Source:** `docs/md/Modelo-Final.md` pp. 21, 36–37

**Rationale:** Preserves the cited source fact or behavior within its stated scope without imposing an additional mechanism.

**Verification:** Demonstration: Define a dimension and verify its name and associated product.

**Status:** Confirmed

**Related:** REQ-MENU-024

---

<a id="req-menu-005"></a>
### REQ-MENU-005 — Sellable variant definition

**Requirement:**
The Menu service shall allow defining a sellable variant by its combination of dimension values for a product, subject to BR-MENU-002 through BR-MENU-004.

**Type:** Functional requirements

**Source:** `docs/md/Modelo-Final.md` pp. 21

**Rationale:** Preserves the cited source fact or behavior within its stated scope without imposing an additional mechanism.

**Verification:** Test: Register a valid combination and attempt the contradictory, foreign-product and duplicate combinations prohibited by the referenced rules.

**Status:** Confirmed

---

<a id="req-menu-006"></a>
### REQ-MENU-006 — Absolute variant price

**Requirement:**
The Menu service shall allow assigning an absolute selling price to each sellable variant.

**Type:** Functional requirements

**Source:** `docs/md/Modelo-Final.md` pp. 26–28

**Rationale:** Preserves the cited source fact or behavior within its stated scope without imposing an additional mechanism.

**Verification:** Test: Assign different prices to two variants and verify each assigned price independently.

**Status:** Confirmed

---

<a id="req-menu-007"></a>
### REQ-MENU-007 — Eligible starting price

**Requirement:**
The Menu service shall display as the starting price the minimum price of variants eligible for a new sale under BR-MENU-023.

**Type:** REQ

**Source:** [ADR-008](../../docs/md/Decisiones-cierre-invariantes.md#adr-008)

**Rationale:** Closure decision adopted under user delegation; the cited decision records its basis, limits and alternatives.

**Verification:** Compare active available, inactive, archived and unavailable variants; only eligible variants enter the minimum.

**Status:** Confirmed

---

---

<a id="req-menu-008"></a>
### REQ-MENU-008 — Stocked fulfillment configuration

**Requirement:**
The Menu service shall allow specifying the inventory item and withdrawal quantity that fulfill a stocked sellable variant.

**Type:** Functional requirements

**Source:** `docs/md/Modelo-Final.md` pp. 8–9, 37

**Rationale:** Preserves the cited source fact or behavior within its stated scope without imposing an additional mechanism.

**Verification:** Test: Configure different inventory references and quantities for two presentations and verify their independent retrieval.

**Status:** Confirmed

---

<a id="req-menu-009"></a>
### REQ-MENU-009 — Prepared fulfillment configuration

**Requirement:**
The Menu service shall allow selecting the recipe used to prepare a sellable variant of a prepared product.

**Type:** Functional requirements

**Source:** `docs/md/Modelo-Final.md` pp. 8–9, 35–37

**Rationale:** Preserves the cited source fact or behavior within its stated scope without imposing an additional mechanism.

**Verification:** Test: Assign recipes to two sizes and verify the recipe selected for each size. A distinct recipe is not mandatory when both use the same formula.

**Status:** Confirmed

---

<a id="req-menu-010"></a>
### REQ-MENU-010 — Combo configuration

**Requirement:**
The Menu service shall allow defining the selection slots of each sellable combo variant.

**Type:** Functional requirements

**Source:** `docs/md/Modelo-Final.md` pp. 9–10, 37

**Rationale:** Preserves the cited source fact or behavior within its stated scope without imposing an additional mechanism.

**Verification:** Demonstration: Define distinct slot configurations for two combo variants and verify each configuration.

**Status:** Confirmed

---

<a id="req-menu-011"></a>
### REQ-MENU-011 — Combo slot definition

**Requirement:**
The Menu service shall allow configuring a combo selection slot with a name, minimum selection count and maximum selection count.

**Type:** Functional requirements

**Source:** `docs/md/Modelo-Final.md` pp. 10

**Rationale:** Preserves the cited source fact or behavior within its stated scope without imposing an additional mechanism.

**Verification:** Demonstration: Configure a named slot and compare its recorded limits with the supplied values.

**Status:** Confirmed

---

<a id="req-menu-012"></a>
### REQ-MENU-012 — Combo option definition

**Requirement:**
The Menu service shall allow configuring a slot option with a concrete STOCKED or PREPARED sellable variant and supplied quantity, without an option price adjustment.

**Type:** Functional requirements

**Source:** [ALIGN-002](../../docs/reviews/ers-interfaces-alignment/decisions.md); supersedes `docs/md/Modelo-Final.md` pp. 10, 31–32 on option pricing.

**Rationale:** Preserves the cited source fact or behavior within its stated scope without imposing an additional mechanism.

**Verification:** Test: Configure different supplied quantities in two slots; included choices never change the fixed combo base price.

**Status:** Confirmed

---

<a id="req-menu-013"></a>
### REQ-MENU-013 — Modifier group definition

**Requirement:**
The Menu service shall allow defining a named customization group for a product with minimum and maximum selection counts.

**Type:** Functional requirements

**Source:** `docs/md/Modelo-Final.md` pp. 12–13, 48

**Rationale:** Preserves the cited source fact or behavior within its stated scope without imposing an additional mechanism.

**Verification:** Demonstration: Define a group and verify its product, name and selection limits.

**Status:** Confirmed

---

<a id="req-menu-014"></a>
### REQ-MENU-014 — Modifier option definition

**Requirement:**
The Menu service shall allow defining a named customization option within a product customization group.

**Type:** Functional requirements

**Source:** `docs/md/Modelo-Final.md` pp. 42–44

**Rationale:** Preserves the cited source fact or behavior within its stated scope without imposing an additional mechanism.

**Verification:** Demonstration: Define an option and verify its name and group.

**Status:** Confirmed

---

<a id="req-menu-015"></a>
### REQ-MENU-015 — Variant modifier price

**Requirement:**
The Menu service shall allow configuring the relative price adjustment of a customization option for a specific sellable variant.

**Type:** Functional requirements

**Source:** `docs/md/Modelo-Final.md` pp. 42–47

**Rationale:** Preserves the cited source fact or behavior within its stated scope without imposing an additional mechanism.

**Verification:** Test: Configure different adjustments for the same option on two sizes and verify each value.

**Status:** Confirmed

**Related:** REQ-MENU-025

---

<a id="req-menu-016"></a>
### REQ-MENU-016 — Copy modifier configurations

**Requirement:**
The Menu service shall allow copying selected customization configurations, including their price adjustments, quantity limits and ingredient effects, from a source variant to a target variant.

**Type:** Functional requirements

**Source:** `docs/md/Modelo-Final.md` pp. 45–46

**Rationale:** Preserves the cited source fact or behavior within its stated scope without imposing an additional mechanism.

**Verification:** Test: Copy a selected configuration and compare all three parameter groups at the destination with the source. E-17 defines FAIL/REPLACE for existing destinations.

**Status:** Confirmed

**Related:** REQ-MENU-026

**Active contract:** [E-17](../interfaces/apis/entrada/E-17.md); [ALIGN](../../docs/reviews/ers-interfaces-alignment/decisions.md)

---

<a id="req-menu-017"></a>
### REQ-MENU-017 — Ingredient addition directive

**Requirement:**
The Menu service shall allow configuring an ingredient addition for a customization on a specific variant, identifying the inventory item, quantity to add and measurement unit.

**Type:** Functional requirements

**Source:** `docs/md/Modelo-Final.md` pp. 34, 42–43

**Rationale:** Preserves the cited source fact or behavior within its stated scope without imposing an additional mechanism.

**Verification:** Test: Configure additions of different quantities for the same option on two variants and verify each effect.

**Status:** Confirmed

---

<a id="req-menu-018"></a>
### REQ-MENU-018 — Ingredient omission directive

**Requirement:**
The Menu service shall allow configuring an ingredient omission for a customization on a specific variant by identifying the inventory item to omit from preparation.

**Type:** Functional requirements

**Source:** `docs/md/Modelo-Final.md` pp. 33–34, 46

**Rationale:** Preserves the cited source fact or behavior within its stated scope without imposing an additional mechanism.

**Verification:** Test: Configure an omission and verify the identified ingredient and omission directive.

**Status:** Confirmed

---

<a id="req-menu-019"></a>
### REQ-MENU-019 — Preparation customization without ingredient effects

**Requirement:**
The Menu service shall allow defining a preparation customization for a variant without any associated ingredient effects.

**Type:** Functional requirements

**Source:** `docs/md/Problema-Inicial.md` pp. 108–110; `docs/md/Modelo-Final.md` pp. 42

**Rationale:** Preserves the cited source fact or behavior within its stated scope without imposing an additional mechanism.

**Verification:** Test: Define a cooking instruction with no ingredient effects and verify that the configuration is accepted.

**Status:** Confirmed

---

<a id="req-menu-020"></a>
### REQ-MENU-020 — Recipe definition

**Requirement:**
The Menu service shall allow defining a culinary recipe with a name, version and ingredient composition specifying each inventory item, required quantity and measurement unit.

**Type:** Functional requirements

**Source:** `docs/md/Modelo-Final.md` pp. 20–23, 37–38

**Rationale:** Preserves the cited source fact or behavior within its stated scope without imposing an additional mechanism.

**Verification:** Demonstration: Define a recipe with several components and compare the recorded composition with the supplied definition.

**Status:** Confirmed

---

<a id="req-menu-021"></a>
### REQ-MENU-021 — Recipe revisions

**Requirement:**
The Menu service shall create a new immutable recipe revision when a change to its name or composition is accepted.

**Type:** REQ

**Source:** [ADR-006](../../docs/md/Decisiones-cierre-invariantes.md#adr-006)

**Rationale:** Closure decision adopted under user delegation; the cited decision records its basis, limits and alternatives.

**Verification:** Change composition and name separately; verify new revisions without altering the prior revisions.

**Status:** Confirmed

---

---

<a id="req-menu-022"></a>
### REQ-MENU-022 — Catalog publication

**Requirement:**
The Menu service shall expose catalog definitions and invalidate consumer views upon effective commercial or availability changes.

**Type:** REQ

**Source:** [ALIGN](../../docs/reviews/ers-interfaces-alignment/decisions.md)

**Rationale:** Explicit user decision in ALIGN; supersedes incompatible earlier wording.

**Verification:** Inspect E-01–E-03 and M-07/M-08; stock changes do not create commercial revisions.

**Status:** Confirmed

---

<a id="req-menu-023"></a>
### REQ-MENU-023 — Removal continuity classification

**Requirement:**
The continuity obligation is consolidated under QA-MENU-002 and its design constraint under CON-MENU-008. This identifier is retained for traceability, not as a second obligation.

**Type:** Functional requirements

**Source:** `docs/md/Auditoria-3.md` pp. 8–9

**Rationale:** Preserves the cited source fact or behavior within its stated scope without imposing an additional mechanism.

**Verification:** Inspection: Follow QA-MENU-002.

**Status:** Reclassified

---

<a id="req-menu-024"></a>
### REQ-MENU-024 — Dimension value definition

**Requirement:**
The Menu service shall allow defining named values within a product variation dimension.

**Type:** Functional requirements

**Source:** `docs/md/Modelo-Final.md` pp. 21, 36–37

**Rationale:** Preserves the cited source fact or behavior within its stated scope without imposing an additional mechanism.

**Verification:** Demonstration: Define two values and verify their association with the selected dimension.

**Status:** Confirmed

---

<a id="req-menu-025"></a>
### REQ-MENU-025 — Variant modifier quantity cap

**Requirement:**
The Menu service shall allow configuring the maximum selectable quantity of a customization option for a specific sellable variant.

**Type:** Functional requirements

**Source:** `docs/md/Modelo-Final.md` pp. 47–48

**Rationale:** Preserves the cited source fact or behavior within its stated scope without imposing an additional mechanism.

**Verification:** Test: Configure different caps for two sizes and verify each cap independently of its price.

**Status:** Confirmed

---

<a id="req-menu-026"></a>
### REQ-MENU-026 — Copy combo configuration

**Requirement:**
The Menu service shall allow copying selection slots and their options from a source combo variant to a target combo variant.

**Type:** Functional requirements

**Source:** `docs/md/Modelo-Final.md` pp. 30–31

**Rationale:** Preserves the cited source fact or behavior within its stated scope without imposing an additional mechanism.

**Verification:** Test: Copy a combo configuration and compare the resulting slots and option definitions with the source.

**Status:** Confirmed

**Active contract:** [E-17](../interfaces/apis/entrada/E-17.md); [ALIGN](../../docs/reviews/ers-interfaces-alignment/decisions.md)

---

<a id="req-menu-027"></a>
### REQ-MENU-027 — Bulk combo option assignment

**Requirement:**
The Menu service shall allow applying a selected set of component options to multiple selected combo variants in one administrative operation.

**Type:** Functional requirements

**Source:** `docs/md/Modelo-Final.md` pp. 31

**Rationale:** Preserves the cited source fact or behavior within its stated scope without imposing an additional mechanism.

**Verification:** Demonstration: Apply a selected set to two combo variants and verify associations by explicit slot IDs according to E-17.

**Status:** Confirmed

**Active contract:** [E-17](../interfaces/apis/entrada/E-17.md); [ALIGN](../../docs/reviews/ers-interfaces-alignment/decisions.md)

---

<a id="req-menu-028"></a>
### REQ-MENU-028 — Archive variant

**Requirement:**
The Menu service shall allow withdrawing a variant by transitioning it to ARCHIVED, subject to the validity of dependent active configurations.

**Type:** REQ

**Source:** [ADR-003](../../docs/md/Decisiones-cierre-invariantes.md#adr-003)

**Rationale:** Closure decision adopted under user delegation; the cited decision records its basis, limits and alternatives.

**Verification:** Archive a variant with historical orders; verify retained history and exclusion from new offers.

**Status:** Confirmed

---

<a id="req-menu-029"></a>
### REQ-MENU-029 — Save incomplete capacity

**Requirement:**
The Menu service shall allow saving an INACTIVE configuration with incomplete selection capacity.

**Type:** REQ

**Source:** [ADR-005](../../docs/md/Decisiones-cierre-invariantes.md#adr-005)

**Rationale:** Closure decision adopted under user delegation; the cited decision records its basis, limits and alternatives.

**Verification:** Save a group with minimum 2 and no options while inactive; verify persistence.

**Status:** Confirmed

---

<a id="req-menu-030"></a>
### REQ-MENU-030 — Report incomplete capacity

**Requirement:**
The Menu service shall identify the group or slot with insufficient capacity when saving an incomplete configuration.

**Type:** REQ

**Source:** [ADR-005](../../docs/md/Decisiones-cierre-invariantes.md#adr-005)

**Rationale:** Closure decision adopted under user delegation; the cited decision records its basis, limits and alternatives.

**Verification:** Verify warning identifies group or slot, required minimum and available capacity.

**Status:** Confirmed

---

<a id="req-menu-031"></a>
### REQ-MENU-031 — No eligible price

**Requirement:**
The Menu service shall present the product as unavailable without a numeric starting price when it has no eligible variants.

**Type:** REQ

**Source:** [ADR-008](../../docs/md/Decisiones-cierre-invariantes.md#adr-008)

**Rationale:** Closure decision adopted under user delegation; the cited decision records its basis, limits and alternatives.

**Verification:** Make all variants ineligible; verify no zero-price fallback or archived price.

**Status:** Confirmed

---

<a id="req-menu-032"></a>
### REQ-MENU-032 — Net ingredient resolution

**Requirement:**
The Menu service shall resolve the net ingredients of a selected line from its pinned product and recipe versions and component and modifier quantities.

**Type:** REQ

**Source:** [ADR-003](../../docs/md/Decisiones-cierre-invariantes.md#adr-003)

**Rationale:** Closure decision adopted under user delegation; the cited decision records its basis, limits and alternatives.

**Verification:** Use base ingredient 30 g, OMIT base and ADD 10 g twice; result is 20 g, scoped to its component.

**Status:** Confirmed

---

<a id="req-menu-033"></a>
### REQ-MENU-033 — Product revision

**Requirement:**
The Menu service shall create a new immutable product revision for each accepted change to its commercial or executable definition.

**Type:** REQ

**Source:** [ADR-006](../../docs/md/Decisiones-cierre-invariantes.md#adr-006)

**Rationale:** Closure decision adopted under user delegation; the cited decision records its basis, limits and alternatives.

**Verification:** Change variant price or modifier configuration; prior version remains unchanged. Derived stock availability is not a definition edit.

**Status:** Confirmed

---

<a id="req-menu-034"></a>
### REQ-MENU-034 — Default variant migration

**Requirement:**
The Menu service shall apply the commercial replacement of DEFAULT by dimensioned variants as a single product revision.

**Type:** REQ

**Source:** [ADR-008](../../docs/md/Decisiones-cierre-invariantes.md#adr-008)

**Rationale:** Closure decision adopted under user delegation; the cited decision records its basis, limits and alternatives.

**Verification:** Attempt incomplete migration, then publish a valid migration; no partial sellable revision is visible.

**Status:** Confirmed

---

<a id="req-menu-035"></a>
### REQ-MENU-035 — Combo review detection

**Requirement:**
The Menu service shall mark a combo variant for review when a configured component variant has an unacknowledged relevant price, composition, modifier or state change.

**Type:** REQ

**Source:** [ALIGN](../../docs/reviews/ers-interfaces-alignment/decisions.md)

**Rationale:** Explicit user decision in ALIGN; supersedes incompatible earlier wording.

**Verification:** Include disabled options; ignore cosmetics, stock and unrelated variants; recipe only after adoption.

**Status:** Confirmed

---

<a id="req-menu-036"></a>
### REQ-MENU-036 — Administrative review visibility

**Requirement:**
The Menu service shall expose the pending review variants and an aggregated review indicator for each combo in administrative reads.

**Type:** REQ

**Source:** [ALIGN](../../docs/reviews/ers-interfaces-alignment/decisions.md)

**Rationale:** Explicit user decision in ALIGN; supersedes incompatible earlier wording.

**Verification:** Inspect E-19/E-20; non-combos have no review state.

**Status:** Confirmed

---

<a id="req-menu-037"></a>
### REQ-MENU-037 — Observed review acknowledgement

**Requirement:**
The Menu service shall acknowledge only the dependency changes identified by the observed review tokens submitted for explicitly selected combo variants.

**Type:** REQ

**Source:** [ALIGN](../../docs/reviews/ers-interfaces-alignment/decisions.md)

**Rationale:** Explicit user decision in ALIGN; supersedes incompatible earlier wording.

**Verification:** Confirm one, several or all displayed variants; concurrent new changes remain pending.

**Status:** Confirmed

---

<a id="req-menu-038"></a>
### REQ-MENU-038 — Preserve reviewed configuration

**Requirement:**
The Menu service shall allow acknowledgement without changing the combo price or pinned composition.

**Type:** REQ

**Source:** [ALIGN](../../docs/reviews/ers-interfaces-alignment/decisions.md)

**Rationale:** Explicit user decision in ALIGN; supersedes incompatible earlier wording.

**Verification:** Acknowledge and keep old reference: no commercial revision and no reactivation of retired option.

**Status:** Confirmed

---

<a id="req-menu-039"></a>
### REQ-MENU-039 — Visual slot reference

**Requirement:**
The Menu service shall expose saved and current component-price sums and their difference for each administrative slot base selection.

**Type:** REQ

**Source:** [ALIGN](../../docs/reviews/ers-interfaces-alignment/decisions.md)

**Rationale:** Explicit user decision in ALIGN; supersedes incompatible earlier wording.

**Verification:** Multiply by supplied quantities; reference changes never overwrite combo selling price.

**Status:** Confirmed
