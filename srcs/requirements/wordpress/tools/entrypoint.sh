
#!/bin/bash

set -e

# Change 'listen' param at file www.conf
sed -i '/listen = /c\listen = 9000' /etc/php/7.4/fpm/pool.d/www.conf

# Creates folder for PHP
mkdir -p /run/php/

mkdir -p /var/www/html/wordpress
cd /var/www/html/wordpress/

if [ -f /run/secrets/secrets_inception ]; then
(
    DB_PWD=$(grep 'db_pass=' /run/secrets/secrets_inception | cut -d '=' -f2)
    WP_ADM_PWD=$(grep 'wp_admin_pass=' /run/secrets/secrets_inception | cut -d '=' -f2)
    WP_USR_PWD=$(grep 'wp_user_pass=' /run/secrets/secrets_inception | cut -d '=' -f2)

    if [ ! -f "wp-config.php" ]; then

        echo "Download wp cli"
        wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar -O /usr/local/bin/wp
        
        # Change premissions for wordpress executable
        chmod +x /usr/local/bin/wp
        
        # Download wordpress, configure and connect database
        wp core download --allow-root 
        
        #Setup wp-config.php file
        cp wp-config-sample.php wp-config.php
        sed -i "s/username_here/$DB_USER/g" wp-config.php
        sed -i "s/password_here/$DB_PWD/g" wp-config.php
        sed -i "s/localhost/$DB_HOST/g" wp-config.php
        sed -i "s/database_name_here/$DB_NAME/g" wp-config.php
        sed -i "s/define( 'WP_DEBUG', false )/define( 'WP_DEBUG', true )/g" wp-config.php

    # Create user admin - WordPress
    wp --allow-root core install --url=$WP_URL --title=$WP_TITLE --admin_user=$WP_ADM_USER --admin_password=$WP_ADM_PWD --admin_email=$WP_ADM_EMAIL --skip-email 
        

    # Create aditional user
    wp --allow-root user create $WP_USR_USER $WP_USR_EMAIL --user_pass=$WP_USR_PWD --role=$WP_USR_ROLE 
        
    fi
)
else
    echo "Error : Secrets not found"
    exit 1
fi
# Set correct permissions
echo "Setting  permissions for WordPress directory..."
find /var/www/html/wordpress/wp-content -type d -exec chmod 777 {} \;
find /var/www/html/wordpress/wp-content -type f -exec chmod 777 {} \;


#  Executa o PHP-FPM
exec php-fpm7.4 -F
