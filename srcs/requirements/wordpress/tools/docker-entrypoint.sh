#!/bin/bash
set -e

#mkdir /var/www/html/wordpress
mv /tmp/wp-config.php /var/www/html/wordpress/
chown -R www-data:www-data /var/www/html

cd /var/www/html/wordpress/

#Download do WordPress
wp --allow-root core download

# Instalação do WordPress
wp --allow-root core install \
    --url=$WP_URL \
    --title=$WP_TITLE \
    --admin_user=$WP_ADM_USER \
    --admin_password=$WP_ADM_PWD \
    --admin_email=$WP_ADM_EMAIL \
    --skip-email

# Criação de usuário adicional
wp --allow-root user create $WP_USR_USER $WP_USR_EMAIL \
    --user_pass=$WP_USR_PWD \
    --role=$WP_USR_ROLE

# Executar o comando passado ao script
exec "$@"
