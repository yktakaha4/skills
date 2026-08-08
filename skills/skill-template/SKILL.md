---
name: skill-template
description: Create or update a repository-managed Agent Skill that follows the Agent Skills specification and can be installed with GitHub CLI. Use when adding a new skill under skills/, revising an existing SKILL.md, or preparing this repository for gh skill validation and publishing.
---

# Skill Template

Create focused, reusable Agent Skills in this repository.

## Workflow

1. Clarify the tasks and prompts that should trigger the skill.
2. Create `skills/<skill-name>/SKILL.md`.
3. Use lowercase letters, digits, and hyphens for both the directory and frontmatter `name`.
4. Put only `name` and `description` in the YAML frontmatter.
5. State what the skill does and when it should trigger in `description`.
6. Write the body as concise imperative instructions for another agent.
7. Add `scripts/`, `references/`, or `assets/` only when the skill needs them.
8. Add `agents/openai.yaml` when Codex-facing display metadata is useful.
9. Run `gh skill publish --dry-run` from the repository root.
10. Fix every validation error before publishing or opening a pull request.

## Resource placement

- Put deterministic automation in `scripts/` and run it during validation.
- Put detailed documentation loaded only when needed in `references/`.
- Put output templates, images, fonts, and other reusable artifacts in `assets/`.
- Link required resources directly from `SKILL.md` and explain when to read or run them.

## Quality bar

- Keep instructions specific to knowledge or procedures an agent cannot safely infer.
- Avoid duplicating information between `SKILL.md` and reference files.
- Avoid auxiliary documentation inside an individual skill.
- Verify scripts and generated artifacts, not only their syntax.
- Keep each skill independently installable.
