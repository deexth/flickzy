-- name: CreateComment :one
INSERT INTO comments(
    id, description, created_at, published_at, likes, blob, user_id, post_id
)VALUES(
    $1, $2, $3, $4, $5, $6, $7, $8
)
RETURNING *;

-- name: GetComments :many
SELECT * FROM comments WHERE post_id=$1;

-- name: DeleteComment :execresult
DELETE FROM comments WHERE id=$1 AND user_id=$2 AND post_id=$3;