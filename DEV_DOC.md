# Developer Documentation

## 1. Setting Up the Environment From Scratch

### 1.1 Prerequisites

- **Docker** and **Docker Compose** installed on the host machine
- **make**
- A Unix-like system (Linux or macOS); on the school's virtual machines, Docker is already available
- Root/sudo access, needed to edit `/etc/hosts`

### 1.2 Cloning the Project

```bash
git clone <repo-url>
cd inception
```

### 1.3 Configuration Files

The project relies on two kinds of configuration:

**Environment variables** (`.env` at the project root, or per-service), typically defining things like:
```
DOMAIN_NAME=[username].42.fr
```

**Docker secrets**, stored as plain text files in the `secrets/` folder and never committed to version control. Two files are required:

`secrets/sql_credentials.txt`
```
SQL_ROOT_PASSWORD=xxx
SQL_USER=xxx
SQL_PASSWORD=xxx
SQL_ADMIN=xxx
SQL_ADMIN_PASSWORD=xxx
```

`secrets/wp_credentials.txt`
```
WP_ADMIN_USER=xxx
WP_ADMIN_PASSWORD=xxx
WP_ADMIN_EMAIL=xxx
```

These files are mounted into the containers as Docker secrets (declared under the `secrets:` key in `docker-compose.yml`) and read at container startup by the entrypoint scripts, rather than being baked into the images.

### 1.4 Hosts File

Add an entry pointing your domain to `localhost` so that `https://[username].42.fr` resolves correctly:

```
127.0.0.1  [username].42.fr
```

(on Linux/macOS this goes in `/etc/hosts`, and requires sudo to edit).

## 2. Building and Launching the Project

Everything is orchestrated through a `Makefile` wrapping `docker compose` calls, and a `docker-compose.yml` defining the three services (`nginx`, `mariadb`, `wordpress`), each built from its own `Dockerfile` under `srcs/requirements/`.

| Command | Effect |
|---|---|
| `make all` | Builds the images and starts all containers in detached mode |
| `make down` | Stops and removes the running containers |
| `make re` | Equivalent to `make down` followed by `make all` (rebuild + relaunch) |
| `make clean` | Stops the containers and removes the containers and volumes created by the project |
| `make fclean` | Same as `make clean`, but also deletes the persistent WordPress and database data on disk |

Under the hood, `make all` typically runs something like:

```bash
docker compose -f srcs/docker-compose.yml up --build -d
```

## 3. Managing Containers and Volumes

Useful commands while developing:

```bash
# List running containers and their status
docker container ls

# Follow logs of a specific service
docker compose -f srcs/docker-compose.yml logs -f wordpress

# Open a shell inside a running container
docker exec -it <container_name> /bin/sh

# List Docker volumes
docker volume ls

# Inspect a specific volume (mountpoint, driver, etc.)
docker volume inspect <volume_name>

# Rebuild a single service without touching the others
docker compose -f srcs/docker-compose.yml build <service_name>
```

If a container keeps restarting, `docker logs <container_name>` is the first place to check for errors (missing secret, failed DB connection, misconfigured entrypoint script, etc.).

## 4. Data Storage and Persistence

Two named Docker volumes are used to persist data across container restarts and rebuilds:

| Volume | Mounted in | Contains |
|---|---|---|
| `db_data` | `mariadb` container, at `/var/lib/mysql` | The WordPress database (posts, users, settings, etc.) |
| `wp_data` | `wordpress` and `nginx` containers, at `/var/www/html` | WordPress core files, themes, plugins, and uploaded media |

These volumes are mounted to a local path on the host (e.g. under `/home/<login>/data/`) so that the data physically lives outside the containers, on the host filesystem.

- Data **survives** `make down` and `make re`.
- Data is **destroyed** by `make fclean`.