# User Documentation

## Installation details

For installing and configuring the projet, see **DEV_DOC.md**

## 1. Services Overview

This repository sets up an infrastructure made of **3 Docker containers**, each with a specific role:

| Container | Role |
|---|---|
| **NGINX** | Web server, single entry point to the site over HTTPS |
| **MariaDB** | Database used by WordPress |
| **WordPress + php-fpm** | Application layer (CMS) |

Once built with `make all`, the containers start automatically and deploy a working WordPress installation, reachable from `localhost` or `[username].42.fr` (the latter redirecting to `localhost` thanks to an entry added (by you) to the `/etc/hosts` file).

## 2. Starting and Stopping the Project

All operations go through the `Makefile` at the root of the project:

| Command | Effect |
|---|---|
| `make all` | Builds the images and starts the containers |
| `make up` | Starts all containers without building |
| `make down` | Stops all containers |
| `make re` | Stops, rebuilds, and restarts the containers |
| `make clean` | Stops and removes the containers as well as the created volumes |
| `make fclean` | Same as `clean`, but also deletes WordPress' and the database's persistent data |

## 3. Accessing the Website and the Admin Panel

- **Website**: open a browser and go to `https://localhost` or `https://[username].42.fr`
- **WordPress admin panel**: `https://localhost/wp-admin/` or `https://[username].42.fr/wp-admin/`

## 4. Managing Credentials

Credentials can be generated with the secrets_init.sh script at the root of the repo.

Credentials are managed through **Docker secrets** and must be provided in two text files located in the `secrets/` folder:

**`sql_credentials.txt`**
```
SQL_ROOT_PASSWORD=xxx
SQL_USER=xxx
SQL_PASSWORD=xxx
SQL_ADMIN=xxx
SQL_ADMIN_PASSWORD=xxx
```

**`wp_credentials.txt`**
```
WP_ADMIN_USER=xxx
WP_ADMIN_PASSWORD=xxx
WP_ADMIN_EMAIL=xxx
```

These files should never be committed to version control (check they are still `.gitignore`'d).

## 5. Checking That Services Are Running Correctly

After startup, check that no container is in an `Exited` state or stuck in a restart loop:

```bash
docker container ls
```

If the initialization went well, this command should list all **three containers** with an `Up` status.