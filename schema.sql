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

-- competition: one row per competition (e.g. a national championship)
CREATE TABLE competition (
    competition_id  SERIAL PRIMARY KEY,
    name            TEXT NOT NULL,
    city            TEXT,
    held_on         DATE NOT NULL
);

-- event: one row per event inside a competition (e.g. Adult Latin)
CREATE TABLE event (
    event_id        SERIAL PRIMARY KEY,
    competition_id  INT NOT NULL REFERENCES competition(competition_id),
    name            TEXT NOT NULL
);

-- round: one row per round inside an event (e.g. quarter-final, final)
CREATE TABLE round (
    round_id  SERIAL PRIMARY KEY,
    event_id  INT NOT NULL REFERENCES event(event_id),
    name      TEXT NOT NULL,
    round_no  INT NOT NULL CHECK (round_no > 0),
    UNIQUE (event_id, round_no)
);
