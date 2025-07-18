-- +goose up
CREATE TABLE preferences(
    id UUID PRIMARY KEY,
    user_id UUID NOT NULL,
    preferred_media_types JSONB NOT NULL,
    preferred_genres JSONB NOT NULL,
    preferred_languages JSONB NOT NULL,
    notification_settings JSONB NOT NULL,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- +goose down
DROP TABLE preferences;