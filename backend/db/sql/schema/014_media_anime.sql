-- +goose up
CREATE TABLE anime_details(
    media_id UUID NOT NULL,
    episodes INTEGER NOT NULL,
    seasons INTEGER NOT NULL,
    studio VARCHAR(64),
    average_duration_per_episode INTEGER NOT NULL,
    FOREIGN KEY (media_id) REFERENCES media(id)
);

-- +goose down
DROP TABLE anime_details;