SELECT "first_name","last_name","salary" FROM "players"
JOIN "salaries" ON "players"."id" = "salaries"."player_id"
WHERE "year" = 2001
ORDER BY "salary" ASC,"first_name" ASC,"last_name" ASC
LIMIT 50;
