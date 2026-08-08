# リポジトリのガイドライン

- 公開可能なAgent Skillsは`skills/<skill-name>/`に配置する。
- 機械可読なスキル識別子には`capy-`を付ける。これはディレクトリ名と`SKILL.md`の`name`に適用する。
- ディレクトリ名は`SKILL.md`の`name`と一致させる。
- スキル名には英小文字、数字、ハイフンだけを使用する。
- `agents/openai.yaml`の`display_name`には、`capy`を含まない簡潔な日本語のUI名を設定する。
- YAMLフロントマターは`name`、`description`、`license`だけにする。
- リソース用ディレクトリはスキルで必要な場合だけ追加する。
- スキルを変更したら`gh skill publish --dry-run`を実行する。
- スキルに含まれるスクリプトの挙動を変更したら、そのスクリプトを実行する。
