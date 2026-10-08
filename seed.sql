-- Fictional sample data (not real people) for practising queries.
-- Load after schema.sql:  psql -f schema.sql -f seed.sql

INSERT INTO dancer (name_en, name_ja, role) VALUES
    ('Ken Sato',   '佐藤 健',   'leader'),
    ('Mika Ito',   '伊藤 美香', 'follower'),
    ('Leo Chen',   '陳 力',     'leader'),
    ('Aya Mori',   '森 彩',     'follower');

INSERT INTO couple (leader_id, follower_id, started_on, ended_on) VALUES
    (1, 2, '2024-04-01', NULL),
    (3, 4, '2025-01-15', NULL);

INSERT INTO competition (name, city, held_on) VALUES
    ('Kanto Open', 'Tokyo', '2026-09-27');

INSERT INTO event (competition_id, name) VALUES (1, 'Adult Latin');

INSERT INTO round (event_id, name, round_no) VALUES
    (1, 'Semi-final', 1),
    (1, 'Final',      2);

INSERT INTO judge (name, country) VALUES
    ('Judge A', 'JP'), ('Judge B', 'JP'), ('Judge C', 'KR');

-- Semi-final callbacks: a row means the judge gave a callback in that dance
INSERT INTO callback_mark (round_id, judge_id, couple_id, dance)
SELECT 1, j, c, d
FROM generate_series(1, 3) AS j,
     generate_series(1, 2) AS c,
     unnest(ARRAY['samba', 'cha_cha', 'rumba', 'paso_doble', 'jive']) AS d
WHERE NOT (c = 2 AND j = 3 AND d IN ('rumba', 'jive'));

-- Final placings (2 couples shown)
INSERT INTO placement_mark (round_id, judge_id, couple_id, dance, place)
SELECT 2, j, c, d,
       CASE WHEN (c = 1) = (j <> 2 OR d = 'jive') THEN 1 ELSE 2 END
FROM generate_series(1, 3) AS j,
     generate_series(1, 2) AS c,
     unnest(ARRAY['samba', 'cha_cha', 'rumba', 'paso_doble', 'jive']) AS d;

-- Four weeks of training for every dancer, heavier in the week before the competition
INSERT INTO training_session (dancer_id, trained_on, type, duration_min, rpe)
SELECT d.dancer_id,
       day::date,
       CASE WHEN EXTRACT(dow FROM day) IN (2, 4) THEN 'fitness' ELSE 'dance' END,
       CASE WHEN day >= '2026-09-20' THEN 120 ELSE 90 END - (d.dancer_id * 5),
       LEAST(10, CASE WHEN day >= '2026-09-20' THEN 7 ELSE 5 END + (d.dancer_id % 2)
                 + (EXTRACT(dow FROM day)::int % 2))
FROM dancer d,
     generate_series('2026-08-31'::date, '2026-09-26'::date, '1 day') AS day
WHERE EXTRACT(dow FROM day) <> 0;

INSERT INTO training_session (dancer_id, trained_on, type, duration_min, rpe)
SELECT dancer_id, '2026-09-27', 'competition', 240, 9 FROM dancer;

-- Daily wellness check-ins; fatigue and soreness rise in the heavy week
INSERT INTO wellness (dancer_id, recorded_on, sleep, fatigue, soreness, stress, mood)
SELECT d.dancer_id,
       day::date,
       CASE WHEN day >= '2026-09-20' THEN 2 ELSE 4 END,
       CASE WHEN day >= '2026-09-20' THEN 4 ELSE 2 END + (d.dancer_id % 2),
       CASE WHEN day >= '2026-09-20' THEN 4 ELSE 2 END,
       CASE WHEN day >= '2026-09-24' THEN 4 ELSE 2 END,
       CASE WHEN day >= '2026-09-20' THEN 3 ELSE 4 END
FROM dancer d,
     generate_series('2026-08-31'::date, '2026-09-27'::date, '1 day') AS day;
