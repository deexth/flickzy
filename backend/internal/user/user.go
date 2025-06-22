package user

import (
	"context"
	"flickzy/db"
	"flickzy/db/database"
	"flickzy/internal/utils"
	"fmt"
	"strconv"
	"time"

	"github.com/google/uuid"
	"github.com/jackc/pgx/v5/pgtype"
)

type UserIn struct {
	Email    string `json:"email" binding:"required"`
	Otp      string `json:"otp"`
	Name     string `json:"name"`
	Username string `json:"username"`
}

type UserOut struct {
	Email       string    `json:"email"`
	Username    string    `json:"username"`
	Name        string    `json:"name"`
	CreatedAt   time.Time `json:"created_at"`
	UpdatedAt   time.Time `json:"updated_at"`
	APItoken    string    `json:"api_token"`
	AccessToken string    `json:"access_token"`
}

func (u *UserIn) NewUser(ctx context.Context) (UserOut, error) {
	id := uuid.New()
	token, err := utils.GetTokens(u.Email, id.String())
	if err != nil {
		return UserOut{}, err
	}

	params := database.CreateUserParams{
		ID:        pgtype.UUID{Bytes: id, Valid: true},
		Email:     u.Email,
		Username:  u.Username,
		ApiToken:  token.APIToken,
		CreatedAt: pgtype.Timestamptz{Time: time.Now(), Valid: true},
		UpdatedAt: pgtype.Timestamptz{Time: time.Now(), Valid: true},
	}

	user, err := db.DBQuery.CreateUser(ctx, params)
	if err != nil {
		return UserOut{}, fmt.Errorf("Issue adding the user to the DB: %v", err)
	}

	useCreated := UserOut{
		Email:       user.Email,
		Username:    user.Username,
		CreatedAt:   user.CreatedAt.Time,
		UpdatedAt:   user.UpdatedAt.Time,
		APItoken:    user.ApiToken,
		AccessToken: token.AccessToken,
	}

	return useCreated, nil
}

func (u *UserIn) CreateOTP(ctx context.Context) error {
	id := uuid.New()
	otp, err := utils.GenerateOTP()
	if err != nil {
		return fmt.Errorf("Issue generating otp: %v", err)
	}

	otpInt, err := strconv.ParseInt(otp, 10, 32)
	if err != nil {
		return fmt.Errorf("Issue parsing the string %s: %v", otp, err)
	}

	params := database.HandleOTPParams{
		ID:        pgtype.UUID{Bytes: id, Valid: true},
		Email:     u.Email,
		ExpiresAt: pgtype.Timestamptz{Time: time.Now().Add(10 * time.Minute), Valid: true},
		Otp:       int32(otpInt),
	}

	_, err = db.DBQuery.HandleOTP(ctx, params)
	if err != nil {
		return fmt.Errorf("Issue adding otp to db: %v", err)
	}

	delParams := database.DeleteUserOTPParams{
		Email: u.Email,
		Otp:   int32(otpInt),
	}

	if err := utils.SendOTP(u.Email, otp); err != nil {
		db.DBQuery.DeleteUserOTP(ctx, delParams)

		return err
	}

	return nil
}

func (u *UserIn) GetUser(ctx context.Context) (string, error) {
	user, err := db.DBQuery.GetUserByEmail(ctx, u.Email)
	if err != nil {
		return "", fmt.Errorf("Issue getting user from db: %v", err)
	}

	return user.ID.String(), nil
}

func (u *UserIn) VerifyOTP(ctx context.Context) error {
	otpInt, err := strconv.ParseInt(u.Otp, 10, 32)
	if err != nil {
		return fmt.Errorf("Issue parsing the string %s: %v", u.Otp, err)
	}

	params := database.GetUserByOTPParams{
		Email: u.Email,
		Otp:   int32(otpInt),
	}

	otpRecord, err := db.DBQuery.GetUserByOTP(ctx, params)
	if err != nil {
		return fmt.Errorf("Issue retieving the otp: %v", err)
	}
	if otpRecord.ExpiresAt.Time.Before(time.Now()) {
		return fmt.Errorf("OTP expired")
	}

	delParams := database.DeleteUserOTPParams{
		Email: u.Email,
		Otp:   int32(otpInt),
	}

	resCmd, err := db.DBQuery.DeleteUserOTP(ctx, delParams)
	if err != nil || resCmd.RowsAffected() < 1 {
		return fmt.Errorf("Issue deleting used otp, rows affected: %v, error: %v", resCmd.RowsAffected(), err)
	}

	return nil
}

func (u *UserIn) UpdateTokens(ctx context.Context, id string) (UserOut, error) {
	tokens, err := utils.GetTokens(u.Email, id)
	if err != nil {
		return UserOut{}, err
	}

	params := database.UpdateApiTokenParams{
		ApiToken: tokens.APIToken,
		Email:    u.Email,
	}

	api, err := db.DBQuery.UpdateApiToken(ctx, params)
	if err != nil || api.RowsAffected() < 1 {
		return UserOut{}, fmt.Errorf("Issue updating the token, rows updated: %d, error: %v", api.RowsAffected(), err)
	}

	user := UserOut{
		APItoken:    tokens.APIToken,
		AccessToken: tokens.AccessToken,
	}

	return user, nil
}
