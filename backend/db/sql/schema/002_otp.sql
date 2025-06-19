-- +goose up
CREATE TABLE userotp(
    id UUID NOT NULL PRIMARY KEY,
    email TEXT UNIQUE NOT NULL,
    otp INTEGER NOT NULL,
    expires_at TIMESTAMPTZ NOT NULL
);

-- +goose down
DROP TABLE userotp;