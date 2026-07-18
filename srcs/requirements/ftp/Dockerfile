FROM debian:bookworm

RUN apt-get update -y
RUN apt-get install vsftpd -y

RUN mkdir -p /var/run/vsftpd/empty

RUN sed -i "s|#write_enable=YES|write_enable=YES|" /etc/vsftpd.conf
RUN sed -i "s|#local_enable=YES|local_enable=YES|" /etc/vsftpd.conf
# RUN sed -i "s|listen=NO|listen=YES|" /etc/vsftpd.conf

# RUN sed -i "s|listen_ipv6=YES|listen_ipv6=NO|" /etc/vsftpd.conf

# FOR TESTING ONLY !! TO REMOVE !!
RUN sed -i "s|anonymous_enable=NO|anonymous_enable=YES|" /etc/vsftpd.conf

RUN echo "local_root=/var/www/html" >> /etc/vsftpd.conf
RUN echo "allow_writeable_chroot=YES" >> /etc/vsftpd.conf
RUN echo "background=NO" >> /etc/vsftpd.conf

COPY ./tools/ftp_run.sh /usr/local/bin/ftp_run.sh
RUN chmod +x "/usr/local/bin/ftp_run.sh"

ENTRYPOINT ["/usr/local/bin/ftp_run.sh"]

CMD ["vsftpd", "/etc/vsftpd.conf"]

EXPOSE 20 21