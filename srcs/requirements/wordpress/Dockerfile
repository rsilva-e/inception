FROM debian:oldstable

EXPOSE 9000

RUN apt-get update && apt-get install -y \
    php-fpm \
    wget \
    php-mysqli \
    default-mysql-client \ 
    curl

COPY tools/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["sh", "entrypoint.sh"]
