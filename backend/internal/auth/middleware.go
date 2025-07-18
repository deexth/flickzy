package auth

import (
	"context"
	"flickzy/internal/user"
	"log"
	"net/http"
	"strings"
	"time"

	"github.com/gin-gonic/gin"
)

func Middleware(ctx *gin.Context) {
	reqHeader := ctx.Request.Header.Get("Authorization")
	if reqHeader == "" {
		ctx.AbortWithStatusJSON(http.StatusUnauthorized, gin.H{
			"Error": "Unauthorized header",
		})
		return
	}

	parts := strings.Fields(reqHeader)
	if len(parts) != 2 || strings.ToLower(parts[0]) != "bearer" {
		ctx.AbortWithStatusJSON(http.StatusUnauthorized, gin.H{
			"error": "unauthorized header",
		})
		return
	}

	reqCtx, cancel := context.WithTimeout(ctx.Request.Context(), 2*time.Second)
	defer cancel()

	apiKey := parts[1]

	userData, err := user.GetUserByToken(reqCtx, apiKey)
	if err != nil {
		log.Printf("Auth attempt: key=%s, success=%v, error=%v", apiKey, err == nil, err)
		ctx.AbortWithStatusJSON(http.StatusUnauthorized, gin.H{
			"error": "unauthorized header",
		})
		return
	}

	ctx.Set("data", userData)
	ctx.Next()

}
