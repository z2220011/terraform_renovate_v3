# Renovateの検証用Dockerfile
# 古いバージョンを意図的に使用（Renovateがアップデート提案を行う）

FROM node:14.17.0-alpine

WORKDIR /app

# 依存関係のインストール
COPY package*.json ./
RUN npm ci --only=production

# アプリケーションファイルのコピー
COPY . .

# ポート公開
EXPOSE 3000

# ヘルスチェック
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD node healthcheck.js || exit 1

# 非rootユーザーで実行
USER node

CMD ["npm", "start"]
