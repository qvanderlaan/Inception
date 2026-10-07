# User Documentation

## Overview
This project provides a small WordPress website infrastructure running trough Docker.

The stack containsthree services:
| Service | Purpose |
| --- | --- |
| NGINX | HTTPS entry point and reverse proxy |
| WordPress | Website application and PHP-FPM |
| MariaDB | WordPress database |

The services communicate trough the Docker network named `inception`.

## Starting the repository root:

```bash
make
```

This build the Docker images and starts the services in detached mode.

You can also use:

```bash
make up
```

## Stopping the Project:

To stop the containers without removing them:
```bash
make stop
```

To stop and remove the Compose stack:
```bash
make down
```

To start previously stopped containers again:
```bash
make start
```

## Accessing te Website

Open:

```text
https://qvan-der.42.fr
```

The website is served trough NGINX over HTTPS on port `443`.

The project uses a self-signed certificate, so your browser may display a certificate/security warning. This is expected for the local development setup.

## Accessing WordPress Administration

The WordPress administration panel is available at:

```text
https://qvan-der.42.fr/wp-admin
```

Use the administrator credentials configured for the project.

## Credentials

Configuration values are loaded trough:

```text
srcs/.env
```

The WordPress setup uses variables for the database connection and WordPress administrator/user configuration.

Credentials should be kept private and should not be committed to Git.

## Checking that the services are running

Run:
```bash
make status
```

This displays the currently running Docker containers.

You should see the project containers, including:

```text
nginx
wordpress
mariadb
```

For all containers, including stopped ones:

```bash
make status-a
```

## Checking Logs

To view the logs from the Compose services:

```bash
make logs
```

You can also inspect an individual container directly:

```bash
docker logs nginx
docker logs wordpress
docker logs mariadb
```

## persistent Data

The project stores persistent data in:

```text
/home/qvan-der/data/mariadb
/home/qvan-der/data/wordpress
```

The first directory contians MariaDB data.

The second directory contains the Wordpress website files.

These directories allow the data to persist when containers are recreated.

## Restarting the project

The containers are configured with:

```yaml
restart: always
```

This means Docker is configured to restart them automatically when they stop unexpectedly.

To manually restart the stack, you can use:

```bash
make down
make up
```
