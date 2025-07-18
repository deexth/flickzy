package main

import (
	"context"
	"flickzy/db"
	"flickzy/internal/auth"
	"flickzy/internal/utils"
	"log"
	"os"

	"github.com/gin-gonic/gin"
)

// var DBQuery db

func main() {
	// if err := godotenv.Load(); err != nil {
	// 	log.Fatal("Error loading .env file")
	// }

	portAddress := os.Getenv("PORT_ADDRESS")
	if portAddress == "" {
		log.Fatal("port address is not set")
	}

	dbURL := os.Getenv("DB_URL")
	if dbURL == "" {
		log.Fatal("DB url is not set")
	}

	redisAddr := os.Getenv("REDIS_ADDR")
	if redisAddr == "" {
		log.Fatal("redis address is not set")
	}

	utils.InitRedis(redisAddr)
	ctx := context.Background()
	_, err := utils.Rdb.Ping(ctx).Result()
	if err != nil {
		log.Fatal("Issue starting redis,", err)
	}
	// ctx.Done()

	pool, err := db.DatabasePool(dbURL)
	if err != nil {
		log.Fatal(err)
	}
	defer pool.Close()

	db.HandlePool(pool)

	server := gin.Default()
	auth.RegisteredRoutes(server)

	log.Println("Starting the server on port: ", portAddress)

	server.Run(":" + portAddress)

}

// func HandleStart() {
// 	dbURL := os.Getenv("DB_URL")
// 	if dbURL == "" {
// 		log.Fatal("DB url is not set")
// 	}

// 	pool, err := db.DatabasePool(dbURL)
// 	if err != nil {
// 		log.Fatal(err)
// 	}
// 	defer pool.Close()

// 	db.HandlePool(pool)
// }

// func mongo() {

// import (
//   "context"
//   "fmt"

//   "go.mongodb.org/mongo-driver/v2/mongo"
//   "go.mongodb.org/mongo-driver/v2/mongo/options"
//   "go.mongodb.org/mongo-driver/v2/mongo/readpref"
// )

// Use the SetServerAPIOptions() method to set the version of the Stable API on the client
//   serverAPI := options.ServerAPI(options.ServerAPIVersion1)
//   opts := options.Client().ApplyURI("mongodb+srv://hkabaremongo:cwqf4r9i7LJsMshy@cluster0.o83kuqu.mongodb.net/?retryWrites=true&w=majority&appName=Cluster0").SetServerAPIOptions(serverAPI)

//   // Create a new client and connect to the server
//   client, err := mongo.Connect(opts)
//   if err != nil {
//     panic(err)
//   }

//   defer func() {
//     if err = client.Disconnect(context.TODO()); err != nil {
//       panic(err)
//     }
//   }()

//   // Send a ping to confirm a successful connection
//   if err := client.Ping(context.TODO(), readpref.Primary()); err != nil {
//     panic(err)
//   }
//   fmt.Println("Pinged your deployment. You successfully connected to MongoDB!")

// }
