-- +goose up
CREATE TABLE users(
    id UUID NOT NULL PRIMARY KEY,
    email TEXT NOT NULL UNIQUE,
    password TEXT,
    token VARCHAR(64) UNIQUE NOT NULL
);

-- +goose down
DROP TABLE users;