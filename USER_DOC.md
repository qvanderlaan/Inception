# User Documentation

## Overview
This project provides a small WordPress website infrastructure running through Docker.

The stack contains three services:
| Service | Purpose |
| --- | --- |
| NGINX | HTTPS entry point and reverse proxy |
| WordPress | Website application and PHP-FPM |
| MariaDB | WordPress database |

The services communicate through the Docker network named `inception`.

## Starting the Project
From the repository root:

```bash
make
```

This builds the Docker images and starts the services in detached mode.

You can also use:

```bash
make up
```

## Stopping the Project

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

## Accessing the Website

Open your browser to:

```text
https://qvan-der.42.fr
```

The website is served through NGINX over HTTPS on port `443`.

The project uses a self-signed certificate, so your browser may display a certificate/security warning. This is expected for local development.

## Accessing WordPress Administration

The WordPress administration panel is available at:

```text
https://qvan-der.42.fr/wp-admin
```

Use the administrator credentials configured for the project.

## Credentials

Configuration values are loaded through:

```text
srcs/.env
```

And sensitive passwords through Docker secrets in:

```text
secrets/
```

Credentials must be kept private and must never be committed to Git.

## Checking that the Services are Running

Run:
```bash
make status
```

This displays the currently running Docker containers:
- `nginx`
- `wordpress`
- `mariadb`

To list all containers, including stopped ones:

```bash
make status-a
```

## Checking Logs

To view the live logs from all services:

```bash
make logs
```

Or inspect an individual container:

```bash
docker logs nginx
docker logs wordpress
docker logs mariadb
```

## Persistent Data

The project stores persistent data in:

```text
/home/qvan-der/data/mariadb
/home/qvan-der/data/wordpress
```

The first directory contains the MariaDB database files.
The second directory contains the WordPress website files.

These directories allow the data to persist when containers are recreated.

## Restart Policy

The containers are configured with:

```yaml
restart: always
```

Docker will automatically restart them if they stop unexpectedly or crash.
