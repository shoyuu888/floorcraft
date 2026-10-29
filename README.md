# Floorcraft

**EN:** Floorcraft is a bilingual (Japanese / English) data app for Latin DanceSport couples. It brings competition results, judges' marks and training load (sRPE, ACWR) into one Postgres database, so a couple and their coach can see what actually moves their results.

**JA:** Floorcraft は、ラテン・ダンススポーツのカップル向けの日英バイリンガルなデータアプリです。競技結果、ジャッジの採点、トレーニング負荷（sRPE・ACWR）を一つの Postgres データベースにまとめ、カップルとコーチが「何が結果を左右しているか」を確かめられるようにします。

## Status
- [x] `dancer`, `couple`, `competition`, `event`, `round`, `judge`, `callback_mark`, `placement_mark`, `training_session`, `wellness` tables (schema complete)
- [x] Fictional sample data (`seed.sql`) and first queries (`queries/`)
- [ ] Nov 2026: result queries on sample data; import my own training log and compute sRPE
- [ ] Dec 2026: ACWR on sample data, then on my own log
- [ ] Ongoing to end of 2027: add each real competition within a week of dancing it

## Data
- `seed.sql` is fictional and stays fixed, so the example queries always give the same answers.
- Real data grows over time: one competition at a time, plus my own training log. Partner and other dancers' names are replaced with codes (P1, P2...) because this repo is public.

## Try it
```bash
psql -f schema.sql -f seed.sql   # seed.sql is fictional sample data
```
