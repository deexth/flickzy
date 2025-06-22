package utils

import (
	"crypto/rand"
	"math/big"
)

func GenerateOTP() (string, error) {
	const otpLength = 6
	const digits = "0123456789"
	otp := ""

	for i := 0; i < otpLength; i++ {
		n, err := rand.Int(rand.Reader, big.NewInt(int64(len(digits))))
		if err != nil {
			return "", err
		}
		otp += string(digits[n.Int64()])
	}
	return otp, nil
}
