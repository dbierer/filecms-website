FROM alpine:latest
RUN \
    echo "Installing basic utils ..." && \
    apk add bash && \
    apk add openrc
RUN \
    echo "Installing PHP + PHP-FPM ..." && \
    apk add php81 && \
    apk add php81-session && \
    apk add php81-ctype && \
    apk add php81-gd && \
    apk add php81-tidy && \
    apk add php81-fpm
RUN \
    echo "Installing nginx ..." && \
    apk add nginx && \
    mv /etc/nginx/http.d/default.conf /etc/nginx/http.d/default.conf.old && \
    mkdir /var/www/html && \
    chown -R nginx /var/www/html
COPY default.conf /etc/nginx/http.d/default.conf
COPY startup.sh /usr/sbin/startup.sh
RUN chmod +x /usr/sbin/*.sh
ENTRYPOINT /usr/sbin/startup.sh
