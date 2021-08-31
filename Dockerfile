FROM wordpress:cli-2

USER root 
RUN sed -i  -e 's/memory_limit = 128M/memory_limit = 512M/' /usr/local/etc/php/php.ini-production
USER www-data

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
