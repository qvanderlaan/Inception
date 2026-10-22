FROM debian:bookworm

# Install PHP-FPM, PHP extensions, etc...
RUN apt-get update -y && apt-get install -y \
    php8.2-fpm \
    php8.2-mysql \
    mariadb-client \
    curl \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Install WP-CLI
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
    && chmod +x wp-cli.phar \
    && mv wp-cli.phar /usr/local/bin/wp

# Create directory for php-fpm socker/PID and web root
RUN mkdir -p /run/php /var/www/html \
    && chown -R www-data:www-data /var/www/html

# Copy pool configuration
COPY conf/www.conf /etc/php/8.2/fpm/pool.d/www.conf

# Copy setup script
COPY tools/setup_wp.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/setup_wp.sh

WORKDIR /var/www/html

ENTRYPOINT [ "/usr/local/bin/setup_wp.sh" ]
