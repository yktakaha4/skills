---
name: gh-merge-pr-safely
description: Safely bring a pull request up to date with its base branch, diagnose and repair pre-merge CI failures, verify every required gate, merge the exact reviewed head, and monitor post-merge CI. Use when asked to merge a GitHub pull request carefully, merge only after CI passes, troubleshoot failures around a merge, or prepare a fix or revert PR after a bad merge.
---

# Merge PR Safely

Treat merging as a gated change followed by production-style verification. Never trade safety for speed.

## Establish the target

1. Read repository instructions and determine the repository, PR, head branch, base branch, current head SHA, draft state, review decision, merge state, and permitted merge methods.
2. Confirm that the selected PR is the one the user intends to merge. Stop and ask when multiple PRs or targets are plausible.
3. Inspect the full PR diff and recent commits before changing or merging anything.
4. Check the working tree. Preserve unrelated local work and stop if it prevents safe branch operations.
5. Record the current PR head SHA and use it as the identity of the revision being verified.

## Update from the base branch

1. Fetch the latest remote state.
2. Determine whether repository policy requires merging, rebasing, or a merge queue.
3. Bring the head branch up to date with the latest base branch when necessary.
4. Ask before rebasing published commits or force-pushing unless the user has explicitly authorized that history rewrite. Use `--force-with-lease`, never plain `--force`.
5. Resolve conflicts by preserving the intent of both sides. Run focused tests for every conflicted area.
6. Push the updated head, then refresh the PR head SHA. Discard all earlier check results associated with an older SHA.

## Satisfy pre-merge gates

1. Confirm the PR is not a draft, has no unresolved merge conflicts, satisfies required reviews, and is mergeable under branch protection.
2. Wait for every required and relevant CI check on the current head SHA to finish. Queued or in-progress checks are not passing checks.
3. If a check fails, inspect the actual failure log and reproduce it locally when practical.
4. Fix failures caused by the implementation with the smallest justified change. Test it, commit it intentionally, push it, and wait for the new head SHA's full check set.
5. Distinguish implementation failures from flaky services, credentials, runner capacity, permissions, and other environment failures. Retry only when evidence supports a transient failure.
6. Report environment-dependent or ambiguous failures and ask the user for direction instead of weakening tests or bypassing protections.
7. Never use administrator bypass merely to make a blocked merge succeed.

## Merge the verified revision

1. Refresh PR metadata immediately before merging.
2. Stop if the head SHA changed after verification, and repeat all affected gates.
3. Select the repository-approved merge method. Ask when more than one method is allowed and the intended history is unclear.
4. Merge with head-SHA matching, such as `gh pr merge --match-head-commit <verified-sha>`, so an unreviewed update cannot race the merge.
5. Verify from GitHub that the PR state is `MERGED` and capture the merge commit SHA. Do not infer success from the command exit code alone.

## Monitor after merge

1. Identify workflows triggered on the base branch by the merge commit and wait for every relevant run to finish.
2. If all relevant runs pass, report the PR, merge commit, merge method, and completed checks.
3. If a run fails, inspect its logs and determine whether the merge introduced the failure.
4. For a repairable implementation failure, create a new branch from the latest base, implement and validate the narrow fix, and open a fix PR.
5. When rapid restoration is safer than a forward fix, prepare a revert PR that clearly identifies the reverted merge and impact.
6. Never merge a fix PR or revert PR automatically. Present its URL, evidence, risk, and CI state to the user for a separate decision.
7. For environment-dependent, operational, or uncertain failures, preserve evidence, explain the likely boundary, and ask the user how to proceed.

## Report precisely

- Separate verified facts, diagnostic inference, and untested assumptions.
- Link the PR and relevant CI runs.
- State whether the PR merged, whether post-merge CI completed, and whether follow-up remains.
- Never call CI successful until the final relevant runs have completed.
