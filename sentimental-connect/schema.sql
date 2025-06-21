
CREATE DATABASE `linkedin`;

USE `linkedin`;


CREATE TABLE `Users`(
    `id`  INT UNSIGNED AUTO_INCREMENT,
    `first_name` VARCHAR(63) NOT NULL,
    `last_name`  VARCHAR(63) NOT NULL,
    `username`   VARCHAR(31) NOT NULL UNIQUE,
    `password`   VARCHAR(127) NOT NULL,
    PRIMARY KEY(`id`)
);

CREATE TABLE `Universities`(
    `id` INT UNSIGNED AUTO_INCREMENT,
    `name` VARCHAR(63) NOT NULL,
    'type' ENUM('Primary','Secondary','Higher Education') NOT NULL,
    `location` VARCHAR(63) NOT NULL,
    `year` YEAR NOT NULL,
    PRIMARY KEY(`id`)
);

CREATE TABLE `Companies`(
    `id` INT UNSIGNED AUTO_INCREMENT,
    `name` VARCHAR(63) NOT NULL,
    'industry' ENUM('Technology','Education','Business') NOT NULL,
    `location` VARCHAR(63) NOT NULL,
    PRIMARY KEY(`id`)
);

CREATE TABLE `Connections_people`(
    `id` INT UNSIGNED AUTO_INCREMENT,
    `user_id` INT UNSIGNED NOT NULL,
    `following_id` INT UNSIGNED NOT NULL,
    PRIMARY KEY(`id`),
    FOREIGN KEY(`user_id`) REFERENCES `Users`(`id`) ON DELETE CASCADE,
    FOREIGN KEY(`following_id`) REFERENCES `Users`(`id`) ON DELETE CASCADE,
    CONSTRAINT `unique_connection` UNIQUE (`user_id`, `following_id`)

);

CREATE TABLE `Connections_universities`(
    `id` INT UNSIGNED AUTO_INCREMENT,
    `user_id` INT UNSIGNED NOT NULL,
    `university_id` INT UNSIGNED NOT NULL,
    `start_date` DATE NOT NULL,
    `end_date` DATE NOT NULL,
    `degree_type` VARCHAR(7) NOT NULL,
    PRIMARY KEY(`id`),
    FOREIGN KEY(`user_id`) REFERENCES `Users`(`id`) ON DELETE CASCADE,
    FOREIGN KEY(`university_id`) REFERENCES `Universities`(`id`) ON DELETE CASCADE
);

CREATE TABLE `Connections_industry`(
    `id` INT UNSIGNED AUTO_INCREMENT,
    `user_id` INT UNSIGNED NOT NULL,
    `company_id` INT UNSIGNED NOT NULL,
    `start_date` DATE NOT NULL,
    `end_date` DATE NOT NULL,
    PRIMARY KEY(`id`),
    FOREIGN KEY(`user_id`) REFERENCES `Users`(`id`) ON DELETE CASCADE,
    FOREIGN KEY(`company_id`) REFERENCES `Companies`(`id`) ON DELETE CASCADE
);


