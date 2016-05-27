#!/bin/sh
set -e

nginx -g "daemon on;" && /usr/local/bin/app-server "$@"