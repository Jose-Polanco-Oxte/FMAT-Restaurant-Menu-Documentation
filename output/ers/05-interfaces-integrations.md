[← Index](./index.md)

# Integration obligations

Each block states one primary obligation. Enumerated attributes describe one fact or operation, not independent steps. Verification entries are proposed acceptance criteria, not executed software tests. Model names identify domain concepts, not required technologies. `Auditoria-4.md` is the active source for the corrected combo, modifier and order-line contracts.

---

Orders obligations are explicitly external to Menu ownership.
---

<a id="int-menu-001"></a>
### INT-MENU-001 — Catalog contracts

**Requirement:**
The Menu service shall expose catalog reads through E-01–E-03 and invalidations through M-07/M-08.

**Type:** INT

**Source:** [ALIGN](../../docs/reviews/ers-interfaces-alignment/decisions.md)


**Verification:** Inspect complete endpoint/event contracts and authorization.

**Status:** Confirmed

---

<a id="int-menu-002"></a>
### INT-MENU-002 — Preparation orchestration

**Requirement:**
The Orders service shall deliver preparation information resolved by Menu to Kitchen as the order orchestrator.

**Type:** INT

**Source:** [ALIGN](../../docs/reviews/ers-interfaces-alignment/decisions.md)


**Verification:** Inspect E-16 as the Menu boundary; no direct Menu–Kitchen contract.

**Status:** Confirmed

---

<a id="int-menu-003"></a>
### INT-MENU-003 — Inventory logical references

**Requirement:**
The Menu service shall identify externally owned inventory items through logical inventory references in stocked fulfillment, recipe components and ingredient effects.

**Type:** Integration obligations

**Source:** `docs/md/Modelo-Final.md` pp. 19–21, 37–38


**Verification:** Inspection: Verify that the three kinds of reference identify Inventory-owned items without importing their internal entity model.

**Status:** Confirmed

---

<a id="int-menu-004"></a>
### INT-MENU-004 — Immutable unit price summary

**Requirement:**
The Orders service shall retain the resolved unitPrice, aggregated modifier extras, unit subtotal and currency for the selected sellable leaf variant or ComboConfiguration when creating its line.

**Type:** INT

**Source:** [ALIGN](../../docs/reviews/ers-interfaces-alignment/decisions.md)


**Verification:** Change catalog prices and verify the stored summary is unchanged; the summary contains the selected sellable unit price and aggregate, not a component price breakdown.

**Status:** Confirmed

---

<a id="int-menu-005"></a>
### INT-MENU-005 — Administrative copy contract

**Requirement:**
The Menu service shall expose same-MenuItem atomic copy and assignment operations through E-17 with ID matching, FAIL/REPLACE, dry run and concurrency validation.

**Type:** INT

**Source:** [ALIGN](../../docs/reviews/ers-interfaces-alignment/decisions.md)


**Verification:** Inspect configuraciones.md; test conflicting destinations and zero partial writes.

**Status:** Confirmed

---

<a id="int-menu-006"></a>
### INT-MENU-006 — Selection audit references

**Requirement:**
The Orders service shall preserve versioned selection references with its resolved unit price summary.

**Type:** INT

**Source:** [ALIGN](../../docs/reviews/ers-interfaces-alignment/decisions.md)


**Verification:** Verify references are not used to reconstruct charged values from current catalog.

**Status:** Confirmed

---

<a id="int-menu-007"></a>
### INT-MENU-007 — Freeform order instructions

**Requirement:**
The Orders service shall retain unconfigured customer preparation instructions as free text on the corresponding order item.

**Type:** Integration obligations

**Source:** `docs/md/Problema-Inicial.md` pp. 109–111


**Verification:** Demonstration: Record a freeform instruction on one order item and verify its association with that item.

**Status:** Confirmed

---

<a id="int-menu-008"></a>
### INT-MENU-008 — Publish requirements

**Requirement:**
The Menu service shall publish changes and withdrawals of flat inventory requirements with an opaque key and definition revision.

**Type:** INT

**Source:** [ADR-001](../../docs/md/Decisiones-cierre-invariantes.md#adr-001)


**Verification:** Edit a recipe binding or stocked quantity; verify changed requirements, not an echoed availability result.

**Status:** Confirmed

---

<a id="int-menu-009"></a>
### INT-MENU-009 — Inventory evaluation

**Requirement:**
The Inventory service shall emit availability of received requirements with their key, definition revision, increasing evaluation revision and explicit expiry.

**Type:** INT

**Source:** [ADR-001](../../docs/md/Decisiones-cierre-invariantes.md#adr-001)


**Verification:** Verify the result carries every correlation and freshness field.

**Status:** Confirmed

---

<a id="int-menu-010"></a>
### INT-MENU-010 — Accept current evaluation

**Requirement:**
The Menu service shall ignore availability evaluations for another definition revision or older than the latest accepted evaluation.

**Type:** INT

**Source:** [ADR-001](../../docs/md/Decisiones-cierre-invariantes.md#adr-001)


**Verification:** Deliver new then old evaluation and a mismatched definition; neither stale result replaces current state.

**Status:** Confirmed

---

<a id="int-menu-011"></a>
### INT-MENU-011 — Fail closed availability

**Requirement:**
The Menu service shall present a variant as unavailable without a current positive evaluation or upon detecting Inventory service unavailability.

**Type:** INT

**Source:** [ADR-001](../../docs/md/Decisiones-cierre-invariantes.md#adr-001)


**Verification:** Test missing, expired, negative results and detected outage; recovery requires fresh positive evaluation.

**Status:** Confirmed

---

<a id="int-menu-012"></a>
### INT-MENU-012 — Snapshot movement

**Requirement:**
The Orders service shall send Inventory the persisted line movement content without reconstructing it from the current availability projection.

**Type:** INT

**Source:** [ADR-003](../../docs/md/Decisiones-cierre-invariantes.md#adr-003)


**Verification:** Change projection before delivery; sent quantities match the stored movement.

**Status:** Confirmed

---

<a id="int-menu-013"></a>
### INT-MENU-013 — Idempotent movement

**Requirement:**
The Inventory service shall apply each movement identity at most once.

**Type:** INT

**Source:** [ADR-003](../../docs/md/Decisiones-cierre-invariantes.md#adr-003)


**Verification:** Deliver identical movement twice and verify one stock effect.

**Status:** Confirmed

---

<a id="int-menu-014"></a>
### INT-MENU-014 — Identity payload conflict

**Requirement:**
The Inventory service shall reject reuse of a movement identity with different content.

**Type:** INT

**Source:** [ADR-003](../../docs/md/Decisiones-cierre-invariantes.md#adr-003)


**Verification:** Retry the same identity with changed quantity; verify rejection and unchanged stock.

**Status:** Confirmed

---

<a id="int-menu-015"></a>
### INT-MENU-015 — Exact reversal

**Requirement:**
The Inventory service shall limit an authorized reversal to the inventory items and quantities not yet reversed from the original applied movement.

**Type:** INT

**Source:** [ADR-003](../../docs/md/Decisiones-cierre-invariantes.md#adr-003)


**Verification:** Reject reversal before application and over-reversal; a valid reversal uses original quantities.

**Status:** Confirmed

---

<a id="int-menu-016"></a>
### INT-MENU-016 — Pinned order version

**Requirement:**
The Orders service shall preserve the product version selected when an existing line is created until that line is explicitly modified.

**Type:** INT

**Source:** [ADR-006](../../docs/md/Decisiones-cierre-invariantes.md#adr-006)


**Verification:** Create line on v1, publish v2, verify unchanged existing line.

**Status:** Confirmed

---

<a id="int-menu-017"></a>
### INT-MENU-017 — Atomic stock acceptance

**Requirement:**
The Inventory service shall accept a deduction only if it can apply the complete requested net list against current stock.

**Type:** INT

**Source:** [ADR-001](../../docs/md/Decisiones-cierre-invariantes.md#adr-001)


**Verification:** Two requests compete for last stock; no partial deduction or oversell based on the availability projection.

**Status:** Confirmed

---

<a id="int-menu-018"></a>
### INT-MENU-018 — Confirmation outcome

**Requirement:**
The Orders service shall confirm a line request only after receiving Inventory acceptance of its deduction.

**Type:** INT

**Source:** [ADR-003](../../docs/md/Decisiones-cierre-invariantes.md#adr-003)


**Verification:** Delay response: line stays pending; rejection prevents confirmation; repeated acceptance does not duplicate confirmation.

**Status:** Confirmed

---

<a id="int-menu-019"></a>
### INT-MENU-019 — Combo availability

**Requirement:**
The Menu service shall consider a ComboConfiguration available only if each slot can satisfy its minimum with eligible leaf variants for their configured quantities.

**Type:** INT

**Source:** [ADR-001](../../docs/md/Decisiones-cierre-invariantes.md#adr-001)


**Verification:** Required slot without options blocks; optional empty slot does not; aggregate stock is rechecked at confirmation.

**Status:** Confirmed

---

<a id="int-menu-020"></a>
### INT-MENU-020 — Minimal unit price response

**Requirement:**
The Menu service shall return only unitPrice, extrasTotal, unitSubtotal and currency in the pricing section of E-16 for the requested sellable unit.

**Type:** INT

**Source:** [ALIGN](../../docs/reviews/ers-interfaces-alignment/decisions.md)


**Verification:** Closed PriceSummary schema rejects component/slot/modifier price terms; ComboOption.priceDelta is included in unitSubtotal but is not returned as a separate term.

**Status:** Confirmed

---

<a id="int-menu-021"></a>
### INT-MENU-021 — Withdrawal tombstones

**Requirement:**
The Menu service shall preserve withdrawal revisions so delayed evaluations cannot resurrect retired availability definitions.

**Type:** INT

**Source:** [ALIGN](../../docs/reviews/ers-interfaces-alignment/decisions.md)


**Verification:** Inspect M-02/M-03 and deliver a delayed positive after withdrawal.

**Status:** Confirmed

---

<a id="int-menu-022"></a>
### INT-MENU-022 — Evaluation content conflicts

**Requirement:**
The Menu service shall treat identical evaluation revisions with different content as conflicts instead of replacing accepted availability.

**Type:** INT

**Source:** [ALIGN](../../docs/reviews/ers-interfaces-alignment/decisions.md)


**Verification:** M-03 identical duplicate ignored; changed duplicate rejected/quarantined.

**Status:** Confirmed

---

<a id="int-menu-023"></a>
### INT-MENU-023 — Recovery identity

**Requirement:**
The Menu service shall require a fresh valid evaluation matching the pending reevaluationRequestId before completing requested recovery.

**Type:** INT

**Source:** [ALIGN](../../docs/reviews/ers-interfaces-alignment/decisions.md)


**Verification:** Old response and expired positive never unlock recovery; inspect M-04/M-03/E-18.

**Status:** Confirmed

---

<a id="int-menu-024"></a>
### INT-MENU-024 — Inventory ingredient catalog

**Requirement:**
The Inventory service shall provide a catalog of items usable as ingredients or STOCKED references with at least item identifier, name and measurement unit.

**Type:** INT — External dependency

**Source:** [Inventory clarification](../../docs/reviews/ers-interfaces-alignment/decisions.md)


**Verification:** Inspect the Inventory contract when available; each selectable item includes the three required data elements. Quantity limits and conversion rules remain OPEN-010.

**Status:** Confirmed

---

<a id="int-menu-025"></a>
### INT-MENU-025 — Inventory catalog search

**Requirement:**
The Inventory service shall provide search over the catalog used to select ingredients and STOCKED item references during administration.

**Type:** INT — External dependency

**Source:** [Inventory clarification](../../docs/reviews/ers-interfaces-alignment/decisions.md)


**Verification:** Demonstrate searching the supplied catalog and selecting an item by its identifier and unit. Search matching, route and pagination await the Inventory contract.

**Status:** Confirmed

---

<a id="int-menu-026"></a>
### INT-MENU-026 — Effective modifier publication

**Requirement:**
The Menu service shall expose a resolved modifier projection for each published leaf variant so that POS and KDS can consume effective applicability, priceDelta, maxQuantity and ingredientEffects without resolving a default and exception at order time.

**Type:** INT

**Source:** `docs/md/Auditoria-4.md`, items 14–18 and 21–22.


**Verification:** Inspect a published leaf catalog response containing one default-only variant and one exception variant; each exposes its effective configuration.

**Status:** Confirmed

---

<a id="int-menu-027"></a>
### INT-MENU-027 — Combo configuration selection

**Requirement:**
The Menu service shall expose ComboConfiguration identities as the sellable selection reference for COMBO products and MenuItemVariant identities as the sellable selection reference for PREPARED and STOCKED products.

**Type:** INT

**Source:** `docs/md/Auditoria-4.md`, items 1–5, 23–32 and 43.


**Verification:** Inspect ResolutionRequest and Resolution examples for one leaf and one combo; the leaf uses variantId and the combo uses configurationId.

**Status:** Confirmed

---

<a id="int-menu-028"></a>
### INT-MENU-028 — Order-line variant revalidation

**Requirement:**
The Orders service shall revalidate price, availability, effective modifiers and inventory effects when an existing leaf order line changes its selected variant.

**Type:** INT

**Source:** `docs/md/Auditoria-4.md`, items 43–45.


**Verification:** Demonstration: edit a line from one leaf variant to another and verify that all four listed domains are evaluated before accepting the edited line.

**Status:** Confirmed

---

<a id="int-menu-029"></a>
### INT-MENU-029 — Personalized order-line separation

**Requirement:**
The Orders service shall represent different modifier selections for the same leaf item and variant as different order lines.

**Type:** INT

**Source:** `docs/md/Auditoria-4.md`, items 43–46.


**Verification:** Submit two selections with the same item and variant and different modifiers; verify that they remain two distinct lines.

**Status:** Confirmed
