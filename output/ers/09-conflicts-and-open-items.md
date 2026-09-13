[← Index](./index.md)

# Decision status

The original Menu closure topics remain as documented; OPEN-010 is partial only for pending Inventory limits. This revision adds OPEN-011 through OPEN-019 for external projections required by the confirmed consumer UI. No UI decision is left open in those entries.

---

<a id="open-001"></a>

### OPEN-001 — Operational availability

**Evidence:** `docs/md/Modelo-Final.md` pp. 18–19

**Status:** Closed

**Decision:** Inventory evaluates flat requirements under opaque keys; Menu maps them and exposes current availability. Missing valid evaluation or detected outage means unavailable. Deduction uses the line net list, not the projection.

**Closure source:** [ADR-001](../../docs/md/Decisiones-cierre-invariantes.md#adr-001)

**Affected documentation:** INT-MENU-008, INT-MENU-009, INT-MENU-010, INT-MENU-011, INT-MENU-017, INT-MENU-019, BR-MENU-023, DATA-MENU-019, DATA-MENU-020, CON-MENU-009, CON-MENU-010.

---

<a id="open-002"></a>

### OPEN-002 — Copy and bulk operation semantics

**Status:** Closed

**Decision:** E-17: same MenuItem, IDs, FAIL/REPLACE, dryRun, concurrency and all-or-none.

**Closure source:** [ALIGN](../../docs/reviews/ers-interfaces-alignment/decisions.md)

**Affected documentation:** INT-MENU-005, REQ-MENU-016, REQ-MENU-026, REQ-MENU-027

---

<a id="open-003"></a>

### OPEN-003 — Configuration retention

**Evidence:** `docs/md/Auditoria-3.md` pp. 8–9

**Status:** Closed

**Decision:** ARCHIVED withdraws variants from new sales. History is retained without purging in this release. Orders persists net ingredients and delivery work; Inventory applies idempotent movements and exact authorized reversals.

**Closure source:** [ADR-003](../../docs/md/Decisiones-cierre-invariantes.md#adr-003)

**Affected documentation:** REQ-MENU-028, REQ-MENU-032, DATA-MENU-022, DATA-MENU-023, INT-MENU-012, INT-MENU-013, INT-MENU-014, INT-MENU-015, INT-MENU-018, QA-MENU-002, CON-MENU-008, CON-MENU-011.

---

<a id="open-004"></a>

### OPEN-004 — Performance acceptance criteria

**Evidence:** `docs/md/Modelo-Final.md` pp. 49–50

**Status:** Closed

**Decision:** ADR-004 acceptance profile is adopted: 40 clients, 30 requests/s for 30 minutes and a 100 requests/s burst for 60 seconds, with per-operation percentiles. These are not measured results.

**Closure source:** [ADR-004](../../docs/md/Decisiones-cierre-invariantes.md#adr-004)

**Affected documentation:** QA-MENU-004, QA-MENU-005, QA-MENU-006, QA-MENU-007, QA-MENU-008, QA-MENU-009, QA-MENU-010, QA-MENU-011, QA-MENU-012, QA-MENU-013, QA-MENU-014, QA-MENU-015, QA-MENU-016, QA-MENU-017.

---

<a id="open-005"></a>

### OPEN-005 — Selection counting and validation phase

**Evidence:** `docs/md/Auditoria-3.md` pp. 8

**Status:** Closed

**Decision:** Modifiers count selected units; slots count options chosen once, not supplied units. Group capacity sums caps; slot capacity counts enabled options. INACTIVE permits incomplete work with warnings; ACTIVE requires viable configuration.

**Closure source:** [ADR-005](../../docs/md/Decisiones-cierre-invariantes.md#adr-005)

**Affected documentation:** BR-MENU-011, BR-MENU-012, BR-MENU-024, BR-MENU-025, BR-MENU-026, BR-MENU-027, BR-MENU-028, BR-MENU-029, BR-MENU-030, BR-MENU-031, BR-MENU-033, BR-MENU-039, REQ-MENU-029, REQ-MENU-030, DATA-MENU-021.

---

<a id="open-006"></a>

### OPEN-006 — Recipe revision lifecycle

**Evidence:** `docs/md/Modelo-Final.md` pp. 23, 37–38

**Status:** Closed

**Decision:** Each accepted effective change generates an immutable per-identity revision with counter and timezone-qualified ISO8601 date. Product and recipe sequences are independent. Existing lines retain pinned versions; variants adopt recipe revisions explicitly.

**Closure source:** [ADR-006](../../docs/md/Decisiones-cierre-invariantes.md#adr-006)

**Affected documentation:** REQ-MENU-021, REQ-MENU-033, BR-MENU-035, BR-MENU-036, BR-MENU-037, DATA-MENU-017, DATA-MENU-018, INT-MENU-016.

---

<a id="open-007"></a>

### OPEN-007 — Consumer and publication contracts

**Status:** Closed

**Decision:** Catalog E-01–E-03 and invalidations M-07/M-08 defined; resolution E-16 and recovery E-18 defined. Orders sends preparation to Kitchen. Broker topology and external Kitchen wire contract belong to integration, not a direct Menu–Kitchen interface.

**Closure source:** [ALIGN](../../docs/reviews/ers-interfaces-alignment/decisions.md)

**Affected documentation:** REQ-MENU-022, INT-MENU-001, INT-MENU-002

---

<a id="open-008"></a>

### OPEN-008 — Variant lifecycle and displayed minimum

**Evidence:** `docs/md/Modelo-Final.md` pp. 7–8, 18–19, 27

**Status:** Closed

**Decision:** The minimum uses only currently eligible variants; no candidates means no starting price. DEFAULT keeps its historical identity and is archived when new dimensioned variants are published, without an invalid intermediate commercial revision.

**Closure source:** [ADR-008](../../docs/md/Decisiones-cierre-invariantes.md#adr-008)

**Affected documentation:** REQ-MENU-007, REQ-MENU-031, REQ-MENU-034, BR-MENU-023, BR-MENU-038, BR-MENU-040, DATA-MENU-016.

---

<a id="open-009"></a>

### OPEN-009 — Pricing multiplicity and snapshot scope

**Status:** Closed

**Decision:** Fixed price without option charges; extras by quantity per unit; aggregated variant summary in E-16 retained by Orders.

**Closure source:** [ALIGN](../../docs/reviews/ers-interfaces-alignment/decisions.md)

**Affected documentation:** BR-MENU-008, BR-MENU-016, BR-MENU-017, INT-MENU-004, INT-MENU-020

---

<a id="open-010"></a>

### OPEN-010 — Data validation policies

**Status:** Partial

**Decision:** Resolved: one external currency, currency precision without rounding, nonnegative prices, positive physical inputs, repeated names and immutable type. Inventory supplies the ingredient/STOCKED catalog with at least ID, name and measurement unit and provides search (INT-MENU-024/025). Quantity magnitude/precision remains open pending Inventory specifications. Unit ownership is resolved; concrete routes, conversion and unit-change semantics await its contract. Seven-day review-token/idempotency retention (option B) and the external monetary configuration contract are approved. Within the original Menu scope, only Inventory agreements remain open; consumer UI contracts are tracked separately below. Capacity is operational sizing, not an undefined business quota. See [approved decision](../../docs/reviews/ers-interfaces-alignment/open-010-proposals.md). No invented thresholds.

**Closure source:** [ALIGN](../../docs/reviews/ers-interfaces-alignment/decisions.md)

**Affected documentation:** BR-MENU-041, BR-MENU-042, BR-MENU-043, BR-MENU-044

---

## External contracts required by confirmed consumer UI

The following items are open only because the referenced owning service or provider is not specified in this repository. They do not make the corresponding UI decision provisional.

<a id="open-011"></a>
### OPEN-011 — Assigned table projection

**Evidence:** Explicit waiter UI decision in the user request dated 2026-09-13; V-MES-01 in `output/ui-spec/ui-data-spec.md`.

**Known Information:** Sala supplies a limited set of tables assigned to the waiter. The UI distinguishes tables with and without an order.

**Missing Information:** Exact table identifier, visible label, assignment representation, table state, active-order reference and query/refresh contract.

**Question to be Resolved:** What projection and contract shall Sala provide to the ordering UI for assigned tables and their order association?

**Status:** Open — external contract

---

<a id="open-012"></a>
### OPEN-012 — Active order and order append projection

**Evidence:** Explicit waiter UI decision in the user request dated 2026-09-13; V-MES-02/V-MES-03 in `output/ui-spec/ui-data-spec.md`.

**Known Information:** Orders owns existing orders, confirmed lines, line quantities and order totals. The UI prepares local draft lines and may add them to an existing order.

**Missing Information:** Active-order read, order creation, append operation, line states, duplicate policy, waiter permissions and authoritative response after append.

**Question to be Resolved:** What Orders contract shall support reading, creating and appending the order while preserving the local draft when an operation fails?

**Status:** Open — external contract

---

<a id="open-013"></a>
### OPEN-013 — Category source and visual-classification mapping

**Evidence:** Explicit UI clarification in the user request dated 2026-09-13; UI-OPEN-003 and section 3.6 of `output/ui-spec/ui-data-spec.md`.

**Known Information:** The UI classification values and labels are confirmed: DISH/Platillo, BEVERAGE/Bebida, COMBO/Combo, DESSERT/Postre and COMPLEMENT/Complemento. `categoryId` and fulfillment type remain distinct.

**Missing Information:** Category catalog owner, category labels, mapping from `categoryId` to classification and versioning of category changes.

**Question to be Resolved:** Which external catalog supplies categories and how does it map each category identity to the confirmed visual classification?

**Status:** Open — external contract

---

<a id="open-014"></a>
### OPEN-014 — Administrative catalog projection

**Evidence:** Explicit administrator UI decision in the user request dated 2026-09-13; V-ADM-01 in `output/ui-spec/ui-data-spec.md`.

**Known Information:** The administrative UI uses the same search and filter intent as the sales catalog and displays management data in cards.

**Missing Information:** Administrative list endpoint or projection, supported filters, pagination, card fields and ownership of classification and lifecycle data.

**Question to be Resolved:** What contract shall supply the administrative catalog projection with the filters and fields required by the UI?

**Status:** Open — external contract

---

<a id="open-015"></a>
### OPEN-015 — Root item archive and soft removal

**Evidence:** Explicit administrator UI decision in the user request dated 2026-09-13; UI-REQ-009/UI-REQ-010 in `output/ui-spec/ui-data-spec.md`.

**Known Information:** The UI separates ACTIVE, INACTIVE, REVIEW_REQUIRED and ARCHIVED and offers one-item, selected-item and all-results removal in the archived section. “Removal” is soft and does not physically delete history. Current Menu contracts define ARCHIVED for variants, not root MenuItems or bulk soft removal.

**Missing Information:** Root item lifecycle state, archive operation, soft-removal operations, response state, restoration policy and historical-reference behavior.

**Question to be Resolved:** What external Menu or administrative contract shall persist root-item archival and the three soft-removal scopes?

**Status:** Open — external contract

---

<a id="open-016"></a>
### OPEN-016 — Coordinated Recipe and MenuItem save result

**Evidence:** Explicit creation/editing UI decision in the user request dated 2026-09-13; V-ADM-02 in `output/ui-spec/ui-data-spec.md`.

**Known Information:** Recipe revisions and MenuItem revisions are separate concepts. The editor must expose their resulting identities separately.

**Missing Information:** Atomicity, compensation and response semantics when one persistence operation succeeds and the other fails.

**Question to be Resolved:** Shall the administrative UI coordinate separate operations, or shall an external contract provide an atomic combined result?

**Status:** Open — external contract

---

<a id="open-017"></a>
### OPEN-017 — Inventory selector projection

**Evidence:** Explicit administrator UI decision in the user request dated 2026-09-13; V-ADM-02 and INT-MENU-024/025.

**Known Information:** Inventory supplies selectable ingredient and STOCKED references with at least identifier, name, unit and search.

**Missing Information:** Routes, pagination, quantity limits, precision, conversion and unit-change semantics. Quantity policy complements the partial status of OPEN-010.

**Question to be Resolved:** What Inventory contract shall support the editor selectors and their quantity/unit controls?

**Status:** Open — external contract

---

<a id="open-018"></a>
### OPEN-018 — Image upload and preview provider

**Evidence:** Explicit catalog-management UI decision in the user request dated 2026-09-13; `imageRef` handling in `output/ui-spec/ui-data-spec.md`.

**Known Information:** Menu stores an image reference string or null; the UI needs image selection, upload state and preview.

**Missing Information:** Provider, upload and deletion operations, validation, authorization and preview-reference lifetime.

**Question to be Resolved:** Which external image contract supplies and resolves the image reference used by the UI?

**Status:** Open — external contract

---

<a id="open-019"></a>
### OPEN-019 — Final Billing adjustments

**Evidence:** Explicit price clarification in the user request dated 2026-09-13; BR-UI-001 and DATA-UI-006.

**Known Information:** The UI displays the pre-order accumulated cost as `Σ(quantity × resolvedUnitSubtotal)`. Billing may adjust the final amount later; those adjustments are not part of the pre-order accumulation.

**Missing Information:** Billing contract for discounts, taxes, charges, rounding, final recalculation and presentation of the final amount.

**Question to be Resolved:** Which Billing response shall provide the final amount and its adjustments after the pre-order is confirmed?

**Status:** Open — external contract
