-- Import full Sakila dataset into fun_sql database
USE fun_sql;

-- Disable foreign key checks temporarily
SET FOREIGN_KEY_CHECKS = 0;

-- Drop existing tables to start fresh
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

-- Import the complete schema
SOURCE movie_rental_sakila/sakila-schema-fun_sql.sql;

-- Import the complete data (this will take a while)
SOURCE movie_rental_sakila/sakila-data.sql;

-- Verify the import
SHOW TABLES;

-- Show record counts for all tables
SELECT 'actor' as table_name, COUNT(*) as record_count FROM actor
UNION ALL
SELECT 'address', COUNT(*) FROM address
UNION ALL
SELECT 'category', COUNT(*) FROM category
UNION ALL
SELECT 'city', COUNT(*) FROM city
UNION ALL
SELECT 'country', COUNT(*) FROM country
UNION ALL
SELECT 'customer', COUNT(*) FROM customer
UNION ALL
SELECT 'film', COUNT(*) FROM film
UNION ALL
SELECT 'film_actor', COUNT(*) FROM film_actor
UNION ALL
SELECT 'film_category', COUNT(*) FROM film_category
UNION ALL
SELECT 'film_text', COUNT(*) FROM film_text
UNION ALL
SELECT 'inventory', COUNT(*) FROM inventory
UNION ALL
SELECT 'language', COUNT(*) FROM language
UNION ALL
SELECT 'payment', COUNT(*) FROM payment
UNION ALL
SELECT 'rental', COUNT(*) FROM rental
UNION ALL
SELECT 'staff', COUNT(*) FROM staff
UNION ALL
SELECT 'store', COUNT(*) FROM store
ORDER BY record_count DESC; 