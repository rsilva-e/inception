FROM debian:oldstable

EXPOSE 3306

# Installl MariaDB
RUN apt-get update && \
    apt-get install -y mariadb-server && \
    apt-get clean && rm -rf /var/lib/apt/lists/*


RUN rm /etc/mysql/mariadb.conf.d/50-server.cnf 
COPY tools/50-server.cnf /etc/mysql/mariadb.conf.d/50-server.cnf 

# Script para configuração inicial do banco
COPY tools/entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]

CMD ["mysqld_safe"]