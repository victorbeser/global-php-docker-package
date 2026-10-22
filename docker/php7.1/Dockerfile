FROM php:7.1.11-apache

# Legacy PHP Docker Pack
# Desenvolvido por Victor Beserra
LABEL org.opencontainers.image.authors="Victor Beserra"
LABEL org.opencontainers.image.title="Legacy PHP Docker Pack"
LABEL org.opencontainers.image.description="Ambiente Docker para sistemas legados PHP 5.3 e 7.1"
LABEL org.opencontainers.image.vendor="Victor Beserra"

ARG DB_DRIVER=pgsql

COPY scripts/install-drivers.sh /usr/local/bin/install-drivers.sh
COPY config/apache-legacy.conf /etc/apache2/conf-available/apache-legacy.conf
COPY oracle/ /tmp/oracle/

RUN chmod +x /usr/local/bin/install-drivers.sh \
    && /usr/local/bin/install-drivers.sh 7.1 "$DB_DRIVER" \
    && a2enmod rewrite \
    && a2enconf apache-legacy \
    && echo 'ServerName localhost' > /etc/apache2/conf-available/servername.conf \
    && a2enconf servername \
    && rm -rf /tmp/oracle

ENV LD_LIBRARY_PATH=/opt/oracle/instantclient_12_1
WORKDIR /var/www/html
EXPOSE 80
