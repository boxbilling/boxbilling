#!/bin/bash
cd "$(dirname "$0")"

#heroku run sh bin/heroku.sh --app <appname>
wget https://github.com/boxbilling/boxbilling/releases/latest/download/BoxBilling.zip
unzip Boxbilling.zip -d boxbilling
cp -r ../src/bb-config-heroku.php ../boxbilling/bb-config.php
cp -r ../boxbilling/htaccess.txt ../boxbilling/.htaccess
rm -rf ../boxbilling/install
rm -rf ../boxbilling/htaccess.txt
rm -rf ../boxbilling/bb-config-sample.php
rm -rf BoxBilling.zip