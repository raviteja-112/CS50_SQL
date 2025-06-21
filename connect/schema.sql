CREATE TABLE Users(
    "id" INTEGER,
    "first_name" TEXT NOT NULL,
    "last_name" TEXT NOT NULL,
    "username" TEXT NOT NULL UNIQUE,
    "password" TEXT NOT NULL,
    PRIMARY KEY("id")
);

CREATE TABLE SCH_UNI(
    "id" INTEGER,
    "name" TEXT NOT NULL,
    "type" TEXT NOT NULL,
    "location" TEXT NOT NULL,
    "year" NUMERIC NOT NULL,
    PRIMARY KEY("id")
);

CREATE TABLE Companies(
    "id" INTEGER,
    "name" TEXT NOT NULL UNIQUE,
    "industry" TEXT NOT NULL,
    "location" TEXT NOT NULL,
    PRIMARY KEY("id")
);

CREATE TABLE CP(
    "id" INTEGER,
    "user_id" INTEGER,
    "following_id" INTEGER,
    PRIMARY KEY("id"),
    FOREIGN KEY("user_id") REFERENCES "Users"("id"),
    FOREIGN KEY("following_id") REFERENCES "Users"("id")
);

CREATE TABLE CSU(
    "id" INTEGER,
    "user_id" INTEGER,
    "uni_id" INTEGER,
    "start" NUMERIC NOT NULL,
    "end" NUMERIC NOT NULL,
    "type" TEXT NOT NULL,

    PRIMARY KEY("id"),
    FOREIGN KEY("user_id") REFERENCES "Users"("id"),
    FOREIGN KEY("uni_id") REFERENCES "SCH_UNI"("id")
);

CREATE TABLE CC(
    "id" INTEGER,
    "user_id" INTEGER,
    "company_id" INTEGER,
    "start" NUMERIC NOT NULL,
    "end" NUMERIC NOT NULL,
    "title" TEXT NOT NULL,

    PRIMARY KEY("id"),
    FOREIGN KEY("user_id") REFERENCES "Users"("id"),
    FOREIGN KEY("company_id") REFERENCES "Companies"("id")

);


