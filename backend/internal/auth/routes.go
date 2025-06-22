package auth

import "github.com/gin-gonic/gin"

func RegisteredRoutes(route *gin.Engine) {
	v1 := route.Group("/v1")
	v1.POST("/sendOTP", login_register)
	v1.POST("/authUser", verifyOTP)
}
