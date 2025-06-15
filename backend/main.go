package main

import (
	"flickzy/db"
	"log"
	"os"
	"strconv"

	"github.com/gin-gonic/gin"
	"github.com/joho/godotenv"
)

// var DBQuery db

func main() {
	if err := godotenv.Load(); err != nil {
		log.Fatal("Error loading .env file")
	}

	HandleStart()

	server := gin.Default()

	server.Run(":8080")

}

func HandleStart() {
	dbURL := os.Getenv("DB_URL")
	if dbURL == "" {
		log.Fatal("DB url is not set")
	}

	_, err := strconv.ParseBool(dbURL)
	if err != nil {
		log.Fatal("Invalid DB url:", err)
	}

	pool, err := db.DatabasePool(dbURL)
	if err != nil {
		log.Fatal(err)
	}
	defer pool.Close()

	db.HandlePool(pool)
}
