# Start from the official Golang image
FROM golang:1.24-alpine AS builder

WORKDIR /app

# Copy go mod and sum files
COPY go.mod go.sum ./
RUN go mod download

# Copy the source code
COPY . .

# Build the Go app
RUN go build -o flickzy

# Use a minimal image for running
FROM alpine:3.20

WORKDIR /app

# Copy the built binary from builder
COPY --from=builder /app/flickzy .
# Copy .env file if needed
COPY .env .

# Expose the port (change if needed)
EXPOSE 8080

# Run the binary
CMD ["./flickzy"]