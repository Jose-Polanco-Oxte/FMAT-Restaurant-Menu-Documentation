---
name: requirements-spec
description: >-
  Extract, draft, reconcile, and structure software requirements specifications (ERS / SRS) from design discussions, architecture decisions, and domain models following ISO/IEC/IEEE 29148:2018 guidelines. Make sure to use this skill whenever the user mentions requirements specification, ERS, SRS, functional requirements, especificación de requisitos, extraer o redactar requerimientos de software, or requests analyzing design/architecture sources to generate specification documents into /output/ers/.
---

# Requirements Specification Skill (`requirements-spec`)

This skill guides the agent to act as a **Senior Requirements Engineer and Systems Analyst**, transforming architecture and design conversations, domain decisions, transcripts, notes, and technical documentation into a **traceable, precise, modular, and verifiable Requirements Specification (ERS / SRS)**.

The specification is output to the workspace directory `/output/ers/`, consisting of an executive `index.md` and several modular Markdown files adhering to the principles defined in this skill and ISO/IEC/IEEE 29148:2018 (incorporating any workspace-level rules like `.agents/REQUIREMENTS-SPEC.md` if present).

The skill is completely **file-agnostic and domain-agnostic**: it operates on whatever input sources are provided by the user or discovered in the workspace (PDFs, Markdown notes, transcripts, diagrams, ADRs, etc.).

---

## 1. Core Principles

### 1.1 Source of Truth (Zero Fabrication)
- The sources provided (transcripts, architecture documents, domain conversations, design diagrams, user prompts) are the **exclusive source of truth**.
- **Do not invent requirements** or fill gaps using best practices, common industry conventions, or unstated domain assumptions.
- Every requirement must answer: *Which excerpt or decision from the sources justifies this requirement?*
- If information is insufficient, ambiguous, or open, document it as a **Pending Specification (`OPEN-NNN`)** or **Conflict (`CONFLICT-NNN`)**; never present assumptions as confirmed requirements.

### 1.2 Temporal Authority of Decisions
- Identify decision evolution over time across the provided sources.
- When a subsequent decision explicitly modifies, corrects, supersedes, restricts, or redefines an earlier one, the **latest decision is active**.
- Do not synthesize an artificial compromise between conflicting old and new decisions.
- Record superseded decisions under **Superseded Decisions (`SUPERSEDED-NNN`)** to maintain full auditability.

### 1.3 Differentiation of Need vs. Solution
Carefully distinguish between:
1. **Business needs**: The underlying goal or problem to solve.
2. **System behaviors (Functional Requirements)**: What the system or service must do in an observable manner.
3. **Domain rules (Business Rules)**: Invariant policies, constraints on calculations, allowed/prohibited states.
4. **Architectural & Technical Constraints**: Non-negotiable boundaries, protocols, decoupling decisions.
5. **Design & Data Decisions**: Internal structural mechanisms. Do not promote internal designs to functional requirements unless mandated as constraints.
6. **Implementation details**: Low-level code or configuration specifics.
7. **Conversational Examples**: Concrete illustrations used during discussions. Examples are not rules.

### 1.4 ISO/IEC/IEEE 29148:2018 Quality Standard
Each requirement must satisfy the 9 quality characteristics:
1. **Necessary**: Solves an actual obligation or active decision from the sources. Removing it causes a functional/architectural gap.
2. **Appropriate**: Right level of abstraction; avoids implementation details not mandated by sources.
3. **Unambiguous**: Only one reasonable interpretation. Prohibited: *fast*, *adequate*, *easy*, *sufficient*, *as needed*, *etc.*
4. **Complete**: Contains subject, observable behavior, condition, boundaries, and expected result.
5. **Singular**: Expresses a single primary obligation (avoid composite statements joined by *and*, *furthermore*, *also*).
6. **Feasible**: Technically compatible with active architecture; not discarded.
7. **Verifiable**: Objective means to verify via Inspection, Analysis, Demonstration, or Test.
8. **Correct**: Faithfully represents source intent without modifying meaning for elegance.
9. **Conforming**: Consistently adheres to the defined format, identifiers, and syntax.

### 1.5 Strict Drafting Syntax
- Use the mandatory construction:
  - `The system shall [observable behavior] [condition, when necessary].`
  - When a responsible component/service is explicitly assigned:
    `The <Name> service shall [observable behavior] [condition, when necessary].`
  - For business rules:
    `The system shall prevent [action] when [condition].`
    `The system shall allow [action] only when [condition].`
    `When [condition], the system shall [action].`
- **Mandatory `shall`**: Never use `should`, `could`, `may`, `preferably`, or `it would be convenient`.
- **Do not fabricate verifiability**: Never invent numerical metrics (e.g. response times in ms, SLAs), HTTP status codes, or retry limits if not present in sources. Instead, flag missing metrics under `OPEN-NNN`.

---

## 2. Output Directory Structure (`/output/ers/`)

When activated, this skill creates or updates the specification files inside `<workspace>/output/ers/`:

```
output/ers/
├── index.md                      # Navigation hub, scope summary, metrics & status overview
├── 01-scope-and-actors.md        # Scope, boundaries, actors, and domain vocabulary
├── 02-functional-requirements.md # Confirmed functional requirements (REQ-<DOMAIN>-NNN)
├── 03-business-rules.md          # Domain and business rules (BR-<DOMAIN>-NNN)
├── 04-data-requirements.md       # Data entities, invariants, and persistence (DATA-<DOMAIN>-NNN)
├── 05-interfaces-integrations.md # Inter-service interfaces, contracts, events (INT-<DOMAIN>-NNN)
├── 06-quality-requirements.md    # Verifiable quality attributes (QA-<DOMAIN>-NNN)
├── 07-constraints.md             # Architecture, design & technology constraints (CON-<DOMAIN>-NNN)
├── 08-superseded-decisions.md    # Chronological log of replaced decisions (SUPERSEDED-NNN)
├── 09-conflicts-and-open-items.md# Active conflicts (CONFLICT-NNN) & open points (OPEN-NNN)
└── 10-traceability-matrix.md     # Cross-reference matrix linking all IDs to sources & status
```

> If a category has no items identified in the sources, retain the modular file and state:
> *"No confirmed items of this category were identified in the analyzed sources."*

---

## 3. Standard Identifiers & Templates

### 3.1 Identifiers Schema
- `REQ-<DOMAIN>-NNN`: Functional requirements (e.g., `REQ-CORE-001`)
- `BR-<DOMAIN>-NNN`: Business rules (e.g., `BR-CORE-001`)
- `DATA-<DOMAIN>-NNN`: Data requirements (e.g., `DATA-CORE-001`)
- `INT-<DOMAIN>-NNN`: Interface/integration requirements (e.g., `INT-CORE-001`)
- `QA-<DOMAIN>-NNN`: Quality attributes (e.g., `QA-CORE-001`)
- `CON-<DOMAIN>-NNN`: Architecture/design constraints (e.g., `CON-CORE-001`)
- `SUPERSEDED-NNN`: Chronologically replaced decisions (e.g., `SUPERSEDED-001`)
- `CONFLICT-NNN`: Incompatible active decisions (e.g., `CONFLICT-001`)
- `OPEN-NNN`: Pending decisions, ambiguities, missing data (e.g., `OPEN-001`)

### 3.2 Standard Requirement Block
```markdown
### REQ-<DOMAIN>-NNN — <short descriptive name>

**Requirement:**
The <System/Service> shall <observable behavior> <condition>.

**Type:** Functional | Quality | Interface | Data | Security | Constraint | Other

**Source:** <Exact citation, source file name, page number, section, or message reference>

**Rationale:**
Briefly explain what intent, need, or decision from the sources gives rise to the requirement. (Non-normative, introduces no obligations).

**Verification:**
Describe how it will be objectively verified (Inspection | Analysis | Demonstration | Test) using only conditions derivable from sources.

**Status:** Confirmed
```

### 3.3 Business Rule Block
```markdown
### BR-<DOMAIN>-NNN — <short rule title>

**Rule Statement:**
The system shall <allow | prevent | calculate> <logic> when <condition>.

**Domain Entities Involved:** <Entity1>, <Entity2>

**Source:** <Citation>

**Rationale:** <Reasoning behind the rule>

**Enforcement:** <How the rule is enforced and verified>

**Status:** Confirmed
```

### 3.4 Conflict Block
```markdown
### CONFLICT-NNN — <short description>

**Source A:** <Citation>
**Interpretation A:** <Meaning>

**Source B:** <Citation>
**Interpretation B:** <Meaning>

**Impact:** <Which requirements or design decisions cannot be settled while open>
**Decision Required:** <Explicit question to be resolved by stakeholders>
```

### 3.5 Pending Specification Block
```markdown
### OPEN-NNN — <topic>

**Evidence:** <Citation>
**Known Information:** <What is established>
**Missing Information:** <What is missing>
**Question to be Resolved:** <Clarifying question>
```

### 3.6 Superseded Decision Block
```markdown
### SUPERSEDED-NNN — <original decision title>

**Previous Decision:** <What was previously decided>
**Source:** <Citation of earlier decision>
**Superseded By:** <What is now the active decision>
**Superseding Source:** <Citation of new decision>
**Impact:** <Which active requirement or architecture now reflects this change>
```

---

## 4. Execution Workflow

When this skill is invoked:

1. **Source Discovery & Parsing**:
   - Inspect the input sources indicated by the user (prompts, attached files, or files present in the workspace such as PDFs, markdown notes, ADRs, transcripts, specifications).
   - If the user did not specify filenames, discover relevant documentation and input files available in the workspace.
   - Trace conversation and decision timelines to establish chronological sequence and detect superseding decisions.

2. **Categorization & Quality Pass**:
   - Classify statements into requirements, business rules, constraints, data rules, interfaces, conflicts, or open points.
   - Filter out mere examples, discarded alternatives, and ungrounded assumptions.
   - Apply the 9 ISO 29148 quality checks. Enforce normative `shall`.

3. **Directory & File Generation (`/output/ers/`)**:
   - Ensure the directory `<workspace>/output/ers/` exists.
   - Generate `output/ers/index.md` with:
     - Document metadata (System Name, Version, Date, Source List).
     - Executive summary of the system and analyzed scope.
     - Table of metrics (counts of confirmed REQs, BRs, CONs, QA, INT, OPEN, CONFLICTS).
     - Full Table of Contents with relative links (`[Functional Requirements](./02-functional-requirements.md)`).
   - Generate all modular files (`01-scope-and-actors.md` to `10-traceability-matrix.md`) populating them with the formatted blocks.
   - Fill the Traceability Matrix in `10-traceability-matrix.md` cross-referencing all entities.

4. **Consistency & Link Verification**:
   - Verify that all relative links between `index.md` and the modular files are working.
   - Ensure ID numbering is sequential, stable, and unique across all files.

---

## 5. Bundled References

For deeper guidance, consult the reference files bundled with this skill:
- [`references/spec-standard.md`](./references/spec-standard.md): In-depth principles, quality standards, and temporal authority rules.
- [`references/templates.md`](./references/templates.md): Copy-paste Markdown templates for all artifact types.
- [`references/modular-structure.md`](./references/modular-structure.md): Guide to the `/output/ers/` modular layout and navigation.
