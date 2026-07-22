FROM alpine:latest
ENV PHP_VER=84
RUN \
    echo "Installing basic utils ..." && \
    apk add bash && \
    apk add openrc
RUN \
    echo "Installing PHP + PHP-FPM ..." && \
    apk add php$PHP_VER && \
    apk add php$PHP_VER-session && \
    apk add php$PHP_VER-ctype && \
    apk add php$PHP_VER-gd && \
    apk add php$PHP_VER-tidy && \
    apk add php$PHP_VER-fpm
RUN \
    echo "Installing nginx ..." && \
    apk add nginx && \
    mv /etc/nginx/http.d/default.conf /etc/nginx/http.d/default.conf.old && \
    mkdir /var/www/html && \
    chown -R nginx /var/www/html
COPY default.conf /etc/nginx/http.d/default.conf
COPY startup.sh /usr/sbin/startup.sh
RUN chmod +x /usr/sbin/*.sh
WORKDIR /repo
ENTRYPOINT /usr/sbin/startup.sh
