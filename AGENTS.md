# Repository guidelines

- Store publishable Agent Skills under `skills/<skill-name>/`.
- Keep the directory name identical to the `name` in `SKILL.md`.
- Use only lowercase letters, digits, and hyphens in skill names.
- Keep YAML frontmatter limited to `name`, `description`, and `license`.
- Add resource directories only when the skill needs them.
- Run `gh skill publish --dry-run` after changing a skill.
- Run scripts included in a skill when their behavior changes.
