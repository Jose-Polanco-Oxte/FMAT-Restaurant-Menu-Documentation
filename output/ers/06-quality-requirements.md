[← Index](./index.md)

# Quality requirements

Each block states one primary obligation. Enumerated attributes describe one fact or operation, not independent steps. Verification entries are proposed acceptance criteria, not executed software tests. Model names identify domain concepts, not required technologies.

---

<a id="qa-menu-001"></a>
### QA-MENU-001 — Deterministic selection resolution

**Requirement:**
The system shall resolve permitted combo selections from explicit ComboConfiguration and ComboOption records and shall provide published leaf-variant modifier behavior without inferring default precedence during order taking.

**Type:** Quality requirements

**Source:** `docs/md/Auditoria-4.md`, items 17 and 21–22, and `Modelo-Final.md` pp. 29–30.


**Verification:** Analysis: Trace a combo selection to its ComboConfiguration and a leaf modifier to its published resolved projection. This requirement prescribes no O(1) or index plan; latency acceptance criteria are in QA-MENU-004 through QA-MENU-017.

**Status:** Confirmed

---

<a id="qa-menu-002"></a>
### QA-MENU-002 — Historical fulfillment continuity

**Requirement:**
The Orders service shall complete processing of a confirmed line using its persisted snapshot even when original variants, recipes or configurations are archived or changed.

**Type:** QA

**Source:** [ADR-003](../../docs/md/Decisiones-cierre-invariantes.md#adr-003)


**Verification:** Confirm a line, archive its variant and change its recipe, then process and reverse an authorized movement using original quantities.

**Status:** Confirmed

---

---

<a id="qa-menu-003"></a>
### QA-MENU-003 — Catalog consistency

**Requirement:**
The Menu service shall prevent acceptance of variant configurations that violate BR-MENU-002, BR-MENU-003 or BR-MENU-004.

**Type:** Quality requirements

**Source:** `docs/md/Modelo-Final.md` pp. 21


**Verification:** Test: Attempt each prohibited configuration through catalog operations and verify rejection without accepting the invalid state. This is a consistency property over the referenced rules, not an additional rule or database mandate.

**Status:** Confirmed

---

<a id="qa-menu-004"></a>
### QA-MENU-004 — Menu browsing p95

**Requirement:**
The system shall meet p95 <= 200 ms for search and category changes under the ADR-004 nominal profile.

**Type:** QA

**Source:** [ADR-004](../../docs/md/Decisiones-cierre-invariantes.md#adr-004)


**Verification:** Measure the named class end to end with 40 clients, 30 requests/s for 30 min and the ADR-004 workload mix.

**Status:** Confirmed

---

<a id="qa-menu-005"></a>
### QA-MENU-005 — Availability p95

**Requirement:**
The system shall meet p95 <= 300 ms for projected availability queries under the ADR-004 nominal profile.

**Type:** QA

**Source:** [ADR-004](../../docs/md/Decisiones-cierre-invariantes.md#adr-004)


**Verification:** Measure the named class end to end with 40 clients, 30 requests/s for 30 min and the ADR-004 workload mix.

**Status:** Confirmed

---

<a id="qa-menu-006"></a>
### QA-MENU-006 — Configuration p95

**Requirement:**
The system shall meet p95 <= 300 ms for validation and price recalculation under the ADR-004 nominal profile.

**Type:** QA

**Source:** [ADR-004](../../docs/md/Decisiones-cierre-invariantes.md#adr-004)


**Verification:** Measure the named class end to end with 40 clients, 30 requests/s for 30 min and the ADR-004 workload mix.

**Status:** Confirmed

---

<a id="qa-menu-007"></a>
### QA-MENU-007 — Order line p95

**Requirement:**
The system shall meet p95 <= 300 ms for order line editing under the ADR-004 nominal profile.

**Type:** QA

**Source:** [ADR-004](../../docs/md/Decisiones-cierre-invariantes.md#adr-004)


**Verification:** Measure the named class end to end with 40 clients, 30 requests/s for 30 min and the ADR-004 workload mix.

**Status:** Confirmed

---

<a id="qa-menu-008"></a>
### QA-MENU-008 — Interactive p99

**Requirement:**
The system shall meet p99 <= 1 s for each operation class in QA-MENU-004 through QA-MENU-007 under the ADR-004 nominal profile.

**Type:** QA

**Source:** [ADR-004](../../docs/md/Decisiones-cierre-invariantes.md#adr-004)


**Verification:** Measure the named class end to end with 40 clients, 30 requests/s for 30 min and the ADR-004 workload mix.

**Status:** Confirmed

---

<a id="qa-menu-009"></a>
### QA-MENU-009 — Orders acknowledgement p95

**Requirement:**
The system shall meet p95 <= 500 ms for send-to-kitchen through Orders acknowledgement under the ADR-004 nominal profile.

**Type:** QA

**Source:** [ADR-004](../../docs/md/Decisiones-cierre-invariantes.md#adr-004)


**Verification:** Measure the named class end to end with 40 clients, 30 requests/s for 30 min and the ADR-004 workload mix.

**Status:** Confirmed

---

<a id="qa-menu-010"></a>
### QA-MENU-010 — Orders acknowledgement p99

**Requirement:**
The system shall meet p99 <= 1 s for send-to-kitchen through Orders acknowledgement under the ADR-004 nominal profile.

**Type:** QA

**Source:** [ADR-004](../../docs/md/Decisiones-cierre-invariantes.md#adr-004)


**Verification:** Measure the named class end to end with 40 clients, 30 requests/s for 30 min and the ADR-004 workload mix.

**Status:** Confirmed

---

<a id="qa-menu-011"></a>
### QA-MENU-011 — Kitchen visibility p95

**Requirement:**
The system shall meet p95 <= 1 s for POS submission through KDS visibility under the ADR-004 nominal profile.

**Type:** QA

**Source:** [ADR-004](../../docs/md/Decisiones-cierre-invariantes.md#adr-004)


**Verification:** Measure the named class end to end with 40 clients, 30 requests/s for 30 min and the ADR-004 workload mix.

**Status:** Confirmed

---

<a id="qa-menu-012"></a>
### QA-MENU-012 — Kitchen visibility p99

**Requirement:**
The system shall meet p99 <= 2 s for POS submission through KDS visibility under the ADR-004 nominal profile.

**Type:** QA

**Source:** [ADR-004](../../docs/md/Decisiones-cierre-invariantes.md#adr-004)


**Verification:** Measure the named class end to end with 40 clients, 30 requests/s for 30 min and the ADR-004 workload mix.

**Status:** Confirmed

---

<a id="qa-menu-013"></a>
### QA-MENU-013 — Nominal error rate

**Requirement:**
The system shall keep internal errors below 0.1% of offered requests under the ADR-004 nominal profile.

**Type:** QA

**Source:** [ADR-004](../../docs/md/Decisiones-cierre-invariantes.md#adr-004)


**Verification:** Count internal errors against offered nominal requests; deliberate invalid-input cases are separate.

**Status:** Confirmed

---

<a id="qa-menu-014"></a>
### QA-MENU-014 — No lost orders

**Requirement:**
The system shall withstand the ADR-004 burst of 100 requests/s for 60 seconds without loss of accepted orders.

**Type:** QA

**Source:** [ADR-004](../../docs/md/Decisiones-cierre-invariantes.md#adr-004)


**Verification:** Reconcile every accepted request with persisted results and verify the named property; no nominal latency bound is claimed during burst.

**Status:** Confirmed

---

<a id="qa-menu-015"></a>
### QA-MENU-015 — No duplicate orders

**Requirement:**
The system shall withstand the ADR-004 burst of 100 requests/s for 60 seconds without duplication of accepted orders.

**Type:** QA

**Source:** [ADR-004](../../docs/md/Decisiones-cierre-invariantes.md#adr-004)


**Verification:** Reconcile every accepted request with persisted results and verify the named property; no nominal latency bound is claimed during burst.

**Status:** Confirmed

---

<a id="qa-menu-016"></a>
### QA-MENU-016 — No order corruption

**Requirement:**
The system shall withstand the ADR-004 burst of 100 requests/s for 60 seconds without corruption of accepted order content.

**Type:** QA

**Source:** [ADR-004](../../docs/md/Decisiones-cierre-invariantes.md#adr-004)


**Verification:** Reconcile every accepted request with persisted results and verify the named property; no nominal latency bound is claimed during burst.

**Status:** Confirmed

---

<a id="qa-menu-017"></a>
### QA-MENU-017 — Burst continuity

**Requirement:**
The system shall withstand the ADR-004 burst of 100 requests/s for 60 seconds without service crashes.

**Type:** QA

**Source:** [ADR-004](../../docs/md/Decisiones-cierre-invariantes.md#adr-004)


**Verification:** Reconcile every accepted request with persisted results and verify the named property; no nominal latency bound is claimed during burst.

**Status:** Confirmed
