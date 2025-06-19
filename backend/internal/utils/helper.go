package utils

import (
	"fmt"
)

type Token struct {
	APIToken    string
	AccessToken string
}

func GetTokens(email string, id string) (Token, error) {
	secretKey, err := getSecret()
	if err != nil {
		return Token{}, err
	}

	apiToken, err := GenerateToken(email, id, secretKey, 720)
	if err != nil {
		return Token{}, err
	}

	accToken, err := GenerateToken(email, id, secretKey, 24)
	if err != nil {
		return Token{}, fmt.Errorf("Issue creating access token: %w", err)
	}

	return Token{
		APIToken:    apiToken,
		AccessToken: accToken,
	}, nil

}
