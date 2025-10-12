package main

import (
	"fmt"
	"log"
	"net/http"
)

func main() {
	// Simple HTTP server example
	http.HandleFunc("/", handleRoot)
	http.HandleFunc("/health", handleHealth)

	port := ":8080"
	fmt.Printf("Starting vertex-stream server on port %s\n", port)
	log.Fatal(http.ListenAndServe(port, nil))
}

func handleRoot(w http.ResponseWriter, r *http.Request) {
	fmt.Fprintf(w, "Welcome to vertex-stream!\n")
	fmt.Fprintf(w, "This is a boilerplate Go application with Terraform infrastructure.\n")
}

func handleHealth(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Content-Type", "application/json")
	fmt.Fprintf(w, `{"status": "healthy", "service": "vertex-stream"}`)
}