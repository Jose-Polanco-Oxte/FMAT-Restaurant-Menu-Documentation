# Phase 1 — Generate Semantic UI Specification from SRS

Use the attached [UI Specification Architecture directive](/docs/ui-spec-arch.md) as the governing specification for this task.

Your goal is to derive the complete **semantic UI specification** from the provided Software Requirements Specification (SRS).

This phase is strictly limited to **pre-wireframe specification work**.

## Inputs

Use:

* the provided [SRS](/output/ers/spec.md) as the authoritative source of functional and behavioral requirements;
* the UI Specification Architecture directive as the authoritative source for how UI artifacts must be modeled;
* any already-approved project specifications that are explicitly provided as supporting context.

Do not assume requirements that are not supported by these sources.

---

## Objective

Analyze the SRS and derive the canonical UI specification necessary to later generate low-fidelity wireframes.

Produce the required canonical artifacts, including where applicable:

* structured view specifications;
* user flows and task flows;
* global navigation model;
* activity diagrams when flow complexity justifies them;
* state machines only when state behavior is sufficiently complex;
* requirement references and traceability metadata.

Do not generate derived documentation unless it is necessary for validation or explicitly required by the architecture directive.

---

## Required Process

### 1. Analyze the SRS

Identify all requirements that have consequences for user interaction.

Determine:

* actors;
* user goals;
* tasks;
* information users must see;
* data users must provide;
* available actions;
* decisions;
* constraints;
* relevant states;
* navigation relationships;
* validation rules;
* permissions or role restrictions when explicitly defined;
* exceptional or alternative interaction paths.

Do not treat every requirement as requiring a separate screen.

Derive views from coherent user responsibilities and interaction needs.

---

### 2. Identify the Required Views

Determine the minimum coherent set of views necessary to satisfy the UI-relevant requirements.

For each view, define the structured semantic information required by the UI Specification Architecture.

At minimum, consider:

* identity;
* purpose;
* actors;
* source requirements;
* inputs;
* regions or sections;
* displayed data;
* controls;
* actions;
* states;
* constraints.

Include optional fields such as outputs, permissions, validation, preconditions, business rules, or flow references only when justified.

Do not introduce visual layout or styling decisions.

---

### 3. Generate Canonical View Specifications

Create the canonical YAML specifications under the appropriate `views/` structure.

The YAML must describe UI semantics, not visual design.

Prefer explicit structured data over ambiguous prose.

Do not encode arbitrary presentation choices such as:

* exact component placement;
* columns;
* pixel measurements;
* colors;
* typography;
* spacing;
* shadows;
* border radius;
* visual branding.

A control must express its functional purpose without unnecessarily fixing its graphical representation.

For example, specify a semantic `categoryFilter` rather than assuming it must be rendered as tabs, chips, a dropdown, or a sidebar.

---

### 4. Generate Interaction Flows

Create User Flows or Task Flows for the main user goals identified in the SRS.

Use Mermaid as the canonical representation.

Flows should capture:

* actor goal;
* relevant views;
* actions;
* decisions;
* meaningful alternative paths.

Do not duplicate the same flow semantics in YAML.

Use normal User Flows for straightforward interaction paths.

Use UML Activity Diagrams only where decisions, loops, branches, parallelism, or business logic make them meaningfully clearer.

---

### 5. Generate the Navigation Model

Create a global navigation map when the system contains multiple related views and such a map improves understanding.

The navigation model must represent reachable relationships between views independently of a single user scenario.

Use Mermaid as the canonical representation.

Avoid duplicating information already sufficiently represented elsewhere unless the global topology adds distinct value.

---

### 6. Model States Only Where Necessary

Simple states such as:

* normal;
* empty;
* no results;
* unavailable;

may remain declared directly in the view YAML.

Create a Mermaid state machine only when a view contains meaningful temporal or behavioral transitions that cannot be clearly represented by a simple state list.

Do not create state diagrams mechanically for every view.

---

### 7. Preserve Traceability

Every derived UI element must be justifiable from the SRS or another explicitly approved source.

Maintain references from canonical artifacts to their source requirements.

The resulting specification should support tracing:

```text
Requirement → Flow → View → UI Element
```

Do not create a manually maintained traceability document if it can later be derived from canonical sources.

---

## Strict Boundaries

### DO NOT generate wireframes

This phase MUST NOT produce:

* wireframes;
* mockups;
* screenshots;
* HTML UI prototypes;
* visual layouts;
* polished interfaces;
* visual design proposals.

Do not attempt to show what the interface should look like.

---

### DO NOT perform visual design

Do not decide:

* color palette;
* typography;
* branding;
* icon style;
* shadows;
* border radius;
* exact spacing;
* exact positioning;
* decorative elements;
* final component appearance.

Only semantic hierarchy may be specified where relevant, such as:

```text
primary
secondary
supporting
```

---

### DO NOT invent functionality

Do not introduce:

* new features;
* new actions;
* unsupported controls;
* unsupported data;
* unsupported states;
* new navigation paths;
* business rules not present in the source material.

If something appears useful but cannot be justified by the SRS or approved context, do not silently add it.

Record it as an unresolved question or ambiguity instead.

---

### DO NOT over-model

Apply the Minimal Duplication Principle from the UI Specification Architecture.

Do not create multiple representations of the same concept when one canonical artifact is sufficient.

In particular:

```text
View semantics → YAML

User / Task Flow → Mermaid

Navigation topology → Mermaid

Complex state behavior → Mermaid

Human-readable view documentation → derived later

Screen inventory → derived later

Traceability matrix → derived later
```

---

## Ambiguities and Missing Information

When the SRS does not provide enough information to make a justified UI decision:

1. do not invent the missing behavior;
2. preserve everything that can be specified safely;
3. record the ambiguity explicitly in [Issues Tracker](/docs/issues-tracker.md);
4. identify the affected requirement, flow, view, or control;
5. explain what information is missing.

Prefer an incomplete but traceable specification over an invented one.

---

## Consistency Audit

After generating the canonical artifacts, perform a final specification audit.

Check at least:

### Requirement Coverage

* Are all UI-relevant requirements represented?
* Are there requirements with no corresponding interaction representation?

### View Consistency

* Does every view have a clear and justified responsibility?
* Are multiple views unnecessarily representing the same responsibility?
* Are any views unsupported by requirements?

### Flow Consistency

* Do all referenced views exist?
* Are flow transitions coherent?
* Are there incomplete or contradictory paths?

### Navigation Consistency

* Are there unreachable or orphan views?
* Do navigation relationships agree with the flows?

### Control Consistency

* Is every control justified?
* Does every action have defined semantics?
* Are controls duplicated unnecessarily?

### State Consistency

* Are declared states meaningful?
* Are state machines used only where justified?
* Are transitions consistent with the SRS?

### Traceability

* Can the derived UI semantics be traced back to source requirements?
* Are there UI elements with no traceable justification?

### No-Unjustified-Inference

* Was any unsupported functionality introduced?
* Were visual design decisions accidentally added?

---

## Final Output

When complete, provide:

1. the canonical UI specification artifacts in `/output/ui-spec/`;
2. a concise summary of the identified views and major flows;
3. the result of the consistency audit;
4. a list of unresolved ambiguities or conflicts in `/docs/issues-tracker.md`;
5. any requirements that could not be mapped confidently.

End the task after this phase.

**Do not proceed to wireframe generation.**
