*This project has been created as part of the 42 curriculum by vanfossi.*

# Inception

## Description

Inception is a system administration project that sets up a small containerized infrastructure using **Docker** and **Docker Compose**. It deploys a **WordPress** site behind an **NGINX**, backed by a **MariaDB** database, with each service running in its own container built from a custom `Dockerfile`. The goal is to practice container creation, apps isolation, persistent storage, and secure credential management.

## Instructions

**For more complete instructions** See `USER_DOC.md`

**Requirements:** Docker, Docker Compose, `make`, sudo access (to edit `/etc/hosts`).

**Setup:**
1. `git clone <repo-url> && cd inception`
2. Create the secret files under `secrets/` (see `DEV_DOC.md`).
3. Add `127.0.0.1  [username].42.fr` to `/etc/hosts`.

**Build & run:** `make all`

| Command | Effect |
|---|---|
| `make down` | Stop all containers |
| `make re` | Rebuild and restart everything |
| `make clean` | Stop and remove containers/volumes |
| `make fclean` | Also deletes persistent WordPress/DB data |

**Access:** `https://localhost` (site) / `https://localhost/wp-admin/` (admin panel)

## Project Description: Docker Architecture

Three services, each built from its own `Dockerfile` under `srcs/requirements/`: **nginx** (TLS termination, reverse proxy), **wordpress** (WordPress + php-fpm, no built-in web server), **mariadb** (database). They communicate over a dedicated Docker network, with only NGINX exposed to the host. Sensitive data (DB/WordPress credentials) is passed via Docker secrets; persistent volumes store the database and WordPress files.

- **VM vs Docker**: VMs virtualize a full OS/kernel, heavier and slower; Docker containers share the host kernel, making them lighter and faster to start, at the cost of some isolation.
- **Secrets vs env variables**: env variables are visible via `docker inspect`/process listing; secrets are mounted as files under `/run/secrets/` and never exposed that way — used here for all credentials.
- **Docker network vs host network**: the default bridge network isolates containers (service-name DNS, only published ports reachable); host networking shares the host's stack directly, removing isolation. This project uses a bridge network so only NGINX is reachable externally.
- **Volumes vs bind mounts**: volumes are managed by Docker and portable; bind mounts map a host path directly into the container. Used here to persist the database and WordPress files across restarts/rebuilds.

## Resources

Docker image creation :
https://aws.plainenglish.io/create-a-custom-docker-image-f02024430dab
https://www.datacamp.com/tutorial/nginx-docker
https://www.docker.com/blog/how-to-dockerize-wordpress/

Nginx docs:
https://nginx.org/en/docs/

Wordpress and mariadb containers creation :
https://fr.wordpress.org/support/article/how-to-install-wordpress/
https://community.hetzner.com/tutorials/dockerizing-mariadb-with-alpine-linux
https://www.wp-script.com/adult-wordpress-plugins/wp-script-core/

General tutorial for the project (not up to date but useful):
https://tuto.grademe.fr/inception/

## AI Usage

AI has been used at various points of the project, mostly for fixing typos/formatting these docs files but also in a teaching role to help parse nginx/mariadb docs.