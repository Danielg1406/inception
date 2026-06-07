*This project has been created as part of the 42 curriculum by dgomez-a*

# Description

Inception aims to broaden the knowledge of system administration by using Docker. It's a small deployment project that demonstrates how to build and run a LEMP-style stack (MariaDB, PHP-FPM, Nginx) using Docker. The goal is to provide a reproducible environment for running a WordPress site using Docker images built from the repository's Dockerfiles, creating them in a new personal virtual machine.

# Instructions

**Prerequisites:**
- Docker and Docker Compose installed on the host.

**Quick start:**

1. Copy the example environment file and edit values:

```bash
cd srcs/
cp .env.example .env
```

2. Create the secret files from the provided examples:

```bash
cp secrets/db_password.example secrets/db_password.txt
cp secrets/db_root_password.example secrets/db_root_password.txt
cp secrets/credentials.example secrets/credentials.txt
```

3. Edit `srcs/.env` and set the configuration values only
```bash
DB_NAME, DB_USER, DB_HOST, WP_URL, WP_FULL_URL, WP_TITLE, and the Nginx certificate settings
```
4. Edit the secret files under `srcs/secrets/*.txt` with the sensitive passwords and WordPress install credentials

5. Build and run the stack (Makefile provided):

```bash
make up
```

6. Stop the stack:

```bash
make down
```

7. Cleanup (remove images and volumes):

```bash
make fclean
```

# Project Description and Design Choices

### Project structure:
```
inception/
├── secrets/                
└── srcs/              
    ├── .env.example
    ├── docker-compose.yml
    └── requirements/
        ├── mariadb/
        ├── nginx/
        └── wordpress/
├── .gitginore
├── DEV_DOC.md
├── Makefile
├── README.md
└── USER_DOC.md
```

### Main design choices:
- Build each service from a local `Dockerfile` so the stack is self-contained and reproducible.
- Use a dedicated Docker volume per service for persistent data (`mariadb_data`, `wordpress_data`).
- Keep PHP-FPM and Nginx separated (PHP-FPM listens on port 9000 inside the compose network).
- Keep runtime configuration in `.env` and sensitive values in Docker secret files mounted at `/run/secrets`.

### Comparisons

- **Virtual Machines vs Docker**
	- Virtual Machines provide full OS isolation with higher overhead (memory/CPU). Good for full-system testing or when different kernels are needed.
	- Docker containers are lightweight, share the host kernel, and start much faster. They are suitable for packaging services and microservices where OS-level virtualization is unnecessary.

- **Secrets vs Environment Variables**
	- Environment variables are convenient for configuration but can leak in process lists, image layers, and logs if mishandled. Use `.env` for non-sensitive example values only.
	- Secrets (Docker secrets, vaults) provide better protection for sensitive data (passwords, keys). For production, prefer secrets management and avoid storing credentials in plain `.env` files.

- **Docker Network vs Host Network**
	- Docker networks (bridge or user-defined) provide service isolation and easy DNS-based service discovery (service names as hostnames). They are portable and secure for multi-service apps.
	- Host networking exposes container ports directly on the host network stack, removing network isolation and potential port conflicts. Useful for low-latency or special networking requirements but less isolated.

- **Docker Volumes vs Bind Mounts**
	- Docker volumes are managed by Docker and are portable across hosts (with volume drivers). They are the recommended way to persist container data.
	- Bind mounts map host directories directly into containers, which is useful for development (live edit) but couples the container to the host filesystem and permissions.

# Resources

- Docker documentation: https://docs.docker.com/
- Docker Compose: https://docs.docker.com/compose/
- WordPress documentation: https://wordpress.org/support/
- MariaDB documentation: https://mariadb.org/

### AI usage disclosure
AI tools were used to assist only with the creation of documentation. Specifically:
 - Drafted and formatted this `README.md` to meet the project requirements.
 - Drafted and formatted `USER_DOC.md` and `DEV_DOC.md` to meet the project requirements.

*All AI-generated changes were reviewed and validated locally by the author.*


