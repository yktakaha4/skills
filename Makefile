AGENTS ?= $(shell ./scripts/detect-agents.sh)
SKILL_PREFIX := capy-
MAIN_BRANCH := main
REMOTE := origin

.PHONY: sync update-main

sync: update-main
	@if [ -z "$(strip $(AGENTS))" ]; then \
		echo "対象のコーディングエージェントを検出できませんでした。AGENTSを指定してください。" >&2; \
		exit 1; \
	fi
	@set -e; for agent in $(AGENTS); do \
		echo "Syncing skills for $$agent"; \
		./scripts/remove-prefixed-skills.sh "$$agent" "$(SKILL_PREFIX)"; \
		gh skill install . --from-local --all --agent "$$agent" --scope user --force; \
	done

update-main:
	@current_branch="$$(git branch --show-current)"; \
	if [ "$$current_branch" != "$(MAIN_BRANCH)" ]; then \
		echo "$(MAIN_BRANCH)ブランチで実行してください（現在: $${current_branch:-detached HEAD}）。" >&2; \
		exit 1; \
	fi
	git pull --ff-only "$(REMOTE)" "$(MAIN_BRANCH)"
