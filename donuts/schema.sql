CREATE TABLE Ingredients(
    "id" INTEGER,
    "name" TEXT NOT NULL UNIQUE,
    "price_per_unit" NUMERIC NOT NULL,
    PRIMARY KEY("id")

);

CREATE TABLE Donuts(
    "id" INTEGER,
    "name" TEXT NOT NULL UNIQUE,
    "gluten_free" INTEGER NOT NULL CHECK("gluten_free" IN ("0","1")),
    "price_per_donut" NUMERIC  NOT NULL,
    PRIMARY KEY("id")
);

CREATE TABLE Donut_ingredients(
    "donut_id" INTEGER,
    "ingredient_id" INTEGER,
    PRIMARY KEY("donut_id","ingredient_id"),
    FOREIGN KEY("donut_id") REFERENCES "Donuts"("id"),
    FOREIGN KEY("ingredient_id") REFERENCES "Ingredients"("id")
);

CREATE TABLE Orders(
    "id" INTEGER,
    "customer_id" INTEGER,
    PRIMARY KEY("id"),
    FOREIGN KEY("customer_id") REFERENCES "Customers"("id")
);

CREATE TABLE Order_Details(
    "order_id" INTEGER,
    "donut_id" INTEGER,
    "quantity" INTEGER NOT NULL,
    PRIMARY KEY("order_id", "donut_id"),
    FOREIGN KEY("order_id") REFERENCES "Orders"("id"),
    FOREIGN KEY("donut_id") REFERENCES "Donuts"("id")
);

CREATE TABLE Customers(
    "id" INTEGER,
    "first_name" TEXT NOT NULL,
    "last_name" TEXT NOT NULL,
    PRIMARY KEY("id")
);


