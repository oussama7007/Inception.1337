#!/bin/bash

mkdir -p /run/php

if [ ! -f /var/www/html/wordpress/wp-config.php ]; then
    echo "Downloading WordPress..."
    wp core download --allow-root
    
    echo "Creating wp-config.php..."
    wp config create --allow-root \
        --dbname=$DB_NAME \
        --dbuser=$DB_USER \
        --dbpass=$DB_PASSWORD \
        --dbhost=mariadb:3306

    echo "Installing WordPress..."
    wp core install --allow-root \
        --url=$DOMAIN_NAME \
        --title="My Inception Site" \
        --admin_user=$WP_ADMIN_USER \
        --admin_password=$WP_ADMIN_PASSWORD \
        --admin_email=$WP_ADMIN_EMAIL

    echo "Creating a second regular user..."
    wp user create --allow-root \
        $WP_USER $WP_USER_EMAIL \
        --user_pass=$WP_USER_PASSWORD \
        --role=author
fi

exec "$@"
