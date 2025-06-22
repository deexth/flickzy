package utils

import (
	"fmt"
	"os"
	"time"

	"github.com/golang-jwt/jwt/v5"
)

type UserClaims struct {
	Email string `json:"sub"`
	ID    string `json:"sub_id"`
	jwt.RegisteredClaims
}

func GenerateToken(email string, userId string, secretKey []byte, lifetime int64) (string, error) {
	claims := UserClaims{
		Email: email,
		ID:    userId,
		RegisteredClaims: jwt.RegisteredClaims{
			Issuer:    "flickzy",
			ExpiresAt: jwt.NewNumericDate(time.Now().Add(time.Hour * time.Duration(lifetime))),
			IssuedAt:  jwt.NewNumericDate(time.Now()),
		},
	}
	token := jwt.NewWithClaims(jwt.SigningMethodHS256, claims)

	tokenStr, err := token.SignedString(secretKey)
	if err != nil {
		return "", fmt.Errorf("Issue signing token: %v", err)
	}

	return tokenStr, nil
}

func VerifyToken(tokenStr string, secretKey []byte) (*UserClaims, error) {
	token, err := jwt.ParseWithClaims(tokenStr, &UserClaims{}, func(t *jwt.Token) (interface{}, error) {
		if _, ok := t.Method.(*jwt.SigningMethodHMAC); !ok {
			return nil, fmt.Errorf("Unexpected signing method")
		}
		return secretKey, nil
	})
	if err != nil {
		return nil, fmt.Errorf("Invalid token: %v", err)
	}

	if !token.Valid {
		return nil, fmt.Errorf("Invalid token")
	}

	claims, ok := token.Claims.(*UserClaims)
	if !ok {
		return nil, fmt.Errorf("Invalid token claims or token expired")
	}

	return claims, nil
}

func getSecret() ([]byte, error) {
	jwtSecr := os.Getenv("JWT_SECRET")
	if jwtSecr == "" {
		return nil, fmt.Errorf("No secret key found")
	}

	return []byte(jwtSecr), nil
}

func getRole(email string) string {
	return ""
}
