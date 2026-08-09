---
name: capy-implement-change-and-review
description: Gitリポジトリを安全に最新のcleanな状態へ準備し、Draft Pull Requestとcheckpoint pushでGitHubから作業状況を確認できるようにしながら、プロンプトで指定されたコード、設定、テスト、文書などの変更を実装・検証し、ブランチ全体の整理と独立した敵対的レビューまで一続きで行う。新しい修正を開始からレビュー結果の報告までend-to-endで進めるよう依頼された場合に使用する。
license: CC0-1.0
---

# 変更を実装してレビューまで進める

`capy-git-start-clean`、通常の実装作業、`capy-gh-prepare-pr-for-review`、`capy-gh-review-pr-adversarially`を順番に実行する。各Skillを実行時に読み、その安全条件と完了条件を省略しない。

ユーザーに選択または承認を求める場合は、環境が提供する構造化された選択・承認UIを使用する。適切なUIがない場合だけ、テキストで選択肢や回答方法を提示する。

開始前に、必要な3つのSkillがすべて利用可能であることを確認する。不足している場合は、安全手順を推測で再構成せず、不足しているSkill名を示してインストールまたは有効化を求める。

## 1. 作業を準備する

1. プロンプトから対象リポジトリ、要求、完了条件を特定する。安全に実装できる程度に明確なら、不要な確認を挟まない。
2. リポジトリと変更対象pathに適用される指示を読む。
3. `capy-git-start-clean`を使用する。ローカル作業、既定ブランチ、fetch、fast-forward、cleanなworktreeに関する判定を同Skillへ委ねる。
4. 同Skillがユーザー判断を要求した場合は、作業を開始せず、その判断を得てから再開する。
5. リポジトリの規則に従い、必要ならfeature branchを作成する。
6. GitHub remote、認証、Pull Requestのbase branchを確認する。Draft Pull Requestを作成できない場合は、GitHubから進捗確認できないことを直ちに報告して中断し、ユーザーがローカルでの継続を明示した場合だけ再開する。

## 2. 指示された変更を実装する

1. 関連する既存実装、テスト、設定、文書、public contractを確認する。
2. プロンプトの要求を満たす最小限で一貫した変更を行う。無関係なcleanupや推測上の要件を混ぜない。
3. 変更した挙動に対応するテスト、format、lint、build、生成物の更新を行う。
4. 実行できない検証や環境依存の失敗を、成功した検証と区別して記録する。
5. diffとworktreeを確認し、secret、デバッグ出力、ローカルpath、無関係な変更が含まれていないことを確かめる。

このSkillによるend-to-endの実装依頼は、作業状況をGitHubで共有するために必要な通常のcommit、現在のfeature branchのpush、Draft Pull Requestの作成と説明更新を許可するものとみなす。ユーザーがこれらを禁止した場合は、その指示を優先する。review投稿、履歴書き換え、force-push、merge、Draft解除は別途明示された場合だけ行う。

## 3. Draft Pull Requestで進捗を公開する

1. 最初の意味ある最小差分を実装して関連する検証を行ったら、checkpoint commitを作成してfeature branchをpushする。Pull Request作成だけを目的とする空commitは作らない。
2. base branchとの差分、commit、検証結果を確認し、Draft Pull Requestをできるだけ早く作成する。タイトルと本文に作業目的、現状、実行済みの検証、残作業を記載し、作成直後にURLと現在のcheckpointをユーザーへ共有する。
3. 以降は、ひとまとまりの挙動、テスト、または修正が完了した節目でcheckpoint commitを作成し、関連する検証後に速やかにpushする。保存のたびの細切れcommitや、未確認の壊れた状態のpushは避ける。
4. 作業段階または残作業が実質的に変わったら、Pull Request本文の進捗と検証状況を更新する。GitHub上のheadと説明がローカルの進捗を正しく表す状態を保つ。
5. push後に利用可能なCIを確認する。失敗や未完了のcheckを成功扱いせず、原因調査中であることをPull Requestの進捗へ反映する。
6. 実装とレビューが完了してもDraftのまま維持する。ready for reviewへの変更はユーザーの明示指示がある場合だけ行う。

## 4. レビュー可能な状態へ整理する

`capy-gh-prepare-pr-for-review`を使用し、baseからの全コミット系列と最終diffを確認する。最終的な挙動に不要な残骸を除き、必要な検証を実行し、レビューしやすい変更へ整える。

同Skillがコミットの書き換えやforce-pushへの明示承認を要求した場合は、その承認を得るまで実行しない。整理で新しい変更が生じた場合は検証してcommit、pushし、Pull Requestの進捗を更新する。Pull Requestを作成できなかった場合は、feature branchとbaseのdiffを対象に可能な範囲を完了し、その制約を記録する。

## 5. 敵対的レビューを実行する

`capy-gh-review-pr-adversarially`を使用する。環境が対応している場合は、同Skillの指示どおり独立したレビュアーエージェントへ委譲し、候補を現在のheadに対して検証してfalse positiveを除外する。

この段階は既定でread-onlyとする。確認済みの指摘を見つけても、ユーザーが追加修正を依頼していない限り、自動修正、GitHub上へのreview投稿を行わない。

Pull Requestが存在しない場合は、baseとheadのローカルdiffを同じ観点でレビューし、GitHub上のPRメタデータやCIを確認していないことを明記する。変更が未commitの場合は、base commit、現在のHEAD、stagedとunstagedを含むworktree patchをレビュー対象として記録してレビュアーへ渡す。レビュー後にpatchが同一であることを再確認し、途中で変化していた場合は影響するレビューをやり直す。

## 6. 結果を引き渡す

次を簡潔に報告する。

- 実装した変更と影響
- ブランチ、base、Draft Pull RequestのURLと現在のhead
- 作成してpushしたcheckpointとGitHub上の進捗
- 実行した検証と結果
- レビュー向け整理で除去または修正した内容
- 敵対的レビューで確認できた指摘、または指摘がなかったこと
- 未検証事項、残るリスク、ユーザー判断が必要な次の操作

準備、実装、検証、レビュー向け整理、敵対的レビューのいずれかが未完了なら、全工程が完了したと報告しない。
