---
name: gh-prepare-pr-for-review
description: Refine a GitHub pull request branch before requesting review by examining its complete commit series and net diff, removing redundant or stale implementation, tests, comments, and documentation, validating the resulting behavior, and organizing the work into reviewer-friendly commits. Use when a PR or feature branch has accumulated iterative fixes or excess context and needs a final coherence pass, including an explicitly approved destructive history rewrite.
---

# Prepare a PR for Review

Turn the current branch into a coherent, reviewable change without altering its intended behavior.

## Establish the review boundary

1. Read the repository instructions, especially `AGENTS.md`, contribution guidance, and rules for generated files, tests, commits, and protected branches.
2. Inspect the current branch, worktree, remotes, upstream, and PR metadata. Determine the base branch from the PR when one exists; otherwise use the repository's configured default branch.
3. Fetch the relevant remote refs before evaluating the branch. Do not merge, rebase, reset, amend, or force-push during this inspection.
4. Record the current branch tip, remote branch tip, merge base, and worktree state. Never rewrite the default branch or another protected branch.
5. If unrelated local changes make the branch boundary ambiguous, stop and ask how to handle them. Do not hide them in the rewrite.

## Review the whole branch

Review both the commit sequence and the final tree relative to the merge base. Do not infer the final intent from the latest commit alone.

- Read every branch commit in chronological order, including its message and patch.
- Inspect the aggregate diff, changed-file list, and diff statistics against the base.
- Trace each behavioral change through implementation, automated tests, comments, documentation, configuration, migrations, and generated artifacts.
- Compare repeated edits to distinguish required final behavior from abandoned approaches and repair-only residue.
- Run targeted searches for old names, obsolete branches, debug code, temporary compatibility layers, copied logs, secrets, local paths, implementation diary comments, and claims that no longer match the code.
- Preserve repository conventions, public contracts, necessary compatibility, and rationale that a future maintainer genuinely needs.

Build a concise inventory before editing: intended outcomes, affected contracts, redundant material, stale facts, validation needs, and proposed commit boundaries. Clearly label uncertainty instead of deleting code whose purpose is not established.

## Make the final tree coherent

Apply the smallest edits needed to make the aggregate change read as one deliberate implementation.

- Collapse redundant paths and remove superseded scaffolding, debugging artifacts, and accidental context leakage.
- Align tests with externally observable behavior. Remove tests for abandoned intermediate implementations, but retain meaningful regression and edge-case coverage.
- Update comments and documentation to describe the resulting system rather than the sequence of attempts that produced it.
- Correct stale examples, names, flags, expected outputs, and migration instructions across all affected surfaces.
- Avoid unrelated cleanup, broad stylistic churn, or concealing unresolved product decisions.

Review the aggregate diff again after editing. Confirm that every changed line supports the stated outcome and that necessary explanatory context remains.

## Validate behavior

Run repository-required checks plus focused tests for the changed behavior. Add broader checks when shared contracts or high-risk paths changed. Also check formatting, generated-file consistency, and whitespace errors where applicable.

Treat passing tests as evidence, not proof. Inspect failures and fix regressions caused by this branch; report unrelated or environment-dependent failures separately. Do not rewrite history until the final tree and validation results are understood.

## Plan reviewer-friendly commits

Design commits around logical, independently understandable changes rather than the chronology of experimentation.

- Keep each commit internally consistent: implementation, directly related tests, and required documentation should agree at that point.
- Order prerequisites before consumers and migrations before dependent behavior.
- Fold fixup and correction commits into the change they repair.
- Separate genuinely independent concerns when doing so improves review or rollback.
- Write commit messages that state the durable purpose, not the editing process.
- Avoid commits that knowingly break build or tests unless repository policy explicitly requires a staged transition.

Present the proposed commit list, mapping from current commits to the new structure, planned history operation, validation evidence, and remote-update impact. State exactly which published branch would be rewritten.

## Require approval before rewriting history

Treat dropping, squashing, reordering, splitting, rebasing, resetting, amending, or recreating existing commits as destructive. Obtain explicit user approval for the concrete rewrite plan before performing any of them. Approval to clean up the final tree is not approval to rewrite commits or force-push.

After approval:

1. Recheck that the branch tips and worktree still match the recorded state. If they changed, invalidate the approval and show a revised plan.
2. Create a clearly named safety ref at the original local tip, such as `codex/backup-<branch>-<timestamp>`, and report its exact name and commit.
3. Preserve unrelated work according to repository policy. Do not use destructive cleanup to manufacture a clean worktree.
4. Perform the approved rewrite non-interactively where practical. Do not broaden its scope without new approval.
5. Compare the rewritten tree to the pre-rewrite prepared tree. Any difference must be intentional and explained.
6. Re-run required and focused validation on the rewritten series or final tree as appropriate.
7. Inspect the new commit sequence and aggregate diff once more for reviewer clarity.

If the branch is published, obtain explicit approval to update it unless that exact force-push was already included in the approved plan. Use only `--force-with-lease`, preferably pinned to the previously recorded remote object ID. Never use an unconditional force push. If the lease fails, fetch, reassess the remote changes, and ask for direction rather than overriding them.

## Hand off

Report:

- the final branch and PR base;
- the resulting logical commit list;
- material cleanup across code, tests, comments, and documentation;
- validation commands and outcomes;
- any unverified behavior or environment-dependent failure;
- the safety ref and rewritten remote branch, if applicable;
- remaining reviewer risks or deliberate tradeoffs.

Do not request review or claim readiness while required checks are failing or known inconsistencies remain.
