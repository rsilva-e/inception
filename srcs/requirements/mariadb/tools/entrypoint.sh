
#!/bin/bash
set -e

# Modify the configuration to accept external connections
sed -i -e 's/127.0.0.1/0.0.0.0/g' /etc/mysql/mariadb.conf.d/50-server.cnf

# Start Service MariaDB
service mariadb start
sleep 1

(
    if [ -f /run/secrets/secrets_inception ]; then
        DB_PWD=$(grep 'db_pass=' /run/secrets/secrets_inception | cut -d '=' -f2)
        DB_ROOT_PWD=$(grep 'db_root_pass=' /run/secrets/secrets_inception | cut -d '=' -f2)
    else
        echo "Error : Secrets not found"
        exit 1
    fi

# Initial database configuration
mariadb -u root << EOF
CREATE DATABASE IF NOT EXISTS $DB_NAME;
CREATE USER IF NOT EXISTS '$DB_USER'@'%' IDENTIFIED BY '$DB_PWD';
GRANT ALL PRIVILEGES ON $DB_NAME.* TO '$DB_USER'@'%' IDENTIFIED BY '$DB_PWD';
GRANT ALL PRIVILEGES ON $DB_NAME.* TO 'root'@'%' IDENTIFIED BY '$DB_ROOT_PWD' WITH GRANT OPTION;
ALTER USER 'root'@'%' IDENTIFIED BY '$DB_ROOT_PWD';
FLUSH PRIVILEGES;
EOF


)

# Parar o serviço MariaDB
service mariadb stop

# Executar o comando passado ao script
exec "$@"
