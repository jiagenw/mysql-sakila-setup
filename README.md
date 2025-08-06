# 🎬 Sakila Database Setup for MySQL

A complete setup for the Sakila sample database with automated installation scripts and comprehensive documentation.

[![MySQL](https://img.shields.io/badge/MySQL-8.0+-blue.svg)](https://www.mysql.com/)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

## 📖 What is Sakila?

Sakila is a well-known sample database for MySQL that represents a movie rental store. It's perfect for learning SQL, testing queries, and practicing database operations.

### 🗂️ Database Structure

**16 Tables** with realistic relationships:
- `actor` - Movie actors and actresses
- `film` - Movie information and details
- `customer` - Store customers
- `rental` - Movie rental records
- `payment` - Payment transactions
- `inventory` - Available movie copies
- `staff` - Store employees
- `store` - Store locations
- `address`, `city`, `country` - Location data
- `category`, `language` - Classification data
- `film_actor`, `film_category` - Many-to-many relationships
- `film_text` - Full-text search data

**7 Views** for common queries:
- `customer_list` - Customer information with addresses
- `film_list` - Film details with categories and actors
- `sales_by_store` - Sales performance by store
- `sales_by_film_category` - Sales by film category
- And more...

**3 Stored Functions** for business logic:
- `inventory_held_by_customer()` - Check who has a specific inventory item
- `inventory_in_stock()` - Check if inventory is available
- `actor_info` - Actor information with film details

## 🚀 Quick Start

### Prerequisites

- MySQL 5.7+ or MySQL 8.0+
- MySQL client tools
- Bash shell (for automated setup)

### Option 1: Automated Setup (Recommended)

1. **Clone this repository:**
   ```bash
   git clone <your-repo-url>
   cd sql_related
   ```

2. **Run the setup script:**
   ```bash
   ./setup_sakila.sh
   ```

3. **Follow the prompts** to enter your MySQL connection details

4. **Verify the setup:**
   ```bash
   mysql -u your_username -p fun_sql -e "SHOW TABLES;"
   ```

### Option 2: Manual Setup

1. **Create the database:**
   ```sql
   CREATE DATABASE fun_sql;
   USE fun_sql;
   ```

2. **Import the schema and data:**
   ```sql
   SOURCE setup_sakila_combined.sql;
   ```

## 📊 Sample Queries

### Basic Queries

```sql
-- Show all tables
SHOW TABLES;

-- Count records in main tables
SELECT 'Actor count:' as info, COUNT(*) as count FROM actor
UNION ALL
SELECT 'Film count:', COUNT(*) FROM film
UNION ALL
SELECT 'Customer count:', COUNT(*) FROM customer
UNION ALL
SELECT 'Rental count:', COUNT(*) FROM rental;
```

### Advanced Queries

```sql
-- Find films starring a specific actor
SELECT f.title, f.release_year, f.rating, f.rental_rate
FROM film f
JOIN film_actor fa ON f.film_id = fa.film_id
JOIN actor a ON fa.actor_id = a.actor_id
WHERE a.first_name = 'JOHNNY' AND a.last_name = 'LOLLOBRIGIDA';

-- Find customers who have rented the most movies
SELECT 
    c.first_name, 
    c.last_name, 
    COUNT(*) as rental_count,
    SUM(p.amount) as total_spent
FROM customer c
JOIN rental r ON c.customer_id = r.customer_id
JOIN payment p ON r.rental_id = p.rental_id
GROUP BY c.customer_id
ORDER BY rental_count DESC
LIMIT 10;

-- Find the most popular film categories
SELECT 
    c.name as category, 
    COUNT(*) as rental_count,
    AVG(f.rental_rate) as avg_rental_rate
FROM category c
JOIN film_category fc ON c.category_id = fc.category_id
JOIN film f ON fc.film_id = f.film_id
JOIN inventory i ON f.film_id = i.film_id
JOIN rental r ON i.inventory_id = r.inventory_id
GROUP BY c.category_id
ORDER BY rental_count DESC;

-- Find films that are currently rented out
SELECT 
    f.title, 
    c.first_name, 
    c.last_name, 
    r.rental_date,
    DATEDIFF(NOW(), r.rental_date) as days_rented
FROM film f
JOIN inventory i ON f.film_id = i.film_id
JOIN rental r ON i.inventory_id = r.inventory_id
JOIN customer c ON r.customer_id = c.customer_id
WHERE r.return_date IS NULL
ORDER BY days_rented DESC;

-- Sales analysis by store
SELECT 
    CONCAT(c.city, ', ', cy.country) AS store_location,
    CONCAT(m.first_name, ' ', m.last_name) AS manager,
    COUNT(DISTINCT r.rental_id) as total_rentals,
    SUM(p.amount) AS total_sales,
    AVG(p.amount) as avg_sale
FROM payment p
JOIN rental r ON p.rental_id = r.rental_id
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN store s ON i.store_id = s.store_id
JOIN address a ON s.address_id = a.address_id
JOIN city c ON a.city_id = c.city_id
JOIN country cy ON c.country_id = cy.country_id
JOIN staff m ON s.manager_staff_id = m.staff_id
GROUP BY s.store_id
ORDER BY total_sales DESC;
```

## 📁 Project Structure

```
sql_related/
├── README.md                           # This file
├── setup_sakila.sh                     # Automated setup script
├── setup_sakila_direct.sh              # Direct setup script
├── setup_sakila_combined.sql           # Combined schema + data
├── .gitignore                          # Git ignore rules
├── movie_rental_sakila/
│   ├── sakila-schema.sql               # Original schema
│   ├── sakila-schema-fun_sql.sql       # Modified schema for fun_sql
│   ├── sakila-data.sql                 # Sample data (large file)
│   └── sakila_model.mwb                # MySQL Workbench model
└── LICENSE                             # License file
```

## 🔧 Troubleshooting

### Common Issues

1. **Connection failed**
   - Ensure MySQL server is running
   - Check credentials and permissions
   - Verify database exists

2. **Foreign key errors**
   - The setup script handles this automatically
   - If manual setup, ensure tables are created in correct order

3. **Permission denied**
   - Ensure your MySQL user has privileges on the database
   - Run: `GRANT ALL PRIVILEGES ON fun_sql.* TO 'your_user'@'localhost';`

4. **File not found errors**
   - Ensure you're in the correct directory
   - Check file paths in SOURCE commands

### Getting Help

- Check MySQL error logs
- Verify MySQL version compatibility
- Ensure all files are present in the repository

## 🤝 Contributing

Contributions are welcome! Please feel free to:

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests if applicable
5. Submit a pull request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- Original Sakila database by MySQL/MySQL AB
- Sample data and schema provided by MySQL
- Community contributions and feedback

## 📞 Support

If you encounter any issues or have questions:

1. Check the troubleshooting section above
2. Search existing issues in the repository
3. Create a new issue with detailed information

---

**Happy SQL Learning! 🎉**

*This setup makes it easy to get started with the Sakila database for learning SQL, testing queries, and practicing database operations.* 