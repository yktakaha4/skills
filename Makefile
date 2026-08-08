AGENTS ?= $(shell ./scripts/detect-agents.sh)
SKILL_PREFIX := capy-

.PHONY: sync

sync:
	@if [ -z "$(strip $(AGENTS))" ]; then \
		echo "対象のコーディングエージェントを検出できませんでした。AGENTSを指定してください。" >&2; \
		exit 1; \
	fi
	@set -e; for agent in $(AGENTS); do \
		echo "Syncing skills for $$agent"; \
		./scripts/remove-prefixed-skills.sh "$$agent" "$(SKILL_PREFIX)"; \
		gh skill install . --from-local --all --agent "$$agent" --scope user --force; \
	done
