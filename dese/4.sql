SELECT "city", COUNT("type") AS "Num of Pub Schools" FROM "schools"
WHERE "type" = 'Public School'
GROUP BY "city"
ORDER BY "Num of Pub Schools" DESC, "city"
LIMIT 10;
