-- +goose up
CREATE TABLE feeds(
    id UUID PRIMARY KEY,
    user_id UUID NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    name VARCHAR(64) NOT NULL UNIQUE,
    subscribers INTEGER NOT NULL DEFAULT 0,
    description TEXT NOT NULL,
    url TEXT NOT NULL UNIQUE,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- +goose down
DROP TABLE feed;