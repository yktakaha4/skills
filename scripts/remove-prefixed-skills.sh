#!/bin/sh

set -eu

agent=${1:?agent is required}
prefix=${2:?prefix is required}

case "$agent" in
codex) skills_dir=${HOME:?}/.codex/skills ;;
claude-code)
	if [ -n "${CLAUDE_CONFIG_DIR:-}" ]; then
		skills_dir=$CLAUDE_CONFIG_DIR/skills
	else
		skills_dir=${HOME:?}/.claude/skills
	fi
	;;
github-copilot) skills_dir=${HOME:?}/.copilot/skills ;;
cursor) skills_dir=${HOME:?}/.cursor/skills ;;
gemini-cli) skills_dir=${HOME:?}/.gemini/skills ;;
opencode) skills_dir=${HOME:?}/.config/opencode/skills ;;
*)
	echo "Unsupported agent: $agent" >&2
	exit 1
	;;
esac

if [ -z "$prefix" ] || [ -z "$skills_dir" ] || [ "$skills_dir" = "/" ]; then
	echo "Refusing to remove skills with unsafe settings" >&2
	exit 1
fi

for skill_path in "$skills_dir"/"$prefix"*; do
	if [ ! -e "$skill_path" ] && [ ! -L "$skill_path" ]; then
		continue
	fi

	echo "Removing ${skill_path##*/} from $agent"
	rm -rf -- "$skill_path"
done
