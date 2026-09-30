# MariaDB

---

## Setup DB Shell Script (`setup_db.sh`)

### Starting temporary MariaDB server for setup

First, we start a temporary MariaDB server because we need a running MariaDB server to execute the setup SQL commands that create the database and user.

We use a temporary server because we want to use the `--skip-networking` flag. The flag tells MariaDB to start normally, but not accept connections trough the network. The server can only be accessed locally through its Unix socket.

Once the setup is complete, we shut down the temporary server and start MariaDB normally with networking enabled.

### Running setup SQL

#### 1. We change the password for the `root` user when connecting to `localhost`
```sql
ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';
```
**Breaking it down**
* `ALTER USER` — modify an existing MySQL account.
* `'root'@'localhost'` — specifically the MySQL account named.
* `root` that is allowed to connect from `localhost`.
* `IDENTIFIED BY` — sets the account's authentication password.
* `'${MYSQL_ROOT_PASSWORD}'` — intended to be the new password. It is substituded with the value of the environment variable.

#### 2. We create a MySQL database whose name comes from the `MYSQL_DATABASE` variable
```sql
CREATE DATABASE IF NOT EXISTS ${MYSQL_DATABASE};
```
**Breaking it down**
* `CREATE DATABASE` — tells MySQL to create a new database.
* `IF NOT EXISTS` — prevents an error if the database alreay exists.
* `${MYSQL_DATABASE}` — the name of the new database, substituted with the value of the environment variable.

#### 3. We create a MySQL user account
```sql
CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
```
**Breaking it down**
* `CREATE DATABASE` — creates a new MySQL account.
* `IF NOT EXISTS` — prevents an error if the account alreay exists.
* `'${MYSQL_USER}'` — the username.
* `'%'` — means the user can connect **from any host**, rather than only `localhost`.
* `IDENTIFIED BY '${MYSQL_PASSWORD}'` — sets the user's password.

#### 4. Give full permissions on a specific database
```sql
GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE}.* TO '${MYSQL_USER}'@'%';
```
**Breaking it down**
* `GRAND` — gives permissions to a MySQL account.
* `ALL PRIVILEGES` — grants all privileges available at that database level, such as `SELECT`, `INSERT`, `UPDATE`, `DELETE`, `CREATE`, `ALTER`, `DROP`, etc.
* `ON ${MYSQL_DATABASE}.*` — applies to every table.object in that database.
* `TO '${MYSQL_USER}'@'%'` — the account, connecting from any host.

#### 5. Flush privileges
```sql
FLUSH PRIVILEGES;
```
This tells MySQL to reload its **privilege information**.

### 
