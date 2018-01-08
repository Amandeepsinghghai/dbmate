# build image
FROM golang:1.9 as build

# required to force cgo (for sqlite driver) with cross compile
ENV CGO_ENABLED 1

# development dependencies
RUN go get \
	github.com/golang/lint/golint \
	github.com/kisielk/errcheck

# copy source files
COPY . $GOPATH/src/github.com/amacneil/dbmate
WORKDIR $GOPATH/src/github.com/amacneil/dbmate

# build
RUN go build -ldflags '-s' -o /go/bin/dbmate ./cmd/dbmate

# runtime image
FROM debian:stretch-slim
COPY --from=build /go/bin/dbmate /usr/local/bin/dbmate
ENTRYPOINT ["dbmate"]
