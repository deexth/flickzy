package utils

import (
	"context"
	"fmt"
	"os"
	"time"

	"github.com/mailersend/mailersend-go"
)

func SendOTP(ctx context.Context, email string, otp string) error {
	ctx, cancel := context.WithTimeout(ctx, 5*time.Second)
	defer cancel()

	APIKey, err := getSecretMailSend()
	if err != nil {
		return err
	}

	ms := mailersend.NewMailersend(APIKey)

	subject := "Your OTP Code"

	from := mailersend.From{
		Name:  "Flickzy",
		Email: "info@flickzy.com",
	}

	recipients := []mailersend.Recipient{
		{
			// Name:  "Recipient",
			Email: email,
		},
	}

	personalization := []mailersend.Personalization{
		{
			Email: email,
			Data: map[string]interface{}{
				"YEAR":     "2025",
				"OTP_CODE": otp,
			},
		},
	}

	tags := []string{"foo", "bar"}

	message := ms.Email.NewMessage()

	message.SetFrom(from)
	message.SetRecipients(recipients)
	message.SetSubject(subject)
	message.SetTemplateID("x2p0347yq094zdrn")
	message.SetPersonalization(personalization)

	message.SetTags(tags)

	_, err = ms.Email.Send(ctx, message)
	if err != nil {
		return fmt.Errorf("Issue sending out otp mail: %w", err)
	}

	// fmt.Printf(res.Header.Get("X-Message-Id"))
	return nil
}

func getSecretMailSend() (string, error) {
	maisendApi := os.Getenv("MAIL_SEND_API")
	if maisendApi == "" {
		return "", fmt.Errorf("No API found for mail send")
	}

	return maisendApi, nil
}
