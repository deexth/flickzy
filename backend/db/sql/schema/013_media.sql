-- +goose up
CREATE TABLE media(
    id UUID PRIMARY KEY;
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    title TEXT NOT NULL,
    description TEXT NOT NULL,
    cover_url TEXT NOT NULL,
    genres JSONB NOT NULL,
    tags JSONB NOT NULL,
    status VARCHAR(24),
    external_links JSONB,
    release_year INTEGER NOT NULL
);

-- +goose down
DROP TABLE media;