FROM debian:bookworm

RUN apt-get update -y

RUN apt-get install -y \
	nginx
	
COPY ./conf/nginx.conf /etc/nginx/conf.d
	
RUN mkdir -p /var/www/static-site

COPY ./ressources/* /var/www/static-site/

RUN mkdir -p /run/nginx

EXPOSE 80

CMD ["nginx", "-g", "daemon off ;"]