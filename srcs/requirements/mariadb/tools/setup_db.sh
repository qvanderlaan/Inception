#!/bin/bash

# Exit the script if a command returns non-zero exit status.
set -e

# Initialize MySQL data directory if it doesn't exist
if [ ! -d "/var/lib/mysql/${MYSQL_DTABASE}" ]; then
	echo "Database directory not found. Initializing MariaDB..."

	mysql_install_db --user=mysql --datadir=/var/lib/mysql > /dev/null

	# Start the server (no networking)
	echo "Starting temporary MariaDB server for setup..."
	mysqld --skip-networking --socket=/var/run/mysqld/mysqld.sock --user=mysql &
	pid="$!"

	# Wait for MariaDB to be ready
	echo "Waiting for MariaDB to be ready..."
	until mysqladmin --socket=/var/run/mysqld/mysqld.sock ping >/dev/null 2>&1; do
		sleep 1
	done

	# Run setup SQL to create database and users
	echo "Running setup SQL..."
	mysql --socket=/var/run/mysqld/mysqld.sock -u root << EOF
ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';
CREATE DATABASE IF NOT EXISTS ${MYSQL_DATABASE};
CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE}.* TO '${MYSQL_USER}'@'%';
FLUSH PRIVILEGES;
EOF

	# Shut down temporary server
	echo "Shutting down temporary MariaDB..."
	mariadb-admin --socket=/var/run/mysqld/mysqld.sock -u root -p"${MYSQL_ROOT_PASSWORD}" shutdown

	# Wait for shutdown
	wait "$pid" || true

	echo "Database initialized successfully."
fi

# Start MariaDB normally (with networking)
echo "Starting MariaDB..."
exec mysqld --user=mysql --datadir=/var/lib/mysql --socket=/run/mysqld/mysqld.sock
