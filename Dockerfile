FROM asclinux/linuxforphp-8.2-ultimate:8.0-nts
MAINTAINER doug@unlikelysource.com
COPY startup.sh /tmp/startup.sh
RUN chmod +x /tmp/*.sh
RUN \
    echo "Setting up error logging to go to /tmp/php_errors.log ..." && \
    sed -i 's/;error_log = php_errors.log/error_log=\/tmp\/php_errors.log/g' /etc/php.ini
CMD /tmp/startup.sh
