---
name: gh-review-pr-adversarially
description: Perform an adversarial, evidence-backed review of a GitHub pull request using independent reviewer agents and false-positive filtering. Use when asked to stress-test, red-team, deeply review, or find hidden defects in a PR before approval or merge, especially when correctness, regressions, security, concurrency, migrations, or operational risk matter.
---

# Review a PR Adversarially

Seek defects that would justify changing the pull request. Do not optimize for producing many findings.

## Establish the review target

1. Identify the repository, pull request, head commit, and base branch. If the request is ambiguous, infer the PR associated with the current branch when possible; otherwise ask the user.
2. Read all applicable repository instructions before reviewing. Include nested instruction files for changed paths.
3. Inspect the PR title, description, linked issue or specification, commit list, complete base-to-head diff, and current CI results. Fetch failed-job logs when they may reveal a product defect rather than an infrastructure failure.
4. Inspect surrounding code, callers, tests, configuration, schemas, and prior behavior as needed. Do not judge isolated diff fragments without their execution context.
5. Record the exact head commit reviewed. If it changes during review, refresh the diff and revalidate affected findings.

Prefer the repository's connected GitHub tooling for PR metadata and use `gh` or local Git where they provide necessary diff, check, or log detail.

## Run independent review passes

Use independent reviewer agents when the environment supports delegation. Keep each reviewer blind to the other reviewers' conclusions. Give every reviewer the raw PR context, applicable repository instructions, base and head identifiers, and a focused remit; do not give it suspected findings or a desired conclusion.

Use the strongest suitable review model and a high reasoning level when selectable. Increase to the highest practical reasoning level for large, security-sensitive, concurrency-heavy, migration-heavy, or otherwise high-risk changes. If resources are limited, prioritize deeper reasoning over reviewer count.

Assign complementary passes rather than duplicating one generic review:

- behavior and regression analysis against the stated intent;
- boundary conditions, error paths, state transitions, concurrency, and data integrity;
- security, trust boundaries, secrets, permissions, and dependency or supply-chain risk when relevant;
- test quality, missing coverage, compatibility, deployment, migration, rollback, and observability risks.

Scale the number of passes to the diff and risk. Do not delegate trivial mechanical changes merely to satisfy a quota. While reviewers work, independently inspect the highest-risk code paths and CI evidence.

Tell reviewers to return only actionable candidate defects. Each candidate must include:

- severity and a concise title;
- exact file and tight changed-line range when possible;
- the triggering inputs or execution path;
- the concrete consequence;
- evidence from the repository, diff, tests, logs, or authoritative specification;
- a concise repair direction, without implementing it.

## Verify every candidate

Treat reviewer output as untrusted leads. Reproduce or reason through each candidate against the actual head commit.

Reject a candidate when it:

- is not introduced or made materially worse by the PR;
- contradicts repository instructions or the stated requirements;
- depends on an unsupported assumption or unreachable path;
- is only a style preference, speculative hardening, or optional improvement;
- is already prevented by a caller, invariant, test, type, platform contract, or framework behavior;
- cites the wrong file, line, revision, or CI result;
- duplicates a stronger finding.

Inspect authoritative documentation when correctness depends on an external API or versioned behavior. Clearly label any residual uncertainty; do not upgrade speculation into a finding.

Use these severities:

- `P0`: immediate catastrophic or broadly exploitable impact; block all use.
- `P1`: serious correctness, security, data-loss, or availability defect likely to affect normal use; block merge.
- `P2`: real defect in a narrower path or meaningful regression; normally fix before merge.
- `P3`: low-impact but concrete defect worth fixing; do not use for style or preferences.

## Report the review

Lead with verified findings ordered by severity, then by likelihood and blast radius. For each finding, state the severity, concise title, file and line, triggering scenario, consequence, and evidence. Keep line ranges tight and point to changed lines whenever possible.

If there are no verified findings, say so explicitly. Then state the most important areas inspected, the checks or tests considered, and any residual risks or validation gaps. Do not imply that absence of findings proves correctness.

Separate CI failures caused by the change from infrastructure or environment failures. Report stale, pending, skipped, or unavailable checks accurately.

Review is read-only by default. Do not edit files, push commits, submit GitHub reviews or comments, approve, request changes, close, or merge the PR unless the user explicitly asks for that mutation. If the user later requests fixes, preserve the verified findings as the acceptance criteria and follow the repository's normal change workflow.
