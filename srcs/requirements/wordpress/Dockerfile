
FROM debian:oldstable

EXPOSE 9000

# Atualizar e instalar pacotes necessários
RUN apt-get update && apt-get install -y php-fpm wget php-mysql curl unzip



# Instalar WP-CLI
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/gh-pages/wp-cli.phar \
    && chmod +x wp-cli.phar \
    && mv wp-cli.phar /usr/local/bin/wp


# Baixar e instalar o WordPress
RUN wget https://wordpress.org/latest.tar.gz 

RUN tar -xzvf latest.tar.gz 

RUN rm latest.tar.gz 



# PASTA WORDPRESS
RUN		service php7.4-fpm stop

RUN mkdir -p /var/www/html/ && mkdir -p /run/php/

RUN mv ./wordpress /var/www/html/

COPY conf/wp-config.php /tmp/wp-config.php

RUN mv /tmp/wp-config.php /var/www/html/wordpress/

# Dar permissões corretas
RUN chown -R www-data:www-data /var/www/html/wordpress

# Copiar a configuração customizada do PHP-FPM
COPY conf/php-fpm.conf /etc/php/7.4/fpm/php-fpm.conf


COPY tools/docker-entrypoint.sh /usr/local/bin/

RUN chmod +x /usr/local/bin/docker-entrypoint.sh

ENTRYPOINT ["docker-entrypoint.sh"]


CMD ["php-fpm7.4","-F"]