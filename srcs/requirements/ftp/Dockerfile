FROM debian:bookworm

RUN apt-get update -y
RUN apt-get install -y \
	vsftpd \
	openssl

RUN mkdir -p /var/run/vsftpd/empty

RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
	-keyout /etc/vsftpd.key \
	-out /etc/vsftpd.crt \
	-subj "/C=FR/ST=Paris/L=Nice/O=42/CN=vanfossi.42.fr"

RUN cp /etc/vsftpd.conf /etc/vstfpd.conf.bak

RUN sed -i "s|rsa_cert_file=/etc/ssl/certs/ssl-cert-snakeoil.pem|rsa_cert_file=/etc/vsftpd.crt|" /etc/vsftpd.conf
RUN sed -i "s|rsa_private_key_file=/etc/ssl/private/ssl-cert-snakeoil.key|rsa_private_key_file=/etc/vsftpd.key|" /etc/vsftpd.conf
RUN sed -i "s|ssl_enable=NO|ssl_enable=yes|" /etc/vsftpd.conf
RUN sed -i "s|#write_enable=YES|write_enable=YES|" /etc/vsftpd.conf
RUN sed -i "s|#local_enable=YES|local_enable=YES|" /etc/vsftpd.conf

RUN echo "local_root=/var/www/html" >> /etc/vsftpd.conf
RUN echo "allow_writeable_chroot=YES" >> /etc/vsftpd.conf
# RUN echo "background=NO" >> /etc/vsftpd.conf

COPY ./tools/ftp_run.sh /usr/local/bin/ftp_run.sh
RUN chmod +x "/usr/local/bin/ftp_run.sh"

ENTRYPOINT ["/usr/local/bin/ftp_run.sh"]

CMD ["./usr/sbin/vsftpd", "/etc/vsftpd.conf"]

EXPOSE 20 21