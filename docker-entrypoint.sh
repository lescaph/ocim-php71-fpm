#!/bin/bash
set -e

# SSMTP
sed -i "s/root=.*/root=$SSMTP_ROOT_MAIL/" /etc/ssmtp/ssmtp.conf    
sed -i "s/mailhub=.*/mailhub=$SSMTP_SMTP_HOST/" /etc/ssmtp/ssmtp.conf
sed -i "s/#rewriteDomain=.*/rewriteDomain=$SSMTP_REWRITEDOMAIN/" /etc/ssmtp/ssmtp.conf
sed -i "s/hostname=.*/hostname=$SSMTP_HOSTNAME/" /etc/ssmtp/ssmtp.conf
sed -i "s/#FromLineOverride=.*/FromLineOverride=YES/" /etc/ssmtp/ssmtp.conf
sed -i "$ a root:$SSMTP_ROOT_MAIL:$SSMTP_SMTP_HOST" /etc/ssmtp/revaliases
sed -i "$ a www-data:$SSMTP_ROOT_MAIL:$SSMTP_SMTP_HOST" /etc/ssmtp/revaliases

# PHP
XDEBUG_INI=/etc/php/7.1/fpm/conf.d/20-xdebug.ini
if [[ $ENABLE_XDEBUG ]]; then
    echo "zend_extension=$(find /usr/lib/php/ -name xdebug.so)" > $XDEBUG_INI
else
    [[ -f $XDEBUG_INI ]] && rm -f $XDEBUG_INI
fi

exec "$@"
