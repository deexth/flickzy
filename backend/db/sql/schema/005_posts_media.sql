-- +goose up
CREATE TABLE post_media(
    id UUID PRIMARY KEY,
    post_id UUID NOT NULL,
    media_type TEXT NOT NULL, -- 'image', 'video', 'gif'
    media_url TEXT NOT NULL,  -- Stored link to S3/DO Spaces
    thumbnail_url TEXT,       -- Optional, for videos
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    FOREIGN KEY (post_id) REFERENCES posts(id) ON DELETE CASCADE
);

-- +goose down
DROP TABLE post_media;