
FROM debian:oldstable

RUN apt-get update && apt-get install -y nginx

COPY conf/nginx.conf /etc/nginx/sites-enable/

EXPOSE 443

CMD ["nginx", "-g", "daemon off;"]