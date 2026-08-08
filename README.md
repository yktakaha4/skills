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

`skills/skill-template` は、新しいSkillを追加するときの見本です。

## Skillを追加する

1. `skills/skill-template` を `skills/<skill-name>` にコピーする。
2. ディレクトリ名と `SKILL.md` の `name` を同じkebab-case名にする。
3. `description` に機能と発動条件を書く。
4. 本文を対象Skill固有の手順に置き換える。
5. 必要な場合だけ `scripts/`、`references/`、`assets/` を追加する。
6. 検証する。

```sh
gh skill publish --dry-run
```

## ローカルから試す

リポジトリをGitHubへpushする前でも、ローカルディレクトリからインストールできます。

```sh
gh skill install . skill-template --from-local --agent codex --scope project
```

## GitHubからインストールする

```sh
gh skill install yktakaha4/skills skill-template --agent codex --scope user
```

全Skillをインストールする場合:

```sh
gh skill install yktakaha4/skills --all --agent codex --scope user
```

バージョンを固定する場合:

```sh
gh skill install yktakaha4/skills skill-template@v1.0.0 --agent codex --scope user
```

## 公開する

検証後、セマンティックバージョンのタグでGitHub Releaseを作成します。

```sh
gh skill publish --tag v1.0.0
```

`gh skill` はプレビュー機能のため、CLI更新時は `gh skill --help` で最新仕様を確認してください。
