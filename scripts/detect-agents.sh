#!/bin/sh

detect() {
	if command -v "$1" >/dev/null 2>&1; then
		printf '%s\n' "$2"
	fi
}

detect codex codex
detect claude claude-code
detect copilot github-copilot
detect cursor cursor
detect gemini gemini-cli
detect opencode opencode
