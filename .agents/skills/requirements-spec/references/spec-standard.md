# Requirements Specification Standard & Engineering Principles

This document provides the normative engineering rules for specifying software requirements, based on ISO/IEC/IEEE 29148:2018 and formal specification principles.

---

## 1. The Source of Truth Principle

- The system requirements engineer must base all active requirements **strictly and exclusively on the verified sources**.
- Unsupported extrapolation, "common sense" assumptions about the domain, or introducing unrequested standard industry patterns are considered defects in the specification.
- If a requirement cannot provide a direct citation or excerpt from the analyzed sources, it must not be confirmed.
- When an essential behavior is partially mentioned but missing critical operational detail, it is recorded under `OPEN-NNN` (Pending Specification).

---

## 2. Temporal Precedence and Decision Authority

Design and architectural discussions evolve over time. Not all statements in a transcript or notes remain in force.

- **Chronological superseding**: A newer decision that redefines, restricts, cancels, or expands an earlier decision replaces it as the active truth.
- **Explicit linkage**: The earlier decision must be cataloged in `08-superseded-decisions.md` as `SUPERSEDED-NNN`, indicating the superseding decision and rationale.
- **Unresolved conflicts**: When two contemporary sources contradict each other and neither explicitly supersedes the other, document the case in `09-conflicts-and-open-items.md` under `CONFLICT-NNN`.

---

## 3. Differentiation of Abstraction Levels

1. **Business Need**: The underlying objective or problem of the domain/stakeholder.
2. **System Behavior (Functional Requirement)**: What the software system or service must do in an observable manner.
3. **Business Rule**: Invariant domain policies, constraints on calculations, allowed/prohibited states.
4. **Architectural Constraint**: Non-negotiable technical boundaries (e.g., service boundaries, auth tokens, database isolation).
5. **Implementation Detail / Design Decision**: Internal mechanism chosen to fulfill a requirement. (Do not promote to functional requirement unless mandated as a constraint).
6. **Conversational Example**: Concrete illustrations used to explain a concept (e.g., "a package containing item X and item Y"). Examples must not be turned into restrictive rules unless explicitly stated as such.

---

## 4. ISO/IEC/IEEE 29148:2018 Quality Dimensions

Every drafted requirement must be evaluated against the following criteria:

| Quality Dimension | Test Question | Prohibited Patterns |
| :--- | :--- | :--- |
| **1. Necessary** | Does removing this requirement create a gap against source decisions? | Redundant or decorative requirements. |
| **2. Appropriate** | Is it at the right abstraction level without leaking unmandated code details? | Specifying SQL queries, UI pixel layouts, or language libraries unless mandated. |
| **3. Unambiguous** | Does it admit only one reasonable interpretation? | Words like *fast*, *adequate*, *user-friendly*, *sufficient*, *as needed*, *etc.* |
| **4. Complete** | Are the actor, condition, behavior, boundaries, and result defined? | Omitting boundary limits or conditions when present in sources. |
| **5. Singular** | Does it describe exactly one obligation? | Compound statements with *and*, *furthermore*, *also*. Separate them! |
| **6. Feasible** | Can it be implemented within the active architecture without contradiction? | Retaining discarded or incompatible designs. |
| **7. Verifiable** | Is there an objective verification method (Inspection, Analysis, Demonstration, Test)? | Subjective or unmeasurable statements. |
| **8. Correct** | Does it faithfully represent the exact intent from the sources? | Distorting source meaning to make the architecture "cleaner". |
| **9. Conforming** | Does it follow the standardized identifier and drafting template? | Inconsistent styling or non-normative phrasing. |

---

## 5. Drafting Rules & Language Standards

- **Normative Verb**: Use `shall`.
  - Prohibited: `should`, `could`, `may`, `might`, `preferably`, `it would be desirable`.
- **Primary Form**:
  - `The system shall <observable behavior> [when <condition>].`
  - `The <Service> service shall <observable behavior> [when <condition>].`
- **Business Rules**:
  - `The system shall prevent <action> when <condition>.`
  - `The system shall allow <action> only when <condition>.`
- **Zero Fabricated Metrics**:
  - Never fabricate numbers (latencies in milliseconds, uptime percentages, HTTP error codes) to fake verifiability.
  - If the source states "The service query must be fast", document the performance expectation as a quality note or `OPEN-NNN` asking for the target SLA, rather than inventing "shall respond in under 200 ms".
