#!/bin/bash
set -e

IMAGE_NAME="test-hello-world"
CONTAINER_NAME="test-hello-world-test"
DEFAULT_PORT="8090"

echo "=== Building Docker image ==="
docker build --tag "$IMAGE_NAME" .

echo ""
echo "=== Test 1: Run with default greeting (port $DEFAULT_PORT) ==="
docker run --rm --name "$CONTAINER_NAME" -d -p "$DEFAULT_PORT:$DEFAULT_PORT" "$IMAGE_NAME"
sleep 2

# Check logs for default greeting
echo "Checking container logs..."
docker logs "$CONTAINER_NAME" 2>&1 | head -5

# Test HTTP endpoint
echo "Testing HTTP endpoint..."
RESPONSE=$(curl -s "http://localhost:$DEFAULT_PORT/hello")
echo "HTTP Response: $RESPONSE"

if [[ "$RESPONSE" == "Hello, World!" ]]; then
    echo "Test 1 PASSED: Default greeting works"
else
    echo "Test 1 FAILED: Expected 'Hello, World!' but got '$RESPONSE'"
    docker stop "$CONTAINER_NAME" 2>/dev/null || true
    exit 1
fi

docker stop "$CONTAINER_NAME"
sleep 1

echo ""
echo "=== Test 2: Run with HELLO_NAME env var ==="
docker run --rm --name "$CONTAINER_NAME" -d -p "$DEFAULT_PORT:$DEFAULT_PORT" -e HELLO_NAME="EnvTest" "$IMAGE_NAME"
sleep 2

# Check logs
echo "Checking container logs..."
docker logs "$CONTAINER_NAME" 2>&1 | head -5

# Test HTTP endpoint
echo "Testing HTTP endpoint..."
RESPONSE=$(curl -s "http://localhost:$DEFAULT_PORT/hello")
echo "HTTP Response: $RESPONSE"

if [[ "$RESPONSE" == "Hello, EnvTest!" ]]; then
    echo "Test 2 PASSED: Environment variable works"
else
    echo "Test 2 FAILED: Expected 'Hello, EnvTest!' but got '$RESPONSE'"
    docker stop "$CONTAINER_NAME" 2>/dev/null || true
    exit 1
fi

docker stop "$CONTAINER_NAME"
sleep 1

echo ""
echo "=== Test 3: Run with CLI argument ==="
docker run --rm --name "$CONTAINER_NAME" -d -p "$DEFAULT_PORT:$DEFAULT_PORT" "$IMAGE_NAME" --name "CLITest"
sleep 2

# Check logs
echo "Checking container logs..."
docker logs "$CONTAINER_NAME" 2>&1 | head -5

# Test HTTP endpoint
echo "Testing HTTP endpoint..."
RESPONSE=$(curl -s "http://localhost:$DEFAULT_PORT/hello")
echo "HTTP Response: $RESPONSE"

if [[ "$RESPONSE" == "Hello, CLITest!" ]]; then
    echo "Test 3 PASSED: CLI argument works"
else
    echo "Test 3 FAILED: Expected 'Hello, CLITest!' but got '$RESPONSE'"
    docker stop "$CONTAINER_NAME" 2>/dev/null || true
    exit 1
fi

docker stop "$CONTAINER_NAME"
sleep 1

echo ""
echo "=== Test 4: Run with custom port via env var ==="
CUSTOM_PORT="9999"
docker run --rm --name "$CONTAINER_NAME" -d -p "$CUSTOM_PORT:$CUSTOM_PORT" -e HELLO_PORT="$CUSTOM_PORT" "$IMAGE_NAME"
sleep 2

# Check logs
echo "Checking container logs..."
docker logs "$CONTAINER_NAME" 2>&1 | head -5

# Test HTTP endpoint on custom port
echo "Testing HTTP endpoint on port $CUSTOM_PORT..."
RESPONSE=$(curl -s "http://localhost:$CUSTOM_PORT/hello")
echo "HTTP Response: $RESPONSE"

if [[ "$RESPONSE" == "Hello, World!" ]]; then
    echo "Test 4 PASSED: Custom port works"
else
    echo "Test 4 FAILED: Expected 'Hello, World!' but got '$RESPONSE'"
    docker stop "$CONTAINER_NAME" 2>/dev/null || true
    exit 1
fi

docker stop "$CONTAINER_NAME"

echo ""
echo "=== All tests PASSED ==="
echo "Docker image '$IMAGE_NAME' is working correctly!"
