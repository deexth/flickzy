# Stage 1: Build the Go binary
FROM golang:1.24-alpine3.22 AS builder

WORKDIR /app

COPY go.mod go.sum ./
RUN go mod download

COPY . .

RUN go build -o app .

# Stage 2: Minimal runtime image
FROM alpine:3.22

RUN adduser -D appuser

WORKDIR /app

COPY --from=builder /app/app .

RUN chown -R appuser:appuser /app

USER appuser

EXPOSE 8080

CMD ["./app"]
