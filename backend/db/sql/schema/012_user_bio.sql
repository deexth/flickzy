-- +goose up 
CREATE TABLE user_bio(
    id PRIMARY KEY,
    user_id UUID NOT NULL,
    about TEXT,
    followers INTEGER DEFAULT 0,
    following INTEGER DEFAULT 1, -- by default the user follows flickzy
    likes INTEGER DEFAULT 0,
    feeds INTEGER DEFAULT 0,
    posts INTEGER DEFAULT 0,
    profile_image_url TEXT NOT NULL,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
);

-- +goose down
DROP TABLE user_bio;