# Build
FROM golang:1.21 as builder
WORKDIR /build

COPY . .

RUN go mod download

RUN go build -o /bin/app main.go

CMD ["/bin/app"]

# Deployment
FROM docker.io/ubuntu

RUN apt-get update && apt-get install -y curl
RUN  apt-get clean autoclean
RUN apt-get autoremove --yes
RUN rm -rf /var/lib/{apt,dpkg,cache,log}/

WORKDIR /server
COPY --from=builder /bin/app app

EXPOSE 80

HEALTHCHECK CMD curl --fail http://localhost || exit 1  

CMD ["/server/app"]
