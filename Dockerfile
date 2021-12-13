FROM asclinux/linuxforphp-8.2-ultimate:8.0-nts
MAINTAINER doug@unlikelysource.com
COPY src/test.sql /tmp/test.sql
COPY startup.sh /tmp/startup.sh
RUN chmod +x /tmp/*.sh
RUN \
    echo "Creating sample database and assigning permissions ..." && \
    /etc/init.d/mysql start && \
    sleep 5 && \
    mysql -uroot -v -e "CREATE DATABASE IF NOT EXISTS test;" && \
    mysql -uroot -v -e "CREATE USER IF NOT EXISTS 'test'@'localhost' IDENTIFIED BY 'password';" && \
    mysql -uroot -v -e "GRANT ALL PRIVILEGES ON *.* TO 'test'@'localhost';" && \
    mysql -uroot -v -e "FLUSH PRIVILEGES;"
RUN \
    echo "Restoring sample database ..." && \
    /etc/init.d/mysql start && \
    sleep 5 && \
    mysql -uroot -e "SOURCE /tmp/test.sql;" test
RUN \
    echo "Installing phpMyAdmin ..." && \
    wget -O /tmp/phpmyadmin_install.sh https://opensource.unlikelysource.com/phpmyadmin_install.sh && \
    chmod +x /tmp/*.sh && \
    /tmp/phpmyadmin_install.sh 5.1.1
RUN \
    echo "Setting up error logging ..." && \
    sed -i 's/;error_log = php_errors.log/error_log=\/tmp\/php_errors.log/g' /etc/php.ini
CMD /tmp/startup.sh
