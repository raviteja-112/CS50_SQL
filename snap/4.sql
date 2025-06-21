SELECT "users"."username"
FROM "users"
JOIN "messages" ON "users"."id" = "messages"."to_user_id"
GROUP BY "users"."id"
ORDER BY COUNT("messages"."id") DESC
LIMIT 1;
