package utils

import (
	"context"
	"fmt"
	"os"
	"strings"
	"time"

	"github.com/resend/resend-go/v2"
)

func SendOTP(ctx context.Context, email string, otp string) error {
	ctx, cancel := context.WithTimeout(ctx, 5*time.Second)
	defer cancel()

	apiKey, err := getSecretMailSend()
	if err != nil {
		return err
	}

	client := resend.NewClient(apiKey)

	htmlBody := strings.ReplaceAll(htmlTemp, "{{ OTP_CODE }}", otp)
	htmlBody = strings.ReplaceAll(htmlBody, "{{ YEAR }}", fmt.Sprintf("%d", time.Now().Year()))

	params := &resend.SendEmailRequest{
		From:    "onboarding@resend.dev",
		To:      []string{email},
		Subject: "Your OTP Code",
		Html:    htmlBody,
	}

	_, err = client.Emails.SendWithContext(ctx, params)
	if err != nil {
		return err
	}

	return nil
}

func getSecretMailSend() (string, error) {
	maisendApi := os.Getenv("RESEND_API")
	if maisendApi == "" {
		return "", fmt.Errorf("No API found for mail send")
	}

	return maisendApi, nil
}

var htmlTemp = `
<!DOCTYPE html>
<html lang="en" style="margin: 0; padding: 0; font-family: 'Segoe UI', sans-serif;">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Your Flickzy OTP Code</title>
</head>
<body style="margin: 0; padding: 0; background-color: #f6f9fc;">
    <table width="100%" cellpadding="0" cellspacing="0" style="background-color: #f6f9fc; padding: 30px 0;">
        <tr>
            <td align="center">
                <table width="100%" max-width="600" cellpadding="0" cellspacing="0" style="background-color: #ffffff; border-radius: 8px; box-shadow: 0 4px 12px rgba(0,0,0,0.1); padding: 40px; text-align: center;">
                    <tr>
                        <td style="padding-bottom: 20px;">
                            <!-- LOGO PLACEHOLDER -->
                            <img src="cid:flickzy-logo" alt="Flickzy Logo" width="120" style="margin-bottom: 10px;" />
                        </td>
                    </tr>

                    <tr>
                        <td>
                            <h2 style="color: #333; font-size: 24px; margin: 0 0 10px;">Your One-Time Code</h2>
                            <p style="color: #555; font-size: 16px; margin-bottom: 30px;">
                                Use the following code to continue your session on <strong>Flickzy</strong>.
                            </p>
                        </td>
                    </tr>

                    <tr>
                        <td>
                            <div style="background-color: #f1f5f9; border-radius: 6px; padding: 20px; display: inline-block; font-size: 32px; letter-spacing: 8px; color: #111; font-weight: bold;">
                                {{ OTP_CODE }}
                            </div>
                        </td>
                    </tr>

                    <tr>
                        <td style="padding-top: 30px;">
                            <p style="color: #777; font-size: 14px; margin-bottom: 8px;">
                                This code will expire in 10 minutes.
                            </p>
                            <p style="color: #999; font-size: 13px;">
                                If you did not request this, you can safely ignore this email.
                            </p>
                        </td>
                    </tr>

                    <tr>
                        <td style="padding-top: 40px;">
                            <p style="color: #bbb; font-size: 12px;">
                                © {{ YEAR }} Flickzy. All rights reserved.
                            </p>
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
    </table>
</body>
</html>
`
