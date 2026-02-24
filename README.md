# Renovate 検証用テストリポジトリ

このリポジトリは、Renovateのセルフホスティッド版の動作検証用サンプルです。

## 含まれる依存関係

- **Node.js** (package.json)
  - 本番依存: express, lodash, axios, dotenv, moment
  - 開発依存: jest, eslint, webpack

- **Docker** (Dockerfile)
  - Node.js 14.17.0 ベースイメージ

- **GitHub Actions** (.github/workflows/ci.yml)
  - actions/checkout@v2
  - actions/setup-node@v2
  - actions/cache@v2

- **Python** (requirements.txt)
  - Django, requests, pytest, black, flake8 など

## Renovateの検証ポイント

1. **自動検出機能**
   - 複数のパッケージマネージャーを自動検出できるか

2. **PR作成**
   - 各依存関係のアップデートPRが正しく作成されるか
   - グルーピング設定が適用されるか

3. **セキュリティアップデート**
   - 脆弱性のある古いバージョンが優先的に検出されるか

4. **スケジュール実行**
   - 設定したスケジュール通りに動作するか

## このリポジトリの使い方

1. GitHubに新しいリポジトリを作成
2. このディレクトリの内容をpush
3. Renovateの設定でこのリポジトリを指定
4. Renovateを実行し、PRが作成されることを確認

## 期待される動作

Renovateを実行すると、以下のようなPRが作成されるはずです：

- Node.js依存関係のアップデート（グループ化される可能性あり）
- Dockerベースイメージのアップデート
- GitHub Actionsのアップデート
- Python依存関係のアップデート
- セキュリティアップデート（高優先度）
