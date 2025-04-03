
#!/bin/bash
set -e

# Modificar a configuração para aceitar conexões externas
sed -i -e 's/127.0.0.1/0.0.0.0/g' /etc/mysql/mariadb.conf.d/50-server.cnf

# Iniciar o serviço MariaDB
service mariadb start
sleep 1

(
    if [ -f /run/secrets/secrets_inception ]; then
        WP_DB_NAME = $(grep 'db_name=' /run/secrets/secrets.txt | cut -d '=' -f2)
        WP_DB_USER = $(grep 'db_user=' /run/secrets/secrets.txt | cut -d '=' -f2)
        WP_DB_PWD = $(grep 'db_pass=' /run/secrets/secrets.txt | cut -d '=' -f2)
        DB_ROOT_PWD = $(grep 'db_root_pwd=' /run/secrets/secrets.txt | cut -d '=' -f2)
    else
        echo "Error : Secrets not found"
        exit 1
    fi

# Configuração inicial do banco de dados
mariadb -u root << EOF
CREATE DATABASE IF NOT EXISTS $WP_DB_NAME;
CREATE USER IF NOT EXISTS '$WP_DB_USER'@'%' IDENTIFIED BY '$WP_DB_PWD';
GRANT ALL PRIVILEGES ON $WP_DB_NAME.* TO '$WP_DB_USER'@'%' IDENTIFIED BY '$WP_DB_PWD';
GRANT ALL PRIVILEGES ON $WP_DB_NAME.* TO 'root'@'%' IDENTIFIED BY '$DB_ROOT_PWD' WITH GRANT OPTION;
ALTER USER 'root'@'%' IDENTIFIED BY '$DB_ROOT_PWD';
FLUSH PRIVILEGES;
EOF

)

# Parar o serviço MariaDB
service mariadb stop

# Executar o comando passado ao script
exec "$@"
