# Documentation Integration Protocol

This repository uses a three-stage documentation workflow:

1. ANALYZE
2. EXECUTE
3. AUDIT

The workflow supports:

- CREATE
- MODIFY
- DELETE
- VERIFY

documentation artifacts.

## Roles

### Analyst

Is the semantic authority.

It determines:

- what must exist
- what must change
- what must be removed
- what must remain unchanged
- which dependencies are affected
- which invariants must remain true

The analyst does not modify repository documentation.

### Editor

Is the execution authority.

It performs only the operations authorized by:

.ai/current/plan.json

The editor does not reconsider architecture or product decisions.

### Auditor

Independently verifies the resulting repository.

The auditor does not modify repository documentation.

## Workflow artifacts

Current workflow state lives under:

.ai/current/

Historical workflow runs live under:

.ai/runs/

## Semantic authority

The current user request and authoritative repository documentation are
the semantic sources of truth.

During execution:

.ai/current/plan.json

is authoritative for what the editor is allowed to do.

## Global rules

- Never stage Git changes.
- Never create Git commits.
- Never automatically revert user changes.
- Never modify files under `.ai/prompts/`.
- Never modify files under `.ai/schemas/`.
- Never modify historical files under `.ai/runs/`.
- Preserve requirement IDs.
- Preserve ADR IDs.
- Preserve terminology.
- Preserve traceability.
- Search for stale indirect references.
- Do not silently invent architecture or product decisions.
- If an operation requires a semantic decision not present in the plan,
  report a blocker.
