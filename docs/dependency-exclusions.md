# 依存関係の更新除外

更新除外を見直す際は、導入時の問題が解消しているかを確認する。

## npm

[default.json](../default.json)の`ignoreDeps`で、npmの単独更新を無効にしている。
この設定は共通プリセットを利用するリポジトリにも適用される。

[導入時の PR #437](https://github.com/dev-hato/renovate-config/pull/437)では、npmのバージョンがNode.jsに依存することを理由に除外した。
Node.jsの同梱版を使うため、Node.jsの更新を通じてnpmも更新する方針となる。

npmをNode.jsとは別に管理する必要が生じた場合に、除外を見直す。
その際は、Node.jsとnpmの対応関係を確認し、依存のインストールとCIが成功することを確かめる。

## node-fetch

2026年9月23日にマージされた[PR #2068](https://github.com/dev-hato/renovate-config/pull/2068)で、`node-fetch`の`2.6.12`固定と更新除外を解除した。
現在も`fetch-ponyfill`を通じた間接依存として残り、要求範囲の`~2.6.0`に従ってバージョンを解決する。
解除時に、ルートの[package-lock.json](../package-lock.json)に記録された`node-fetch`を`2.6.13`へ更新した。

[導入時の PR #1744](https://github.com/dev-hato/renovate-config/pull/1744)は、Super Linterの実行が終わらない問題への対応だった。
この対応で、[package.json](../package.json)の`node-fetch`を`2.6.13`から`2.6.12`へ変更して固定した。
併せて、[renovate.json](../renovate.json)の`ignoreDeps`で、このリポジトリでの`node-fetch`の自動更新を無効にした。
この除外は共通プリセットの利用先には適用しなかった。
[参照先の PR](https://github.com/dev-hato/hato-atama/pull/3551)でも、textlintの実行時間の問題に対して同じバージョンへ固定した。

固定の解除前に、ローカルでNode.js `24.21.0`を使い、辞書キャッシュを毎回削除して両バージョンを3回ずつ比較した。
いずれも約5.4〜5.8秒でtextlintが正常終了した。
マージ前の[GitHub Actions の Super Linter](https://github.com/dev-hato/renovate-config/actions/runs/35801007774)でも、`NATURAL_LANGUAGE`を含むすべての検査が成功した。

## 除外の見直し手順

除外の解除や許容範囲の拡大は、次の手順で判断する。

1. 検証用のブランチで候補バージョンとロックファイルを更新する。
2. 同じNode.jsと文書を使い、textlintが完了することと実行時間を比較する。
3. Super Linterが完了し、他の検査にも問題がないことを確認する。
4. 検証結果をPRに記録し、確認できた更新範囲に合わせて固定と除外を見直す。
