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

ENV PCRE_VERSION 8.43
ENV ZLIB_VERSION 1.2.11
ENV OPENSSL_VERSION 1.1.1
ENV NGINX_VERSION 1.17.7

RUN groupadd -r nginx \
    && useradd -r -g nginx -s /sbin/nologin -d /usr/local/nginx -M nginx

RUN mkdir -pv /usr/local/nginx/{client_body_temp,proxy_temp,fastcgi_temp,uwsgi_temp,scgi_temp} \
    && mkdir -pv /usr/local/nginx/{logs,sbin,conf} \
    && chown -R nginx:nginx /usr/local/nginx

RUN wget -c https://ftp.pcre.org/pub/pcre/pcre-${PCRE_VERSION}.tar.gz -O pcre.tar.gz \
    && mkdir -p pcre \
    && tar -xf pcre.tar.gz -C pcre --strip-components=1 \
    && rm -f pcre.tar.gz \
    && ( \
    cd pcre \
    && ./configure \
    && make \
    && make install \
    )

RUN wget -c http://www.zlib.net/fossils/zlib-${ZLIB_VERSION}.tar.gz -O zlib.tar.gz \
    && mkdir -p zlib \
    && tar -xf zlib.tar.gz -C zlib --strip-components=1 \
    && rm -f zlib.tar.gz \
    && ( \
    cd zlib \
    && ./configure \
    && make \
    && make install \
    )

RUN wget -c https://www.openssl.org/source/openssl-${OPENSSL_VERSION}-pre8.tar.gz -O openssl.tar.gz \
    && mkdir -p openssl \
    && tar -xf openssl.tar.gz -C openssl --strip-components=1 \
    && rm -f openssl.tar.gz \
    && ( \
    cd openssl \
    && ./config \
    && make \
    && make install \
    )

RUN wget -c https://bitbucket.org/nginx-goodies/nginx-sticky-module-ng/get/master.tar.gz -O sticky.tar.gz \
    && mkdir -p sticky \
    && tar -xf sticky.tar.gz -C sticky --strip-components=1 \
    && rm -f sticky.tar.gz \
    && wget -c http://nginx.org/download/nginx-${NGINX_VERSION}.tar.gz -O nginx.tar.gz \
    && mkdir -p nginx \
    && tar -xf nginx.tar.gz -C nginx --strip-components=1 \
    && rm -f nginx.tar.gz \
    && ( \
    cd nginx \
    && CFLAGS="-fPIC" ./configure \
        --prefix=/usr/local/nginx \
        --sbin-path=/usr/local/nginx/sbin/ \
        --conf-path=/usr/local/nginx/conf/nginx.conf \
        --error-log-path=/usr/local/nginx/logs/error.log \
        --http-log-path=/usr/local/nginx/logs/access.log \
        --pid-path=/var/run/nginx.pid  \
        --lock-path=/var/lock/nginx.lock \
        --user=nginx \
        --group=nginx \
        --with-http_ssl_module \
        --with-http_v2_module \
        --with-http_dav_module \
        --with-http_flv_module \
        --with-http_realip_module \
        --with-http_addition_module \
        --with-http_xslt_module \
        --with-http_stub_status_module \
        --with-http_sub_module \
        --with-http_random_index_module \
        --with-http_degradation_module \
        --with-http_secure_link_module \
        --with-http_gzip_static_module \
        --with-http_perl_module \
        --add-module=../sticky \
        --with-pcre=../pcre \
        --with-pcre-opt="-fPIC" \
        --with-zlib=../zlib \
        --with-zlib-opt="-fPIC" \
        --with-openssl=../openssl \
        --with-openssl-opt="-fPIC" \
        --with-debug \
        --with-file-aio \
        --with-mail \
        --with-mail_ssl_module \
        --http-client-body-temp-path=/usr/local/nginx/client_body_temp/ \
        --http-proxy-temp-path=/usr/local/nginx/proxy_temp/ \
        --http-fastcgi-temp-path=/usr/local/nginx/fastcgi_temp/ \
        --http-uwsgi-temp-path=/usr/local/nginx/uwsgi_temp/ \
        --http-scgi-temp-path=/usr/local/nginx/scgi_temp/ \
        --with-stream \
        --with-ld-opt="-fPIC -Wl,-E" \
    && make \
    && make install \
    ) \
    && rm -rf nginx \
    && rm -rf pcre \
    && rm -rf zlib \
    && rm -rf openssl \
    && rm -rf sticky

RUN echo "export PATH=$PATH:/usr/local/nginx/sbin/" > /etc/profile.d/nginx.sh \
    && source /etc/profile.d/nginx.sh

CMD ["/usr/local/nginx/sbin/nginx", "-g", "daemon off;"]

EXPOSE 80