SELECT "players"."first_name","players"."last_name","salaries"."salary","performances"."HR","salaries"."year" FROM "players"
JOIN "performances" ON "players"."id" = "performances"."player_id" AND  "performances"."year" = "salaries"."year"
JOIN "salaries" ON "players"."id" = "salaries"."player_id"
ORDER BY
"players"."id" ASC,
"performances"."year" DESC,
"performances"."HR" DESC,
"salaries"."salary" DESC;
