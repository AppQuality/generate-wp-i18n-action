FROM wordpress:cli-2

USER root
RUN adduser --disabled-password  -u 1000 user
RUN chown -R user .
RUN chmod -R 755 .
RUN apk add gettext
USER user

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
