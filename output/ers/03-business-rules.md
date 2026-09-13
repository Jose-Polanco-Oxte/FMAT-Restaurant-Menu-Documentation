[← Index](./index.md)

# Business rules

Each block states one primary obligation. Enumerated attributes describe one fact or operation, not independent steps. Verification entries are proposed acceptance criteria, not executed software tests. Model names identify domain concepts, not required technologies.

---

Orders obligations are explicitly external to Menu ownership.
---

<a id="br-menu-001"></a>
### BR-MENU-001 — Universal variant

**Requirement:**
The system shall require at least one sellable variant for every commercial product.

**Type:** Business rules

**Source:** `docs/md/Modelo-Final.md` pp. 7–8

**Rationale:** Preserves the cited source fact or behavior within its stated scope without imposing an additional mechanism.

**Verification:** Test: Attempt to define a product without a sellable variant.

**Status:** Confirmed

---

<a id="br-menu-002"></a>
### BR-MENU-002 — One value per dimension

**Requirement:**
The system shall prevent a variant from selecting more than one value of the same dimension.

**Type:** Business rules

**Source:** `docs/md/Modelo-Final.md` pp. 21

**Rationale:** Preserves the cited source fact or behavior within its stated scope without imposing an additional mechanism.

**Verification:** Test: Attempt to select two sizes in one variant.

**Status:** Confirmed

---

<a id="br-menu-003"></a>
### BR-MENU-003 — Variant value ownership

**Requirement:**
The system shall allow associating dimension values with a variant only when those values belong to dimensions of the same product.

**Type:** Business rules

**Source:** `docs/md/Modelo-Final.md` pp. 21

**Rationale:** Preserves the cited source fact or behavior within its stated scope without imposing an additional mechanism.

**Verification:** Test: Attempt to associate a value from another product.

**Status:** Confirmed

---

<a id="br-menu-004"></a>
### BR-MENU-004 — Unique combination

**Requirement:**
The system shall prevent two variants of the same product from having the same set of dimension values.

**Type:** Business rules

**Source:** `docs/md/Modelo-Final.md` pp. 21

**Rationale:** Preserves the cited source fact or behavior within its stated scope without imposing an additional mechanism.

**Verification:** Test: Attempt to register the same combination twice, including reordered values.

**Status:** Confirmed

---

<a id="br-menu-005"></a>
### BR-MENU-005 — Fulfillment homogeneity

**Requirement:**
The system shall require the fulfillment classification of each variant to match that of its product.

**Type:** Business rules

**Source:** `docs/md/Modelo-Final.md` pp. 6–9

**Rationale:** Preserves the cited source fact or behavior within its stated scope without imposing an additional mechanism.

**Verification:** Test: Attempt to assign stocked fulfillment to a prepared product variant.

**Status:** Confirmed

---

<a id="br-menu-006"></a>
### BR-MENU-006 — No nested combos

**Requirement:**
The system shall allow a combo option to reference only a stocked or prepared product variant.

**Type:** Business rules

**Source:** `docs/md/Modelo-Final.md` pp. 11

**Rationale:** Preserves the cited source fact or behavior within its stated scope without imposing an additional mechanism.

**Verification:** Test: Attempt to configure a combo variant as a component option.

**Status:** Confirmed

---

<a id="br-menu-007"></a>
### BR-MENU-007 — Combo modifier scope

**Requirement:**
The system shall prevent a customization of a combo from modifying the ingredients of its component products.

**Type:** Business rules

**Source:** `docs/md/Modelo-Final.md` pp. 14–15

**Rationale:** Preserves the cited source fact or behavior within its stated scope without imposing an additional mechanism.

**Verification:** Test: Attempt to apply a bundle omission to an ingredient inside a child product.

**Status:** Confirmed

---

<a id="br-menu-008"></a>
### BR-MENU-008 — Resolved unit subtotal

**Requirement:**
The Menu service shall calculate one sellable variant unit subtotal as its fixed base price plus aggregated selected modifier contributions.

**Type:** BR

**Source:** [ALIGN](../../docs/reviews/ers-interfaces-alignment/decisions.md)

**Rationale:** Explicit user decision in ALIGN; supersedes incompatible earlier wording.

**Verification:** Combo 200 with two unit extras 5 and 10 resolves 215; changing included options alone stays 200.

**Status:** Confirmed

---

<a id="br-menu-009"></a>
### BR-MENU-009 — Enabled modifier applicability

**Requirement:**
The Orders service shall allow selecting a modifier only if an enabled configuration exists for the selected variant.

**Type:** BR

**Source:** [ADR-005](../../docs/md/Decisiones-cierre-invariantes.md#adr-005)

**Rationale:** Closure decision adopted under user delegation; the cited decision records its basis, limits and alternatives.

**Verification:** Compare absent, disabled and enabled configurations; quantity caps still apply.

**Status:** Confirmed

---

---

<a id="br-menu-010"></a>
### BR-MENU-010 — Modifier multiplicity cap

**Requirement:**
The ordering system shall prevent selecting a modifier quantity above the configured maximum for the selected variant.

**Type:** Business rules

**Source:** `docs/md/Modelo-Final.md` pp. 47–48

**Rationale:** Preserves the cited source fact or behavior within its stated scope without imposing an additional mechanism.

**Verification:** Test: Select the configured maximum and then a quantity above it.

**Status:** Confirmed

---

<a id="br-menu-011"></a>
### BR-MENU-011 — Selection counting

**Requirement:**
The Orders service shall accept a modifier group selection only if minSelections <= sum of selected quantities <= maxSelections.

**Type:** BR

**Source:** [ADR-005](../../docs/md/Decisiones-cierre-invariantes.md#adr-005)

**Rationale:** Closure decision adopted under user delegation; the cited decision records its basis, limits and alternatives.

**Verification:** Minimum 2: one option selected twice succeeds when its cap is 2; quantities 1 and 3 fail when limits are 2..2.

**Status:** Confirmed

---

---

<a id="br-menu-012"></a>
### BR-MENU-012 — Configured group capacity

**Requirement:**
The Menu service shall consider a group sellable for a variant only when the sum of maxQuantity across its enabled configurations is at least minSelections.

**Type:** BR

**Source:** [ADR-005](../../docs/md/Decisiones-cierre-invariantes.md#adr-005)

**Rationale:** Closure decision adopted under user delegation; the cited decision records its basis, limits and alternatives.

**Verification:** One enabled option with cap 2 satisfies minimum 2; disabling it removes its contribution.

**Status:** Confirmed

---

---

<a id="br-menu-013"></a>
### BR-MENU-013 — Addition measurement

**Requirement:**
The Menu service shall require an ingredient quantity and measurement unit when defining an addition effect.

**Type:** Business rules

**Source:** `docs/md/Modelo-Final.md` pp. 14, 34, 42–43

**Rationale:** Preserves the cited source fact or behavior within its stated scope without imposing an additional mechanism.

**Verification:** Test: Attempt an addition without its quantity and then without its unit. Numeric ranges are OPEN-010.

**Status:** Confirmed

---

<a id="br-menu-014"></a>
### BR-MENU-014 — Exclusive modifier ownership

**Requirement:**
The Menu service shall prevent a customization definition owned by one product from being shared with another product.

**Type:** Business rules

**Source:** `docs/md/Modelo-Final.md` pp. 12–13, 32–33

**Rationale:** Preserves the cited source fact or behavior within its stated scope without imposing an additional mechanism.

**Verification:** Test: Attempt to reuse the same group or option identity on another product; independent copies are distinct definitions.

**Status:** Confirmed

---

<a id="br-menu-015"></a>
### BR-MENU-015 — Administrative sale eligibility

**Requirement:**
The ordering system shall allow selling a product only when its administrative status is active.

**Type:** Business rules

**Source:** `docs/md/Modelo-Final.md` pp. 18–19

**Rationale:** Preserves the cited source fact or behavior within its stated scope without imposing an additional mechanism.

**Verification:** Test: Attempt a new sale of an inactive product. Propagation timing is not specified.

**Status:** Confirmed

---

<a id="br-menu-016"></a>
### BR-MENU-016 — Fixed combo price

**Requirement:**
The Menu service shall exclude standalone component prices and included option choices from changes to the configured combo base price.

**Type:** BR

**Source:** [ALIGN](../../docs/reviews/ers-interfaces-alignment/decisions.md)

**Rationale:** Explicit user decision in ALIGN; supersedes incompatible earlier wording.

**Verification:** Compare selections and updated component prices with identical configured base.

**Status:** Confirmed

---

<a id="br-menu-017"></a>
### BR-MENU-017 — Modifier multiplicity

**Requirement:**
The Menu service shall calculate each modifier contribution as its selected quantity multiplied by the pinned configured adjustment for its individual personalized unit.

**Type:** BR

**Source:** [ALIGN](../../docs/reviews/ers-interfaces-alignment/decisions.md)

**Rationale:** Explicit user decision in ALIGN; supersedes incompatible earlier wording.

**Verification:** Two supplied units, only one cheese at 5: extras 5, not 10; both cheese: 10.

**Status:** Confirmed

---

<a id="br-menu-018"></a>
### BR-MENU-018 — Modifier ingredient multiplicity

**Requirement:**
The system shall calculate the quantity added by a selected modifier as its selected quantity multiplied by the ingredient addition quantity configured for the selected variant.

**Type:** Business rules

**Source:** `docs/md/Modelo-Final.md` pp. 15–16, 42–43

**Rationale:** Preserves the cited source fact or behavior within its stated scope without imposing an additional mechanism.

**Verification:** Test: Compare the added ingredient quantity for one and two selections of the same modifier.

**Status:** Confirmed

---

<a id="br-menu-019"></a>
### BR-MENU-019 — Omission has no quantity

**Requirement:**
The Menu service shall represent an ingredient omission without a quantitative ingredient adjustment.

**Type:** Business rules

**Source:** `docs/md/Modelo-Final.md` pp. 33–34, 46

**Rationale:** Preserves the cited source fact or behavior within its stated scope without imposing an additional mechanism.

**Verification:** Test: Inspect an omission and verify that it is an exclusion directive rather than a gram subtraction.

**Status:** Confirmed

---

<a id="br-menu-020"></a>
### BR-MENU-020 — Combo slot membership

**Requirement:**
The ordering system shall accept a selected component variant for a combo slot only when it is configured as an option of that slot for the selected combo variant.

**Type:** Business rules

**Source:** `docs/md/Modelo-Final.md` pp. 29

**Rationale:** Preserves the cited source fact or behavior within its stated scope without imposing an additional mechanism.

**Verification:** Test: Try a configured option and an option configured only for a different combo size or slot.

**Status:** Confirmed

---

<a id="br-menu-021"></a>
### BR-MENU-021 — Shared group bounds

**Requirement:**
The Menu service shall use the same group selection limits across the variants of the product that owns the group.

**Type:** Business rules

**Source:** `docs/md/Modelo-Final.md` pp. 47–48

**Rationale:** Preserves the cited source fact or behavior within its stated scope without imposing an additional mechanism.

**Verification:** Test: Inspect a product with several variants and verify that each references the same group limits.

**Status:** Confirmed

---

<a id="br-menu-022"></a>
### BR-MENU-022 — Supported ingredient operations

**Requirement:**
The Menu service shall restrict ingredient effects to addition and omission operations in the current scope.

**Type:** Business rules

**Source:** `docs/md/Modelo-Final.md` pp. 33–35

**Rationale:** Preserves the cited source fact or behavior within its stated scope without imposing an additional mechanism.

**Verification:** Test: Attempt to configure a quantitative removal or set-quantity effect.

**Status:** Confirmed

---

<a id="br-menu-023"></a>
### BR-MENU-023 — Sale eligibility

**Requirement:**
The Menu service shall consider a variant eligible only if product and variant are ACTIVE, its configuration is valid and it has a current positive availability evaluation for the current revision.

**Type:** BR

**Source:** [ADR-001](../../docs/md/Decisiones-cierre-invariantes.md#adr-001)

**Rationale:** Closure decision adopted under user delegation; the cited decision records its basis, limits and alternatives.

**Verification:** Exercise each missing prerequisite independently.

**Status:** Confirmed

---

<a id="br-menu-024"></a>
### BR-MENU-024 — Selection ranges

**Requirement:**
The Menu service shall require integer selection limits satisfying 0 <= minSelections <= maxSelections.

**Type:** BR

**Source:** [ADR-005](../../docs/md/Decisiones-cierre-invariantes.md#adr-005)

**Rationale:** Closure decision adopted under user delegation; the cited decision records its basis, limits and alternatives.

**Verification:** Reject negative, fractional and inverted limits.

**Status:** Confirmed

---

<a id="br-menu-025"></a>
### BR-MENU-025 — Modifier quantity range

**Requirement:**
The Orders service shall require integer modifier quantities between zero and maxQuantity inclusive.

**Type:** BR

**Source:** [ADR-005](../../docs/md/Decisiones-cierre-invariantes.md#adr-005)

**Rationale:** Closure decision adopted under user delegation; the cited decision records its basis, limits and alternatives.

**Verification:** Test zero, cap, cap+1, negative and fractional quantities.

**Status:** Confirmed

---

<a id="br-menu-026"></a>
### BR-MENU-026 — Slot counting

**Requirement:**
The Orders service shall count one selection for each chosen ComboOption regardless of its supplied quantity.

**Type:** BR

**Source:** [ADR-005](../../docs/md/Decisiones-cierre-invariantes.md#adr-005)

**Rationale:** Closure decision adopted under user delegation; the cited decision records its basis, limits and alternatives.

**Verification:** An option supplying six units counts once.

**Status:** Confirmed

---

<a id="br-menu-027"></a>
### BR-MENU-027 — Slot repetition

**Requirement:**
The Orders service shall prevent choosing the same ComboOption more than once per combo unit.

**Type:** BR

**Source:** [ADR-005](../../docs/md/Decisiones-cierre-invariantes.md#adr-005)

**Rationale:** Closure decision adopted under user delegation; the cited decision records its basis, limits and alternatives.

**Verification:** Reject a repeated option identity; two configured option identities may target the same variant.

**Status:** Confirmed

---

<a id="br-menu-028"></a>
### BR-MENU-028 — Slot bounds

**Requirement:**
The Orders service shall accept a slot only when its selected option count is between minSelections and maxSelections inclusive.

**Type:** BR

**Source:** [ADR-005](../../docs/md/Decisiones-cierre-invariantes.md#adr-005)

**Rationale:** Closure decision adopted under user delegation; the cited decision records its basis, limits and alternatives.

**Verification:** Test below, at and above limits.

**Status:** Confirmed

---

<a id="br-menu-029"></a>
### BR-MENU-029 — Slot capacity

**Requirement:**
The Menu service shall consider a slot sellable only if its number of enabled options with an ACTIVE component covers minSelections.

**Type:** BR

**Source:** [ADR-005](../../docs/md/Decisiones-cierre-invariantes.md#adr-005)

**Rationale:** Closure decision adopted under user delegation; the cited decision records its basis, limits and alternatives.

**Verification:** Disabled options and archived components contribute zero capacity.

**Status:** Confirmed

---

<a id="br-menu-030"></a>
### BR-MENU-030 — Activation validation

**Requirement:**
The Menu service shall reject product activation if no ACTIVE variant remains or any variant becoming ACTIVE has an unsellable group or slot.

**Type:** BR

**Source:** [ADR-005](../../docs/md/Decisiones-cierre-invariantes.md#adr-005)

**Rationale:** Closure decision adopted under user delegation; the cited decision records its basis, limits and alternatives.

**Verification:** Test an empty active set and a variant with insufficient group or slot capacity.

**Status:** Confirmed

---

<a id="br-menu-031"></a>
### BR-MENU-031 — Retired option eligibility

**Requirement:**
The Menu service shall exclude inactive or archived component options from new selections while allowing dependent combos with other valid selections to remain eligible.

**Type:** BR

**Source:** [ALIGN](../../docs/reviews/ers-interfaces-alignment/decisions.md)

**Rationale:** Explicit user decision in ALIGN; supersedes incompatible earlier wording.

**Verification:** Retire chicken: beef remains selectable; no alternatives in required slot makes combo unavailable.

**Status:** Confirmed

---

<a id="br-menu-032"></a>
### BR-MENU-032 — Irreversible archive

**Requirement:**
The Menu service shall prevent reactivating an ARCHIVED variant in this release.

**Type:** BR

**Source:** [ADR-003](../../docs/md/Decisiones-cierre-invariantes.md#adr-003)

**Rationale:** Closure decision adopted under user delegation; the cited decision records its basis, limits and alternatives.

**Verification:** Attempt ARCHIVED to ACTIVE or INACTIVE.

**Status:** Confirmed

---

<a id="br-menu-033"></a>
### BR-MENU-033 — Supplied quantity

**Requirement:**
The Menu service shall require a positive integer supplied quantity for each ComboOption.

**Type:** BR

**Source:** [ADR-005](../../docs/md/Decisiones-cierre-invariantes.md#adr-005)

**Rationale:** Closure decision adopted under user delegation; the cited decision records its basis, limits and alternatives.

**Verification:** Reject zero, negative and fractional supplied quantities.

**Status:** Confirmed

---

<a id="br-menu-034"></a>
### BR-MENU-034 — Omission before addition

**Requirement:**
The Menu service shall exclude only the base ingredient contribution through OMIT before summing ADD effects for the selected component.

**Type:** BR

**Source:** [ADR-003](../../docs/md/Decisiones-cierre-invariantes.md#adr-003)

**Rationale:** Closure decision adopted under user delegation; the cited decision records its basis, limits and alternatives.

**Verification:** Base 30, OMIT and ADD 10 produce 10; sibling components remain unchanged.

**Status:** Confirmed

---

<a id="br-menu-035"></a>
### BR-MENU-035 — Revision sequence

**Requirement:**
The Menu service shall assign versions formatted as `<counter>_<ISO8601 timestamp with timezone>`, starting at 1 and incrementing by one per accepted effective change within each product or recipe identity.

**Type:** BR

**Source:** [ADR-006](../../docs/md/Decisiones-cierre-invariantes.md#adr-006)

**Rationale:** Closure decision adopted under user delegation; the cited decision records its basis, limits and alternatives.

**Verification:** Verify initial 1, next 2, timezone and independent product/recipe counters.

**Status:** Confirmed

---

<a id="br-menu-036"></a>
### BR-MENU-036 — No-op revision

**Requirement:**
The Menu service shall preserve the version when the same change is retried or an identical definition is saved.

**Type:** BR

**Source:** [ADR-006](../../docs/md/Decisiones-cierre-invariantes.md#adr-006)

**Rationale:** Closure decision adopted under user delegation; the cited decision records its basis, limits and alternatives.

**Verification:** Repeat a change and an identical save; no extra revision is created.

**Status:** Confirmed

---

<a id="br-menu-037"></a>
### BR-MENU-037 — Pinned recipe adoption

**Requirement:**
The Menu service shall preserve a variant recipe revision reference until an explicit product edit adopts another revision.

**Type:** BR

**Source:** [ADR-006](../../docs/md/Decisiones-cierre-invariantes.md#adr-006)

**Rationale:** Closure decision adopted under user delegation; the cited decision records its basis, limits and alternatives.

**Verification:** Publish recipe v2 while product pins v1; reference stays v1 until product edit.

**Status:** Confirmed

---

<a id="br-menu-038"></a>
### BR-MENU-038 — Default historical identity

**Requirement:**
The Menu service shall preserve the historical identity of DEFAULT while creating new identities for its dimensioned replacements.

**Type:** BR

**Source:** [ADR-008](../../docs/md/Decisiones-cierre-invariantes.md#adr-008)

**Rationale:** Closure decision adopted under user delegation; the cited decision records its basis, limits and alternatives.

**Verification:** Verify existing order references still identify DEFAULT after migration.

**Status:** Confirmed

---

<a id="br-menu-039"></a>
### BR-MENU-039 — Zero modifier capacity

**Requirement:**
The Menu service shall allow a nonnegative integer maxQuantity in a modifier configuration.

**Type:** BR

**Source:** [ADR-005](../../docs/md/Decisiones-cierre-invariantes.md#adr-005)

**Rationale:** Closure decision adopted under user delegation; the cited decision records its basis, limits and alternatives.

**Verification:** Zero contributes no capacity and cannot be selected; fractional and negative caps fail.

**Status:** Confirmed

---

<a id="br-menu-040"></a>
### BR-MENU-040 — Dimensional sale identity

**Requirement:**
The Menu service shall exclude variants without a dimension combination from new sales when the product has selectable dimensions.

**Type:** BR

**Source:** [ADR-008](../../docs/md/Decisiones-cierre-invariantes.md#adr-008)

**Rationale:** Closure decision adopted under user delegation; the cited decision records its basis, limits and alternatives.

**Verification:** After dimensions are introduced, DEFAULT cannot remain offered as an unspecified size.

**Status:** Confirmed

---

<a id="br-menu-041"></a>
### BR-MENU-041 — Monetary validation

**Requirement:**
The Menu service shall reject negative prices or adjustments, incompatible restaurant currencies and amounts exceeding the configured currency precision.

**Type:** BR

**Source:** [ALIGN](../../docs/reviews/ers-interfaces-alignment/decisions.md)

**Rationale:** Explicit user decision in ALIGN; supersedes incompatible earlier wording.

**Verification:** Accept zero; reject excess precision, including trailing zeros, without rounding. Inspect the approved external monetary contract in ALIGN: currency selected at provisioning, minorUnit derived from ISO 4217, retained accepted revision shared with Orders, no external lookup per sale, and no ordinary currency substitution. Missing accepted configuration blocks monetary writes and resolution; provider outage does not invalidate accepted configuration.

**Status:** Confirmed

---

<a id="br-menu-042"></a>
### BR-MENU-042 — Physical positivity

**Requirement:**
The Menu service shall reject nonpositive physical quantities in stocked fulfillment, recipes and ingredient additions.

**Type:** BR

**Source:** [ALIGN](../../docs/reviews/ers-interfaces-alignment/decisions.md)

**Rationale:** Explicit user decision in ALIGN; supersedes incompatible earlier wording.

**Verification:** Omission uses OMIT; zero net omitted from resolution; reject negative/zero input quantities.

**Status:** Confirmed

---

<a id="br-menu-043"></a>
### BR-MENU-043 — Immutable fulfillment type

**Requirement:**
The Menu service shall reject changing the fulfillment type of an existing MenuItem.

**Type:** BR

**Source:** [ALIGN](../../docs/reviews/ers-interfaces-alignment/decisions.md)

**Rationale:** Explicit user decision in ALIGN; supersedes incompatible earlier wording.

**Verification:** Attempt STOCKED to PREPARED even before activation; create a new identity instead.

**Status:** Confirmed

---

<a id="br-menu-044"></a>
### BR-MENU-044 — Names are labels

**Requirement:**
The Menu service shall allow repeated display names for entities with distinct valid identities.

**Type:** BR

**Source:** [ALIGN](../../docs/reviews/ers-interfaces-alignment/decisions.md)

**Rationale:** Explicit user decision in ALIGN; supersedes incompatible earlier wording.

**Verification:** Repeated labels accepted; repeated dimension combinations still rejected.

**Status:** Confirmed
