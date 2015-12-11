#!/bin/bash
ocpath='/var/www/owncloud'
apacheuser='www-data'
apachegroup='www-data'
adminuser='root'

find ${ocpath}/ -type f -print0 | xargs -0 chmod 0640
find ${ocpath}/ -type d -print0 | xargs -0 chmod 0750

chown -R ${adminuser}:${apachegroup} ${ocpath}/
chown -R ${apacheuser}:${apachegroup} ${ocpath}/apps/
chown -R ${apacheuser}:${apachegroup} ${ocpath}/config/
chown -R ${apacheuser}:${apachegroup} ${ocpath}/data/ || true
chown -R ${apacheuser}:${apachegroup} ${ocpath}/themes/

chown ${adminuser}:${apachegroup} ${ocpath}/.htaccess
chown ${adminuser}:${apachegroup} ${ocpath}/data/.htaccess || true

chmod 0644 ${ocpath}/.htaccess
chmod 0644 ${ocpath}/data/.htaccess || true
