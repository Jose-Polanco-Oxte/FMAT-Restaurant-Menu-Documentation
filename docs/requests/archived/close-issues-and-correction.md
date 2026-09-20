# Review Existing UI Specification

Use the [**UI Specification Architecture directive**](/docs/ui-spec-arch.md) as the governing rules.

Review the existing semantic UI specification and its current [Issues Tracker](/docs/issues-tracker.md) against the **latest SRS**.

Do **not** regenerate the specification from scratch. Update the existing canonical artifacts only where necessary.

`OPEN-002` and `OPEN-009` have already been resolved in the latest SRS. Propagate those decisions into every affected view, flow, state, control, and issue, and remove obsolete references to them as unresolved.

## Issue Relevance Rule

Do not treat every missing system or implementation detail as a UI-specification issue.

An issue is relevant to this phase only when it prevents or materially affects determining:

* whether a view exists;
* what information the user sees;
* what information the user provides;
* what controls or actions exist;
* what choice the user makes;
* what user-observable state results;
* what interaction or navigation occurs.

Do **not** block the UI specification for details such as:

* API contracts or transport;
* serialization formats;
* URLs or routing implementation;
* authentication implementation;
* storage or media processing;
* database constraints;
* exact search algorithms;
* persistence types;
* backend calculation implementation;
* integration protocols.

If these remain unresolved but do not change the semantic UI, classify them as implementation concerns rather than UI blockers.

## Review Existing Issues

Re-evaluate every current issue and classify it as:

* `Closed`
* `Open` and relevant to the UI specification
* `Deferred` as an implementation concern
* invalid / unnecessary as a UI-specification issue

For Inventory/Recipe references, determine only the required **human interaction semantics**: for example, whether the administrator enters an ID, searches, or selects an entity. Do not define the underlying service integration.

Remaining SRS Open Items must stay unresolved unless an authoritative source resolves them. Classify their impact on the UI instead of inventing a solution.

## Review and Update

Verify the existing:

* `views/*.yaml`
* flows
* navigation
* state diagrams when present
* requirement traceability

Correct inconsistencies with the latest SRS, remove unsupported assumptions, and preserve valid existing work.

Do not over-model. Stop once there is enough information to determine:

`View → Data → Controls → Actions → States → Navigation`

## Final Audit

Verify:

* UI-relevant requirements are covered;
* all views and controls are justified;
* flows reference valid views;
* navigation is coherent;
* no unsupported functionality was introduced;
* `OPEN-002` and `OPEN-009` are correctly propagated;
* remaining issues are actually relevant to low-fidelity UI specification.

At the end, provide:

1. updated canonical artifacts;
2. updated Issues Tracker;
3. remaining UI-blocking issues;
4. remaining UI-relevant non-blocking issues;
5. deferred implementation concerns;
6. a concise audit summary.

**Do not generate wireframes or visual design. Stop after the review and audit.**
