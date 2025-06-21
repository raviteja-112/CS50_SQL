SELECT "salary" FROM "salaries"
JOIN "performances" ON "performances"."player_id" = "salaries"."player_id"
WHERE "performances"."HR" = (
SELECT MAX("HR") FROM "performances"
WHERE "year" = 2001) AND
"salaries"."year" = 2001;
