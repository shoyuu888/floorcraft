-- Floorcraft schema

-- dancer: one row per dancer
CREATE TABLE dancer (
    dancer_id   SERIAL PRIMARY KEY,
    name_en     TEXT NOT NULL,
    name_ja     TEXT,
    birth_date  DATE,
    role        TEXT NOT NULL CHECK (role IN ('leader', 'follower')),
    created_at  TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- couple: one row per partnership; a partner change ends the old row and adds a new one
CREATE TABLE couple (
    couple_id    SERIAL PRIMARY KEY,
    leader_id    INT NOT NULL REFERENCES dancer(dancer_id),
    follower_id  INT NOT NULL REFERENCES dancer(dancer_id),
    started_on   DATE NOT NULL,
    ended_on     DATE,
    CHECK (leader_id <> follower_id),
    CHECK (ended_on IS NULL OR ended_on >= started_on)
);
