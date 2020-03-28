#!/bin/sh
set -v

# 设置crontab，使用shell生成crontab，避免docker容器无法生效
echo "*/1 * * * * /bin/echo 'it works' >> /root/test.log" > ./php/crontab/cron/root

# 停止所有容器
# docker stop $(docker ps -a -q)
# 删除所有容器
# docker rm $(docker ps -a -q)

# 停止 Exited 状态容器
docker stop $(docker ps -a | grep "Exited" | awk '{print $1 }')

# 删除 Exited 状态 容器
docker rm $(docker ps -a | grep "Exited" | awk '{print $1 }')

# 删除 none 的镜像
docker rmi $(docker images | grep "none" | awk '{print $3}')

# 重建docker镜像
docker-compose up -d --build