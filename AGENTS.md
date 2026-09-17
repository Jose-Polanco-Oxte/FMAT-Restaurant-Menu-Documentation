# Agents

## Documentation Integration Workflow

### Scope Authority

The user's request is the authority for what the run is allowed to accomplish.

Repository context may be read to understand the request. Reading a file does not make that file part of the task.

Do not convert discovered repository problems into work unless fixing that exact problem is directly required for the requested outcome.

### Configuration

Don't forget to update the version and specification (if applicable) in any configuration file or within a document that includes a configuration section. Do this only if that file has been modified (or, in the case of a specific document, if the file or files referenced by that configuration have been modified).

### Workflow

The workflow is:

1. Analyst
2. Surgical Editor
3. Auditor

All agent work occurs in an isolated Git worktree. The main repository is never an agent workspace.

### Analyst

The Analyst is read-only.

It produces the smallest IntegrationPlan that satisfies the request.

It must not expand the task into:

- repository-wide cleanup;
- synchronization of historical documents;
- translation synchronization;
- generated/derived documentation updates;
- adjacent fixes;
- workflow changes.

A secondary file belongs in `affected_files` only when changing that exact file is directly necessary to satisfy the original request.

### Surgical Editor

The Editor is invoked once per writable target.

Each invocation receives exactly one writable file in `.ai/current/editor-task.md`.

All other files are read-only context for that invocation.

The Editor must not execute other plan entries and must not edit another file for consistency.

If another write seems necessary, it must stop and return:

`[DOCFLOW_BLOCKED] <reason>`

The harness validates the actual Git delta after every attempt. Unauthorized writes are rolled back automatically and the same target is retried with corrective feedback.

### Auditor

The Auditor checks the requested outcome and scope discipline.

It must not fail a run merely because unrelated pre-existing repository content is stale, inconsistent, historical, or imperfect.

It should fail:

- defects in the requested outcome;
- missing requested behavior;
- contradictions introduced by the candidate;
- unnecessary candidate changes outside request scope.

### Protected Workflow Files

Documentation runs never modify:

- `AGENTS.md`
- `.gitignore`
- `.agents/**`
- `.ai/**`
- `scripts/**`

### Git Safety

Agents never stage, commit, reset, restore, clean, or manipulate Git history.

The harness owns checkpoints, rollback, deletion, reports, and final application.

### Automatic Editor Recovery

A successful process exit is not enough. CREATE/MODIFY must produce a real delta on the one allowed target, the target must remain a file, Git HEAD must remain under harness control, and protected workflow files must remain unchanged. Failed attempts are rolled back and retried automatically.

## UI Specification Architecture

The UI Specification Architecture is a set of principles and practices for producing a UI specification. Follow the principles and practices described in [ui-spec-arch.md](docs/ui-spec-arch.md) to produce a UI specification that is consistent, complete, and maintainable.
