FROM debian:bookworm

RUN apt-get update -y

RUN apt-get install -y \
	nginx \
	openssl

RUN	mkdir -p /etc/nginx/ssl && \
	openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
  	-keyout /etc/nginx/ssl/nginx.key \
 	-out /etc/nginx/ssl/nginx.crt \
	-subj "/C=FR/ST=Paris/L=Nice/O=42/CN=vanfossi.42.fr"

COPY ./conf/nginx.conf /etc/nginx/conf.d

RUN mkdir -p /run/nginx

EXPOSE 443

CMD ["nginx", "-g", "daemon off ;"]