package main

import (
	"flickzy/db"
	"log"
	"os"

	"github.com/gin-gonic/gin"
	"github.com/joho/godotenv"
)

// var DBQuery db

func main() {

	server := gin.Default()

	server.Run(":8080")

}

func HandleStart() {
	if err := godotenv.Load(); err != nil {
		log.Fatal("Error loading .env file")
	}

	dbURL := os.Getenv("DB_URL")
	if dbURL == "" {
		log.Fatal("DB url is not set")
	}

	pool, err := db.DatabasePool(dbURL)
	if err != nil {
		log.Fatal(err)
	}
	defer pool.Close()

	db.HandlePool(pool)
}
