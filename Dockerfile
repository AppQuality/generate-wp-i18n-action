FROM wordpress:cli-2

USER root
RUN adduser --disabled-password  -u 1000 -g user user
RUN chown -R user:user .
RUN chmod -R g+rw .
RUN apk add gettext
USER user

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
