# skills

`gh skill` でインストールできる Agent Skill の管理用リポジトリです。

## 構成

```text
skills/
└── <skill-name>/
    ├── SKILL.md
    ├── agents/
    │   └── openai.yaml
    ├── scripts/      # 必要な場合のみ
    ├── references/   # 必要な場合のみ
    └── assets/       # 必要な場合のみ
```

## Skills

| Skill | 用途 |
| --- | --- |
| `git-start-clean` | ローカル作業を保全しながら、作業開始前のGitリポジトリを最新かつcleanな状態にする |
| `gh-review-pr-adversarially` | 独立した複数の観点からPRを敵対的に検証し、確認できた問題だけを報告する |
| `gh-prepare-pr-for-review` | ブランチ全体を整理し、明示承認を得てレビューしやすいコミット履歴へ再構成する |
| `gh-merge-pr-safely` | base追従、CI確認、マージ、マージ後CIの監視と復旧判断を慎重に行う |

## Skillを追加する

1. `skills/<skill-name>/SKILL.md` を作成する。
2. ディレクトリ名と `SKILL.md` の `name` を同じkebab-case名にする。
3. `description` に機能と発動条件を書く。
4. 本文に対象Skill固有の手順を書く。
5. 必要な場合だけ `agents/openai.yaml`、`scripts/`、`references/`、`assets/` を追加する。
6. 検証する。

```sh
gh skill publish --dry-run
```

## ローカルから試す

リポジトリをGitHubへpushする前でも、ローカルディレクトリからインストールできます。

```sh
gh skill install . git-start-clean --from-local --agent codex --scope project
```

## 全Skillをユーザースコープへ同期する

現在のチェックアウトにある全Skillを、検出したコーディングエージェントのユーザースコープへインストールまたは更新します。

```sh
make sync
```

`codex`、`claude`、`copilot`、`cursor`、`gemini`、`opencode`の各コマンドを`PATH`から検出します。検出結果を変更する場合は、`gh skill`のエージェント名を指定します。

```sh
make sync AGENTS="codex claude-code github-copilot"
```

同期先に同名のSkillがある場合は、現在のチェックアウトの内容で上書きします。

## GitHubからインストールする

```sh
gh skill install yktakaha4/skills git-start-clean --agent codex --scope user
```

全Skillをインストールする場合:

```sh
gh skill install yktakaha4/skills --all --agent codex --scope user
```

インストール済みのSkillをデフォルトブランチの最新版へ更新する場合:

```sh
gh skill update --all
```

## Releaseを使う場合

Releaseは必須ではありません。Releaseがなければ、`gh skill install` はデフォルトブランチのHEADを使用します。バージョンを固定して配布したい場合だけ、検証後にセマンティックバージョンのタグでReleaseを作成します。

```sh
gh skill publish --tag v1.0.0
```

`gh skill` はプレビュー機能のため、CLI更新時は `gh skill --help` で最新仕様を確認してください。
