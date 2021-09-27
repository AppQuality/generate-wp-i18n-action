FROM wordpress:cli-2

USER root
RUN mkdir -p /user
RUN adduser --disabled-password  -u 1000 user
RUN chown user /user
RUN apk add gettext
USER user
WORKDIR /user

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
