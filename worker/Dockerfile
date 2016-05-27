FROM alpine:3.3

RUN apk update && apk add git && rm -rf /var/cache/apk/*

ENV ASSETS=/opt/postgres-ci/assets \
	WORKING_DIR=/tmp/postgres-ci/builds/ \
	NUM_WORKERS=auto \
	LOG_LEVEL=warning \
	DB_PORT=5432 \
	DB_DATABASE=postgres_ci \
	DOCKER_ENDPOINT=unix:///var/run/docker.sock

COPY ./tmp/worker /usr/local/bin/worker

ENTRYPOINT ["/usr/local/bin/worker"]
