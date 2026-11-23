-- Real data: 2026 CYO CUP, Chiayi, 2026-11-22
-- World Amateur Open Latin, final. Couple 10: 7th of 8, total 35 (sum of places across the 5 dances).
-- Per-judge placings were no longer viewable, so only the overall result is stored (round_result).
-- Run after schema.sql and data/real/2026-11-15_vision_cup.sql (which adds Dancer H / Partner P1 and their couple).

INSERT INTO competition (name, city, held_on) VALUES ('2026 CYO CUP', 'Chiayi', '2026-11-22');
INSERT INTO event (competition_id, name) SELECT competition_id, 'World Amateur Open Latin' FROM competition WHERE name = '2026 CYO CUP';
INSERT INTO round (event_id, name, round_no) SELECT event_id, 'Final', 1 FROM event WHERE name = 'World Amateur Open Latin';  -- earlier rounds not recorded

INSERT INTO round_result (round_id, couple_id, place, total)
SELECT r.round_id, c.couple_id, 7, 35
FROM round r
JOIN event e ON e.event_id = r.event_id AND e.name = 'World Amateur Open Latin'
JOIN couple c ON c.leader_id = (SELECT dancer_id FROM dancer WHERE name_en = 'Dancer H')
WHERE r.name = 'Final';
