## dnmp-centos
>
> 基于CentOS最新的CentOS-8作为基础镜像
>
> 源码编写安装 Nginx dockerfile 及 PHP dockerfile
>
> 并使用 docker-compose进行编排
> 
> PHP基础扩展 PDO-MySQL + PDO-PgSQL + OpenSSL + Mbstring + Curl + Iconv + XML + Ctype + JSon + BCmath
> 
> 编译安装 swoole + Redis + mongoDB + rabbitMQ + amqp
>
> 同时完美解决 docker 下，cronTab的使用及supervisor使用问题
>


### 目录结构
```shell
# pwd

/path/to/project_dir

# tree
.
├── build.sh
├── docker-compose.yml
├── nginx
│   ├── conf
│   │   ├── certs
│   │   │   ├── www.example.cn.key
│   │   │   └── www.example.cn.pem
│   │   ├── nginx.conf
│   │   └── servers
│   │       ├── ip.conf
│   │       ├── example443.conf
│   │       └── example80.conf
│   ├── Dockerfile
│   ├── html
│   │   ├── index.html
│   │   ├── index.php
│   │   └── info.php
│   └── logs
│       ├── access.log
│       └── error.log
├── php
│   ├── crontab
│   │   └── cron
│   │       └── root
│   ├── docker-entrypoint.sh
│   ├── Dockerfile
│   ├── php-fpm.d
│   │   └── www.conf
│   ├── rsyslogd
│   │   └── conf
│   │       ├── rsyslog.conf
│   │       └── rsyslog.d
│   └── supervisor
│       ├── conf
│       │   ├── supervisor.d
│       │   │   ├── crond.conf
│       │   │   └── rsyslog.conf
│       │   └── supervisord.conf
│       ├── log
│       │   ├── crond_stderr.log
│       │   ├── crond_stdout.log
│       │   ├── rsyslogd_stderr.log
│       │   ├── rsyslogd_stdout.log
│       │   └── supervisord.log
│       └── run
│           └── supervisor.sock
└── ReadMe.md
```

### 目录说明：
> 服务配置文件：关于当前服务的配置  如:nginx.conf
>
> 项目配置目录：当前服务为项目提供的配置  如:ip.conf

```shell
.
├── build.sh
├── docker-compose.yml
├── nginx
│   ├── conf
│   │   ├── certs                       nginx 项目证书目录
│   │   │   ├── www.example.cn.key
│   │   │   └── www.example.cn.pem
│   │   ├── nginx.conf                  nginx 服务配置文件
│   │   └── servers                     nginx 项目配置目录
│   │       ├── ip.conf
│   │       ├── example443.conf
│   │       └── example80.conf
│   ├── Dockerfile
│   ├── html                            nginx 项目部署目录
│   │   ├── index.html
│   │   ├── index.php
│   │   └── info.php
│   └── logs                            nginx 日志目录
│       ├── access.log
│       └── error.log
├── php
│   ├── crontab
│   │   └── cron
│   │       └── root                    crontab root用户配置文件
│   ├── docker-entrypoint.sh
│   ├── Dockerfile
│   ├── php-fpm.d
│   │   └── www.conf                    php 服务配置文件
│   ├── rsyslogd
│   │   └── conf
│   │       ├── rsyslog.conf            rsyslog 服务配置文件
│   │       └── rsyslog.d               rsyslog 项目配置目录
│   └── supervisor
│       ├── conf
│       │   ├── supervisor.d            superviosr 项目配置文件
│       │   │   ├── crond.conf
│       │   │   └── rsyslog.conf
│       │   └── supervisord.conf        supervisor 服务配置文件
│       ├── log                         supervisor 日志目录
│       │   ├── crond_stderr.log
│       │   ├── crond_stdout.log
│       │   ├── rsyslogd_stderr.log
│       │   ├── rsyslogd_stdout.log
│       │   └── supervisord.log
│       └── run                         superviosr 运行目录
│           └── supervisor.sock
└── ReadMe.md

# crontab root用户配置文件
./DockerFile/php/crontab/cron/root

# php-fpm 服务配置文件
./DockerFile/php/php-fpm.d/www.conf

# rsyslog 服务配置文件
./DockerFile/php/rsyslog/conf/rsyslog.conf

# supervisor 服务配置文件
./DockerFile/php/supervisor/conf/supervisord.conf

# crond 监控服务 （利用superviosr启动crond服务）
./DockerFile/php/supervisor/conf/supervisor.d/crond.conf

# rsyslog 监控服务 （利用superviosr启动rsyslog服务）
./DockerFile/php/supervisor/conf/supervisor.d/rsyslog.conf

```

### 首次创建镜像
```shell
# 进入DockerFile目录
cd /path/to/DockerFile/

# 执行重建脚本
sh ./build.sh
```

### 执行 docker-compose
```shell
# 以下命令需要在./Dockerfile目录下执行

# 启动docker-compose (守护进程模式)
docker-compose up -d

# 停止容器
docker-compose stop all

# 重启nginx (修改nginx配置后执行)
docker-compose restart nginx

# 重启php-fpm （修改crontab、supervisor配置后执行）
docker-compose restart php-fpm
```

### 配置项目
```shell
# 项目部署目录
./Dockerfile/nginx/html/

# 项目配置目录
./Dockerfile/nginx/conf/servers/

# 重启nginx
docker-compose restart nginx
```

### crontab

```shell
# 请在Liunx宿主机中进行添加 (也可进入容器添加)
# 初次执行sh build.sh 生成（已存在，后期使用vi更新即可）
vi ./DockerFile/php/crontab/cron/root

# 重启php-fpm
docker-compose restart php-fpm
```

### supervisor
```shell
# superviosr.d配置目录
cd ./DockerFile/php/supervisor/conf/supervisor.d/

# 重启php-fpm
docker-compose restart php-fpm
```

### 执行composer:
> 执行composer，需要进入到容器内执行

```shell
# 进入容器内
docker exec -it php-fpm /bin/bash 

# 进入项目目录
cd /usr/local/nginx/html/project_name/

# 执行composer命令
composer install -vvv
```

### 执行脚本：
> 执行脚本，需要执行的文件，加载到容器中

```shell
# 进入容器内
docker exec -it php-fpm /bin/bash

# 采用全路径执行
/usr/local/php/bin/php /usr/local/nginx/html/index.php

# 容器外执行
docker exec php-fpm /usr/local/php/bin/php /usr/local/nginx/html/index.php
```