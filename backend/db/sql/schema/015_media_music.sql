-- +goose up
CREATE TABLE music_details(
    media_id UUID NOT NULL,
    track_count INTEGER NOT NULL,
    duration INTEGER NOT NULL,
    artist VARCHAR(64) NOT NULL,
    album VARCHAR(64) NOT NULL,
    FOREIGN KEY (media_id) REFERENCES media(id)
);

-- +goose down
DROP TABLE music_details;