-- Q3: average fatigue per dancer in the heavy week before the Kanto Open
SELECT d.name_en, AVG(w.fatigue) AS avg_fat
FROM wellness w JOIN dancer d ON d.dancer_id = w.dancer_id
WHERE recorded_on BETWEEN '2026-09-20' AND '2026-09-26'
GROUP BY d.name_en
ORDER BY avg_fat DESC;
