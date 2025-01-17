# builder image
FROM golang:alpine as stage1

ENV GO111MODULE=on

WORKDIR /app

ADD ./ /app

RUN apk update --no-cache

RUN apk add git

RUN go build -o golang-test  .

# generate clean, final image for end users
FROM golang:alpine as stage2

WORKDIR /data

COPY --from=stage1 /app/golang-test .

# executable
ENTRYPOINT ["/data/golang-test"]

EXPOSE 8000


