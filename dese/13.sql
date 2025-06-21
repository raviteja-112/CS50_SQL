-- SELECT "districts"."name","schools"."name","districts"."type" FROM "districts"
-- JOIN "schools" ON "districts"."id" = "schools"."district_id";
-- WHERE "districts"."type" = 'Public School District'

SELECT "name"
FROM "schools"
JOIN "graduation_rates" ON schools.id = graduation_rates.school_id
GROUP BY schools.district_id;
