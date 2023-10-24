package main

import (
	"log"
	"net/http"
	"os"
	"time"

	"tobalo/golang-website/pkg/news"
	"tobalo/golang-website/pkg/website"

	"github.com/joho/godotenv"
)

func main() {

	err := godotenv.Load()
	if err != nil {
		log.Println("Error loading .env file")
	}
	port := os.Getenv("PORT")
	if port == "" {
		port = "3000"
	}
	apiKey := os.Getenv("NEWS_API_KEY")
	if apiKey == "" {
		log.Fatal("Env: apiKey must be set")
	}
	myClient := &http.Client{Timeout: 10 * time.Second}
	newsapi := news.NewClient(myClient, apiKey, 20)
	//header := &website.Header{Title: customData}
	fs := http.FileServer(http.Dir("public/assets"))

	mux := http.NewServeMux()
	mux.Handle("/assets/", http.StripPrefix("/assets/", fs))
	mux.HandleFunc("/search", website.SearchHandler(newsapi))
	mux.HandleFunc("/", website.IndexHandler)
	log.Print("Listening on :" + port + "...")
	http.ListenAndServe(":"+port, mux)

}
