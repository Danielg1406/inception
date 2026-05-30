FROM debian:bookworm-slim

RUN apt-get update && apt-get install -y --no-install-recommends \
	nginx \
	openssl \
 && rm -rf /var/lib/apt/lists/*

COPY conf/nginx.conf /etc/nginx/nginx.conf
COPY conf/server.conf /etc/nginx/conf.d/default.conf
COPY tools/entrypoint.sh /usr/local/bin/entrypoint.sh

RUN set -eux; \
	mkdir -p /var/www/inception; \
	chmod +x /usr/local/bin/entrypoint.sh; \
	chown -R www-data:www-data /var/www/inception

EXPOSE 443

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD ["nginx", "-g", "daemon off;"]