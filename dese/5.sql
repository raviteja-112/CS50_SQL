SELECT "city", COUNT("type") AS "Num of Pub Schools" FROM "schools"
WHERE "type" = 'Public School'
GROUP BY "city"
HAVING "Num of Pub Schools" <=3
ORDER BY "Num of Pub Schools" DESC, "city"
