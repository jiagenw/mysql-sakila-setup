-- Setup script to import Sakila database into fun_sql database
-- This script will create all Sakila tables, views, functions, and sample data

-- First, let's make sure we're using the fun_sql database
USE fun_sql;

-- Disable foreign key checks temporarily to avoid dependency issues
SET FOREIGN_KEY_CHECKS = 0;

-- Drop existing Sakila tables if they exist (to avoid conflicts)
DROP TABLE IF EXISTS payment;
DROP TABLE IF EXISTS rental;
DROP TABLE IF EXISTS inventory;
DROP TABLE IF EXISTS film_category;
DROP TABLE IF EXISTS film_actor;
DROP TABLE IF EXISTS film_text;
DROP TABLE IF EXISTS film;
DROP TABLE IF EXISTS customer;
DROP TABLE IF EXISTS staff;
DROP TABLE IF EXISTS store;
DROP TABLE IF EXISTS address;
DROP TABLE IF EXISTS city;
DROP TABLE IF EXISTS country;
DROP TABLE IF EXISTS category;
DROP TABLE IF EXISTS actor;
DROP TABLE IF EXISTS language;

-- Re-enable foreign key checks
SET FOREIGN_KEY_CHECKS = 1;

-- Now we'll import the schema and data
-- The following commands will import the Sakila database into fun_sql

-- Import schema (this will create all tables, views, and functions)
SOURCE movie_rental_sakila/sakila-schema.sql;

-- Import sample data
SOURCE movie_rental_sakila/sakila-data.sql;

-- Verify the setup by showing all tables
SHOW TABLES;

-- Show some sample data to confirm everything is working
SELECT 'Actor count:' as info, COUNT(*) as count FROM actor
UNION ALL
SELECT 'Film count:', COUNT(*) FROM film
UNION ALL
SELECT 'Customer count:', COUNT(*) FROM customer
UNION ALL
SELECT 'Rental count:', COUNT(*) FROM rental; 