FROM nginx:stable-alpine

RUN rm -rf /etc/nginx/conf.d

COPY ./tmp/assets /opt/postgres-ci/assets
COPY ./tmp/app-server /usr/local/bin/app-server
COPY ./docker-entrypoint.sh /
COPY etc/nginx/conf.d /etc/nginx/conf.d

ENV ADDRESS=127.0.0.1:8888 \
	TEMPLATES=/opt/postgres-ci/assets/templates/ \
	LOG_LEVEL=error \
	DB_PORT=5432 \
	DB_DATABASE=postgres_ci

ENTRYPOINT ["/docker-entrypoint.sh"]
