#!/bin/bash

# 删除所有容器
containers=$(sudo docker ps -aq)
if [ -n "$containers" ]; then
    sudo docker rm -f $containers
else
    echo "没有容器可删除"
fi

# 删除所有镜像
images=$(sudo docker images -q)
if [ -n "$images" ]; then
    sudo docker rmi -f $images
else
    echo "没有镜像可删除"
fi

sudo docker compose up -d