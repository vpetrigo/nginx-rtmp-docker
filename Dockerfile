FROM alpine:3.11

LABEL maintainer="vladimir.petrigo@gmail.com"

ENV NGINX_VERSION 1.18.0
ENV NGINX_RTMP_VERSION 1.2.1
ENV NGINX_NDK_VERSION 0.3.1
ENV NGINX_SET_MISC_VERSION 0.32
ENV NGINX_HTTP_SUBS_VERSION master

RUN apk add --no-cache --update openssl-dev pcre-dev curl ca-certificates \
    make gcc g++ binutils zlib-dev unzip

RUN mkdir -p /tmp/nginx_rtmp
RUN mkdir -p /tmp/nginx
RUN mkdir -p /tmp/nginx_ndk
RUN mkdir -p /tmp/nginx_set_misc
RUN mkdir -p /tmp/nginx_subs

RUN wget "https://github.com/arut/nginx-rtmp-module/archive/v${NGINX_RTMP_VERSION}.tar.gz" -O/tmp/nginx_rtmp/v${NGINX_RTMP_VERSION}.tar.gz && \
    cd /tmp/nginx_rtmp && \
    tar zxf v${NGINX_RTMP_VERSION}.tar.gz

RUN wget "https://github.com/vision5/ngx_devel_kit/archive/v${NGINX_NDK_VERSION}.tar.gz" -O/tmp/nginx_ndk/v${NGINX_NDK_VERSION}.tar.gz && \
    cd /tmp/nginx_ndk && \
    tar zxf v${NGINX_NDK_VERSION}.tar.gz

RUN wget "https://github.com/openresty/set-misc-nginx-module/archive/v${NGINX_SET_MISC_VERSION}.tar.gz" -O/tmp/nginx_set_misc/v${NGINX_SET_MISC_VERSION}.tar.gz && \
    cd /tmp/nginx_set_misc && \
    tar zxf v${NGINX_SET_MISC_VERSION}.tar.gz

RUN wget "https://github.com/yaoweibin/ngx_http_substitutions_filter_module/archive/master.zip" -O/tmp/nginx_subs/v${NGINX_HTTP_SUBS_VERSION}.zip && \
    cd /tmp/nginx_subs && \
    unzip v${NGINX_HTTP_SUBS_VERSION}.zip

RUN wget https://nginx.org/download/nginx-${NGINX_VERSION}.tar.gz -O/tmp/nginx/nginx-${NGINX_VERSION}.tar.gz && \
    cd /tmp/nginx && \
    tar zxf nginx-${NGINX_VERSION}.tar.gz

# Build nginx with RTMP module
RUN cd /tmp/nginx/nginx-${NGINX_VERSION} && \
    ./configure \
        --sbin-path=/usr/local/sbin/nginx \
        --conf-path=/etc/nginx/nginx.conf \
        --error-log-path=/var/log/nginx/error.log \
        --pid-path=/var/run/nginx/nginx.pid \
        --lock-path=/var/lock/nginx/nginx.lock \
        --http-log-path=/var/log/nginx/access.log \
        --http-client-body-temp-path=/tmp/nginx-client-body \
        --with-http_ssl_module \
        --with-http_auth_request_module \
        --with-threads \
        --with-cc-opt=-Wno-error \
        --add-module=/tmp/nginx_ndk/ngx_devel_kit-${NGINX_NDK_VERSION} \
        --add-module=/tmp/nginx_rtmp/nginx-rtmp-module-${NGINX_RTMP_VERSION} \
        --add-module=/tmp/nginx_subs/ngx_http_substitutions_filter_module-${NGINX_HTTP_SUBS_VERSION} \
        --add-module=/tmp/nginx_set_misc/set-misc-nginx-module-${NGINX_SET_MISC_VERSION} && \
    make -j$(nproc) && \
    make install && \
    mkdir -p /var/lock/nginx && \
    mkdir -p /var/www/live && \
    mkdir -p /var/www/keys && \
    cd / && \
    rm -rf /tmp/nginx*

RUN ln -sf /dev/stdout /var/log/nginx/access.log && \
    ln -sf /dev/stderr /var/log/nginx/error.log

ENV PATH="/usr/local/sbin:${PATH}"

EXPOSE 1935
CMD ["nginx", "-g", "daemon off;"]
