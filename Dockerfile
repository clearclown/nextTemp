# Stage 1: Build
FROM node:20 as build

WORKDIR /app

# 環境変数をコピー
COPY .env .env
COPY package.json package-lock.json ./
RUN npm install

COPY . .
RUN npm run build

# Stage 2: Production
FROM node:20

WORKDIR /app

RUN apt update && apt -y upgrade && apt -y dist-upgrade && apt -y autoremove && apt -y autoclean
RUN apt -y install \
    sudo \
    curl \
    git \
    vim \
    nano \
    sudo \
    build-essential

# 必要なファイルのみコピー
COPY --from=build /app ./
COPY --from=build /app/.next ./.next

# フロントエンドサーバーを起動
CMD ["npm", "run", "start"]
