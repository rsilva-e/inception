
FROM debian:oldstable

EXPOSE 3306


# Instalar o MariaDB
RUN apt-get update && \
    apt-get install -y mariadb-server && \
    apt-get clean && rm -rf /var/lib/apt/lists/*


## Configurar o MariaDB para rodar como serviço no container
RUN mkdir -p /run/mysqld && chown -R mysql:mysql /run/mysqld



# Script para configuração inicial do banco
COPY tools/docker-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-entrypoint.sh
ENTRYPOINT ["docker-entrypoint.sh"]


# Comando padrão para iniciar o MariaDB
#CMD ["mysqld"]



CMD ["mysqld_safe"]