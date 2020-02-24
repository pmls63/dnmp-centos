#!/bin/sh
set -e

/usr/bin/supervisord -c /etc/supervisord.conf
/usr/local/php/sbin/php-fpm --nodaemonize -R

