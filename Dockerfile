# Build
FROM docker.io/golang:1.21-alpine3.17 as builder
WORKDIR /build

COPY . .

RUN go mod download

RUN go build -o /bin/yeet ./cmd/microlith/main.go

CMD ["/bin/yeet"]

# Deployment
FROM docker.io/ubuntu

RUN apt-get update && apt-get install -y curl
RUN  apt-get clean autoclean
RUN apt-get autoremove --yes
RUN rm -rf /var/lib/{apt,dpkg,cache,log}/

WORKDIR /server
COPY --from=builder /bin/yeet yeet
COPY ./public /server/

EXPOSE 80 3000

HEALTHCHECK CMD curl --fail http://localhost || exit 1  

CMD ["/server/yeet"]
