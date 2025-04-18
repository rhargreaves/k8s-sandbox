package main

import (
	"fmt"
	"io"
	"net/http"
)

type Result struct {
	response   string
	err        error
	statusCode int
}

func truncateString(str string, maxLength int) string {
	if len(str) <= maxLength {
		return str
	}
	return str[:maxLength] + "..."
}

func main() {
	http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {

		backendChan := make(chan Result)
		externalChan := make(chan Result)

		go func() {
			backendResult := getBackendResponse("http://backend-api:8080", "")
			backendChan <- backendResult
		}()

		go func() {
			externalResult := getBackendResponse("http://www-roberthargreaves-com.default.svc.cluster.local",
				"www.roberthargreaves.com")
			externalChan <- externalResult
		}()

		backendResult := <-backendChan
		if backendResult.err != nil {
			http.Error(w, "Failed to get backend response: "+backendResult.err.Error(), http.StatusInternalServerError)
			return
		}

		externalResult := <-externalChan
		if externalResult.err != nil {
			http.Error(w, "Failed to get external response: "+externalResult.err.Error(), http.StatusInternalServerError)
			return
		}

		fmt.Fprintf(w, "Hello, this is the frontend API! 🚀\n\n"+
			"Backend API response: (%d) %s\n\n"+
			"External service response: (%d) %s\n\n",
			backendResult.statusCode,
			truncateString(backendResult.response, 300),
			externalResult.statusCode,
			truncateString(externalResult.response, 300))
	})

	port := ":8080"
	fmt.Printf("Server starting on port %s\n", port)
	if err := http.ListenAndServe(port, nil); err != nil {
		panic(err)
	}
}

func getBackendResponse(url string, host string) Result {
	request, err := http.NewRequest("GET", url, nil)
	if err != nil {
		return Result{err: err}
	}
	if host != "" {
		request.Host = host
	}

	resp, err := http.DefaultClient.Do(request)
	if err != nil {
		return Result{err: err}
	}
	defer resp.Body.Close()

	body, err := io.ReadAll(resp.Body)
	if err != nil {
		return Result{err: err}
	}

	return Result{string(body), nil, resp.StatusCode}
}
