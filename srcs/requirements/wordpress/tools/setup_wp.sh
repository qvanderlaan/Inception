#!/bin/bash
set -e

# Read secrets if available, fall back to environment variables
if [ -f "/run/secrets/db_password" ]; then
    MYSQL_PASSWORD=$(cat /run/secrets/db_password)
fi

if [ -f "/run/secrets/wp_admin_password" ]; then
    WP_ADMIN_PASSWORD=$(cat /run/secrets/wp_admin_password)
fi

if [ -f "/run/secrets/wp_user_password" ]; then
    WP_PASSWORD=$(cat /run/secrets/wp_user_password)
fi

# Wait until MariaDB is reay to accept connections
until mariadb -h mariadb -u "${MYSQL_USER}" -p"${MYSQL_PASSWORD}" -e "SHOW DATABASES;" > /dev/null 2>&1; do
    sleep 2
done
echo "Connected to MariaDB."

# Configure WordPress if wp-config.php doesn't exist
if [ ! -f "/var/www/html/wp-config.php" ]; then
    echo "Downloading WordPress..."
    wp core download --allow-root --force

    echo "Creating wp-config.php..."
    wp config create \
        --dbname="${MYSQL_DATABASE}" \
        --dbuser="${MYSQL_USER}" \
        --dbpass="${MYSQL_PASSWORD}" \
        --dbhost="mariadb:3306" \
        --allow-root

    echo "Installing WordPress..."
    wp core install \
        --url="https://${DOMAIN_NAME}" \
        --title="${WP_TITLE}" \
        --admin_user="${WP_ADMIN_USER}" \
        --admin_password="${WP_ADMIN_PASSWORD}" \
        --admin_email="${WP_ADMIN_EMAIL}" \
        --allow-root

    echo "Creating regular user..."
    wp user create "${WP_USER}" "${WP_USER_EMAIL}" \
        --role=author \
        --user_pass="${WP_PASSWORD}" \
        --allow-root

    chown -R www-data:www-data /var/www/html
    echo "WordPress setup complete."
fi

# Run php-fpm in foreground (-F)
echo "Starting PHP-FPM..."
exec php-fpm8.2 -F
