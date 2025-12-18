package main

import (
	"flag"
	"fmt"
	"net/http"
	"os"
	"time"
)

// getName returns the name to greet, checking CLI flag first, then env var, then default
func getName() string {
	// Define CLI flag
	nameFlag := flag.String("name", "", "Name to greet (can also use HELLO_NAME env var)")
	flag.Parse()

	// Check CLI flag first
	if *nameFlag != "" {
		return *nameFlag
	}

	// Fall back to environment variable
	if envName := os.Getenv("HELLO_NAME"); envName != "" {
		return envName
	}

	// Default value
	return "World"
}

var greetName string

func hello(w http.ResponseWriter, req *http.Request) {
	fmt.Printf("Got /hello request\n")
	w.WriteHeader(200)
	w.Write([]byte(fmt.Sprintf("Hello, %s!", greetName)))
}

func main() {
	greetName = getName()
	fmt.Printf("Starting with greeting name: %s\n", greetName)

	go func() {
		http.HandleFunc("/hello", hello)
		fmt.Printf("HTTP server listening on :8080\n")
		http.ListenAndServe(":8080", nil)
	}()

	fmt.Printf("Hello, %s! Start.\n", greetName)
	for i := 0; true; i++ {
		fmt.Printf("Hello, %s! Count: %d\n", greetName, i)
		time.Sleep(5 * time.Second)
	}
}
