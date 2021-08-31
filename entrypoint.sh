#!/bin/bash
echo "Generating $1"
cat /usr/local/etc/php/php.ini-production

wp i18n make-pot . $1
