#!/bin/bash

. ./.env

# 当前文件夹名称
APP_NAME=$(basename "$PWD")
# 获取远程IP地址
REMOTE_HOST=${REMOTE_IP}

docker build -t ${APP_NAME} .
docker save ${APP_NAME} -o ${APP_NAME}

# 拷贝代码到远程服务器
echo "Copying code to root@${REMOTE_HOST}:~/"
scp -r ${APP_NAME} root@${REMOTE_HOST}:~/

# SSH连接并执行部署命令
echo "Connecting to root@${REMOTE_HOST}..."
ssh root@${REMOTE_HOST} << EOF

docker stop ${APP_NAME}
docker rm ${APP_NAME}
docker rmi ${APP_NAME}
docker load -i ${APP_NAME}

rm ${APP_NAME}

docker run -d -p 3000:3000 --name ${APP_NAME} --network fanshu_default ${APP_NAME}
echo "Deployment finished successfully!"
EOF
