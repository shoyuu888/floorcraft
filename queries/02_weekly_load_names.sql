-- Q2: same weekly load as Q1, showing dancer names (JOIN dancer)
SELECT d.name_en, SUM(rpe * duration_min) AS srpe
FROM training_session t JOIN dancer d ON d.dancer_id = t.dancer_id
WHERE trained_on BETWEEN '2026-09-20' AND '2026-09-26'
GROUP BY d.name_en
ORDER BY srpe DESC;
