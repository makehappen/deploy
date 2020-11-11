#!/bin/sh

# call this script
# SERVER_IP=123.45.679.90 && SITE=www.example.com && BRANCH=master

# set ssh
SSH="ssh ubuntu@$SERVER_IP"

# load config
. sites/config/$SITE.sh

# environment path
WWW_PATH="/var/www"

# create site folder
$SSH "[ $SITE ] && [ ! -d \"/var/www/$SITE\" ] && mkdir -p \"/var/www/$SITE\";"

# clone sites repos
$SSH "[ $SITE ] && [ ! -d \"/var/www/$SITE/.git\" ] && cd /var/www/$SITE && git clone $REPO .;"

# checkout branches
$SSH "[ $SITE ] && cd /var/www/$SITE && git fetch && git checkout \"$BRANCH\" && git pull && git remote prune origin;"

# env
[ sites/env/$SITE.env ] && scp sites/env/$SITE.env ubuntu@$SERVER_IP:/var/www/$SITE/.env

# install via file
$SSH "[ $SITE ] && cd /var/www/$SITE && [ -f install.sh ] && . install.sh;"

# install via composer
$SSH "[ $SITE ] && cd /var/www/$SITE && [ ! -f install.sh ] && [ -f composer.json ] && composer install --no-dev --no-interaction --prefer-dist --optimize-autoloader;"

# permissions
$SSH "[ $SITE ] && [ -f /var/www/$SITE/bootstrap/cache ] && sudo chown -R ubuntu:www-data /var/www/$SITE/bootstrap/cache;"
$SSH "[ $SITE ] && [ -f /var/www/$SITE/bootstrap/cache ] && sudo chmod -R 775 /var/www/$SITE/bootstrap/cache;"

$SSH "[ $SITE ] && [ -f /var/www/$SITE/storage ] && sudo chown -R ubuntu:www-data /var/www/$SITE/storage;"
$SSH "[ $SITE ] && [ -f /var/www/$SITE/storage ] && sudo chmod -R 775 /var/www/$SITE/storage;"

$SSH "[ $SITE ] && [ -f /var/www/$SITE/env ] && sudo chown -R ubuntu:www-data /var/www/$SITE/env;"
$SSH "[ $SITE ] && [ -f /var/www/$SITE/env ] && sudo chmod -R 775 /var/www/$SITE/env;"

# restart fpm
$SSH "[ $SITE ] && cd /var/www/$SITE && [ ! -f install.sh ] && ( flock -w 10 9 || exit 1 echo 'Restarting FPM...'; sudo -S service php7.4-fpm reload ) 9>/tmp/fpmlock;"

# migrations
$SSH "[ $SITE ] && cd /var/www/$SITE && [ ! -f install.sh ] && [ -f artisan ] && php artisan migrate --force;"
