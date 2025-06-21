CREATE VIEW "frequently_reviewed" AS
SELECT "listings"."id","property_type","host_name",COUNT("comments") AS "review_count"
FROM "listings"
JOIN "reviews" ON "listings"."id" = "reviews"."listing_id"
GROUP BY "listings"."id"
ORDER BY "review_count" DESC,"property_type","host_name"
LIMIT 100;

