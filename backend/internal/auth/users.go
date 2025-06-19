package auth

import (
	"flickzy/internal/user"
	"net/http"

	"github.com/gin-gonic/gin"
)

func register(ctx *gin.Context) {
	// Change this, return only email and instead return the full user in verifyOTP
	// This will just check email
	reqCtx := ctx.Request.Context()

	var userInput user.UserIn
	if err := ctx.ShouldBindJSON(userInput); err != nil {
		ctx.JSON(http.StatusBadRequest, gin.H{
			"Error": "Something went wrong",
		})
		return
	}

	user, err := userInput.NewUser(reqCtx)
	if err != nil {
		ctx.JSON(http.StatusInternalServerError, gin.H{
			"Error": "Internal server error",
		})
		return
	}

	ctx.JSON(http.StatusCreated, gin.H{
		"User": user,
	})
}

func login(ctx *gin.Context) {
	// Only check email and to the rest in VerifyOTP
	reqCtx := ctx.Request.Context()

	var userInput user.UserIn
	if err := ctx.ShouldBindJSON(userInput); err != nil {
		ctx.JSON(http.StatusBadRequest, gin.H{
			"Error": "Something went wrong",
		})
		return
	}

	user, err := userInput.CheckUserEmail(reqCtx)
	if err != nil {
		ctx.JSON(http.StatusInternalServerError, gin.H{
			"Error": "Something went wrong",
		})
		return
	}

	ctx.JSON(http.StatusOK, gin.H{
		"Status": "Login successful",
		"User":   user,
	})
}

func deleteAccount(ctx *gin.Context) {}
func updateEmail(ctx *gin.Context)   {}
func logout(ctx *gin.Context)        {}
func verifyOTP(ctx *gin.Context) {
	// Return full user
	// Generate the token and other crucial settings
}
