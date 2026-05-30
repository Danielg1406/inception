FROM	debian:bookworm-slim

RUN	apt update && \
	apt install --y --no-install-recommends --no-install-suggests \
	mariadb-server && \
	rm -rf /var/lib/apt/lists/*

COPY	conf/50-server.cnf /etc/mysql/mariadb.conf.d/
COPY	tools/setup.sh /bin/

RUN	chmos +x /bin/setup.sh

EXPOSE	3306

HEALTHCHECK --start-period=5m \
  CMD mariadb -e 'SELECT @@datadir;' || exit 1

CMD	["setup.sh", "mariadbd"]
