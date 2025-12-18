FROM golang:1.20
LABEL org.opencontainers.image.source=https://github.com/IzumaNetworks/test-hello-world
LABEL org.opencontainers.image.description="Hello World Go test container"
LABEL org.opencontainers.image.licenses=Apache-2.0

ADD app /app
ENV CGO_ENABLED=0
RUN cd /app && go build -o app .
WORKDIR /app

# Default greeting name (can be overridden at runtime)
ENV HELLO_NAME="World"

# Use ENTRYPOINT + CMD pattern so CLI args can be passed
ENTRYPOINT [ "/app/app" ]
CMD []
