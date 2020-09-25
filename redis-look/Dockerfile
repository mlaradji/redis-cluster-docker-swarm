FROM redis:6.0.8-alpine

LABEL maintainer="Mohamed Laradji <mlaradji@protonmail.ch>"

ENV REDIS_SENTINEL_IP redis-sentinel
ENV REDIS_MASTER_NAME redismaster
ENV REDIS_SENTINEL_PORT 26379

COPY entrypoint.sh /usr/local/bin/

RUN chmod +x /usr/local/bin/entrypoint.sh

WORKDIR /redis
COPY redis.conf .

EXPOSE 6379

ENTRYPOINT ["entrypoint.sh"]
