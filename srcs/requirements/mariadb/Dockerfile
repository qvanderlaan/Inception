FROM debian:bookworm

# Update Apt packages and install mariadb-server and delete temporary downloaded packages
RUN apt-get update -y \
	&& apt-get install -y mariadb-server \
	&& rm -rf /var/lib/apt/lists

# Create directories
RUN mkdir -p /var/run/mysqld \
	&& mkdir -p /var/log/mysql \
	&& chown -R mysql:mysql /var/log/mysql \
	&& chown -R mysql:mysql /var/run/mysqld \
	&& chmod 750 /var/log/mysql \
	&& chmod 755 /var/run/mysqld

# Replace the 50-server.cnf with the default one
COPY conf/50-server.cnf /etc/mysql/mariadb.conf.d/50-server.cnf

# Copy the setup_db.sh to the usr bin, and allow it to be executed
COPY tools/setup_db.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/setup_db.sh

# Configure the container to run as an executable
ENTRYPOINT [ "/usr/local/bin/setup_db.sh" ]
