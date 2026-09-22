# ローカルでの検証

[.node-version](../.node-version)に記載されたNode.jsと、同梱版のnpmを使う。
リポジトリのルートで依存関係を導入し、検証する。

```sh
npm ci
npm run setup:lint
npm run lint
```

`npm run lint`はRenovateの設定検証とtextlintを順番に実行する。
失敗した場合は、表示された箇所を修正して再実行する。

## 検証を個別に実行する

```sh
npm run lint:renovate
npm run lint:textlint
```

Renovateの検証対象は、共通設定の`default.json`と、このリポジトリ用の`renovate.json`となる。
`--no-global`でリポジトリ用の設定として検証し、`--strict`で移行が必要な設定も検出する。
詳しくは[Renovate の設定検証](https://docs.renovatebot.com/config-validation/)を参照する。

textlintでは`README.md`と`docs`ディレクトリのMarkdownファイルを検証する。
外部リンクや辞書の検査では、ネットワーク接続が必要となる。

ローカル検証に使うRenovateは[専用のpackage.json](../tools/renovate/package.json)とロックファイルで固定する。
`npm run setup:lint`は、ルートの`.npmrc`を使って専用ディレクトリへ依存関係を導入する。
ルートの依存から分離することで、既存CIの検証ツールを置き換えずにローカルで実行できる。
専用のロックファイルが更新された場合は、`npm run setup:lint`を再実行する。
GitHub ActionsのSuper Linterでは、YAMLやシェルスクリプトなども検証される。
