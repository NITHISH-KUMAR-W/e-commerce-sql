drop database if exists ecommerce;
create database ecommerce;
use ecommerce;

CREATE TABLE customers (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    address TEXT
);

CREATE TABLE products (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    description TEXT
);

CREATE TABLE orders (
    id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT,
    order_date DATE NOT NULL,
    total_amount DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (customer_id) REFERENCES customers(id) ON DELETE CASCADE
);

INSERT INTO customers (name, email, address) VALUES
('Nithish Kumar', 'nithish@mail.com', 'Vellore'),
('Smith', 'smith@mail.com', 'Coimbatore'),
('Vijay', 'vijay@mail.com', 'Chennai');

INSERT INTO products (name, price, description) VALUES
('Product A', 30.00, 'Description of Product A'),
('Product B', 25.50, 'Description of Product B'),
('Product C', 40.00, 'Description of Product C'),
('Product D', 50.00, 'Description of Product D');

INSERT INTO orders (customer_id, order_date, total_amount) VALUES
(1, CURDATE() - INTERVAL 10 DAY, 100.00),
(2, CURDATE() - INTERVAL 20 DAY, 200.00),
(3, CURDATE() - INTERVAL 35 DAY, 150.00);

SELECT DISTINCT customers.* FROM customers
JOIN orders ON customers.id = orders.customer_id
WHERE orders.order_date >= CURDATE() - INTERVAL 30 DAY;

SELECT customers.name, SUM(orders.total_amount) AS total_spent
FROM customers
JOIN orders ON customers.id = orders.customer_id
GROUP BY customers.name;

UPDATE products SET price = 45.00 WHERE name = 'Product C';

ALTER TABLE products ADD COLUMN discount DECIMAL(5,2) DEFAULT 0;

SELECT * FROM products ORDER BY price DESC LIMIT 3;

SELECT DISTINCT customers.name FROM customers
JOIN orders ON customers.id = orders.customer_id
JOIN order_items ON orders.id = order_items.order_id
JOIN products ON order_items.product_id = products.id
WHERE products.name = 'Product A';

SELECT customers.name, orders.order_date FROM customers
JOIN orders ON customers.id = orders.customer_id;

SELECT * FROM orders WHERE total_amount > 150.00;

CREATE TABLE order_items (
    id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT,
    product_id INT,
    quantity INT NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE
);

ALTER TABLE orders DROP COLUMN total_amount;

SELECT AVG(total_amount) AS average_order_total FROM (
    SELECT orders.id, SUM(order_items.quantity * order_items.price) AS total_amount
    FROM orders
    JOIN order_items ON orders.id = order_items.order_id
    GROUP BY orders.id
) AS order_totals;