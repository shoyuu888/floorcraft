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

-- judge: one row per adjudicator
CREATE TABLE judge (
    judge_id  SERIAL PRIMARY KEY,
    name      TEXT NOT NULL,
    country   TEXT
);

-- callback_mark: heats. A row exists only when the judge gave the couple a callback (✓) in that dance
CREATE TABLE callback_mark (
    round_id   INT  NOT NULL REFERENCES round(round_id),
    judge_id   INT  NOT NULL REFERENCES judge(judge_id),
    couple_id  INT  NOT NULL REFERENCES couple(couple_id),
    dance      TEXT NOT NULL CHECK (dance IN ('samba', 'cha_cha', 'rumba', 'paso_doble', 'jive')),
    PRIMARY KEY (round_id, judge_id, couple_id, dance)
);

-- placement_mark: final. One placing per judge, couple and dance
CREATE TABLE placement_mark (
    round_id   INT  NOT NULL REFERENCES round(round_id),
    judge_id   INT  NOT NULL REFERENCES judge(judge_id),
    couple_id  INT  NOT NULL REFERENCES couple(couple_id),
    dance      TEXT NOT NULL CHECK (dance IN ('samba', 'cha_cha', 'rumba', 'paso_doble', 'jive')),
    place      INT  NOT NULL CHECK (place BETWEEN 1 AND 8),
    PRIMARY KEY (round_id, judge_id, couple_id, dance)
);

-- training_session: one row per dancer per session. Session load (sRPE) = rpe * duration_min, computed in queries
CREATE TABLE training_session (
    session_id    SERIAL PRIMARY KEY,
    dancer_id     INT  NOT NULL REFERENCES dancer(dancer_id),
    trained_on    DATE NOT NULL,
    type          TEXT NOT NULL CHECK (type IN ('dance', 'fitness', 'competition')),
    duration_min  INT  NOT NULL CHECK (duration_min > 0),
    rpe           INT  NOT NULL CHECK (rpe BETWEEN 0 AND 10)
);
