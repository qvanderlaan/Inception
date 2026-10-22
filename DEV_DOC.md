# Developer Documentation

## 1. Environment Setup from Scratch

### Prerequisites
Ensure the host machine (VM) has the following installed:
- A Linux distribution (e.g., Debian/Ubuntu)
- Docker Engine (`docker --version`)
- Docker Compose plugin (`docker compose version`)
- GNU Make (`make --version`)

### Host DNS Configuration
Add the custom domain name to your host's `/etc/hosts` file:
```bash
sudo echo "127.0.0.1 qvan-der.42.fr" >> /etc/hosts
```

### Configuration Files & Secrets
Before launching the project, the following files and directories must be created:

1. **Environment File (`srcs/.env`):**
```env
DOMAIN_NAME=qvan-der.42.fr

# --- MySQL ---
MYSQL_DATABASE=xxxxxxxxxxx
MYSQL_USER=xxxxxxxxxxx

# --- Wordpress ---
WP_TITLE=Inception
WP_ADMIN_USER=xxxxxxxxxxx
WP_ADMIN_EMAIL=xxxxxxxxxxx
WP_USER=xxxxxxxxxxx
WP_USER_EMAIL=xxxxxxxxxxx
WP_PASSWORD=xxxxxxxxxxx
```
*(Note: `WP_ADMIN_USER` must never contain "admin" or "administrator").*

2. **Secrets Directory (`secrets/` at root):**
Create the secrets directory and the secret text files required by Docker Compose:
```bash
mkdir -p secrets
echo "RootSecurePass123!" > secrets/db_root_password.txt
echo "DBUserSecurePass123!" > secrets/db_password.txt
echo "AdminSecurePass123!" > secrets/credentials.txt
chmod 600 secrets/*.txt
```

---

## 2. Building and Launching the Project

The project is orchestrated via the root `Makefile`:

- **Build and start services:**
  ```bash
  make
  # or
  make up
  ```
- **Force rebuild and start:**
  ```bash
  make build
  ```
- **Stop services (preserving containers):**
  ```bash
  make stop
  ```
- **Resume stopped services:**
  ```bash
  make start
  ```
- **Stop and remove containers and network:**
  ```bash
  make down
  ```
- **Full reset (rebuild everything from scratch):**
  ```bash
  make re
  ```

---

## 3. Container & Volume Management Commands

Use these commands during maintenance and debugging:

- **Check container status:**
  ```bash
  docker compose -f ./srcs/docker-compose.yml ps
  ```
- **View live aggregated logs:**
  ```bash
  docker compose -f ./srcs/docker-compose.yml logs -f
  ```
- **Inspect service specific logs:**
  ```bash
  docker logs nginx
  docker logs wordpress
  docker logs mariadb
  ```
- **Access a container shell:**
  ```bash
  docker exec -it wordpress bash
  docker exec -it mariadb bash
  docker exec -it nginx bash
  ```
- **Inspect named volumes:**
  ```bash
  docker volume inspect mariadb_data
  docker volume inspect wordpress_data
  ```
- **Inspect the custom bridge network:**
  ```bash
  docker network inspect inception
  ```

---

## 4. Data Storage & Persistence Architecture

Data persists independently of container lifecycles using Docker named volumes mapped to the host filesystem:

- **MariaDB Data:**
  - Volume name: `mariadb_data`
  - Host path: `/home/qvan-der/data/mariadb`
  - Container path: `/var/lib/mysql`
- **WordPress Data:**
  - Volume name: `wordpress_data`
  - Host path: `/home/qvan-der/data/wordpress`
  - Container path: `/var/www/html`

### Persistence Behavior
- Stopping or removing containers (`make down`) does **not** erase `/home/qvan-der/data`.
- When containers are recreated, Docker mounts the host directories back into the containers, preserving database records and uploaded WordPress files.
- Persistent data is only wiped when executing `make fclean`.
