package main

import (
	"flag"
	"fmt"
	"net/http"
	"os"
	"time"
)

var (
	greetName string
	port      string
)

// getEnvOrDefault returns the environment variable value or a default
func getEnvOrDefault(key, defaultVal string) string {
	if val := os.Getenv(key); val != "" {
		return val
	}
	return defaultVal
}

func hello(w http.ResponseWriter, req *http.Request) {
	fmt.Printf("Got /hello request\n")
	w.WriteHeader(200)
	w.Write([]byte(fmt.Sprintf("Hello, %s!", greetName)))
}

func main() {
	// Define CLI flags
	nameFlag := flag.String("name", "", "Name to greet (can also use HELLO_NAME env var)")
	portFlag := flag.String("port", "", "Port to listen on (can also use HELLO_PORT env var)")
	flag.Parse()

	// Get name: CLI flag > env var > default
	if *nameFlag != "" {
		greetName = *nameFlag
	} else {
		greetName = getEnvOrDefault("HELLO_NAME", "World")
	}

	// Get port: CLI flag > env var > default
	if *portFlag != "" {
		port = *portFlag
	} else {
		port = getEnvOrDefault("HELLO_PORT", "8090")
	}

	fmt.Printf("Starting with greeting name: %s\n", greetName)
	fmt.Printf("Using port: %s\n", port)

	go func() {
		http.HandleFunc("/hello", hello)
		fmt.Printf("HTTP server listening on :%s\n", port)
		http.ListenAndServe(":"+port, nil)
	}()

	fmt.Printf("Hello, %s! Start.\n", greetName)
	for i := 0; true; i++ {
		fmt.Printf("Hello, %s! Count: %d\n", greetName, i)
		time.Sleep(5 * time.Second)
	}
}
