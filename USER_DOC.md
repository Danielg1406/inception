*This project has been created as part of the 42 curriculum by dgomez-a*

# User Documentation

### What the stack provides

This project runs a small WordPress stack using Docker. The services are:

- `mariadb`: stores the WordPress database.
- `wordpress`: runs PHP-FPM and the WordPress application.
- `nginx`: serves HTTPS traffic and forwards PHP requests to WordPress.

The website is exposed through HTTPS on the host machine, and the database is kept in a persistent Docker volume.

### Start and stop the project

From the repository root, start the project with:

```bash
make up
```

This command also creates the local secret files if they do not already exist and adds the configured host name to `/etc/hosts`.

To stop the containers, run:

```bash
make down
```

To remove the containers, images, and volumes used by the stack, run:

```bash
make fclean
```

To do down and up at the same time, run:
```bash
make re
```

### Access the website and administration panel

The website is available at the domain configured in `Makefile` and `srcs/.env`.

Typical access URL:

```text
https://dgomez-a.42.fr
```

The WordPress administration panel is available at:

```text
https://dgomez-a.42.fr/wp-admin
```

If the domain does not resolve on your machine, check that `/etc/hosts` contains the entry added by `make up`.

### Locate and manage credentials

Sensitive values are not stored in `srcs/.env`.

The repository uses these local secret files under `srcs/secrets/`:

- `db_password.txt`
- `db_root_password.txt`
- `credentials.txt`

The `credentials.txt` file contains the WordPress admin and first user credentials used by the installation script.

If you need to create the secret files from the examples, use:

```bash
cd srcs
make secrets
```

You can then edit the generated `*.txt` files manually.

### Check that the services are running correctly

Use the following commands to confirm the stack is healthy:

```bash
docker compose -f srcs/docker-compose.yml ps
```

```bash
docker compose -f srcs/docker-compose.yml logs -f
```

You should see the `mariadb`, `wordpress`, and `nginx` containers running.

In a browser, confirm that:

- the WordPress home page loads over HTTPS,
- `/wp-admin` opens the administration login page,
- the certificate is being served by Nginx.

