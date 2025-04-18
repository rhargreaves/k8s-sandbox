package main

import (
	"fmt"
	"io"
	"net/http"
)

func main() {
	http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
		backendResponse, err := getBackendResponse()
		if err != nil {
			http.Error(w, "Failed to get backend response", http.StatusInternalServerError)
			return
		}

		fmt.Fprintf(w, "Hello, this is the frontend API! 🚀\n"+
			"Backend API response: %s\n", backendResponse)
	})

	port := ":8080"
	fmt.Printf("Server starting on port %s\n", port)
	if err := http.ListenAndServe(port, nil); err != nil {
		panic(err)
	}
}

func getBackendResponse() (string, error) {
	resp, err := http.Get("http://backend-api:8080")
	if err != nil {
		return "", err
	}
	defer resp.Body.Close()

	body, err := io.ReadAll(resp.Body)
	if err != nil {
		return "", err
	}

	return string(body), nil
}
