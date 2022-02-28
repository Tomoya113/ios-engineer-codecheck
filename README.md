# iOS エンジニアコードチェック課題

## アーキテクチャ

MVVMに加え、Repository, Routerパターンを使って実装しました。
<img src="https://user-images.githubusercontent.com/22112440/155922895-b167fbeb-75c0-4cfc-9cdc-5db1186f45ae.png" width="600px">

## 環境構築
CocoaPodsをインストールしていない場合はインストールしてください
```
$ pod install
$ open iOSEngineerCodeCheck.xcworkspace
```

## ライブラリ
追加したライブラリは以下の通りです。
- Moya
- Moya/RxSwift
- Nuke
- PKHUD
- RxCocoa
- RxSwift
- RxTest
- SwiftLint

## 取り組んだ課題
以下の課題に取り組みました。
- [ソースコードの可読性の向上](https://github.com/Tomoya113/ios-engineer-codecheck/issues/1)
- [ソースコードの安全性の向上](https://github.com/Tomoya113/ios-engineer-codecheck/issues/2)
- [バグを修正](https://github.com/Tomoya113/ios-engineer-codecheck/issues/3)
- [アーキテクチャを適用](https://github.com/Tomoya113/ios-engineer-codecheck/issues/6)
- [新機能を追加](https://github.com/Tomoya113/ios-engineer-codecheck/issues/8)
- [テストを追加](https://github.com/Tomoya113/ios-engineer-codecheck/issues/9)

## 追加した機能
元のアプリに以下の新しい機能を追加しました。

### [リポジトリ検索画面にバリデーションとローディング機能を追加](https://github.com/Tomoya113/ios-engineer-codecheck/pull/24)
- 文字が入力されずに検索が行われた時にアラートを出す機能
- 検索時のローディング機能

### [リポジトリ検索機能にエラーハンドリング機能を追加](https://github.com/Tomoya113/ios-engineer-codecheck/pull/25)
- エラーが発生した時にアラートを出す機能

## 反省点
開発中に感じた反省点、提出期限までに着手できなかった改善点についてです。

### テスト用のモックの管理

テスト用のモックを生成するコードが長く、複雑になってしまっている。

#### 改善案
mockoloなどのモックを自動で生成するライブラリを導入する。


### project.pbxprojの管理
MVVMアーキテクチャを構築する際に、最初に必要なファイルをすべて作り、ブランチを切ってPRを出すというフローで開発を行ったので、PRの所々でproject.pbxprojの整合性が取れない部分ができてきてしまいました。

#### 改善案
XcodeGenを使い、project.pbxprojの生成を自動化する。

