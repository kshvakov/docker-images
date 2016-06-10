FROM alpine:3.3
RUN apk add --update ca-certificates && \
    rm -rf /var/cache/apk/* /tmp/*

RUN update-ca-certificates

ENV LOG_LEVEL=warning \
	DB_PORT=5432 \
	DB_DATABASE=postgres_ci

COPY ./tmp/notifier /usr/local/bin/notifier

ENTRYPOINT ["/usr/local/bin/notifier"]
