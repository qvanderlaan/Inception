*This project has been created as part of the 42 curriculum by qvan-der*

# Inception

## Description
Inception is a 42 system administration project focussed on Docker and containerized infrastructure.

The goal of this project is to build a small web infrastructure from scratch using Docker Compose. The stack is composed of three dedicated services:
- **NGINX** — The only public entry point. It listens on port `443` and provides HTTPS using TLS 1.2/1.3.
- **WordPress + PHP-FPM** — serves the WordPress application and executes PHP trough PHP-FPM.
- **MariaDB** — stores the WordPress database.

The services communicate trough a dedicated Docker network named `inception`. Wordpress website files and MariaDB data are persisted trough Docker named volumes.

## Technical Choices

Each major service runs in its own container:
- `nginx`
- `wordpress`
- `mariadb`

Docker Compose defines how these services are built, connected, restarted, and provided with persistent storage.

### NGINX

NGINX is the only service exposed to the host. Port `443` is mapped to the container's port `443`.

TLS is configured with:
```nginx
ssl_protocols TLSv1.2 TLSv1.3;
```

NGINX serves the WordPRess files and forwards PHP requests to:
```text
wordpress:9000
```

The SSL certificate is generated during the NGINX image build with OpenSSL.

### WordPress and PHP-FPM

The WordPress container installs:

- PHP 8.2-FPM
- PHP MySQL support
- MariaDB client
- WP-CLI
- curl

The setup script waits until MariaDB accepts connections, downloads WordPress if it has not already been initialized, creates `wp-config.php`, installs WordPress, and creates a regular author account.

PHP-FPM listens on:

```text
0.0.0.0:9000
```

It is not directly exposed to the host.

### MariaDB

MariaDB is initialized by `setup_db.sh`.

On first initialization, the script:

1. Initializes the MariaDB data directory.
2. Starts a temporary server with networking disabled.
3. Sets the root password.
4. Creates the application database.
5. Creates the WordPress database user.
6. Grants that user privileges on the application database.
7. Stops the temporary server.
8. Starts MariaDB normally.

MariaDB listens on port `3306` inside the Docker network.

## Volumes and Persistence

Two Docker named volumes are used:

- `mariadb_data` → `/var/lib/mysql`
- `wordpress_data` → `/var/www/html`

The Compose configuration maps these named volumes to host directories:

```text
/home/qvan-der/data/mariadb
/home/qvan-der/data/wordpress
```

This allows the database and WordPress files to survive container recreation.


## Docker Network vs Host Network

This project uses a dedicated Docker bridge network named `inception`.

### Docker Network

A Docker network provides isolated communication between the containers. Services can reach one another using their Compose service names, such as:

```text
mariadb
wordpress
```

For example, WordPress connects to MariaDB using:

```text
mariadb:3306
```

Only NGINX needs to be reachable from outside the Docker network.

### Host Network

With host networking, a container shares the host's network namespace. This reduces network isolation and can create port-management conflicts.

The project therefore uses an explicit Docker network instead of host networking.


## Docker Volumes vs Bind Mounts

### Docker Volume

A Docker volume is managed by Docker and can persist data independently from the lifecycle of a container.

This project uses named volumes:

```text
mariadb_data
wordpress_data
```

### Bind Mount

A bind mount directly maps a host filesystem path into a container.

In this project, the named volumes are configured with local driver options that point to:

```text
/home/qvan-der/data/mariadb
/home/qvan-der/data/wordpress
```

This gives the project persistent host-backed storage while the Compose services still refer to the storage as named volumes.


## Virtual Machines vs Docker

### Virtual Machine

A virtual machine emulates or virtualizes an entire computer environment, including its own operating system kernel. This provides strong isolation but generally requires more resources.

### Docker

Docker containers share the host kernel while isolating applications and their filesystems, processes, and networking. Containers are usually lighter and faster to start than full virtual machines.

Inception uses Docker because the objective is to package each service separately and connect the services through a controlled container network.

## Secrets vs Environment Variables

### Environment Variables

Environment variables are convenient for configuration such as:

- database names
- usernames
- domain names
- WordPress configuration values

This project loads configuration from `srcs/.env`.

Sensitive values should not be committed to a public Git repository.

### Docker Secrets

Docker secrets are intended for sensitive information such as passwords. They avoid putting credentials directly into ordinary environment variables or configuration files.

For a production system, secrets are preferable for confidential credentials.

## Instructions

### Prerequisites

You need:

- A Linux virtual machine suitable for the 42 project.
- Docker.
- Docker Compose.
- GNU Make.
- A domain entry for `qvan-der.42.fr` pointing to the VM's local IP address.

The project expects its persistent data directories under:

```text
/home/qvan-der/data/
```

### Start the project

From the repository root:

```bash
make
```

or:

```bash
make up
```

This creates the data directories and builds/starts the Docker Compose stack in detached mode.

### Build the project

```bash
make build
```

### Stop the containers

```bash
make stop
```

### Start stopped containers

```bash
make start
```

### Stop and remove the Compose stack

```bash
make down
```


## Accessing the Website

The configured domain is:

```text
https://qvan-der.42.fr
```

The NGINX container is the only service exposed to the host, through port `443`.

Because the project uses a self-signed certificate generated during the NGINX image build, a browser may display a certificate warning.

The WordPress administration panel is available at:

```text
https://qvan-der.42.fr/wp-admin
```

The administrator credentials are configured through the project's environment configuration. Do not publish passwords or other credentials in Git.


## Resources

Useful references for understanding the technologies used in this project include:

- Docker documentation: https://docs.docker.com/
- Docker Compose documentation: https://docs.docker.com/compose/
- Debian documentation: https://www.debian.org/doc/
- NGINX documentation: https://nginx.org/en/docs/
- MariaDB documentation: https://mariadb.com/docs/
- PHP-FPM documentation: https://www.php.net/manual/en/install.fpm.php
- WordPress documentation: https://developer.wordpress.org/
- WP-CLI documentation: https://make.wordpress.org/cli/handbook/

### Use of Artificial Intelligence

AI was used as a supporting tool throughout the project to review my work and help me verify my understanding of the subject. I asked questions to clarify concepts and make sure I understood the material correctly.
