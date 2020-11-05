#!/bin/bash
cd "$(dirname "$0")"

#heroku run sh bin/heroku.sh --app <appname>

cp -r ../src/bb-config-heroku.php ../src/bb-config.php
php prepare.php
cp -r ../src/htaccess.txt ../src/.htaccess
rm -rf ../src/install
rm -rf ../src/htaccess.txt
rm -rf ../src/bb-config-heroku.php
rm -rf ../src/bb-config-sample.php