CREATE DATABASE expertsoft;

USE expertsoft;

CREATE TABLE customers(
	customer_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_name VARCHAR(150) NOT NULL,
    identification INT UNIQUE NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    address VARCHAR(100) NOT NULL,
    phone_number VARCHAR(100) NOT NULL
);

CREATE TABLE transactions(
	transaction_id VARCHAR(100) PRIMARY KEY,
    customer_id INT NOT NULL,
    date_time DATETIME NOT NULL,
    amount INT NOT NULL,
    platform ENUM('nequi','daviplata'),
    
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

CREATE TABLE bills(
	bill_num VARCHAR(100) PRIMARY KEY,
    transaction_id VARCHAR(100) NOT NULL,
    period DATE NOT NULL,
    bill_amount INT UNIQUE NOT NULL,
    paid_amount INT NOT NULL,
	state ENUM('pendiente','fallida','completada'),
    
    FOREIGN KEY (transaction_id) REFERENCES transactions(transaction_id)
);

SELECT*FROM customers;

SELECT*FROM bills;

SELECT*FROM transactions;


SELECT 
	t.transaction_id,
    c.customer_id,
	c.customer_name,
    c.identification,
    t.date_time AS transaction_datetime,
    t.amount,
    t.platform
FROM transactions t
JOIN customers c ON t.customer_id = c.customer_id;


-- CONSULTAS
-- 1. Total pagado por cada cliente
SELECT c.customer_id AS ID, c.customer_name AS Customer,
SUM(b.paid_amount) AS TotalPaid
FROM customers c
JOIN transactions t ON c.customer_id = t.customer_id
JOIN bills b ON t.transaction_id = b.transaction_id
GROUP BY c.customer_id, c.customer_name;


-- 2. Facturas pendientes con información de cliente y transacción asociada
SELECT 
    b.bill_num,
    b.state,
    c.customer_name AS customer,
    t.transaction_id,
    t.amount
FROM bills b
JOIN transactions t ON b.transaction_id = t.transaction_id
JOIN customers c ON t.customer_id = c.customer_id
WHERE b.state = 'pendiente';



