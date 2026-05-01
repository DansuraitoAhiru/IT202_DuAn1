CREATE DATABASE rikkei_store;
use rikkei_store;

CREATE TABLE Users(
    user_id INT PRIMARY KEY AUTO_INCREMENT,
    user_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    address VARCHAR(255)
);

CREATE TABLE Categories(
    category_id INT PRIMARY KEY AUTO_INCREMENT,
    category_name VARCHAR(100) NOT NULL
);

CREATE TABLE Products(
    product_id INT PRIMARY KEY AUTO_INCREMENT,
    product_name VARCHAR(100) NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    stock INT NOT NULL,
    category_id INT NOT NULL,
    FOREIGN KEY(category_id) REFERENCES Categories(category_id)
);

CREATE TABLE Orders(
    order_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    order_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    status ENUM('Pending','Paid','Cancelled') NOT NULL,
    shipping_address VARCHAR(255) NOT NULL,
    total_money DECIMAL(10,2) NOT NULL,
    FOREIGN KEY(user_id) REFERENCES Users(user_id)
);

CREATE TABLE Order_Details(
    order_detail_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL CHECK(quantity>0),
    price DECIMAL(10,2) NOT NULL,
    FOREIGN KEY(order_id) REFERENCES Orders(order_id),
    FOREIGN KEY(product_id) REFERENCES Products(product_id)
);

INSERT INTO Users(user_name,email,address) 
VALUES
	('Dansuraito Ahiru','ahiru@gmail.com','Hà Nội'),
	('Phoạm Văn Thoái','thoai36@gmail.com','Hoa Thanh Quế'),
	('Trưn Cong Suy','suyvai@gmail.com','Thanh Hóa'),
	('Dick Grayson','nguyengrayson@gmail.com','Gotham'),
	('Quyền Chí Long','longnger@gmail.com','Seoul');

INSERT INTO Categories(category_name) 
VALUES
	('Electronics'),
    ('Clothing'),
    ('Food');

INSERT INTO Products(product_name,price,stock,category_id)
VALUES
	('Laptop', 1000, 10, 1),
	('Phone', 500, 20, 1),
	('Hamburger', 250, 5, 3),
	('Shirt', 50, 100, 2),
	('Pizza', 10, 200, 3);
    
INSERT INTO Orders(user_id, status, shipping_address, total_money) 
VALUES
	(1, 'Paid', 'Xuân Phương, Hà Nội', 2500),
	(2, 'Paid', 'Hà Đông, Hà Nội', 500),
	(1, 'Pending', 'Ngọc Trục, Đại Mỗ, Hà Nội', 800),
	(3, 'Cancelled', 'Thanh Hóa', 0),
	(4, 'Paid', '35 Phố Baker, Gotham', 1000);
    
INSERT INTO Order_Details(order_id, product_id, quantity, price)
VALUES
	(1, 1, 2, 2000),
	(1, 2, 1, 500),
	(2, 1, 1, 1000),
	(3, 3, 1, 800),
	(5, 1, 1, 1000);

-- Q1
SELECT o.order_id, o.order_date, u.user_name, o.total_money
FROM Orders o
JOIN Users u on o.user_id = u.user_id;

-- Q2
SELECT * FROM Products p
JOIN Categories c on c.category_id = p.category_id
WHERE category_name = 'Electronics';

-- Q3
SELECT user_id, user_name, email FROM Users;

-- Q4
SELECT SUM(total_money) as total_revenue FROM Orders;

-- Q5
SELECT p.product_id, p.product_name, SUM(od.quantity) as total_quantity 
FROM Order_Details od
JOIN Products p on p.product_id = od.product_id
Group by p.product_id;

-- Q6
SELECT p.product_id, p.product_name, SUM(od.quantity) as total_quantity
FROM Products p
JOIN Order_Details od on od.product_id = p.product_id
Group by p.product_id
Order by total_quantity DESC
LIMIT 1; 

-- Q7
SELECT o.order_id, u.user_name, o.total_money, SUM(od.quantity) as total_product 
FROM Orders o
JOIN Users u on u.user_id = o.user_id
JOIN Order_Details od on od.order_id = o.order_id
Group by o.order_id;

-- Q8
SELECT product_id, product_name FROM Products
WHERE product_id NOT IN (SELECT product_id FROM Order_Details);

-- Q9
SELECT u.user_id, u.user_name, COUNT(o.order_id) as total_orders
FROM Users u
JOIN Orders o ON u.user_id = o.user_id
GROUP BY u.user_id;

-- Q10
SELECT * FROM Products
WHERE price > (SELECT AVG(price) FROM Products);

-- Q11
SELECT u.*, SUM(o.total_money) as total_spent FROM Users u
JOIN Orders o on o.user_id = u.user_id
Group by u.user_id
HAVING total_spent > (
	SELECT AVG(total_spent)
    FROM (
        SELECT SUM(total_money) as total_spent FROM Orders
        GROUP BY user_id
    ) t
);

-- Q12
SELECT * FROM Orders
Order by total_money DESC
LIMIT 1;

-- Q13
SELECT c.category_id, c.category_name, SUM(od.price) as total_revenue FROM Categories c
JOIN Products p on p.category_id = c.category_id
JOIN Order_Details od on od.product_id = p.product_id
Group by c.category_id
Order by total_revenue DESC
LIMIT 1;

-- Q14
SELECT p.product_id, p.product_name, SUM(od.quantity) as total_quantity
FROM Products p
JOIN Order_Details od on od.product_id = p.product_id
Group by p.product_id
Order by total_quantity DESC, product_id ASC
LIMIT 3;

-- Q15
SELECT * FROM Users u
WHERE NOT EXISTS (SELECT 1 FROM Orders o WHERE o.user_id = u.user_id);