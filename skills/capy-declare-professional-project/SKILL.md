---
name: capy-declare-professional-project
description: 対象プロジェクトを仕事のプログラミングとして扱い、非機能要件、将来の拡張性、トラフィック量、互換性、運用リスクを確認し、破壊的変更を避けた段階的で安全な修正と環境反映を優先する。ユーザーがこのスキルを明示的に指定し、業務用または組織で運用するプロジェクトのレビュー、設計、実装、展開方針を決める場合に使用する。
license: CC0-1.0
---

# 仕事のプログラミングとして扱う

対象を仕事のプログラミングとして明示し、利用者、データ、業務継続性、組織の運用を守る変更を選ぶ。必要な要件を確認し、事故の発生確率と影響範囲を抑えながら段階的に進める。

ユーザーに選択または承認を求める場合は、環境が提供する構造化された選択・承認UIを使用する。適切なUIがない場合だけ、テキストで選択肢や回答方法を提示する。

## 適用範囲を確定する

1. ユーザーがこのスキルを明示的に指定した場合だけ適用する。企業名義、リポジトリの規模、利用技術から仕事のプロジェクトだと推測しない。
2. 対象となるリポジトリ、system、環境、変更期間、関係するteamを確認する。この宣言を無関係な別プロジェクトへ引き継がない。
3. `capy-declare-hobby-project`も同時に指定されている場合は方針を混ぜず、どちらを対象に適用するかユーザーへ確認する。
4. リポジトリの規則、変更管理、承認、監査、release、security、incident対応の手順を読み、一般論よりproject固有の規則を優先する。

## 必要な前提を確認する

レビューや方針決定に影響する範囲で、次を確認する。容易に調査できる事実をユーザーへ質問せず、不明点を勝手に高トラフィックや高可用性の要件へ置き換えない。

- 利用者、stakeholder、公開範囲、重要な業務経路
- 現在と予測期間内のtraffic、data量、成長率、peak、latency目標
- 可用性、復旧時間、データ損失許容度、backupとrestoreの実績
- 個人情報、credential、機密情報、法令、契約、監査上の制約
- 対応version、外部consumer、APIやschemaの互換性、廃止手順
- development、staging、productionの差、deploy頻度、作業時間帯、担当者
- monitoring、alert、support、rollback、incident時の責任分界

選択を変えない情報まで網羅的に収集しない。重要な前提が不明な場合は、確認済みの事実、仮定、必要な判断を分ける。

## 段階的で可逆な変更を設計する

1. 現在のcontract、consumer、保存データ、運用手順を特定し、変更による影響範囲を整理する。
2. 小さくreview可能で、各段階を独立して検証できる変更へ分ける。途中状態でもsystemを安全に運用できる順序にする。
3. 必要に応じて後方互換なschema変更、expand-and-contract、feature flag、段階的rolloutを使う。ただし、実際のriskを下げない仕組みを儀式的に追加しない。
4. migrationは再実行性、部分失敗、並行version、処理時間、lock、data検証、rollbackまたはforward fixを検討する。
5. 破壊的変更が避けられない場合は、consumerの移行、告知、期限、backup、承認、停止条件を含む計画を提示し、実行前にユーザーの承認を得る。
6. 一度に複数の独立したriskを持ち込まず、無関係なrefactor、dependency更新、環境変更を分離する。

## 事故を抑える方法で環境へ反映する

- localまたは隔離環境で再現し、対象test、静的解析、migration検証、必要な統合testを完了してから共有環境へ進む。
- 対象revision、設定差分、artifact、実行主体、環境を固定し、検証していないheadや手元だけの状態を展開しない。
- dry-run、preview、staging、canary、少量trafficなど、対象systemが対応する最小のblast radiusから始める。
- deploy前にbackup、rollback条件、観測するmetricとlog、担当者、判断時刻を確認する。restore未検証のbackupを復旧保証として扱わない。
- deploy後は利用者側の主要経路、error率、latency、data整合性を確認する。コマンド成功やprocess稼働だけで完了としない。
- 特権、production、共有data、外部通知を伴う操作は、依頼と権限の範囲を確認する。保護機構や必須gateを迂回しない。

## レビューの基準を調整する

- correctness、security、privacy、data integrity、concurrency、互換性、migration、rollback、observability、運用負担を変更内容に応じて確認する。
- 理論上の最大規模ではなく、確認したtrafficと成長見込みに対して余裕があるかを評価する。
- 将来の拡張性は、予定されたroadmap、既存consumer、変更頻度に根拠がある場合に考慮する。抽象化自体を品質とみなさない。
- 指摘は発生条件、影響、根拠、修正方針を示す。規約や実害に結びつかない好みをblockerにしない。
- 安全策の追加による複雑性と新しいfailure modeも評価し、変更riskに釣り合う最小の対策を選ぶ。

## 検証して報告する

1. 変更前後の期待挙動、互換性、failure path、rollbackまたはforward fixを確認する。
2. 実行したtest、対象revision、確認した環境、未実施の検証を記録する。
3. 報告では、確認済みの非機能要件と運用前提、採用した段階、残るrisk、次の承認点を明示する。
4. production反映や最終checkが未完了なら、その状態を成功または完了として報告しない。

仕事のプログラミングを過剰設計の理由にせず、確認できた業務上の影響に比例して安全性と可逆性を高める。
