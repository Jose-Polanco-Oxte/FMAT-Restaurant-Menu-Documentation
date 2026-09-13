# Requirement Templates & Formats

This document defines the exact Markdown templates for each section of the Requirements Specification (`/output/ers/`).

---

## 1. Functional Requirement Template

```markdown
### REQ-<DOMAIN>-NNN — <Short Title>

**Requirement:**
The <system / service name> shall <observable action> <condition, when applicable>.

**Type:** Functional
**Source:** <Document Name, Page/Section, or Conversation Excerpt>
**Rationale:** <Brief non-normative context on why this requirement exists>
**Verification:** <Test | Inspection | Analysis | Demonstration>: <Clear objective procedure based on sources>
**Status:** Confirmed
```

---

## 2. Business Rule Template

```markdown
### BR-<DOMAIN>-NNN — <Rule Title>

**Rule Statement:**
The system shall <prevent / enforce / calculate> <business constraint or calculation logic> when <condition>.

**Domain Entities:** <List of relevant domain entities>
**Source:** <Exact citation from sources>
**Rationale:** <Business reasoning from conversation/decision log>
**Enforcement:** <How the system enforces the rule, e.g. rejection of invalid payload, runtime calculation>
**Status:** Confirmed
```

---

## 3. Data Requirement Template

```markdown
### DATA-<DOMAIN>-NNN — <Entity / Attribute Requirement Title>

**Specification:**
The <Service / Domain> shall persist the entity `<EntityName>` with the following attributes and invariants:
- `<attribute_1>`: <Type/Constraint>
- `<attribute_2>`: <Type/Constraint>

**Invariants:**
1. <Domain invariant statement>

**Source:** <Citation>
**Rationale:** <Origin in domain design>
**Verification:** Inspection / Test: <Verification details>
**Status:** Confirmed
```

---

## 4. Interface and Integration Template

```markdown
### INT-<DOMAIN>-NNN — <Interface or Integration Title>

**Requirement:**
The <Source Service> shall <send / query / publish> <contract or payload> to <Target Service> when <condition>.

**Protocol / Mechanism:** <Synchronous HTTP / Asynchronous Event / Direct ID reference, as stated in sources>
**Contract Elements:** <Entities/attributes transmitted>
**Source:** <Citation>
**Rationale:** <Architectural boundary and decoupling decision>
**Verification:** Test / Inspection
**Status:** Confirmed
```

---

## 5. Constraint Template

```markdown
### CON-<DOMAIN>-NNN — <Constraint Title>

**Constraint Statement:**
The system architecture shall <respect constraint, e.g., isolate service datastores without cross-service database transactions>.

**Category:** Architecture | Technology | Security | Regulatory
**Source:** <Citation>
**Rationale:** <Discussion or design principle establishing this boundary>
**Verification:** Inspection of architectural design and schema definitions.
**Status:** Confirmed
```

---

## 6. Superseded Decision Template

```markdown
### SUPERSEDED-NNN — <Original Decision Title>

**Previous Decision:**
<Description of the superseded decision or previous model structure>

**Original Source:** <Citation of earlier discussion/decision>
**Superseded By:** <Active decision or requirement replacing it>
**Superseding Source:** <Citation of the subsequent modification>
**Impact:** <Which active components, requirements, or diagrams are affected>
```

---

## 7. Active Conflict Template

```markdown
### CONFLICT-NNN — <Conflict Summary>

**Source A:** <Citation A>
**Interpretation A:** <Stated behavior or decision in Source A>

**Source B:** <Citation B>
**Interpretation B:** <Contradictory behavior or decision in Source B>

**Impact:** <List of requirements or design points blocked by this contradiction>
**Decision Required:** <Explicit question for project architect or product owner>
```

---

## 8. Pending Specification Template

```markdown
### OPEN-NNN — <Ambiguity or Missing Information Topic>

**Evidence:** <Citation where the need or concept was introduced>
**Known Information:** <What is confirmed by the sources>
**Missing Information:** <What essential operational parameters or boundary conditions are omitted>
**Question to be Resolved:** <Formulation of the question needed to complete the requirement>
```

---

## 9. Traceability Matrix Table Format

```markdown
| ID | Requirement / Rule Summary | Type | Source Citation | Status |
| :--- | :--- | :--- | :--- | :--- |
| `REQ-AUTH-001` | Validate token payload locally without synchronous roundtrip | Functional | `architecture-decisions.md` §3.1 | Confirmed |
| `BR-CATALOG-001` | Modification option without resource deltas represents non-inventory customization | Business Rule | `design-notes.pdf` p. 12 | Confirmed |
| `CON-ARCH-001` | Isolate service datastores without cross-database foreign keys | Constraint | `system-architecture.pdf` p. 4 | Confirmed |
```

---

## 10. `index.md` Master Layout Format

```markdown
# Requirements Specification (ERS / SRS) — <System Name>

## Executive Overview
- **System**: <Name of System/Microservice>
- **Status**: <Draft / Baseline / Audited>
- **Analyzed Sources**:
  - `<Document 1>`
  - `<Document 2>`

## Specification Metrics & Status Summary

| Category | Identifier Prefix | Confirmed Count | Open / Conflicted |
| :--- | :--- | :--- | :--- |
| Scope & Actors | N/A | - | - |
| Functional Requirements | `REQ-*` | N | - |
| Business Rules | `BR-*` | N | - |
| Data Requirements | `DATA-*` | N | - |
| Interfaces & Integrations | `INT-*` | N | - |
| Quality Attributes | `QA-*` | N | - |
| Constraints | `CON-*` | N | - |
| Superseded Decisions | `SUPERSEDED-*`| N | - |
| Active Conflicts | `CONFLICT-*` | - | N |
| Open Items | `OPEN-*` | - | N |

## Modular Navigation

1. [01. Identified Scope & Domain Actors](./01-scope-and-actors.md)
2. [02. Functional Requirements](./02-functional-requirements.md)
3. [03. Business Rules](./03-business-rules.md)
4. [04. Data Requirements](./04-data-requirements.md)
5. [05. Interface and Integration Requirements](./05-interfaces-integrations.md)
6. [06. Quality Requirements](./06-quality-requirements.md)
7. [07. Architectural and Design Constraints](./07-constraints.md)
8. [08. Superseded Decisions Log](./08-superseded-decisions.md)
9. [09. Detected Conflicts & Open Specification Items](./09-conflicts-and-open-items.md)
10. [10. Comprehensive Traceability Matrix](./10-traceability-matrix.md)
```
