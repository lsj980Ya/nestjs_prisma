# 第一阶段: 构建阶段
FROM node:18-alpine AS build

# 设置工作目录
WORKDIR /app

# 复制 package.json 和 package-lock.json
COPY package*.json ./

# 安装依赖
RUN npm install

# 复制项目代码
COPY . .

# 构建项目（例如前端打包或者 TypeScript 编译）
RUN npm run build

# 第二阶段: 生产运行阶段
FROM node:18-alpine AS production

# 安装 PM2 全局
RUN npm install -g pm2

# 设置工作目录
WORKDIR /app

# 复制 package.json 和 package-lock.json
COPY package*.json ./

# 安装仅生产环境依赖
RUN npm install --production

# 从构建阶段复制构建产物
COPY --from=build /app/dist ./dist

# 复制应用的所有代码
# 复制其他必须的运行时配置或文件 (如配置文件或环境文件)
COPY --from=build /app/.env .env
COPY --from=build /app/prisma prisma
COPY --from=build /app/ecosystem.config.js ecosystem.config.js

# 生成 Prisma 客户端（需要在构建阶段生成）
RUN npx prisma generate

# 设置环境变量
ENV NODE_ENV=production

# 暴露应用端口
EXPOSE 3000

# 使用 PM2 启动应用
CMD ["pm2-runtime", "start", "ecosystem.config.js"]
