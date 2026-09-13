FROM debian:trixie

# Update Apt packages and install mariadb-server
RUN apt-get update -y && \
	apt-get install -y mariadb-server

# Delete the temporary downloaded packages
RUN rm -rf /var/lib/apt/lists

# Allow MariaDB to accept connections from other containers
RUN sed -i 's/bind-address\s*=\s*127.0.0.1/bind-address = 0.0.0.0/' /etc/mysql/mariadb.conf.d/50-server.cnf

# Copy the script.sh to the usr bin, and allow it to be executed
COPY tools/script.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/script.sh

# Configure the container to run as an executable
ENTRYPOINT [ "/usr/local/bin/script.sh" ]
