
FROM debian:oldstable

EXPOSE 443

RUN apt-get update && apt-get install -y nginx ssl-cert

RUN	make-ssl-cert generate-default-snakeoil

COPY conf/nginx.conf /etc/nginx/sites-enabled/



CMD ["nginx", "-g", "daemon off;"]