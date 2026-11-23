-- Real data: 2026 Vision Cup (2026願景盃), Taipei, 2026-11-15
-- Amateur Open Latin, semi-final. Couple 56: eliminated with 27 callbacks (lowest qualifier: 63).
-- Names are replaced with codes because this repo is public. Judges keep their panel codes (J2, J3...).
-- Only 22 of the 27 callbacks are listed: the judges below J33 were not captured, so 5 callbacks are missing.
-- Run after schema.sql (seed.sql optional).

INSERT INTO dancer (name_en, role) VALUES ('Dancer H', 'leader'), ('Partner P1', 'follower');
INSERT INTO couple (leader_id, follower_id, started_on) SELECT l.dancer_id, f.dancer_id, '2026-01-01'
  FROM dancer l, dancer f WHERE l.name_en = 'Dancer H' AND f.name_en = 'Partner P1';  -- start date approximate

INSERT INTO competition (name, city, held_on) VALUES ('2026 Vision Cup', 'Taipei', '2026-11-15');
INSERT INTO event (competition_id, name) SELECT competition_id, 'Amateur Open Latin' FROM competition WHERE name = '2026 Vision Cup';
INSERT INTO round (event_id, name, round_no) SELECT event_id, 'Semi-final', 1 FROM event WHERE name = 'Amateur Open Latin';  -- earlier rounds not recorded

INSERT INTO judge (name) VALUES ('J2'), ('J3'), ('J4'), ('J5'), ('J10'), ('J11'), ('J15'), ('J18'), ('J21'), ('J26'), ('J28'), ('J29'), ('J30'), ('J33');

INSERT INTO callback_mark (round_id, judge_id, couple_id, dance)
SELECT r.round_id, j.judge_id, c.couple_id, v.dance
FROM (VALUES
  ('J2', 'cha_cha'),
  ('J2', 'rumba'),
  ('J2', 'paso_doble'),
  ('J2', 'jive'),
  ('J5', 'paso_doble'),
  ('J11', 'cha_cha'),
  ('J11', 'samba'),
  ('J11', 'rumba'),
  ('J11', 'paso_doble'),
  ('J11', 'jive'),
  ('J18', 'cha_cha'),
  ('J18', 'jive'),
  ('J21', 'cha_cha'),
  ('J21', 'samba'),
  ('J21', 'rumba'),
  ('J21', 'paso_doble'),
  ('J21', 'jive'),
  ('J26', 'samba'),
  ('J26', 'jive'),
  ('J30', 'samba'),
  ('J30', 'rumba'),
  ('J30', 'paso_doble')
) AS v(judge, dance)
JOIN judge j ON j.name = v.judge
JOIN round r ON r.name = 'Semi-final'
JOIN event e ON e.event_id = r.event_id AND e.name = 'Amateur Open Latin'
JOIN couple c ON c.leader_id = (SELECT dancer_id FROM dancer WHERE name_en = 'Dancer H');

-- Overall result: eliminated in the semi-final with 27 callbacks (no place given)
INSERT INTO round_result (round_id, couple_id, place, total)
SELECT r.round_id, c.couple_id, NULL, 27
FROM round r
JOIN event e ON e.event_id = r.event_id AND e.name = 'Amateur Open Latin'
JOIN couple c ON c.leader_id = (SELECT dancer_id FROM dancer WHERE name_en = 'Dancer H')
WHERE r.name = 'Semi-final';
