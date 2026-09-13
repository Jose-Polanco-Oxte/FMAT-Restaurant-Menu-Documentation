[← Index](./index.md)

# Integration obligations

Each block states one primary obligation. Enumerated attributes describe one fact or operation, not independent steps. Verification entries are proposed acceptance criteria, not executed software tests. Model names identify domain concepts, not required technologies.

---

Orders obligations are explicitly external to Menu ownership.
---

<a id="int-menu-001"></a>
### INT-MENU-001 — Catalog contracts

**Requirement:**
The Menu service shall expose catalog reads through E-01–E-03 and invalidations through M-07/M-08.

**Type:** INT

**Source:** [ALIGN](../../docs/reviews/ers-interfaces-alignment/decisions.md)

**Rationale:** Explicit user decision in ALIGN; supersedes incompatible earlier wording.

**Verification:** Inspect complete endpoint/event contracts and authorization.

**Status:** Confirmed

---

<a id="int-menu-002"></a>
### INT-MENU-002 — Preparation orchestration

**Requirement:**
The Orders service shall deliver preparation information resolved by Menu to Kitchen as the order orchestrator.

**Type:** INT

**Source:** [ALIGN](../../docs/reviews/ers-interfaces-alignment/decisions.md)

**Rationale:** Explicit user decision in ALIGN; supersedes incompatible earlier wording.

**Verification:** Inspect E-16 as the Menu boundary; no direct Menu–Kitchen contract.

**Status:** Confirmed

---

<a id="int-menu-003"></a>
### INT-MENU-003 — Inventory logical references

**Requirement:**
The Menu service shall identify externally owned inventory items through logical inventory references in stocked fulfillment, recipe components and ingredient effects.

**Type:** Integration obligations

**Source:** `docs/md/Modelo-Final.md` pp. 19–21, 37–38

**Rationale:** Preserves the cited source fact or behavior within its stated scope without imposing an additional mechanism.

**Verification:** Inspection: Verify that the three kinds of reference identify Inventory-owned items without importing their internal entity model.

**Status:** Confirmed

---

<a id="int-menu-004"></a>
### INT-MENU-004 — Immutable unit price summary

**Requirement:**
The Orders service shall retain the resolved base price, aggregated extras, unit subtotal and currency for the selected sellable variant when creating its line.

**Type:** INT

**Source:** [ALIGN](../../docs/reviews/ers-interfaces-alignment/decisions.md)

**Rationale:** Explicit user decision in ALIGN; supersedes incompatible earlier wording.

**Verification:** Change catalog prices and verify the stored summary is unchanged; individual modifier prices are not required.

**Status:** Confirmed

---

<a id="int-menu-005"></a>
### INT-MENU-005 — Administrative copy contract

**Requirement:**
The Menu service shall expose same-MenuItem atomic copy and assignment operations through E-17 with ID matching, FAIL/REPLACE, dry run and concurrency validation.

**Type:** INT

**Source:** [ALIGN](../../docs/reviews/ers-interfaces-alignment/decisions.md)

**Rationale:** Explicit user decision in ALIGN; supersedes incompatible earlier wording.

**Verification:** Inspect configuraciones.md; test conflicting destinations and zero partial writes.

**Status:** Confirmed

---

<a id="int-menu-006"></a>
### INT-MENU-006 — Selection audit references

**Requirement:**
The Orders service shall preserve versioned selection references with its resolved unit price summary.

**Type:** INT

**Source:** [ALIGN](../../docs/reviews/ers-interfaces-alignment/decisions.md)

**Rationale:** Explicit user decision in ALIGN; supersedes incompatible earlier wording.

**Verification:** Verify references are not used to reconstruct charged values from current catalog.

**Status:** Confirmed

---

<a id="int-menu-007"></a>
### INT-MENU-007 — Freeform order instructions

**Requirement:**
The Orders service shall retain unconfigured customer preparation instructions as free text on the corresponding order item.

**Type:** Integration obligations

**Source:** `docs/md/Problema-Inicial.md` pp. 109–111

**Rationale:** Preserves the cited source fact or behavior within its stated scope without imposing an additional mechanism.

**Verification:** Demonstration: Record a freeform instruction on one order item and verify its association with that item.

**Status:** Confirmed

---

<a id="int-menu-008"></a>
### INT-MENU-008 — Publish requirements

**Requirement:**
The Menu service shall publish changes and withdrawals of flat inventory requirements with an opaque key and definition revision.

**Type:** INT

**Source:** [ADR-001](../../docs/md/Decisiones-cierre-invariantes.md#adr-001)

**Rationale:** Closure decision adopted under user delegation; the cited decision records its basis, limits and alternatives.

**Verification:** Edit a recipe binding or stocked quantity; verify changed requirements, not an echoed availability result.

**Status:** Confirmed

---

<a id="int-menu-009"></a>
### INT-MENU-009 — Inventory evaluation

**Requirement:**
The Inventory service shall emit availability of received requirements with their key, definition revision, increasing evaluation revision and explicit expiry.

**Type:** INT

**Source:** [ADR-001](../../docs/md/Decisiones-cierre-invariantes.md#adr-001)

**Rationale:** Closure decision adopted under user delegation; the cited decision records its basis, limits and alternatives.

**Verification:** Verify the result carries every correlation and freshness field.

**Status:** Confirmed

---

<a id="int-menu-010"></a>
### INT-MENU-010 — Accept current evaluation

**Requirement:**
The Menu service shall ignore availability evaluations for another definition revision or older than the latest accepted evaluation.

**Type:** INT

**Source:** [ADR-001](../../docs/md/Decisiones-cierre-invariantes.md#adr-001)

**Rationale:** Closure decision adopted under user delegation; the cited decision records its basis, limits and alternatives.

**Verification:** Deliver new then old evaluation and a mismatched definition; neither stale result replaces current state.

**Status:** Confirmed

---

<a id="int-menu-011"></a>
### INT-MENU-011 — Fail closed availability

**Requirement:**
The Menu service shall present a variant as unavailable without a current positive evaluation or upon detecting Inventory service unavailability.

**Type:** INT

**Source:** [ADR-001](../../docs/md/Decisiones-cierre-invariantes.md#adr-001)

**Rationale:** Closure decision adopted under user delegation; the cited decision records its basis, limits and alternatives.

**Verification:** Test missing, expired, negative results and detected outage; recovery requires fresh positive evaluation.

**Status:** Confirmed

---

<a id="int-menu-012"></a>
### INT-MENU-012 — Snapshot movement

**Requirement:**
The Orders service shall send Inventory the persisted line movement content without reconstructing it from the current availability projection.

**Type:** INT

**Source:** [ADR-003](../../docs/md/Decisiones-cierre-invariantes.md#adr-003)

**Rationale:** Closure decision adopted under user delegation; the cited decision records its basis, limits and alternatives.

**Verification:** Change projection before delivery; sent quantities match the stored movement.

**Status:** Confirmed

---

<a id="int-menu-013"></a>
### INT-MENU-013 — Idempotent movement

**Requirement:**
The Inventory service shall apply each movement identity at most once.

**Type:** INT

**Source:** [ADR-003](../../docs/md/Decisiones-cierre-invariantes.md#adr-003)

**Rationale:** Closure decision adopted under user delegation; the cited decision records its basis, limits and alternatives.

**Verification:** Deliver identical movement twice and verify one stock effect.

**Status:** Confirmed

---

<a id="int-menu-014"></a>
### INT-MENU-014 — Identity payload conflict

**Requirement:**
The Inventory service shall reject reuse of a movement identity with different content.

**Type:** INT

**Source:** [ADR-003](../../docs/md/Decisiones-cierre-invariantes.md#adr-003)

**Rationale:** Closure decision adopted under user delegation; the cited decision records its basis, limits and alternatives.

**Verification:** Retry the same identity with changed quantity; verify rejection and unchanged stock.

**Status:** Confirmed

---

<a id="int-menu-015"></a>
### INT-MENU-015 — Exact reversal

**Requirement:**
The Inventory service shall limit an authorized reversal to the inventory items and quantities not yet reversed from the original applied movement.

**Type:** INT

**Source:** [ADR-003](../../docs/md/Decisiones-cierre-invariantes.md#adr-003)

**Rationale:** Closure decision adopted under user delegation; the cited decision records its basis, limits and alternatives.

**Verification:** Reject reversal before application and over-reversal; a valid reversal uses original quantities.

**Status:** Confirmed

---

<a id="int-menu-016"></a>
### INT-MENU-016 — Pinned order version

**Requirement:**
The Orders service shall preserve the product version selected when an existing line is created until that line is explicitly modified.

**Type:** INT

**Source:** [ADR-006](../../docs/md/Decisiones-cierre-invariantes.md#adr-006)

**Rationale:** Closure decision adopted under user delegation; the cited decision records its basis, limits and alternatives.

**Verification:** Create line on v1, publish v2, verify unchanged existing line.

**Status:** Confirmed

---

<a id="int-menu-017"></a>
### INT-MENU-017 — Atomic stock acceptance

**Requirement:**
The Inventory service shall accept a deduction only if it can apply the complete requested net list against current stock.

**Type:** INT

**Source:** [ADR-001](../../docs/md/Decisiones-cierre-invariantes.md#adr-001)

**Rationale:** Closure decision adopted under user delegation; the cited decision records its basis, limits and alternatives.

**Verification:** Two requests compete for last stock; no partial deduction or oversell based on the availability projection.

**Status:** Confirmed

---

<a id="int-menu-018"></a>
### INT-MENU-018 — Confirmation outcome

**Requirement:**
The Orders service shall confirm a line request only after receiving Inventory acceptance of its deduction.

**Type:** INT

**Source:** [ADR-003](../../docs/md/Decisiones-cierre-invariantes.md#adr-003)

**Rationale:** Closure decision adopted under user delegation; the cited decision records its basis, limits and alternatives.

**Verification:** Delay response: line stays pending; rejection prevents confirmation; repeated acceptance does not duplicate confirmation.

**Status:** Confirmed

---

<a id="int-menu-019"></a>
### INT-MENU-019 — Combo availability

**Requirement:**
The Menu service shall consider a combo available only if each slot can satisfy its minimum with options eligible for their supplied quantity.

**Type:** INT

**Source:** [ADR-001](../../docs/md/Decisiones-cierre-invariantes.md#adr-001)

**Rationale:** Closure decision adopted under user delegation; the cited decision records its basis, limits and alternatives.

**Verification:** Required slot without options blocks; optional empty slot does not; aggregate stock is rechecked at confirmation.

**Status:** Confirmed

---

<a id="int-menu-020"></a>
### INT-MENU-020 — Minimal unit price response

**Requirement:**
The Menu service shall return only basePrice, extrasTotal, unitSubtotal and currency in the pricing section of E-16 for the requested sellable variant unit.

**Type:** INT

**Source:** [ALIGN](../../docs/reviews/ers-interfaces-alignment/decisions.md)

**Rationale:** Explicit user decision in ALIGN; supersedes incompatible earlier wording.

**Verification:** Closed PriceSummary schema rejects component/slot/modifier price terms; preparation remains separate.

**Status:** Confirmed

---

<a id="int-menu-021"></a>
### INT-MENU-021 — Withdrawal tombstones

**Requirement:**
The Menu service shall preserve withdrawal revisions so delayed evaluations cannot resurrect retired availability definitions.

**Type:** INT

**Source:** [ALIGN](../../docs/reviews/ers-interfaces-alignment/decisions.md)

**Rationale:** Explicit user decision in ALIGN; supersedes incompatible earlier wording.

**Verification:** Inspect M-02/M-03 and deliver a delayed positive after withdrawal.

**Status:** Confirmed

---

<a id="int-menu-022"></a>
### INT-MENU-022 — Evaluation content conflicts

**Requirement:**
The Menu service shall treat identical evaluation revisions with different content as conflicts instead of replacing accepted availability.

**Type:** INT

**Source:** [ALIGN](../../docs/reviews/ers-interfaces-alignment/decisions.md)

**Rationale:** Explicit user decision in ALIGN; supersedes incompatible earlier wording.

**Verification:** M-03 identical duplicate ignored; changed duplicate rejected/quarantined.

**Status:** Confirmed

---

<a id="int-menu-023"></a>
### INT-MENU-023 — Recovery identity

**Requirement:**
The Menu service shall require a fresh valid evaluation matching the pending reevaluationRequestId before completing requested recovery.

**Type:** INT

**Source:** [ALIGN](../../docs/reviews/ers-interfaces-alignment/decisions.md)

**Rationale:** Explicit user decision in ALIGN; supersedes incompatible earlier wording.

**Verification:** Old response and expired positive never unlock recovery; inspect M-04/M-03/E-18.

**Status:** Confirmed

---

<a id="int-menu-024"></a>
### INT-MENU-024 — Inventory ingredient catalog

**Requirement:**
The Inventory service shall provide a catalog of items usable as ingredients or STOCKED references with at least item identifier, name and measurement unit.

**Type:** INT — External dependency

**Source:** [Inventory clarification](../../docs/reviews/ers-interfaces-alignment/decisions.md)

**Rationale:** Inventory owns the selectable item references and their units; Menu does not prescribe an independent unit catalog.

**Verification:** Inspect the Inventory contract when available; each selectable item includes the three required data elements. Quantity limits and conversion rules remain OPEN-010.

**Status:** Confirmed

---

<a id="int-menu-025"></a>
### INT-MENU-025 — Inventory catalog search

**Requirement:**
The Inventory service shall provide search over the catalog used to select ingredients and STOCKED item references during administration.

**Type:** INT — External dependency

**Source:** [Inventory clarification](../../docs/reviews/ers-interfaces-alignment/decisions.md)

**Rationale:** The administrator needs to find items without browsing the complete inventory catalog.

**Verification:** Demonstrate searching the supplied catalog and selecting an item by its identifier and unit. Search matching, route and pagination await the Inventory contract.

**Status:** Confirmed
