SELECT "english_title" AS "Print_Title", "print_number" AS "Print_Number", "brightness" AS "Brightness_Level" FROM "views"
WHERE "artist" = 'Hokusai' AND "brightness" > 0.5
ORDER BY "print_number" ASC;
