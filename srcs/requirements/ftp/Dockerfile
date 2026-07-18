FROM debian:bookworm

RUN apt-get update -y
RUN apt-get install vsftpd -y

RUN sed -i "s|#write_enable=YES|write_enable=YES|" /etc/vsftpd.conf
RUN sed -i "s|listen=NO|listen=YES|" /etc/vsftpd.conf

# FOR TESTING ONLY !! TO REMOVE !!
RUN sed -i "s|anonymous_enable=NO|anonymous_enable=YES|" /etc/vsftpd.conf

RUN echo "local_root=/var/www/html" >> /etc/vsftpd.conf
RUN echo "background=NO" >> /etc/vsftpd.conf


CMD ["ftp"]

EXPOSE 20 21