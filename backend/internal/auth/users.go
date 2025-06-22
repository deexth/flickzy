package auth

import (
	"flickzy/internal/user"
	"net/http"

	"github.com/gin-gonic/gin"
)

func login_register(ctx *gin.Context) {
	reqCtx := ctx.Request.Context()

	var user user.UserIn
	if err := ctx.ShouldBindJSON(&user); err != nil {
		ctx.JSON(http.StatusBadRequest, gin.H{
			"Error": "Something went wrong",
			"issue": err.Error(),
		})
		return
	}

	if err := user.CreateOTP(reqCtx); err != nil {
		ctx.JSON(http.StatusInternalServerError, gin.H{
			"Error": "Internal server error",
			"issue": err.Error(),
		})
		return
	}

	ctx.JSON(http.StatusOK, "OTP sent")
}

func verifyOTP(ctx *gin.Context) {
	reqCtx := ctx.Request.Context()

	var user user.UserIn
	if err := ctx.ShouldBindJSON(&user); err != nil {
		ctx.JSON(http.StatusBadRequest, gin.H{
			"Error": "Something went wrong",
			"issue": err.Error(),
		})
		return
	}

	if err := user.VerifyOTP(reqCtx); err != nil {
		ctx.JSON(http.StatusInternalServerError, gin.H{
			"Error": "Invalid OTP",
			"issue": err.Error(),
		})
		return
	}

	id, err := user.GetUser(reqCtx)
	if err != nil {
		user, errN := user.NewUser(reqCtx)
		if errN != nil {
			ctx.JSON(http.StatusInternalServerError, gin.H{
				"Error": "Internal server error",
				"issue": errN.Error(),
			})
			return
		}

		ctx.JSON(http.StatusCreated, gin.H{
			"Status": "Successfully registered",
			"User":   user,
		})
		return
	}

	LoggedInUser, err := user.UpdateTokens(reqCtx, id)
	if err != nil {
		ctx.JSON(http.StatusInternalServerError, gin.H{
			"Error": "Internal server error",
			"issue": err.Error(),
		})
		return
	}

	ctx.JSON(http.StatusOK, gin.H{
		"Status": "Loged in successfully",
		"Token":  LoggedInUser.APItoken,
	})
}
