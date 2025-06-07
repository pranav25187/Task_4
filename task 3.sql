-- Create database
CREATE DATABASE Ecommerce_SQL_Database;
USE Ecommerce_SQL_Database;

-- Create tables
CREATE TABLE customers (
    customer_id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE,
    phone VARCHAR(20),
    address VARCHAR(200),
    city VARCHAR(50),
    state VARCHAR(50),
    zip_code VARCHAR(20),
    registration_date DATE,
    last_login DATETIME
);

CREATE TABLE products (
    product_id INT PRIMARY KEY AUTO_INCREMENT,
    product_name VARCHAR(100) NOT NULL,
    description TEXT,
    category VARCHAR(50),
    price DECIMAL(10,2) NOT NULL,
    stock_quantity INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE orders (
    order_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT,
    order_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    status VARCHAR(20) DEFAULT 'Pending',
    total_amount DECIMAL(10,2),
    shipping_address VARCHAR(200),
    payment_method VARCHAR(50),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

CREATE TABLE order_items (
    order_item_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT,
    product_id INT,
    quantity INT NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    subtotal DECIMAL(10,2) GENERATED ALWAYS AS (quantity * unit_price) STORED,
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

CREATE TABLE reviews (
    review_id INT PRIMARY KEY AUTO_INCREMENT,
    product_id INT,
    customer_id INT,
    rating INT CHECK (rating BETWEEN 1 AND 5),
    comment TEXT,
    review_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (product_id) REFERENCES products(product_id),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);


-- Insert customers
INSERT INTO customers (first_name, last_name, email, phone, address, city, state, zip_code, registration_date, last_login)
VALUES 
('John', 'Smith', 'john.smith@example.com', '555-123-4567', '123 Main St', 'New York', 'NY', '10001', '2022-01-15', '2023-04-20 14:30:00'),
('Emily', 'Johnson', 'emily.j@example.com', '555-234-5678', '456 Oak Ave', 'Los Angeles', 'CA', '90001', '2022-02-20', '2023-04-21 09:15:00'),
('Michael', 'Williams', 'michael.w@example.com', '555-345-6789', '789 Pine Rd', 'Chicago', 'IL', '60601', '2022-03-10', '2023-04-19 16:45:00'),
('Sarah', 'Brown', 'sarah.b@example.com', '555-456-7890', '321 Elm St', 'Houston', 'TX', '77001', '2022-04-05', '2023-04-22 11:20:00'),
('David', 'Jones', 'david.j@example.com', '555-567-8901', '654 Maple Dr', 'Phoenix', 'AZ', '85001', '2022-05-12', '2023-04-18 13:10:00');

-- Insert products
INSERT INTO products (product_name, description, category, price, stock_quantity)
VALUES 
('Smartphone X', 'Latest smartphone with advanced features', 'Electronics', 799.99, 100),
('Wireless Headphones', 'Noise-cancelling Bluetooth headphones', 'Electronics', 199.99, 50),
('Coffee Maker', 'Automatic drip coffee maker', 'Home Appliances', 89.99, 30),
('Running Shoes', 'Lightweight running shoes', 'Sports', 129.99, 75),
('Backpack', 'Water-resistant backpack with laptop compartment', 'Accessories', 59.99, 40),
('Smart Watch', 'Fitness tracking smartwatch', 'Electronics', 249.99, 60),
('Desk Lamp', 'LED adjustable desk lamp', 'Home', 39.99, 25);

-- Insert orders
INSERT INTO orders (customer_id, order_date, status, total_amount, shipping_address, payment_method)
VALUES 
(1, '2023-01-10 10:30:00', 'Delivered', 799.99, '123 Main St, New York, NY 10001', 'Credit Card'),
(2, '2023-01-15 14:45:00', 'Shipped', 429.98, '456 Oak Ave, Los Angeles, CA 90001', 'PayPal'),
(3, '2023-02-05 09:15:00', 'Processing', 179.98, '789 Pine Rd, Chicago, IL 60601', 'Credit Card'),
(4, '2023-02-20 16:20:00', 'Delivered', 129.99, '321 Elm St, Houston, TX 77001', 'Debit Card'),
(1, '2023-03-12 11:30:00', 'Shipped', 309.98, '123 Main St, New York, NY 10001', 'PayPal'),
(5, '2023-03-25 13:45:00', 'Delivered', 89.99, '654 Maple Dr, Phoenix, AZ 85001', 'Credit Card');

-- Insert order items
INSERT INTO order_items (order_id, product_id, quantity, unit_price)
VALUES 
(1, 1, 1, 799.99),
(2, 2, 1, 199.99),
(2, 5, 1, 59.99),
(3, 7, 2, 39.99),
(4, 4, 1, 129.99),
(5, 6, 1, 249.99),
(5, 3, 1, 89.99),
(6, 3, 1, 89.99);

-- Insert reviews
INSERT INTO reviews (product_id, customer_id, rating, comment)
VALUES 
(1, 1, 5, 'Excellent phone with great camera!'),
(2, 2, 4, 'Good sound quality but battery life could be better'),
(3, 5, 3, 'Works fine but takes time to brew'),
(4, 4, 5, 'Very comfortable for long runs'),
(6, 1, 4, 'Great fitness tracker but screen is small'),
(1, 3, 5, 'Best smartphone I have ever used'),
(5, 2, 4, 'Sturdy backpack with plenty of space');



-- Get all electronics products priced over $200, ordered by price descending
SELECT product_name, category, price 
FROM products 
WHERE category = 'Electronics' AND price > 200
ORDER BY price DESC;

-- Get all orders with customer information
SELECT o.order_id, o.order_date, o.status, o.total_amount, 
       c.first_name, c.last_name, c.email
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id;

-- Calculate total sales by product category
SELECT p.category, SUM(oi.subtotal) AS total_sales, COUNT(oi.order_item_id) AS items_sold
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
GROUP BY p.category
ORDER BY total_sales DESC;


-- Find customers who have spent more than the average customer
SELECT c.customer_id, c.first_name, c.last_name, SUM(o.total_amount) AS total_spent
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
HAVING SUM(o.total_amount) > (
    SELECT AVG(total_amount) 
    FROM (
        SELECT customer_id, SUM(total_amount) AS total_amount
        FROM orders
        GROUP BY customer_id
    ) AS customer_totals
);


-- Create a view for product sales analysis
CREATE VIEW product_sales_view AS
SELECT p.product_id, p.product_name, p.category, 
       SUM(oi.quantity) AS total_quantity_sold,
       SUM(oi.subtotal) AS total_revenue,
       AVG(r.rating) AS average_rating
FROM products p
LEFT JOIN order_items oi ON p.product_id = oi.product_id
LEFT JOIN reviews r ON p.product_id = r.product_id
GROUP BY p.product_id, p.product_name, p.category;

-- Query the view
SELECT * FROM product_sales_view ORDER BY total_revenue DESC;

-- Find products that have never been ordered (using LEFT JOIN and NULL check)
SELECT p.product_id, p.product_name, p.price
FROM products p
LEFT JOIN order_items oi ON p.product_id = oi.product_id
WHERE oi.order_id IS NULL;

-- Alternative with NOT EXISTS
SELECT product_id, product_name, price
FROM products p
WHERE NOT EXISTS (
    SELECT 1 FROM order_items oi WHERE oi.product_id = p.product_id
);

-- Calculate average revenue per user
SELECT 
    COUNT(DISTINCT o.customer_id) AS active_customers,
    SUM(o.total_amount) AS total_revenue,
    SUM(o.total_amount) / COUNT(DISTINCT o.customer_id) AS avg_revenue_per_user
FROM orders o;

-- Create indexes to optimize frequent queries
CREATE INDEX idx_orders_customer_id ON orders(customer_id);
CREATE INDEX idx_order_items_product_id ON order_items(product_id);
CREATE INDEX idx_products_category ON products(category);