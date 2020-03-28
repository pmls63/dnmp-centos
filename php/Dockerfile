FROM centos:latest

MAINTAINER lightserver.cn <1083239138@qq.com>

RUN cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime

RUN curl -o /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-8.repo

RUN dnf makecache \
    && dnf -y update

RUN dnf -y install \
    autoconf \
    bison \
    bzip2 bzip2-devel \
    cmake \
    curl-devel \
    e2fsprogs-devel \
    freetype freetype-devel \
    fuse-devel \
    gcc gcc-c++ \
    glibc-devel git gtk2-devel \
    gd-devel \
    gettext gettext-devel gettext-common-devel \
    gmp-devel \
    httpd \
    libaio-devel \
    libblkid-devel \
    libffi-devel \
    libicu-devel \
    libjpeg libjpeg-devel \
    libpng libpng-devel \
    libtirpc-devel libtool \
    libuuid-devel libudev-devel \
    libxml2-devel \
    libxslt libxslt-devel \
    m4 \
    make \
    ncurses ncurses-devel \
    oniguruma \
    openssl openssl-devel \
    patch \
    pcre pcre-devel \
    perl-devel perl-ExtUtils-Embed perl-Data-Dumper \
    postgresql-devel \
    readline-devel \
    sqlite-devel \
    wget \
    unixODBC unixODBC-devel \
    xmlto xz \
    zlib zlib-devel

# supervisor 需要安装 epel-release 后才能执行安装
RUN dnf -y install epel-release \
    &&  dnf -y install supervisor crontabs rsyslog

RUN sed -i '/session    required   pam_loginuid.so/c\#session    required   pam_loginuid.so' /etc/pam.d/crond

ENV LIBMCRYPT_VERSION 2.5.8
ENV MHASH_VERSION 0.9.9.9
ENV ONIGURUMA_VERSION 6.9.4
ENV PHP_VERSION 7.4.1
ENV SWOOLE_VERSION 4.4.14
ENV AMQP_VERSION 1.9.4
ENV RABBITMQ_C_VERSION 0.10.0
ENV REDIS_VERSION 5.1.1

RUN groupadd -r php \
    && useradd -r -g php -s /sbin/nologin -d /usr/local/php -M php

RUN wget -c https://jaist.dl.sourceforge.net/project/mcrypt/Libmcrypt/${LIBMCRYPT_VERSION}/libmcrypt-${LIBMCRYPT_VERSION}.tar.gz -O libmcrypt.tar.gz \
    && mkdir -p libmcrypt \
    && tar -xf libmcrypt.tar.gz -C libmcrypt --strip-components=1 \
    && rm -f libmcrypt.tar.gz \
    && ( \
    cd libmcrypt \
    && ./configure \
    && make \
    && make install \
    ) \
    && rm -rf libmcrypt

RUN wget -c https://jaist.dl.sourceforge.net/project/mhash/mhash/${MHASH_VERSION}/mhash-${MHASH_VERSION}.tar.gz -O mhash.tar.gz \
    && mkdir -p mhash \
    && tar -xf mhash.tar.gz -C mhash --strip-components=1 \
    && rm -f mhash.tar.gz \
    && ( \
    cd mhash \
    && ./configure \
    && make \
    && make install \
    ) \
    && rm -rf mhash

RUN wget -c https://github.com/kkos/oniguruma/archive/v${ONIGURUMA_VERSION}.tar.gz -O oniguruma.tar.gz \
    && mkdir -p oniguruma \
    && tar -xf oniguruma.tar.gz -C oniguruma --strip-components=1 \
    && rm -f oniguruma.tar.gz \
    && ( \
    cd oniguruma \
    && ./autogen.sh \
    && ./configure --prefix=/usr \
    && make \
    && make install \
    ) \
    && rm -rf oniguruma

RUN mkdir -p /usr/local/php/etc \
    && wget -c https://www.php.net/distributions/php-${PHP_VERSION}.tar.gz -O php.tar.gz \
    && mkdir -p php \
    && tar -xf php.tar.gz -C php --strip-components=1 \
    && rm -f php.tar.gz \
    && ( \
    cd php \
    && ./configure \
        --prefix=/usr/local/php \
        --exec-prefix=/usr/local/php \
        --bindir=/usr/local/php/bin \
        --sbindir=/usr/local/php/sbin \
        --includedir=/usr/local/php/include \
        --libdir=/usr/local/php/lib/php \
        --mandir=/usr/local/php/php/man \
        --with-config-file-path=/usr/local/php/etc \
        --with-mysql-sock=/var/run/mysql/mysql.sock \
        --with-fpm-user=php \
        --with-fpm-group=php \
        --with-openssl \
        --with-mhash \
        --with-sqlite3 \
        --with-zlib \
        --with-iconv \
        --with-bz2 \
        --with-curl \
        --with-cdb \
        --with-openssl-dir \
        --with-zlib-dir \
        --with-gettext \
        --with-gmp \
        --with-mhash \
        --with-mysqli=mysqlnd \
        --with-pdo-mysql=mysqlnd \
        --with-zlib-dir \
        --with-pgsql \
        --with-pdo-pgsql \
        --with-readline \
        --with-xsl \
        --with-pear \
        --enable-fpm \
        --enable-inline-optimization \
        --enable-shared \
        --enable-soap \
        --enable-pcntl \
        --enable-xml \
        --enable-xmlreader \
        --enable-xmlwriter \
        --enable-bcmath \
        --enable-calendar \
        --enable-dom \
        --enable-exif \
        --enable-fileinfo \
        --enable-filter \
        --enable-ftp \
        --enable-gd-jis-conv \
        --enable-json \
        --enable-mbstring \
        --enable-mbregex \
        --enable-pdo \
        --enable-session \
        --enable-shmop \
        --enable-simplexml \
        --enable-sockets \
        --enable-sysvmsg \
        --enable-sysvsem \
        --enable-sysvshm \
        --enable-mysqlnd-compression-support \
        --enable-opcache \
        --disable-debug \
        --disable-rpath \
    && make \
    && make install \
    )

RUN cp php/php.ini-production /usr/local/php/etc/php.ini \
    && echo "extension_dir=\"/usr/local/php/lib/php/extensions/no-debug-non-zts-20190902\"" >> /usr/local/php/etc/php.ini \
    && cp php/sapi/fpm/init.d.php-fpm /etc/init.d/php-fpm \
    && cp /usr/local/php/etc/php-fpm.conf.default /usr/local/php/etc/php-fpm.conf \
    && cp /usr/local/php/etc/php-fpm.d/www.conf.default /usr/local/php/etc/php-fpm.d/www.conf \
    && echo "export PATH=$PATH:/usr/local/php/bin/:/usr/local/php/sbin/" > /etc/profile.d/php.sh \
    && source /etc/profile.d/php.sh \
    && rm -rf php

RUN wget -c https://github.com/swoole/swoole-src/archive/v${SWOOLE_VERSION}.tar.gz -O swoole.tar.gz \
    && mkdir -p swoole \
    && tar -zxvf swoole.tar.gz -C swoole --strip-components=1 \
    && rm -f swoole.tar.gz \
    && ( \
    cd swoole \
    && /usr/local/php/bin/phpize \
    && ./configure --with-php-config=/usr/local/php/bin/php-config --enable-openssl \
    && make \
    && make install \
    ) \
    && rm -rf swoole \
    && sed -i "2i extension=swoole.so" /usr/local/php/etc/php.ini

RUN wget -c https://github.com/alanxz/rabbitmq-c/archive/v${RABBITMQ_C_VERSION}.tar.gz -O rabbitmq.tar.gz \
    && mkdir -p rabbitmq \
    && tar -xf rabbitmq.tar.gz -C rabbitmq --strip-components=1 \
    && rm -f rabbitmq.tar.gz \
    && ( \
    cd rabbitmq \
    && mkdir build \
    && cd build \
    && cmake -DCMAKE_INSTALL_PREFIX=/usr/local/rabbitmq .. \
    && cmake --build .  --target install \
    && cp -r /usr/local/rabbitmq/lib64 /usr/local/rabbitmq/lib \
    ) \
    && rm -rf rabbitmq

RUN wget -c https://pecl.php.net/get/amqp-${AMQP_VERSION}.tgz -O amqp.tgz \
    && mkdir -p amqp \
    && tar -xf amqp.tgz -C amqp --strip-components=1 \
    && rm -f amqp.tgz \
    && ( \
    cd amqp \
    && /usr/local/php/bin/phpize \
    && ./configure \
    --with-php-config=/usr/local/php/bin/php-config \
    --with-amqp \
    --with-librabbitmq-dir=/usr/local/rabbitmq \
    && make \
    && make install \
    ) \
    && rm -rf amqp \
    && sed -i "2i extension=amqp.so" /usr/local/php/etc/php.ini \
    && ln -s /usr/local/rabbitmq-c/lib64/librabbitmq.so.4 /usr/lib64/librabbitmq.so.4

RUN wget -c https://github.com/phpredis/phpredis/archive/${REDIS_VERSION}.tar.gz -O phpredis.tar.gz \
    && mkdir -p phpredis \
    && tar -zxvf phpredis.tar.gz -C phpredis --strip-components=1 \
    && rm -f phpredis.tar.gz \
    && ( \
    cd phpredis \
    && /usr/local/php/bin/phpize \
    && ./configure \
    --with-php-config=/usr/local/php/bin/php-config \
    --enable-redis \
    && make \
    && make install \
    ) \
    && rm -rf phpreids \
    && sed -i "2i extension=redis.so" /usr/local/php/etc/php.ini

RUN wget -c https://pecl.php.net/get/mongodb-1.7.1.tgz -O mongodb.tgz \
    && mkdir -p mongodb \
    && tar -xf mongodb.tgz -C mongodb --strip-components=1 \
    && rm -f mongodb.tgz \
    && ( \
    cd mongodb \
    && /usr/local/php/bin/phpize \
    && ./configure \
    --with-php-config=/usr/local/php/bin/php-config \
    && make \
    && make install \
    ) \
    && rm -rf mongodb \
    && sed -i "2i extension=mongodb.so" /usr/local/php/etc/php.ini

RUN /usr/local/php/bin/php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" \
    && /usr/local/php/bin/php composer-setup.php \
    && chmod a+x composer-setup.php \
    && rm -f composer-setup.php \
    && mv composer.phar /usr/local/bin/composer \
    && chmod a+x /usr/local/bin/composer \
    && /usr/local/php/bin/php /usr/local/bin/composer config -g repo.packagist /usr/local/bin/composer https://packagist.phpcomposer.com

COPY ./docker-entrypoint.sh /root/

ENTRYPOINT ["/root/docker-entrypoint.sh"]

EXPOSE 9000