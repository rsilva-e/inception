#!/bin/bash
set -e

# Modificar a configuração para aceitar conexões externas
sed -i -e 's/127.0.0.1/0.0.0.0/g' /etc/mysql/mariadb.conf.d/50-server.cnf

# Iniciar o serviço MariaDB
service mariadb start
sleep 1

# Esperar até que o MariaDB esteja pronto
until mysql -u root -p"$DB_ROOT_PWD" -e "SELECT 1"; do
    echo "Esperando pelo MariaDB..."
    sleep 1
done

# Configuração inicial do banco de dados
mysql -u root -p"$DB_ROOT_PWD" << EOF
CREATE DATABASE IF NOT EXISTS $WP_DB_NAME;
CREATE USER IF NOT EXISTS '$WP_USR_USER'@'%' IDENTIFIED BY '$WP_DB_PWD';
GRANT ALL PRIVILEGES ON $WP_DB_NAME.* TO '$WP_USR_USER'@'%';
ALTER USER 'root'@'localhost' IDENTIFIED BY '$DB_ROOT_PWD';
FLUSH PRIVILEGES;
EOF

# Parar o serviço MariaDB
service mariadb stop

# Executar o comando passado ao script
exec "$@"



        