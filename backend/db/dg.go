package db

import (
	"context"
	"flickzy/db/database"
	"fmt"
	"time"

	"github.com/jackc/pgx/v5/pgxpool"
)

const (
	defaultMaxConns          = int32(4)
	defaultMinConns          = int32(0)
	defaultMaxConnLifetime   = time.Hour
	defaultMaxConnIdletime   = time.Minute * 30
	defaultHealthCheckPeriod = time.Minute
	defaultConnectTimeout    = time.Second * 10
)

var DBQuery *database.Queries

func DatabasePool(dbURL string) (*pgxpool.Pool, error) {

	dbConfig, err := pgxpool.ParseConfig(dbURL)
	if err != nil {
		return nil, fmt.Errorf("Failed to parse the config: %v", err)
	}

	dbConfig.MaxConns = defaultMaxConns
	dbConfig.MinConns = defaultMinConns
	dbConfig.MaxConnLifetime = defaultMaxConnLifetime
	dbConfig.MaxConnIdleTime = defaultMaxConnIdletime
	dbConfig.HealthCheckPeriod = defaultHealthCheckPeriod
	dbConfig.ConnConfig.ConnectTimeout = defaultConnectTimeout

	pool, err := pgxpool.NewWithConfig(context.Background(), dbConfig)
	if err != nil {
		return nil, fmt.Errorf("Couldn't connect to the DB: %v", err)
	}
	// defer pool.Close()

	return pool, nil
}

func HandlePool(pool *pgxpool.Pool) {
	// connPool, err := databasePool(dbURL)
	// if err != nil {
	// 	return nil, err
	// }

	DBQuery = database.New(pool)
}
