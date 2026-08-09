---
name: capy-gh-merge-pr-safely
description: デフォルトブランチ上の変更から必要に応じてPull Requestを作成し、baseブランチの最新状態へ安全に追従させ、マージ前のCI失敗を診断・修正し、必須ゲートをすべて確認したうえで、レビュー済みの正確なheadをマージし、マージ後のCIを監視して、通常のcheckout、Codex-managed worktree、permanentまたは手動worktreeに応じて作業環境を安全に整理する。GitHubのPull Requestを慎重にマージする、CI成功後だけマージする、デフォルトブランチ上の未コミット変更をPRにしてマージする、マージ前後の失敗を調査する、不適切なマージ後に修正PRまたはrevert PRを準備するよう依頼された場合に使用する。
license: CC0-1.0
---

# Pull Requestを安全にマージする

マージを、ゲートを通過させる変更と、その後の本番運用相当の検証として扱う。速さのために安全性を犠牲にしない。

ユーザーに選択または承認を求める場合は、環境が提供する構造化された選択・承認UIを使用する。適切なUIがない場合だけ、テキストで選択肢や回答方法を提示する。

## GitHub操作の手段を選ぶ

GitHub上のrepository、Pull Request、issue、review、check、workflow run、マージ状態を読み書きする場合は、環境が標準で提供するGitHub App、connector、MCP、専用API toolなどの構造化されたGitHub機能を最初に使用する。使い慣れている、またはshellで一括実行しやすいという理由だけで`gh`を優先しない。

操作前に利用可能な標準機能と、その機能が必要な取得項目、書き込み、待機、head SHA照合を満たせるか確認する。標準機能が利用できない、必要な情報や操作を提供しない、認証・権限上使用できない、または検証済みhead SHAとの照合など本スキルの安全条件を保証できない場合だけ、該当部分に限定して`gh`をフォールバックとして使用する。フォールバックする場合は、標準機能では満たせなかった条件を簡潔に明記する。

標準機能で対応できる部分まで`gh`へ置き換えず、必要なら標準機能と限定的な`gh`フォールバックを組み合わせる。GitHub上の操作ではないlocal repositoryのstatus、diff、branch、worktree、fetch、pullなどには通常の`git`を使用する。

## 対象を確定する

1. リポジトリの指示を読み、リポジトリ、PR、headブランチ、baseブランチ、現在のhead SHA、draft状態、レビュー判定、マージ状態、許可されているマージ方式を確認する。
2. 現在のブランチが確認済みのデフォルトブランチで、依頼対象の変更がworktreeにあり、対応するPRがない場合は、次の順序でPRを作成する。
   - 無関係なローカル作業を保全し、依頼対象を安全に分離できることを確認する。対象が曖昧、または安全に分離できない場合だけ停止して確認する。
   - デフォルトブランチの現在のcommitから`codex/`で始まる作業ブランチを作成し、worktreeの変更を維持したまま切り替える。
   - 依頼対象の変更だけを検証してコミットする。ユーザーの変更や無関係なファイルを含めない。
   - 作業ブランチをpushし、ユーザーがdraftを指定していない限りready状態のPRを作成する。
   - 作成したPRのメタデータとhead SHAを取得し、以降の手順を続ける。デフォルトブランチにいることやPRが未作成であることだけを理由に停止しない。
3. 選択または作成したPRがユーザーの意図する対象であることを確認する。複数のPRや対象が考えられる場合は停止して確認する。
4. 変更やマージの前に、PR全体のdiffと直近のコミットを確認する。
5. worktreeを確認する。無関係なローカル作業を保全し、安全なブランチ操作を妨げる場合は停止する。
6. 現在のPRのhead SHAを記録し、検証対象リビジョンの識別子として使用する。

## baseブランチへ追従する

1. リモートの最新状態をfetchする。
2. リポジトリの方針がmerge、rebase、またはmerge queueのどれを求めているか確認する。
3. 必要に応じて、headブランチを最新のbaseブランチへ追従させる。
4. ユーザーが履歴の書き換えを明示的に許可していない限り、公開済みコミットのrebaseやforce-pushの前に確認する。通常の`--force`は使わず、`--force-with-lease`を使用する。
5. 両方の変更意図を保ちながら競合を解消する。競合した領域ごとに対象を絞ったテストを実行する。
6. 更新したheadをpushし、PRのhead SHAを再取得する。古いSHAに紐づくそれまでのcheck結果はすべて破棄する。

## マージ前ゲートを満たす

1. PRがdraftでなく、未解決のマージ競合がなく、必須レビューを満たし、branch protectionの下でマージ可能であることを確認する。
2. 現在のhead SHAに対する必須かつ関連するCI checkがすべて完了するまで待つ。queuedまたはin progressのcheckを成功扱いしない。
3. checkが失敗した場合は実際の失敗ログを確認し、可能であればローカルで再現する。
4. 実装が原因の失敗は、根拠のある最小の変更で修正する。テストし、意図が明確なコミットを作成し、pushして、新しいhead SHAに対する一連のcheckがすべて完了するまで待つ。
5. 実装の失敗と、flakyなサービス、認証情報、runner容量、権限、その他の環境要因による失敗を区別する。一時的な失敗だと判断できる根拠がある場合だけ再実行する。
6. 環境依存または原因が曖昧な失敗は報告し、テストを弱めたり保護を回避したりせず、ユーザーに方針を確認する。
7. ブロックされたマージを通すだけの目的でadministrator bypassを使用しない。

## 検証済みリビジョンをマージする

1. マージ直前にPRのメタデータを再取得する。
2. 検証後にhead SHAが変わっていた場合は停止し、影響するすべてのゲートを再確認する。
3. リポジトリで許可されているマージ方式を選ぶ。ユーザー指定やリポジトリ方針がない場合はmerge commit方式を既定とする。squashまたはrebaseは、ユーザー指定またはリポジトリ方針がある場合だけ使用する。
4. 環境標準のGitHub機能が検証済みhead SHAを拘束してマージできる場合は、その機能を使用する。保証できない場合は、理由を明記して`gh pr merge --match-head-commit <verified-sha>`をフォールバックとして使用し、未レビューの更新が競合して先にマージされることを防ぐ。
5. GitHub上でPRの状態が`MERGED`であることを確認し、merge commit SHAを記録する。コマンドの終了コードだけから成功を推測しない。

## マージ後のbaseを確認する

1. リポジトリまたはhostingのメタデータから、remoteとデフォルトブランチを特定する。`origin/main`やPRのbaseブランチをデフォルトブランチだと仮定しない。
2. remoteをfetchし、GitHubで確認したmerge commit SHAがremoteのデフォルトブランチから到達可能であることを確認する。現在のworktreeでデフォルトブランチをcheckoutすることを、この確認の前提にしない。
3. `git worktree list --porcelain`と利用可能なアプリのメタデータを使い、現在地が通常のlocal checkout、Codex-managed worktree、permanent worktree、または手動作成されたlinked worktreeのどれかを特定する。pathだけでmanagedかどうかを断定しない。
4. 各worktreeが所有するbranchを確認する。同じbranchを複数のworktreeでcheckoutしようとせず、`--force`でGitの保護を回避しない。
5. マージ後CIの調査や修正が必要になる可能性に備え、この時点では現在の作業環境を削除またはarchiveしない。

## マージ後を監視する

1. merge commitによってbaseブランチ上で開始されたworkflowを特定し、関連するrunがすべて完了するまで待つ。
2. 関連するrunがすべて成功した場合は、PR、merge commit、マージ方式、完了したcheckを報告する。
3. runが失敗した場合はログを確認し、その失敗がマージによって発生したかを判断する。
4. 修正可能な実装上の失敗には、最新のbaseから新しいブランチを作成し、範囲を絞った修正を実装・検証して、修正PRを作成する。
5. 前進修正より早期復旧の方が安全な場合は、取り消すmergeと影響を明記したrevert PRを準備する。
6. 修正PRやrevert PRを自動的にマージしない。URL、根拠、リスク、CI状態を提示し、別の判断としてユーザーに委ねる。
7. 環境依存、運用上、または不確実な失敗については、証拠を保全し、推定される責任境界を説明して、進め方をユーザーに確認する。

## 作業環境を整理する

関連するマージ後CIがすべて成功し、修正PRや追加調査が不要な場合だけ実施する。

1. 現在のworktreeについて、staged、unstaged、untracked、未pushのcommitを再確認する。今回の作業またはユーザーの作業がremoteや別の安全な保存先に残っていない場合は、切り替え、削除、archiveを行わず停止する。worktree削除前のsnapshotだけを唯一の保存手段にしない。
2. 通常のlocal checkoutで作業している場合は、デフォルトブランチが別のworktreeで使用されていないことを確認してから切り替え、確認済みのupstreamからfast-forwardのみでpullする。ブランチが分岐している、未pushのcommitがある、または信頼できるupstreamがない場合は、resetやrebaseを自動実行せず停止してユーザーに確認する。
3. Codex-managed worktreeで作業している場合は、そのworktreeをデフォルトブランチへ切り替えない。デフォルトブランチを所有するlocal checkoutが存在し、cleanで安全に更新できる場合は、そのcheckoutを確認済みのupstreamへfast-forwardする。変更中、権限不足、または利用中で安全性を確認できない場合は触れず、local checkoutが未更新であることを報告する。
4. Codex-managed worktreeからlocal checkoutで作業を続ける必要がある場合は、同じbranchを両方でcheckoutせず、利用可能なHandoff機能を使用する。この場合はタスクをarchiveしない。
5. Codex-managed worktreeで作業を続ける必要がなく、変更がすべて保存され、マージ後CIも成功している場合は、最終報告に必要な情報を確定してから、利用可能なタスクのarchive機能でタスクをarchiveする。アプリの管理対象worktreeをrawなdirectory削除や`git worktree remove --force`で閉じない。archive機能が利用できない場合は、ユーザーがタスクをarchiveできることを案内する。
6. permanent worktreeまたは手動作成されたlinked worktreeは自動的にarchiveまたは削除しない。不要になった場合でも、cleanで保存済みであることを確認し、ユーザーが削除を明示的に依頼したときだけ、別のworktreeから`git worktree remove <path>`を使用する。`--force`を既定にしない。
7. 整理後に、デフォルトブランチを所有するcheckoutとそのupstreamとの関係、残したworktree、削除またはarchiveした対象を確認する。

## 正確に報告する

- 確認済みの事実、診断上の推論、未検証の仮定を分ける。
- PRと関連するCI runへのリンクを示す。
- PRがマージされたか、マージ後CIが完了したか、後続対応が残っているかを明記する。
- 通常checkoutへ戻した、managed worktreeをarchiveした、Handoffした、またはworktreeを残した、のどれを行ったか明記する。デフォルトブランチを所有するlocal checkoutを更新できなかった場合は、その理由も示す。
- 最後の関連runが完了するまで、CIが成功したと報告しない。
