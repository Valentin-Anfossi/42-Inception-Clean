FROM debian:bookworm

RUN apt-get update -y
RUN apt-get install lsb-release curl gpg -y

RUN curl -fsSL https://packages.redis.io/gpg | gpg --dearmor -o /usr/share/keyrings/redis-archive-keyring.gpg
RUN chmod 644 /usr/share/keyrings/redis-archive-keyring.gpg

RUN echo "deb [signed-by=/usr/share/keyrings/redis-archive-keyring.gpg] https://packages.redis.io/deb $(lsb_release -cs) main" | tee /etc/apt/sources.list.d/redis.list

RUN apt-get update
RUN apt-get install redis -y

COPY ./conf/redis.conf /etc/redis/

CMD ["redis-server", "/etc/redis/redis.conf"]

EXPOSE 6379