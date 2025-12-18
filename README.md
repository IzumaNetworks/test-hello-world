# Test Hello World

A simple Go "Hello World" program for testing Docker container deployments. This program accepts a configurable greeting name via CLI flag or environment variable.

## Features

- Prints a greeting message in a loop every 5 seconds
- HTTP server on port 8080 with `/hello` endpoint for health checks
- Configurable greeting name via:
  - CLI flag: `--name`
  - Environment variable: `HELLO_NAME`
  - Default: "World"

## Usage

### Running Locally

```bash
# Build the Go program
cd app && go build -o app .

# Run with default ("World")
./app

# Run with CLI flag
./app --name "Developer"

# Run with environment variable
HELLO_NAME="Developer" ./app
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
# Run with default greeting
docker run -p 8080:8080 test-hello-world

# Run with environment variable
docker run -p 8080:8080 -e HELLO_NAME="Docker" test-hello-world

# Run with CLI argument
docker run -p 8080:8080 test-hello-world --name "Docker"
```

#### Test the HTTP endpoint

```bash
curl http://localhost:8080/hello
# Returns: Hello, Docker!
```

## Deploy to Kubernetes

```bash
kubectl apply -f deployment.yaml
```

The deployment sets `HELLO_NAME=Kubernetes` by default. You can customize by editing `deployment.yaml`:

```yaml
env:
- name: HELLO_NAME
  value: "YourCustomName"
```

Or use CLI args in the container spec:

```yaml
containers:
- name: test-hello-world
  image: ghcr.io/izumanetworks/test-hello-world:latest
  args: ["--name", "YourCustomName"]
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
HTTP server listening on :8080
Hello, Docker! Start.
Hello, Docker! Count: 0
Hello, Docker! Count: 1
Hello, Docker! Count: 2
...
```
