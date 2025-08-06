#!/bin/bash

# Setup script to import Sakila database into fun_sql database
# This script will help you set up the Sakila sample database

echo "Setting up Sakila database in fun_sql..."
echo "========================================"

# Check if MySQL is available
if ! command -v mysql &> /dev/null; then
    echo "Error: MySQL client is not installed or not in PATH"
    echo "Please install MySQL client and try again"
    exit 1
fi

# Prompt for MySQL connection details
echo "Please enter your MySQL connection details:"
read -p "Host (default: localhost): " MYSQL_HOST
MYSQL_HOST=${MYSQL_HOST:-localhost}

read -p "Port (default: 3306): " MYSQL_PORT
MYSQL_PORT=${MYSQL_PORT:-3306}

read -p "Username: " MYSQL_USER

read -s -p "Password: " MYSQL_PASS
echo ""

# Test connection
echo "Testing connection to MySQL..."
if mysql -h "$MYSQL_HOST" -P "$MYSQL_PORT" -u "$MYSQL_USER" -p"$MYSQL_PASS" -e "USE fun_sql;" 2>/dev/null; then
    echo "✓ Successfully connected to fun_sql database"
else
    echo "Error: Could not connect to fun_sql database"
    echo "Please make sure:"
    echo "1. MySQL server is running"
    echo "2. fun_sql database exists"
    echo "3. Your credentials are correct"
    exit 1
fi

# Create the setup SQL file
echo "Creating setup SQL file..."
cat > setup_sakila_final.sql << 'EOF'
-- Setup script to import Sakila database into fun_sql database
USE fun_sql;

-- Disable foreign key checks temporarily
SET FOREIGN_KEY_CHECKS = 0;

-- Drop existing Sakila tables if they exist
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

-- Import the modified schema
SOURCE movie_rental_sakila/sakila-schema-fun_sql.sql;

-- Import sample data
SOURCE movie_rental_sakila/sakila-data.sql;

-- Verify the setup
SHOW TABLES;

-- Show some sample data
SELECT 'Actor count:' as info, COUNT(*) as count FROM actor
UNION ALL
SELECT 'Film count:', COUNT(*) FROM film
UNION ALL
SELECT 'Customer count:', COUNT(*) FROM customer
UNION ALL
SELECT 'Rental count:', COUNT(*) FROM rental;
EOF

# Run the setup
echo "Importing Sakila database..."
mysql -h "$MYSQL_HOST" -P "$MYSQL_PORT" -u "$MYSQL_USER" -p"$MYSQL_PASS" fun_sql < setup_sakila_final.sql

if [ $? -eq 0 ]; then
    echo "✓ Sakila database successfully imported into fun_sql!"
    echo ""
    echo "You can now run queries like:"
    echo "  SELECT * FROM actor LIMIT 5;"
    echo "  SELECT * FROM film LIMIT 5;"
    echo "  SELECT * FROM customer LIMIT 5;"
    echo ""
    echo "To connect to your database:"
    echo "  mysql -h $MYSQL_HOST -P $MYSQL_PORT -u $MYSQL_USER -p fun_sql"
else
    echo "Error: Failed to import Sakila database"
    exit 1
fi

# Clean up
rm -f setup_sakila_final.sql

echo "Setup complete!" 