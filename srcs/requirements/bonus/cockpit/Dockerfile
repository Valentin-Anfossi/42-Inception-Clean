FROM debian:bookworm

RUN apt-get update -y && apt-get install -y cockpit

COPY ./tools/cockpit_run.sh /usr/local/bin/cockpit_run.sh
RUN chmod +x /usr/local/bin/cockpit_run.sh

ENTRYPOINT ["./usr/local/bin/cockpit_run.sh"]

CMD ["/usr/lib/cockpit/cockpit-ws", "--no-tls"]

EXPOSE 9090