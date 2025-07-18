-- name: CreatePost :one
INSERT INTO posts(
    id, description, created_at, published_at, likes, blob, user_id, sharecount, repost
)VALUES(
    $1, $2, $3, $4, $5, $6, $7, $8, $9
)
RETURNING *;

-- name: GetUserPosts :many
SELECT * FROM posts WHERE user_id=$1;

-- name: GetPosts :many
SELECT * FROM posts;

-- name: DeletePost :execresult
DELETE FROM posts WHERE id=$1 AND user_id=$2;