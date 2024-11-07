FROM debian:oldstable

EXPOSE 9000

# Atualizar e instalar pacotes necessários
RUN apt-get update && apt-get install -y php-fpm wget php-mysql unzip

# Instalar WP-CLI
RUN wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
    && chmod +x wp-cli.phar \
    && mv wp-cli.phar /usr/local/bin/wp

RUN service php7.4-fpm stop
RUN mkdir -p /run/php/

COPY conf/wp-config.php /tmp/wp-config.php

# Copiar a configuração customizada do PHP-FPM
COPY conf/www.conf /etc/php/7.4/fpm/pool.d/

COPY tools/docker-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["php-fpm7.4","-F"]