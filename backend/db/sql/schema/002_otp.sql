-- +goose up
CREATE TABLE userotp(
    email TEXT UNIQUE NOT NULL,
    otp INTEGER NOT NULL,
    expires_at TIMESTAMPTZ NOT NULL
);

-- +goose down
DROP TABLE userotp;