package main

import (
	"fmt"
	"log"
	"net/http"
	"time"
)

func main() {
	// 简单的 HTTP 服务器示例
	http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
		fmt.Fprintf(w, "Hello from Go Development Environment!\n")
		fmt.Fprintf(w, "Time: %s\n", time.Now().Format("2006-01-02 15:04:05"))
		fmt.Fprintf(w, "Go Version: %s\n", "1.25.0")
	})

	http.HandleFunc("/health", func(w http.ResponseWriter, r *http.Request) {
		w.WriteHeader(http.StatusOK)
		fmt.Fprintf(w, `{"status": "healthy", "timestamp": "%s"}`, time.Now().Format(time.RFC3339))
	})

	fmt.Println("Go 开发服务器启动...")
	fmt.Println("访问地址:")
	fmt.Println("  - http://localhost:8080/")
	fmt.Println("  - http://localhost:8080/health")

	log.Fatal(http.ListenAndServe(":8080", nil))
}
