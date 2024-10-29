#!/bin/bash
set -e

# Modificar a configuração para aceitar conexões externas
sed -i -e 's/127.0.0.1/0.0.0.0/g' /etc/mysql/mariadb.conf.d/50-server.cnf

# Iniciar o serviço MariaDB
service mariadb start
sleep 1

# Esperar até que o MariaDB esteja pronto
until mariadb -u root -e ""; do
    sleep 1
done

# Configuração inicial do banco de dados
mariadb -u root << EOF
CREATE DATABASE IF NOT EXISTS $MYSQL_DATABASE;
        CREATE USER IF NOT EXISTS '$MYSQL_USER'@'%' IDENTIFIED BY '$MYSQL_PASSWORD';
        GRANT ALL PRIVILEGES ON $MYSQL_DATABASE.* TO '$MYSQL_USER'@'%';
        ALTER USER 'root'@'localhost' IDENTIFIED BY '$MYSQL_ROOT_PASSWORD';
        FLUSH PRIVILEGES;
EOF

# Parar o serviço MariaDB
service mariadb stop

# Executar o comando passado ao script
exec "$@"



        