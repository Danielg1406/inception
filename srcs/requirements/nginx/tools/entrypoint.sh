#!/bin/sh

set -eu

mkdir -p "$CERT_FOLDER"

if [ ! -f "$CERTIFICATE" ] || [ ! -f "$KEY" ]; then
	openssl req -newkey rsa:4096 -x509 -sha256 -days 365 -nodes \
		-keyout "$KEY" \
		-out "$CERTIFICATE" \
		-subj "/C=${COUNTRY}/ST=${STATE}/L=${LOCALITY}/O=${ORGANIZATION}/OU=${UNIT}/CN=${COMMON_NAME}" \
		-addext "subjectAltName=DNS:${COMMON_NAME}"
fi

chown -R www-data:www-data "$CERT_FOLDER"

exec "$@"