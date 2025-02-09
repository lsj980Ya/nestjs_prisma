# 构建阶段
FROM node:20-alpine AS builder

WORKDIR /app

# 首先只复制 package.json 和 prisma 相关文件
COPY package.json ./
COPY prisma ./prisma/

# 安装依赖
RUN npm config set registry https://registry.npmmirror.com
RUN npm install

# 生成 Prisma Client
RUN npx prisma generate

# 复制源代码
COPY . .

# 构建应用
RUN npm run build

# 生产阶段
FROM node:20-alpine

WORKDIR /app

# 安装PM2
RUN npm config set registry https://registry.npmmirror.com
RUN npm install -g pm2

# 从构建阶段复制必要文件
COPY --from=builder /app/dist ./dist
COPY --from=builder /app/package*.json ./
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/prisma ./prisma

# 暴露端口
EXPOSE 3000

# 设置启动脚本
COPY docker-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

# 使用入口脚本启动应用
ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["pm2-runtime", "start", "dist/main.js"]