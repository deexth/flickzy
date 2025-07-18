package utils

import (
	"context"
	"errors"
	"fmt"

	"github.com/go-redis/redis_rate/v10"
	"github.com/redis/go-redis/v9"
)

var (
	Rdb     *redis.Client
	Limiter *redis_rate.Limiter
)

func InitRedis(address string) {
	Rdb = redis.NewClient(&redis.Options{
		Addr: address,
	})
	Limiter = redis_rate.NewLimiter(Rdb)
}

func Ratelimit(ctx context.Context, cleintIp string) error {
	res, err := Limiter.Allow(ctx, cleintIp, redis_rate.PerHour(5))
	if err != nil {
		return fmt.Errorf("TSomething went wrong: %v", err)
	}

	if res.Remaining == 0 {
		return errors.New("Limit exceeded")
	}
	return nil
}
