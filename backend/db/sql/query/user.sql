-- name: CreateUser :one
INSERT INTO users(
    id, email, created_at, updated_at, api_token, username
)VALUES(
    $1, $2, $3, $4, $5, $6
)
RETURNING *;

-- name: HandleOTP :one
INSERT INTO userotp(
    id, email, expires_at, otp
)VALUES(
    $1, $2, $3, $4
)
RETURNING *;

-- name: GetUserByOTP :one
SELECT * FROM userotp WHERE email=$1 AND otp=$2;

-- name: GetUserByEmail :one
SELECT id, email, created_at, updated_at, api_token FROM users WHERE email=$1;

-- name: GetUserByToken :one
SELECT id, email, created_at, updated_at, api_token FROM users WHERE api_token=$1;

-- name: UpdateApiToken :execresult
UPDATE users SET api_token = $1 WHERE email = $2;

-- name: UpdateUserEmail :execresult
UPDATE users SET email = $1, updated_at = $2 WHERE email = $3;

-- name: DeleteUser :execresult
DELETE FROM users WHERE id = $1 AND username=$2;

-- name: DeleteUserOTP :execresult
DELETE FROM userotp WHERE email = $1 AND otp=$2;