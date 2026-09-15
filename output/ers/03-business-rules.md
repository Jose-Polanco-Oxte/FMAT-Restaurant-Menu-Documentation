[← Index](./index.md)

# Business rules

Each block states one primary obligation. Enumerated attributes describe one fact or operation, not independent steps. Verification entries are proposed acceptance criteria, not executed software tests. Model names identify domain concepts, not required technologies. `Auditoria-4.md` is the active source for the corrected `MenuItem`, modifier and combo invariants.

---

Orders obligations are explicitly external to Menu ownership.
---

<a id="br-menu-001"></a>
### BR-MENU-001 — At least one leaf presentation

**Requirement:**
The system shall require at least one sellable `MenuItemVariant` for every PREPARED or STOCKED `MenuItem` and at least one `ComboConfiguration` for every COMBO `MenuItem`.

**Type:** Business rules

**Source:** `docs/md/Auditoria-4.md`, items 1–4


**Verification:** Test: Attempt to save a PREPARED or STOCKED `MenuItem` without a sellable presentation and a COMBO `MenuItem` without a `ComboConfiguration`.

**Status:** Confirmed

---

<a id="br-menu-002"></a>
### BR-MENU-002 — One value per presentation characteristic

**Requirement:**
The system shall prevent a `MenuItemVariant` from selecting more than one value of the same presentation characteristic.

**Type:** Business rules

**Source:** `docs/md/Modelo-Final.md` pp. 21


**Verification:** Test: Attempt to select two values of the same presentation characteristic in one `MenuItemVariant`.

**Status:** Confirmed

---

<a id="br-menu-003"></a>
### BR-MENU-003 — Presentation value ownership

**Requirement:**
The system shall allow associating presentation characteristic values with a `MenuItemVariant` only when those values belong to characteristics of the same leaf `MenuItem`.

**Type:** Business rules

**Source:** `docs/md/Modelo-Final.md` pp. 21


**Verification:** Test: Attempt to associate a presentation value from another `MenuItem`.

**Status:** Confirmed

---

<a id="br-menu-004"></a>
### BR-MENU-004 — Unique presentation

**Requirement:**
The system shall prevent two `MenuItemVariant` records of the same leaf `MenuItem` from having the same set of presentation characteristic values.

**Type:** Business rules

**Source:** `docs/md/Modelo-Final.md` pp. 21


**Verification:** Test: Attempt to register the same presentation twice, including reordered characteristic values.

**Status:** Confirmed

---

<a id="br-menu-005"></a>
### BR-MENU-005 — Fulfillment homogeneity

**Requirement:**
The system shall require every `MenuItemVariant` of a PREPARED or STOCKED `MenuItem` to use the corresponding fulfillment definition for that `MenuItem`.

**Type:** Business rules

**Source:** `docs/md/Auditoria-4.md`, items 1–2 and 11


**Verification:** Test: Attempt to assign stocked fulfillment to a presentation of a PREPARED `MenuItem`.

**Status:** Confirmed

---

<a id="br-menu-006"></a>
### BR-MENU-006 — No nested combos

**Requirement:**
The system shall allow a combo option to reference only a STOCKED or PREPARED leaf `MenuItemVariant`.

**Type:** Business rules

**Source:** `docs/md/Modelo-Final.md` pp. 11


**Verification:** Test: Attempt to configure a ComboConfiguration as a component option.

**Status:** Confirmed

---

<a id="br-menu-007"></a>
### BR-MENU-007 — Combo modifier scope

**Requirement:**
The system shall prevent a COMBO `MenuItem` from owning `ModifierGroup` records that apply directly to the combo rather than to a selected leaf component.

**Type:** Business rules

**Source:** `docs/md/Auditoria-4.md`, items 23–28


**Verification:** Test: Attempt to apply a bundle omission to an ingredient inside a selected leaf `MenuItem`.

**Status:** Confirmed

---

<a id="br-menu-008"></a>
### BR-MENU-008 — Resolved unit subtotal

**Requirement:**
The Menu service shall calculate a selected combo unit subtotal as the ComboConfiguration.unitPrice plus selected ComboOption.priceDelta contributions plus selected modifier contributions on the selected leaf components.

**Type:** BR

**Source:** `docs/md/Auditoria-4.md`, items 8, 15–17 and 31–32


**Verification:** Resolve a combo configuration with unitPrice 200, one selected option priceDelta 10 and one component modifier contribution 5; verify 215 and verify that the component's normal unitPrice is not added.

**Status:** Confirmed

---

<a id="br-menu-009"></a>
### BR-MENU-009 — Enabled modifier applicability

**Requirement:**
The Orders service shall allow selecting a modifier only if its effective configuration for the selected leaf variant is enabled, using a variant exception when present and the ModifierOption default otherwise.

**Type:** BR

**Source:** `docs/md/Auditoria-4.md`, items 14–18 and 21–22


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


**Verification:** Test: Select the configured maximum and then a quantity above it.

**Status:** Confirmed

---

<a id="br-menu-011"></a>
### BR-MENU-011 — Selection counting

**Requirement:**
The Orders service shall accept a modifier group selection only if minSelections <= sum of selected quantities <= maxSelections.

**Type:** BR

**Source:** [ADR-005](../../docs/md/Decisiones-cierre-invariantes.md#adr-005)


**Verification:** Minimum 2: one option selected twice succeeds when its cap is 2; quantities 1 and 3 fail when limits are 2..2.

**Status:** Confirmed

---

---

<a id="br-menu-012"></a>
### BR-MENU-012 — Modifier group minimum

**Requirement:**
The Menu service shall consider a `ModifierGroup` usable for a leaf `MenuItem` only when the sum of the maximum quantities allowed by its enabled options is at least `minSelections`, using a variant exception when one exists and the general option value otherwise.

**Type:** BR

**Source:** `docs/md/Auditoria-4.md`, items 14–19


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


**Verification:** Test: Attempt an addition without its quantity and then without its unit. Numeric ranges are OPEN-010.

**Status:** Confirmed

---

<a id="br-menu-014"></a>
### BR-MENU-014 — Exclusive modifier ownership

**Requirement:**
The Menu service shall prevent a customization definition owned by one leaf `MenuItem` from being shared with another leaf `MenuItem`.

**Type:** Business rules

**Source:** `docs/md/Modelo-Final.md` pp. 12–13, 32–33


**Verification:** Test: Attempt to reuse the same group or option identity on another leaf `MenuItem`; independent copies are distinct definitions.

**Status:** Confirmed

---

<a id="br-menu-015"></a>
### BR-MENU-015 — Administrative sale eligibility

**Requirement:**
The ordering system shall allow selling a `MenuItem` only when its administrative status is ACTIVE.

**Type:** Business rules

**Source:** `docs/md/Modelo-Final.md` pp. 18–19


**Verification:** Test: Attempt a new sale of an INACTIVE `MenuItem`. Propagation timing is not specified.

**Status:** Confirmed

---

<a id="br-menu-016"></a>
### BR-MENU-016 — Combo configuration price

**Requirement:**
The Menu service shall exclude standalone component unit prices from the combo subtotal while including the selected ComboOption.priceDelta values in addition to the ComboConfiguration.unitPrice.

**Type:** BR

**Source:** `docs/md/Auditoria-4.md`, items 23–32


**Verification:** Compare two selections and updated component prices with the same ComboConfiguration.unitPrice; only the configured option deltas affect the combo subtotal.

**Status:** Confirmed

---

<a id="br-menu-017"></a>
### BR-MENU-017 — Modifier multiplicity

**Requirement:**
The Menu service shall calculate each modifier contribution as its selected quantity multiplied by the effective priceDelta for its individual personalized unit.

**Type:** BR

**Source:** `docs/md/Auditoria-4.md`, items 14–18 and 21–22


**Verification:** Two component units, only one cheese at 5: extras 5, not 10; both cheese: 10.

**Status:** Confirmed

---

<a id="br-menu-018"></a>
### BR-MENU-018 — Modifier ingredient multiplicity

**Requirement:**
The system shall calculate the quantity added by a selected modifier as its selected quantity multiplied by the ingredient addition quantity in the effective modifier configuration for the selected variant.

**Type:** Business rules

**Source:** `docs/md/Auditoria-4.md`, items 14–20


**Verification:** Test: Compare the added ingredient quantity for one and two selections of the same modifier.

**Status:** Confirmed

---

<a id="br-menu-019"></a>
### BR-MENU-019 — Omission has no quantity

**Requirement:**
The Menu service shall represent an ingredient omission without a quantitative ingredient adjustment.

**Type:** Business rules

**Source:** `docs/md/Modelo-Final.md` pp. 33–34, 46


**Verification:** Test: Inspect an omission and verify that it is an exclusion directive rather than a gram subtraction.

**Status:** Confirmed

---

<a id="br-menu-020"></a>
### BR-MENU-020 — Combo slot membership

**Requirement:**
The ordering system shall accept a selected leaf component variant for a combo slot only when it is configured as an option of that slot for the selected ComboConfiguration.

**Type:** Business rules

**Source:** `docs/md/Modelo-Final.md` pp. 29


**Verification:** Test: Try a configured option and an option configured only for a different combo size or slot.

**Status:** Confirmed

---

<a id="br-menu-021"></a>
### BR-MENU-021 — Item-level group bounds

**Requirement:**
The Menu service shall keep `ModifierGroup.minSelections` and `ModifierGroup.maxSelections` general to the owning leaf `MenuItem` rather than varying them by presentation.

**Type:** Business rules

**Source:** `docs/md/Auditoria-4.md`, item 19


**Verification:** Test: Inspect several presentations of one leaf `MenuItem` and verify that the same group's minimum and maximum apply to all of them.

**Status:** Confirmed

---

<a id="br-menu-022"></a>
### BR-MENU-022 — Supported ingredient operations

**Requirement:**
The Menu service shall restrict ingredient effects to addition and omission operations in the current scope.

**Type:** Business rules

**Source:** `docs/md/Modelo-Final.md` pp. 33–35


**Verification:** Test: Attempt to configure a quantitative removal or set-quantity effect.

**Status:** Confirmed

---

<a id="br-menu-023"></a>
### BR-MENU-023 — Sale eligibility

**Requirement:**
The Menu service shall consider a leaf `MenuItemVariant` or `ComboConfiguration` eligible only if its owning `MenuItem` is ACTIVE, the sellable definition is valid and it has a current positive availability evaluation for the current revision.

**Type:** BR

**Source:** [ADR-001](../../docs/md/Decisiones-cierre-invariantes.md#adr-001)


**Verification:** Exercise each missing prerequisite independently.

**Status:** Confirmed

---

<a id="br-menu-024"></a>
### BR-MENU-024 — Selection ranges

**Requirement:**
The Menu service shall require integer selection limits satisfying 0 <= minSelections <= maxSelections.

**Type:** BR

**Source:** [ADR-005](../../docs/md/Decisiones-cierre-invariantes.md#adr-005)


**Verification:** Reject negative, fractional and inverted limits.

**Status:** Confirmed

---

<a id="br-menu-025"></a>
### BR-MENU-025 — Modifier quantity range

**Requirement:**
The Orders service shall require integer modifier quantities between zero and maxQuantity inclusive.

**Type:** BR

**Source:** [ADR-005](../../docs/md/Decisiones-cierre-invariantes.md#adr-005)


**Verification:** Test zero, cap, cap+1, negative and fractional quantities.

**Status:** Confirmed

---

<a id="br-menu-026"></a>
### BR-MENU-026 — Slot counting

**Requirement:**
The Orders service shall count one selection for each chosen ComboOption regardless of its supplied quantity.

**Type:** BR

**Source:** [ADR-005](../../docs/md/Decisiones-cierre-invariantes.md#adr-005)


**Verification:** An option supplying six units counts once.

**Status:** Confirmed

---

<a id="br-menu-027"></a>
### BR-MENU-027 — Slot repetition

**Requirement:**
The Orders service shall prevent choosing the same ComboOption more than once per combo unit.

**Type:** BR

**Source:** [ADR-005](../../docs/md/Decisiones-cierre-invariantes.md#adr-005)


**Verification:** Reject a repeated option identity; two configured option identities may target the same variant.

**Status:** Confirmed

---

<a id="br-menu-028"></a>
### BR-MENU-028 — Slot bounds

**Requirement:**
The Orders service shall accept a slot only when its selected option count is between minSelections and maxSelections inclusive.

**Type:** BR

**Source:** [ADR-005](../../docs/md/Decisiones-cierre-invariantes.md#adr-005)


**Verification:** Test below, at and above limits.

**Status:** Confirmed

---

<a id="br-menu-029"></a>
### BR-MENU-029 — Slot capacity

**Requirement:**
The Menu service shall consider a slot sellable only if its number of enabled options with an ACTIVE component covers minSelections.

**Type:** BR

**Source:** [ADR-005](../../docs/md/Decisiones-cierre-invariantes.md#adr-005)


**Verification:** Disabled options and archived components contribute zero capacity.

**Status:** Confirmed

---

<a id="br-menu-030"></a>
### BR-MENU-030 — MenuItem activation validation

**Requirement:**
The Menu service shall reject `MenuItem` activation if no ACTIVE leaf presentation remains or any presentation becoming ACTIVE has an unusable modifier group or combo slot.

**Type:** BR

**Source:** [ADR-005](../../docs/md/Decisiones-cierre-invariantes.md#adr-005)


**Verification:** Test an empty active set and a variant with insufficient group or slot capacity.

**Status:** Confirmed

---

<a id="br-menu-031"></a>
### BR-MENU-031 — Retired option eligibility

**Requirement:**
The Menu service shall exclude inactive or archived component variants from new combo selections while allowing a dependent combo to remain eligible when every required slot has another valid option.

**Type:** BR

**Source:** `docs/md/Auditoria-4.md`, items 23–28 and 33–37


**Verification:** Retire chicken: beef remains selectable; no alternatives in required slot makes combo unavailable.

**Status:** Confirmed

---

<a id="br-menu-032"></a>
### BR-MENU-032 — Irreversible archive

**Requirement:**
The Menu service shall prevent reactivating an ARCHIVED variant in this release.

**Type:** BR

**Source:** [ADR-003](../../docs/md/Decisiones-cierre-invariantes.md#adr-003)


**Verification:** Attempt ARCHIVED to ACTIVE or INACTIVE.

**Status:** Confirmed

---

<a id="br-menu-033"></a>
### BR-MENU-033 — Supplied quantity

**Requirement:**
The Menu service shall require a positive integer quantity for each ComboOption.

**Type:** BR

**Source:** `docs/md/Auditoria-4.md`, items 26 and 32


**Verification:** Reject zero, negative and fractional ComboOption quantities.

**Status:** Confirmed

---

<a id="br-menu-034"></a>
### BR-MENU-034 — Omission before addition

**Requirement:**
The Menu service shall exclude only the base ingredient contribution through OMIT before summing ADD effects for the selected component.

**Type:** BR

**Source:** [ADR-003](../../docs/md/Decisiones-cierre-invariantes.md#adr-003)


**Verification:** Base 30, OMIT and ADD 10 produce 10; sibling components remain unchanged.

**Status:** Confirmed

---

<a id="br-menu-035"></a>
### BR-MENU-035 — Revision sequence

**Requirement:**
The Menu service shall assign versions formatted as `<counter>_<ISO8601 timestamp with timezone>`, starting at 1 and incrementing by one per accepted effective change within each `MenuItem` or recipe identity.

**Type:** BR

**Source:** [ADR-006](../../docs/md/Decisiones-cierre-invariantes.md#adr-006)


**Verification:** Verify initial 1, next 2, timezone and independent `MenuItem`/recipe counters.

**Status:** Confirmed

---

<a id="br-menu-036"></a>
### BR-MENU-036 — No-op revision

**Requirement:**
The Menu service shall preserve the version when the same change is retried or an identical definition is saved.

**Type:** BR

**Source:** [ADR-006](../../docs/md/Decisiones-cierre-invariantes.md#adr-006)


**Verification:** Repeat a change and an identical save; no extra revision is created.

**Status:** Confirmed

---

<a id="br-menu-037"></a>
### BR-MENU-037 — Pinned recipe adoption

**Requirement:**
The Menu service shall preserve a presentation's recipe revision reference until an explicit `MenuItem` edit adopts another revision.

**Type:** BR

**Source:** [ADR-006](../../docs/md/Decisiones-cierre-invariantes.md#adr-006)


**Verification:** Publish recipe v2 while a presentation pins v1; the reference stays v1 until the `MenuItem` is edited.

**Status:** Confirmed

---

<a id="br-menu-038"></a>
### BR-MENU-038 — Default historical identity

**Requirement:**
The Menu service shall preserve the historical identity of DEFAULT while creating new identities for its presentation-characteristic replacements.

**Type:** BR

**Source:** [ADR-008](../../docs/md/Decisiones-cierre-invariantes.md#adr-008)


**Verification:** Verify existing order references still identify DEFAULT after migration.

**Status:** Confirmed

---

<a id="br-menu-039"></a>
### BR-MENU-039 — Zero modifier capacity

**Requirement:**
The Menu service shall allow a nonnegative integer maxQuantity in a modifier configuration.

**Type:** BR

**Source:** [ADR-005](../../docs/md/Decisiones-cierre-invariantes.md#adr-005)


**Verification:** Zero contributes no capacity and cannot be selected; fractional and negative caps fail.

**Status:** Confirmed

---

<a id="br-menu-040"></a>
### BR-MENU-040 — Presentation sale identity

**Requirement:**
The Menu service shall exclude leaf presentations without a complete set of presentation values from new sales when the `MenuItem` has customer-selectable presentation characteristics.

**Type:** BR

**Source:** [ADR-008](../../docs/md/Decisiones-cierre-invariantes.md#adr-008)


**Verification:** After presentation characteristics are introduced, DEFAULT cannot remain offered as an unspecified presentation.

**Status:** Confirmed

---

<a id="br-menu-041"></a>
### BR-MENU-041 — Monetary validation

**Requirement:**
The Menu service shall reject negative prices or adjustments, incompatible restaurant currencies and amounts exceeding the configured currency precision.

**Type:** BR

**Source:** [ALIGN](../../docs/reviews/ers-interfaces-alignment/decisions.md)


**Verification:** Accept zero; reject excess precision, including trailing zeros, without rounding. Inspect the approved external monetary contract in ALIGN: currency selected at provisioning, minorUnit derived from ISO 4217, retained accepted revision shared with Orders, no external lookup per sale, and no ordinary currency substitution. Missing accepted configuration blocks monetary writes and resolution; provider outage does not invalidate accepted configuration.

**Status:** Confirmed

---

<a id="br-menu-042"></a>
### BR-MENU-042 — Physical positivity

**Requirement:**
The Menu service shall reject nonpositive physical quantities in stocked fulfillment, recipes and ingredient additions.

**Type:** BR

**Source:** [ALIGN](../../docs/reviews/ers-interfaces-alignment/decisions.md)


**Verification:** Omission uses OMIT; zero net omitted from resolution; reject negative/zero input quantities.

**Status:** Confirmed

---

<a id="br-menu-043"></a>
### BR-MENU-043 — Immutable MenuItem type

**Requirement:**
The Menu service shall reject changing the contractual `fulfillmentType` of an existing `MenuItem`.

**Type:** BR

**Source:** [ALIGN](../../docs/reviews/ers-interfaces-alignment/decisions.md)


**Verification:** Attempt STOCKED to PREPARED even before activation; create a new identity instead.

**Status:** Confirmed

---

<a id="br-menu-044"></a>
### BR-MENU-044 — Names are labels

**Requirement:**
The Menu service shall allow repeated display names for entities with distinct valid identities.

**Type:** BR

**Source:** [ALIGN](../../docs/reviews/ers-interfaces-alignment/decisions.md)


**Verification:** Repeated labels accepted; repeated presentation combinations still rejected.

**Status:** Confirmed

---

## Confirmed consumer UI business rules

<a id="br-ui-001"></a>
### BR-UI-001 — Pre-order accumulated cost

**Rule Statement:**
The ordering UI shall calculate the displayed pre-order accumulated cost as the sum of each configured line cost, where each line cost equals its quantity multiplied by its resolved unit subtotal.

**Domain Entities Involved:** DraftOrderLine, MenuItemVariant, PriceSummary

**Source:** Explicit price clarification in the user request dated 2026-09-13 and E-16; consolidated in `output/ui-spec/ui-data-spec.md`, section 6.3.


**Enforcement:** Recalculate the local accumulation when quantity or configuration changes and display it separately from the existing order total and final Billing amount.

**Status:** Confirmed
