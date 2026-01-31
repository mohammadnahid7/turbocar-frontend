package listing

import (
	"time"

	"github.com/google/uuid"
	"github.com/lib/pq"
)

// Constants for enums
const (
	CarStatusActive  = "active"
	CarStatusSold    = "sold"
	CarStatusExpired = "expired"
	CarStatusFlagged = "flagged"
	CarStatusDeleted = "deleted"

	CarConditionExcellent = "excellent"
	CarConditionGood      = "good"
	CarConditionFair      = "fair"

	TransmissionAutomatic = "automatic"
	TransmissionManual    = "manual"

	FuelTypePetrol   = "petrol"
	FuelTypeDiesel   = "diesel"
	FuelTypeElectric = "electric"
	FuelTypeHybrid   = "hybrid"
)

// Car represents the car listing model in the database
type Car struct {
	ID           uuid.UUID      `json:"id" db:"id"`
	SellerID     uuid.UUID      `json:"seller_id" db:"seller_id"`
	Title        string         `json:"title" db:"title"`
	Description  string         `json:"description" db:"description"`
	Make         string         `json:"make" db:"make"`
	Model        string         `json:"model" db:"model"`
	Year         int            `json:"year" db:"year"`
	Mileage      int            `json:"mileage" db:"mileage"`
	Price        float64        `json:"price" db:"price"`
	Condition    string         `json:"condition" db:"condition"`
	Transmission string         `json:"transmission" db:"transmission"`
	FuelType     string         `json:"fuel_type" db:"fuel_type"`
	Color        string         `json:"color" db:"color"`
	VIN          string         `json:"vin" db:"vin"`
	Images       pq.StringArray `json:"images" gorm:"type:text[]"`
	City         string         `json:"city" db:"city"`
	State        string         `json:"state" db:"state"`
	Latitude     float64        `json:"latitude" db:"-"`  // Computed from PostGIS
	Longitude    float64        `json:"longitude" db:"-"` // Computed from PostGIS
	Status       string         `json:"status" db:"status"`
	IsFeatured   bool           `json:"is_featured" db:"is_featured"`
	ViewsCount   int            `json:"views_count" db:"views_count"`
	CreatedAt    time.Time      `json:"created_at" db:"created_at"`
	UpdatedAt    time.Time      `json:"updated_at" db:"updated_at"`
	ExpiresAt    time.Time      `json:"expires_at" db:"expires_at"`

	// Joins/Extras
	SellerName   string  `json:"seller_name,omitempty" db:"seller_name"`
	SellerPhoto  string  `json:"seller_photo,omitempty" db:"seller_photo"`
	SellerRating float64 `json:"seller_rating,omitempty" db:"seller_rating"`
}
