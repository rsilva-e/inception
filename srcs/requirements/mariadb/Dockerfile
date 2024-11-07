FROM debian:oldstable

EXPOSE 3306

# Instalar o MariaDB
RUN apt-get update && \
    apt-get install -y mariadb-server && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Script para configuração inicial do banco
COPY tools/docker-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-entrypoint.sh
ENTRYPOINT ["docker-entrypoint.sh"]

CMD ["mysqld_safe"]