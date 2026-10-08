-- Q1: total training load (sRPE) per dancer in the week before the Kanto Open
SELECT dancer_id, SUM(rpe * duration_min) AS srpe
FROM training_session
WHERE trained_on BETWEEN '2026-09-20' AND '2026-09-26'
GROUP BY dancer_id
ORDER BY  srpe DESC;
