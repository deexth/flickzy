package user

import (
	"context"
	"flickzy/db"
	"flickzy/db/database"
	"flickzy/internal/utils"
	"fmt"
	"time"

	"github.com/google/uuid"
	"github.com/jackc/pgx/v5/pgtype"
)

type UserIn struct {
	Email string `json:"email" binding:"required"`
}

type UserOut struct {
	ID          uuid.UUID `json:"id"`
	Email       string    `json:"email"`
	APIToken    string    `json:"api_token"`
	CreatedAt   time.Time `json:"created_at"`
	UpdateAt    time.Time `json:"updated_at"`
	AccessToken string    `json:"access_token"`
}

func (e *UserIn) NewUser(ctx context.Context) (UserOut, error) {
	id := uuid.New()

	tokens, err := utils.GetTokens(e.Email, id.String())
	if err != nil {
		return UserOut{}, err
	}

	params := database.CreateUserParams{
		ID:        pgtype.UUID{Bytes: id, Valid: true},
		Email:     e.Email,
		CreatedAt: pgtype.Timestamptz{Time: time.Now(), Valid: true},
		UpdatedAt: pgtype.Timestamptz{Time: time.Now(), Valid: true},
		ApiToken:  tokens.APIToken,
	}

	user, err := db.DBQuery.CreateUser(ctx, params)
	if err != nil {
		return UserOut{}, fmt.Errorf("Issue creating user: %w", err)
	}

	createdUser := UserOut{
		ID:          user.ID.Bytes,
		Email:       user.Email,
		APIToken:    user.ApiToken,
		CreatedAt:   user.CreatedAt.Time,
		UpdateAt:    user.UpdatedAt.Time,
		AccessToken: tokens.AccessToken,
	}
	return createdUser, nil
}

func (e *UserIn) CheckUserEmail(ctx context.Context) (UserOut, error) {

	user, err := db.DBQuery.GetUserByEmail(ctx, e.Email)
	if err != nil {
		return UserOut{}, fmt.Errorf("Wrong email: %w", err)
	}

	// ----------------------
	// Send OTP and check it
	// ----------------------

	tokens, err := utils.GetTokens(e.Email, user.ID.String())
	if err != nil {
		return UserOut{}, err
	}

	return UserOut{
		ID:          user.ID.Bytes,
		Email:       user.Email,
		APIToken:    tokens.APIToken,
		CreatedAt:   user.CreatedAt.Time,
		UpdateAt:    user.UpdatedAt.Time,
		AccessToken: tokens.AccessToken,
	}, nil
}

func DeleteUser(ctx context.Context, userId uuid.UUID) {

}

func ChangeEmail(ctx context.Context) {

}

func VerifyOTP(ctx context.Context) {}
func CreateOTP(ctx context.Context) {}
