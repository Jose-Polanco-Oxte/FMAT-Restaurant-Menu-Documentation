[← Index](./index.md)

# Architecture and design constraints

Each block states one primary obligation. Enumerated attributes describe one fact or operation, not independent steps. Verification entries are proposed acceptance criteria, not executed software tests. Model names identify domain concepts, not required technologies. `Auditoria-4.md` is the active source for the `MenuItem` type and projection boundaries.

---

These architecture decisions come from the sources; they are not presented as unavoidable restaurant-domain constraints.
---

<a id="con-menu-001"></a>
### CON-MENU-001 — Inventory database boundary

**Requirement:**
The Menu service shall maintain no database foreign-key relationship to Inventory-owned data.

**Type:** Architecture and design constraints

**Source:** `docs/md/Modelo-Final.md` pp. 19


**Verification:** Inspection: Compare the domain model and relevant contracts with the stated boundary or representation.

**Status:** Confirmed

---

<a id="con-menu-002"></a>
### CON-MENU-002 — Aggregate boundaries

**Requirement:**
The Menu domain model shall separate Menu, MenuItem and Recipe into independent aggregate roots.

**Type:** Architecture and design constraints

**Source:** `docs/md/Modelo-Final.md` pp. 21–23


**Verification:** Inspection: Compare the domain model and relevant contracts with the stated boundary or representation.

**Status:** Confirmed

---

<a id="con-menu-003"></a>
### CON-MENU-003 — Explicit modifier configuration

**Requirement:**
The Menu domain model shall define modifier behavior once in ModifierOption.defaultConfig and represent only variant-specific differences in optional VariantModifierConfig records.

**Type:** Architecture and design constraints

**Source:** `docs/md/Auditoria-4.md`, items 14–18


**Verification:** Inspection: Verify that a variant without an exception resolves to the option default and that an exception is present only when behavior differs.

**Status:** Confirmed

---

<a id="con-menu-004"></a>
### CON-MENU-004 — Authoritative variant price

**Requirement:**
The Menu domain model shall use `MenuItemVariant.unitPrice` as the authoritative unit price for PREPARED/STOCKED leaf `MenuItem` records and `ComboConfiguration.unitPrice` as the authoritative unit price for COMBO.

**Type:** Architecture and design constraints

**Source:** `docs/md/Modelo-Final.md` pp. 26–28


**Verification:** Inspection: Compare the domain model and relevant contracts with the stated boundary or representation.

**Status:** Confirmed

---

<a id="con-menu-005"></a>
### CON-MENU-005 — Universal sellable reference

**Requirement:**
The ordering contract shall identify a concrete MenuItemVariant for every PREPARED or STOCKED order line and a ComboConfiguration for every COMBO order line.

**Type:** Architecture and design constraints

**Source:** `docs/md/Auditoria-4.md`, items 1–5 and 43


**Verification:** Inspection: Verify that leaf and combo order references use their respective concrete sellable identities and that no leaf variantId is nullable.

**Status:** Confirmed

---

<a id="con-menu-006"></a>
### CON-MENU-006 — Inventory entity ownership

**Requirement:**
The Menu domain model shall exclude Inventory entities and cross-service object relationships from its internal model.

**Type:** Architecture and design constraints

**Source:** `docs/md/Modelo-Final.md` pp. 19–21


**Verification:** Inspection: Compare the domain model and relevant contracts with the stated boundary or representation.

**Status:** Confirmed

---

<a id="con-menu-007"></a>
### CON-MENU-007 — Recipe ownership

**Requirement:**
The Menu service shall own culinary recipe definitions.

**Type:** Architecture and design constraints

**Source:** `docs/md/Modelo-Final.md` pp. 20–23


**Verification:** Inspection: Compare the domain model and relevant contracts with the stated boundary or representation.

**Status:** Confirmed

---

<a id="con-menu-008"></a>
### CON-MENU-008 — Historical retention

**Requirement:**
The Menu service shall retain historical `MenuItem`, presentation, recipe and configuration revisions without physical purging in this release.

**Type:** CON

**Source:** [ADR-003](../../docs/md/Decisiones-cierre-invariantes.md#adr-003)


**Verification:** Attempt physical deletion and verify rejection; archived data remains retrievable.

**Status:** Confirmed

---

---

<a id="con-menu-009"></a>
### CON-MENU-009 — Inventory language

**Requirement:**
The Inventory service shall interpret received requirements only as inventory items, quantities and units, using opaque keys without `MenuItem` or presentation semantics.

**Type:** CON

**Source:** [ADR-001](../../docs/md/Decisiones-cierre-invariantes.md#adr-001)


**Verification:** Inspect contracts for absence of recipe, modifier and combo resolution rules in Inventory.

**Status:** Confirmed

---

<a id="con-menu-010"></a>
### CON-MENU-010 — Availability subscription

**Requirement:**
The Menu-Inventory integration shall exchange requirement changes and availability evaluations through publish/subscribe.

**Type:** CON

**Source:** [ADR-001](../../docs/md/Decisiones-cierre-invariantes.md#adr-001)


**Verification:** Inspect both event directions; no echo loop republishes availability as requirements.

**Status:** Confirmed

---

<a id="con-menu-011"></a>
### CON-MENU-011 — Atomic outbox

**Requirement:**
The Orders service shall persist the confirmation request snapshot and its movement delivery work in the same local transaction through an outbox.

**Type:** CON

**Source:** [ADR-003](../../docs/md/Decisiones-cierre-invariantes.md#adr-003)


**Verification:** Inject failure before and after commit; no movement delivery exists without its persisted snapshot and committed work remains retryable.

**Status:** Confirmed

---

<a id="con-menu-012"></a>
### CON-MENU-012 — Approved interface conventions

**Requirement:**
The Menu service shall enforce the approved authorization, identity scope, concurrency and idempotency conventions in the interface package, including seven-day complete-result retention and durable compact records that prevent silent reexecution after expiry.

**Type:** CON

**Source:** [ALIGN](../../docs/reviews/ers-interfaces-alignment/decisions.md)


**Verification:** Inspect D-01–D-09, HTTP permissions, ETags and logical channels; verify seven-day expiry, retained audit and pending changes, and expired-result rejection under the approved OPEN-010 decision. No broker/storage product mandated.

**Status:** Confirmed

---

<a id="con-menu-013"></a>
### CON-MENU-013 — Menu durable publication

**Requirement:**
The Menu service shall persist its effective changes and pending publication work atomically through its own outbox.

**Type:** CON

**Source:** [ALIGN](../../docs/reviews/ers-interfaces-alignment/decisions.md)


**Verification:** Inspect M-01 and conventions; distinguish Orders outbox CON-MENU-011.

**Status:** Confirmed

---

<a id="con-menu-014"></a>
### CON-MENU-014 — Separate combo configuration identity

**Requirement:**
The Menu domain model shall represent COMBO sellable configurations with ComboConfiguration rather than reusing MenuItemVariant.

**Type:** Architecture and design constraints

**Source:** `docs/md/Auditoria-4.md`, items 23, 29–32.


**Verification:** Inspection: Verify that combo definitions contain ComboConfiguration records and that ComboOption references leaf variants.

**Status:** Confirmed

---

<a id="con-menu-015"></a>
### CON-MENU-015 — Separate category repositories

**Requirement:**
The Menu domain model shall use `ItemCategory` for PREPARED and STOCKED `MenuItem` records and `ComboCategory` for COMBO `MenuItem` records.

**Type:** Architecture and design constraints

**Source:** `docs/md/Auditoria-4.md`, items 33–38.


**Verification:** Inspection: Verify that a leaf cannot use a ComboCategory and a combo cannot use an ItemCategory or leaf commercial classification.

**Status:** Confirmed
