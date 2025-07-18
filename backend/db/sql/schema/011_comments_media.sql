-- +goose up
CREATE TABLE comments_media(
    id UUID PRIMARY KEY,
    comment_id UUID NOT NULL,
    media_url TEXT NOT NULL,  -- Stored link to S3/DO Spaces
    thumbnail_url TEXT,       -- Optional, for videos
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    FOREIGN KEY (comment_id) REFERENCES comments(id) ON DELETE CASCADE
);

-- +goose down
DROP TABLE comments_media;