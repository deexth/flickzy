package utils

import (
	"fmt"
	"os"
	"strconv"
	"time"

	"github.com/golang-jwt/jwt/v5"
)

type jwtMaker struct {
	secretKey []byte
}

// func NewJWTMaker(secretKey string) jwtMaker {
// 	return jwtMaker{
// 		secretKey: secretKey,
// 	}
// }

type UserClaims struct {
	Iss    string
	Sub    string
	Sub_id int64
	Exp    jwt.NumericDate
	Iat    jwt.NumericDate
}

func (maker *jwtMaker) GenerateToken(email string, userId int64) (string, error) {
	tClaims := jwt.NewWithClaims(jwt.SigningMethodHS256, jwt.MapClaims{
		"iss":    "flickzy",
		"sub":    email,
		"sub_id": userId,
		"exp":    jwt.NewNumericDate(time.Now().Add(time.Hour)),
		"iat":    jwt.NewNumericDate(time.Now()),
	})

	tokenStr, err := tClaims.SignedString(maker.secretKey)
	if err != nil {
		return "", fmt.Errorf("Issue signing token: %v", err)
	}

	return tokenStr, nil
}

func (maker *jwtMaker) VerifyToken(token string) (UserClaims, error) {
	parsedToken, err := jwt.Parse(token, func(t *jwt.Token) (interface{}, error) {
		if _, ok := t.Method.(*jwt.SigningMethodHMAC); !ok {
			return nil, fmt.Errorf("Invalid token signing method")
		}
		return maker.secretKey, nil
	})
	if err != nil {
		return UserClaims{}, fmt.Errorf("Invalid credentials, %v", err)
	}

	if !parsedToken.Valid {
		return UserClaims{}, fmt.Errorf("Invalid token")
	}

	claims, ok := parsedToken.Claims.(jwt.MapClaims)
	if !ok {
		return UserClaims{}, fmt.Errorf("Unable to parse claims")
	}

	if exp, ok := claims["exp"].(float64); ok {
		if time.Unix(int64(exp), 0).Before(time.Now()) {
			return UserClaims{}, fmt.Errorf("token has expired")
		}
	}

	userClaims := UserClaims{
		Iss:    claims["iss"].(string),
		Sub:    claims["sub"].(string),
		Sub_id: int64(claims["sub_id"].(float64)),
		Exp:    jwt.NumericDate{Time: time.Unix(int64(claims["exp"].(float64)), 0)},
		Iat:    jwt.NumericDate{Time: time.Unix(int64(claims["iat"].(float64)), 0)},
	}

	return userClaims, nil
}

func NewSecret() (*jwtMaker, error) {
	jwtSecr := os.Getenv("JWT_SECRET")
	if jwtSecr == "" {
		return nil, fmt.Errorf("No secret key found")
	}

	_, err := strconv.ParseBool(jwtSecr)
	if err != nil {
		return nil, fmt.Errorf("Invalid secret key format: %v", err)
	}

	return &jwtMaker{secretKey: []byte(jwtSecr)}, nil
}

func getRole(email string) string {
	return ""
}
