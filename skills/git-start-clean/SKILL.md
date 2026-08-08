---
name: git-start-clean
description: Safely prepare a Git repository for new work by preserving local changes, switching to the remote default branch, and fast-forwarding it to the latest remote state. Use before starting a new task when the current branch or worktree may contain staged, unstaged, untracked, generated, or unfinished files.
---

# Git Start Clean

Leave the repository on an up-to-date default branch with a clean worktree. Preserve anything that might be valuable, explain every destructive candidate, and never silently discard local work.

## Workflow

1. Confirm the current directory is inside the intended Git repository. Read repository instructions before changing anything.
2. Inspect the repository before fetching or switching branches:
   - Record the current branch or detached `HEAD`.
   - Inspect `git status --short --branch` and, when needed, `git status --porcelain=v2`.
   - Distinguish staged changes, unstaged tracked changes, untracked files, conflicts, and submodule changes.
   - Check whether the current branch has commits not present on its upstream. Do not treat committed work as disposable.
3. Determine the remote and default branch from repository metadata. Prefer the tracked remote's symbolic `HEAD`, then hosting metadata such as `gh repo view --json defaultBranchRef`; ask the user if the result is absent or conflicting. Do not assume `origin/main`.
4. Fetch the selected remote with pruning. If authentication, network access, or remote configuration prevents a reliable fetch, report the problem and stop rather than claiming the checkout is current.
5. Resolve every local change using the classification rules below. Re-run status after each action.
6. Switch to the local default branch. If it does not exist, create it to track the verified remote default branch. Never force the switch.
7. Update the default branch from its verified remote counterpart using fast-forward-only behavior, such as `git pull --ff-only`. If the branch has diverged, contains local commits, or lacks a trustworthy upstream, stop and ask the user how to proceed. Do not reset or rebase it automatically.
8. Verify and report the final branch, upstream relationship, fetched remote/default branch, and worktree status. A successful result must be both current with the fetched remote and clean.

## Classify local changes

Treat staged changes and modified or deleted tracked files as valuable work by default. Preserve them together so that index state is not accidentally lost.

Treat an untracked file as disposable only when repository evidence shows that it is reproducible generated output or a known temporary artifact. Suitable evidence includes a documented build output path, an ignore rule, or a deterministic command that recreates it. Similar naming, an unfamiliar extension, or the agent's intuition is not sufficient.

Treat the following as valuable or uncertain and stash them instead of deleting them:

- source, tests, documentation, configuration, credentials, reports, data, or user-authored notes;
- files whose origin or reproducibility is unclear;
- generated files containing possible manual edits;
- changes spanning both generated and authored files when separating them could lose context.

Ask the user before acting when classification is ambiguous, a merge or rebase is in progress, conflicts exist, nested repositories or submodules are dirty, multiple stashes would obscure related work, or cleanup would require changing repository state beyond this workflow.

## Preserve work

Use a descriptive stash that includes untracked files, for example `git stash push -u -m "pre-task cleanup: <context>"`. Do not include ignored files unless they were inspected and the user explicitly wants them preserved. After stashing:

- verify that the stash was created and record its reference and message;
- verify that the intended paths left the worktree;
- report how to restore the work, without applying or dropping the stash;
- do not split related staged and unstaged work merely to make cleanup easier.

If stashing fails or leaves changes behind, stop and preserve the remaining state for user inspection.

## Delete disposable artifacts

Deletion is destructive. Before deleting anything:

1. Show the exact candidate paths and the repository evidence that each is generated and reproducible.
2. Use a dry-run or preview when available.
3. Obtain explicit user confirmation for the exact deletion set.
4. Delete only those exact paths; never use a broad unresolved glob, repository-wide `git clean`, or recursive deletion rooted at the workspace.
5. Re-run status and report what was removed and whether it can be regenerated.

Never delete tracked changes, ignored files, credentials, user data, or uncertain artifacts. Never use `git reset --hard`, forced checkout/switch, or equivalent commands to make the tree clean.

## Completion criteria

Do not call the repository ready unless all of the following are true:

- the checked-out branch is the verified default branch;
- it matches the freshly fetched remote default branch;
- no staged, unstaged, untracked, conflicted, or dirty submodule state remains;
- every original local change was either explicitly deleted with approval, preserved in a verified stash, or otherwise accounted for to the user.
