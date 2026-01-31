package errors

import (
	"errors"
	"net/http"

	"github.com/gin-gonic/gin"
)

// Custom error types
var (
	ErrUserAlreadyExists = errors.New("user already exists")
	ErrInvalidCredentials = errors.New("invalid credentials")
	ErrUserNotVerified   = errors.New("user not verified")
	ErrInvalidToken      = errors.New("invalid token")
	ErrOTPExpired        = errors.New("OTP expired")
	ErrOTPInvalid        = errors.New("invalid OTP")
	ErrTooManyAttempts   = errors.New("too many attempts")
	ErrNotFound          = errors.New("resource not found")
	ErrUnauthorized      = errors.New("unauthorized")
	ErrForbidden         = errors.New("forbidden")
)

// ErrorResponse represents an error response
// @Description Error response structure
type ErrorResponse struct {
	Error   string `json:"error" example:"Bad Request"`
	Message string `json:"message,omitempty" example:"Invalid input data"`
}

// HandleError handles errors and returns appropriate HTTP responses
func HandleError(c *gin.Context, err error) {
	statusCode := http.StatusInternalServerError
	message := err.Error()

	switch err {
	case ErrUserAlreadyExists:
		statusCode = http.StatusConflict
	case ErrInvalidCredentials:
		statusCode = http.StatusUnauthorized
	case ErrUserNotVerified:
		statusCode = http.StatusForbidden
	case ErrInvalidToken, ErrUnauthorized:
		statusCode = http.StatusUnauthorized
	case ErrForbidden:
		statusCode = http.StatusForbidden
	case ErrOTPExpired, ErrOTPInvalid:
		statusCode = http.StatusBadRequest
	case ErrTooManyAttempts:
		statusCode = http.StatusTooManyRequests
	case ErrNotFound:
		statusCode = http.StatusNotFound
	}

	c.JSON(statusCode, ErrorResponse{
		Error:   http.StatusText(statusCode),
		Message: message,
	})
}

// HandleErrorWithMessage handles errors with a custom message
func HandleErrorWithMessage(c *gin.Context, statusCode int, message string) {
	c.JSON(statusCode, ErrorResponse{
		Error:   http.StatusText(statusCode),
		Message: message,
	})
}

