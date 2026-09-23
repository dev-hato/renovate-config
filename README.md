# renovate-config

[dev-hato](https://github.com/dev-hato)で利用するRenovateの共通設定です。

## 利用方法

利用するリポジトリの`renovate.json`に、次の設定を追加する。

```json
{
  "$schema": "https://docs.renovatebot.com/renovate-schema.json",
  "extends": ["github>dev-hato/renovate-config"]
}
```

共通設定は[default.json](default.json)で管理している。
このリポジトリ自身の[renovate.json](renovate.json)も同じ共通設定を利用する。

## 更新方針

| 設定             | 内容                                              |
| ---------------- | ------------------------------------------------- |
| 基本設定         | `config:best-practices`を継承する                 |
| タイムゾーン     | `Asia/Tokyo`を使う                                |
| 自動マージ       | major 更新を含めて有効にする                      |
| 同時 PR 数       | 原則として 2 件までに制限する                     |
| リリース後の待機 | `dev-hato/*`以外の依存に 7 日間の待機期間を設ける |
| Go               | 依存の更新後に`go mod tidy`を実行する             |
| ロックファイル   | 定期更新を有効にする                              |
| npm              | 単独でのバージョン更新を対象外にする              |

利用先のGitHub設定では、自動マージを有効にする。
ブランチ保護またはルールセットには、マージ前に成功を必須とするCIのチェックを指定する。
詳しくは[Renovate の自動マージ設定](https://docs.renovatebot.com/configuration-options/#automerge)を参照する。

利用先で設定を変える場合は、`extends`と同じ階層で上書きする。
たとえば同時PR数の上限を5件にする場合は、次のように指定する。

```json
{
  "extends": ["github>dev-hato/renovate-config"],
  "prConcurrentLimit": 5
}
```

## 開発

### 依存関係の導入

[.node-version](.node-version)に記載されたNode.jsと、その同梱版のnpmを用意する。
リポジトリのルートで依存関係をインストールする。

```sh
npm ci
```

[.npmrc](.npmrc)で指定したnpmレジストリに接続できる環境が必要となる。

### コミット時の検査

[公式手順](https://pre-commit.com/#installation)に従って`pre-commit`をインストールする。
クローンしたリポジトリごとに、フックを登録する。

```sh
pre-commit install
pre-commit run --all-files
```

フックを登録すると、コミット時に[.pre-commit-config.yaml](.pre-commit-config.yaml)のGitleaksが秘密情報を検査する。
PR作成後はGitHub ActionsのSuper Linterでも検証される。
