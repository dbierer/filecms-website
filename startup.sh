#!/bin/bash
echo "Finishing Apache setup ..."
mv -f /srv/www /srv/www.OLD
ln -sfv /repo/public /srv/www
chown apache:apache /srv/www
chgrp -R apache /repo
chmod -R 775 /repo
/etc/init.d/phpfpm start
/etc/init.d/httpd start
lfphp --mysql --phpfpm --apache >/dev/null 2&>1
