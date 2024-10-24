
FROM debian:oldstable

EXPOSE 9000

# Atualizar e instalar pacotes necessários
RUN apt-get update && apt-get install -y php-fpm wget php-mysql curl unzip

# Baixar e instalar o WordPress
RUN wget https://wordpress.org/latest.tar.gz 

RUN tar -xzvf latest.tar.gz 

RUN rm latest.tar.gz 


# PASTA WORDPRESS

RUN mkdir -p /var/www/html/

RUN mkdir -p /run/php/

RUN mv wordpress /var/www/html/

# Dar permissões corretas
RUN chown -R www-data:www-data /var/www/html/wordpress



# Copiar a configuração customizada do PHP-FPM
COPY conf/php-fpm.conf /etc/php/7.4/fpm/php-fpm.conf


CMD ["php-fpm7.4","-F"]