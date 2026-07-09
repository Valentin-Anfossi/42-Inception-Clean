FROM debian:bookworm

RUN apt-get update && apt-get upgrade && apt-get install -y \
    mariadb-server \ 
    mariadb-client

COPY ./conf/50-server.cnf	/etc/mysql/mariadb.conf.d/50-server.cnf
COPY ./tools/mariadb_run.sh /usr/local/bin/mariadb_run.sh

RUN chmod +x /usr/local/bin/mariadb_run.sh

ENTRYPOINT [ "/usr/local/bin/mariadb_run.sh" ]