FROM redis:6.0.8-alpine

LABEL maintainer="Mohamed Laradji <mlaradji@protonmail.ch>"

RUN apk --no-cache add drill

COPY entrypoint.sh /usr/local/bin/

RUN chmod +x /usr/local/bin/entrypoint.sh

ENTRYPOINT ["entrypoint.sh"]
