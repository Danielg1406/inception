*This project has been created as part of the 42 curriculum by dgomez-a*

# Developer Documentation

## Environment setup from scratch

### Prerequisites

- Docker Engine installed.
- Docker Compose v2 available as `docker compose`.
- `make` installed.

### Repository layout

- `Makefile` manages the full stack lifecycle.
- `srcs/docker-compose.yml` defines the services and secrets.
- `srcs/.env.example` contains the non-sensitive configuration values.
- `secrets/` contains the example secret files.
- `srcs/requirements/` contains the service Dockerfiles and startup scripts.

### Configuration files

1. Copy the example environment file and secrets:

```bash
make secrets
```

2. Fill in the configuration values in `srcs/.env`.

Keep only non-sensitive settings there, such as:

- database name and user,
- WordPress URL and site title,
- Nginx certificate fields.


3. Edit the secret files in `srcs/secrets/`.

The project expects these files:

- `db_password.txt`
- `db_root_password.txt`
- `credentials.txt`

`credentials.txt` stores the WordPress admin and user credentials used during first-time installation.

## Build and launch

Build and start the stack with the Makefile:

```bash
make up
```

This command:

- creates the data directories under `~/data`,
- ensures the configured host name is present in `/etc/hosts`,
- runs `docker compose up -d --build`.


## Data storage and persistence

Persistent data is stored in bind-mounted host directories managed by Docker volumes:

- MariaDB data: `~/data/database`
- WordPress files: `~/data/wordpress_files`

The compose file maps those paths through the `mariadb_data` and `wordpress_data` volumes. This means:

- the database survives container recreation,
- the WordPress files survive container recreation,
- `make fclean` removes the volumes and therefore the persisted data.

Secret files are stored locally under `srcs/secrets/` and are ignored by git through `.gitignore`.

## Commands

| Command         | Description                                      |
|-----------------|--------------------------------------------------|
| `make` / `make up` | Build images and start all services           |
| `make down`     | Stop all services (preserves volumes)            |
| `make clean`    | Remove containers and networks                   |
| `make fclean`   | Remove containers, images, and volumes           |
| `make re`       | Rebuild everything from scratch (`fclean` + `up`) |

## Container, volume, and service management

Stops the stack, removes the images and volumes, and prunes builder cache.

```bash
docker compose -f srcs/docker-compose.yml ps
```

Lists the running services.

```bash
docker compose -f srcs/docker-compose.yml logs -f
```

Streams the container logs.

```bash
docker compose -f srcs/docker-compose.yml down --remove-orphans
```

Stops and removes containers created by the compose project.