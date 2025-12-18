# Test Hello World

A simple Go "Hello World" program for testing Docker container deployments. This program accepts configurable greeting name and port via CLI flags or environment variables.

## Features

- Prints a greeting message in a loop every 5 seconds
- HTTP server with `/hello` endpoint for health checks
- Configurable via CLI flags or environment variables:
  - `--name` / `HELLO_NAME`: Name to greet (default: "World")
  - `--port` / `HELLO_PORT`: Port to listen on (default: "8090")

## Usage

### Running Locally

```bash
# Build the Go program
cd app && go build -o app .

# Run with defaults
./app

# Run with CLI flags
./app --name "Developer" --port 9000

# Run with environment variables
HELLO_NAME="Developer" HELLO_PORT="9000" ./app
```

### Running with Docker

#### Build the Docker image

```bash
# Standard build
docker build --tag test-hello-world .

# Cross-platform build (e.g., on Apple Silicon for amd64)
docker buildx build --platform linux/amd64 --tag test-hello-world --load .
```

#### Run the container

```bash
# Run with defaults (port 8090)
docker run -p 8090:8090 test-hello-world

# Run with custom name via environment variable
docker run -p 8090:8090 -e HELLO_NAME="Docker" test-hello-world

# Run with custom port
docker run -p 9000:9000 -e HELLO_PORT="9000" test-hello-world

# Run with CLI arguments
docker run -p 8090:8090 test-hello-world --name "Docker"
```

#### Test the HTTP endpoint

```bash
curl http://localhost:8090/hello
# Returns: Hello, Docker!
```

## Deploy to Kubernetes

```bash
kubectl apply -f deployment.yaml
```

The deployment sets `HELLO_NAME=Kubernetes` and `HELLO_PORT=8090` by default. Customize in `deployment.yaml`:

```yaml
env:
- name: HELLO_NAME
  value: "YourCustomName"
- name: HELLO_PORT
  value: "9000"
```

Or use CLI args in the container spec:

```yaml
containers:
- name: test-hello-world
  image: ghcr.io/izumanetworks/test-hello-world:latest
  args: ["--name", "YourCustomName", "--port", "9000"]
```

## Dockerfile Variants

| Dockerfile | Description |
|------------|-------------|
| `Dockerfile` | Standard build |
| `Dockerfile-cross` | Cross-platform build without CGO |
| `Dockerfile-cross-cgo` | Cross-platform build with CGO |
| `Dockerfile-cross-cgo-xx` | Cross-platform build with xx tools |
| `Dockerfile-cross-cgo-xx-alpine` | Alpine-based cross-platform build |
| `Dockerfile-dev` | Development image with rsync for live reload |

## Example Output

```
Starting with greeting name: Docker
Using port: 8090
HTTP server listening on :8090
Hello, Docker! Start.
Hello, Docker! Count: 0
Hello, Docker! Count: 1
Hello, Docker! Count: 2
...
```
