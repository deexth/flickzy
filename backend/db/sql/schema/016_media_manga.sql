-- +goose up
CREATE TABLE music_details(
    media_id UUID NOT NULL,
    volumes INTEGER NOT NULL,
    chapters INTEGER NOT NULL,
    author VARCHAR(64) NOT NULL,
    serialization VARCHAR(64) NOT NULL,
    FOREIGN KEY (media_id) REFERENCES media(id)
);

-- +goose down
DROP TABLE music_details;