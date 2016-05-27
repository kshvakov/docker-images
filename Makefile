go_version = go1.6.2.linux-amd64

go:

	@echo "\033[1mInstall Go compiler\033[0m"

	@[ -d env ] || mkdir env

	@if [ ! -d env/go ]; then \
		cd env && \
		wget https://storage.googleapis.com/golang/$(go_version).tar.gz && \
		tar -xf ./$(go_version).tar.gz && \
		mkdir gopath && \
		rm ./$(go_version).tar.gz ; \
	fi

	@GOROOT=$(shell pwd)/env/go \
	GOPATH=$(shell pwd)/env/gopath \
	env/go/bin/go get -u github.com/FiloSottile/gvt

	@GOROOT=$(shell pwd)/env/go \
	GOPATH=$(shell pwd)/env/gopath \
	env/go/bin/go get -u github.com/kshvakov/build-html

	@echo "\033[1mGo compiler installed!\033[0m"

build-worker:

	@echo "\033[1mBuild Postgres-CI worker\033[0m"

	@GOROOT=$(shell pwd)/env/go \
	GOPATH=$(shell pwd)/env/gopath \
	env/go/bin/go get -d -u github.com/postgres-ci/worker

	@cd env/gopath/src/github.com/postgres-ci/worker && \
		$(shell pwd)/env/gopath/bin/gvt restore

	@[ -d worker/tmp/ ] || mkdir worker/tmp/

	@GOROOT=$(shell pwd)/env/go \
	GOPATH=$(shell pwd)/env/gopath \
	CGO_ENABLED=0 \
	env/go/bin/go build -ldflags='-s -w' -o worker/tmp/worker \
		env/gopath/src/github.com/postgres-ci/worker/worker.go 

	@echo "\033[1mBuild worker: done!\033[0m"

build-app-server:

	@echo "\033[1mBuild Postgres-CI app-server\033[0m"

	@GOROOT=$(shell pwd)/env/go \
	GOPATH=$(shell pwd)/env/gopath \
	env/go/bin/go get -d -u github.com/postgres-ci/app-server

	@cd env/gopath/src/github.com/postgres-ci/app-server && \
		$(shell pwd)/env/gopath/bin/gvt restore

	@rm -rf app-server/tmp/ && mkdir -p app-server/tmp/assets

	@GOROOT=$(shell pwd)/env/go \
	GOPATH=$(shell pwd)/env/gopath \
	CGO_ENABLED=0 \
	env/go/bin/go build -ldflags='-s -w' -o app-server/tmp/app-server \
		env/gopath/src/github.com/postgres-ci/app-server/app-server.go 

	@cp -r env/gopath/src/github.com/postgres-ci/app-server/assets/static app-server/tmp/assets/static

	@./env/gopath/bin/build-html -i env/gopath/src/github.com/postgres-ci/app-server/assets/templates_src -o app-server/tmp/assets/templates

	@echo "\033[1mBuild app-server: done!\033[0m"

build-worker-image: build-worker

	@echo "\033[1mBuild worker docker image\033[0m"

	@cd worker && docker build -t postgresci/worker .

	@echo "\033[1mBuild worker docker image: done!\033[0m"

build-app-server-image: build-app-server

	@echo "\033[1mBuild app-server docker image\033[0m"

	@cd app-server && docker build -t postgresci/app-server .

	@echo "\033[1mBuild app-server docker image: done!\033[0m"

build: build-worker build-app-server

all: go build-worker-image build-app-server-image
