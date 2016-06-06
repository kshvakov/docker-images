FROM golang:1.7-alpine

RUN apk update && apk add git && apk add mercurial && rm -rf /var/cache/apk/*

RUN go get -u github.com/FiloSottile/gvt

CMD /sbin/init