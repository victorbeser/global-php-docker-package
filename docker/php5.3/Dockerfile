
# PHP 5.3.29 + Apache
FROM orsolin/docker-php-5.3-apache:latest

# Legacy PHP Docker Pack
# Desenvolvido por Victor Beserra
LABEL org.opencontainers.image.authors="Victor Beserra"
LABEL org.opencontainers.image.title="Legacy PHP Docker Pack"
LABEL org.opencontainers.image.description="Ambiente Docker para sistemas legados PHP 5.3 e 7.1"
LABEL org.opencontainers.image.vendor="Victor Beserra"

ARG DB_DRIVER=pgsql

# Copiar arquivos de configuracao
COPY scripts/install-drivers.sh /usr/local/bin/install-drivers.sh
COPY config/apache-legacy.conf /etc/apache2/conf-available/apache-legacy.conf
COPY oracle/ /tmp/oracle/

# Preparar diretorios ANTES de instalar extensoes PHP
RUN mkdir -p /usr/local/etc/php/conf.d \
    /etc/php5/apache2/conf.d \
    && chmod +x /usr/local/bin/install-drivers.sh \
    && /usr/local/bin/install-drivers.sh 5.3 "$DB_DRIVER" \
    && ln -sf /usr/local/etc/php/conf.d/99-legacy.ini \
       /etc/php5/apache2/conf.d/99-legacy.ini \
    && a2enmod rewrite \
    && a2enconf apache-legacy \
    && echo 'ServerName localhost' > /etc/apache2/conf-available/servername.conf \
    && a2enconf servername \
    && rm -rf /tmp/oracle

ENV LD_LIBRARY_PATH=/opt/oracle/instantclient_12_1

WORKDIR /var/www/html

EXPOSE 80
