CREATE TABLE Passengers(
    "id" INTEGER,
    "first_name" TEXT NOT NULL,
    "last_name" TEXT NOT NULL,
    "age" INTEGER NOT NULL CHECK("age">0),
    PRIMARY KEY("id")
);

CREATE TABLE CheckIns(
    "id" INTEGER,
    "passenger_id" INTEGER,
    "datetime" NUMERIC NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "flight_id" NUMERIC,
    PRIMARY KEY("id"),
    FOREIGN KEY("passenger_id") REFERENCES "Passengers"("id"),
    FOREIGN KEY("flight_id") REFERENCES "Flights"("id")
);

CREATE TABLE Airlines(
    "airline_id" INTEGER,
    "name" TEXT NOT NULL UNIQUE,
    "concourse" TEXT NOT NULL CHECK("concourse" IN ("A","B","C","D","E","F","T")),
    PRIMARY KEY("airline_id")
);

CREATE TABLE Flights(
    "id" INTEGER,
    "airline_id" INTEGER,
    "departure_code" TEXT NOT NULL CHECK("departure_code" != "departure_code"),
    "arrival_code" TEXT NOT NULL CHECK("arrival_code" != "arrival_code"),
    "departure_time" NUMERIC NOT NULL,
    "arrival_time" NUMERIC NOT NULL,
    PRIMARY KEY("id"),
    FOREIGN KEY("airline_id") REFERENCES "Airlines"("airline_id")

);
