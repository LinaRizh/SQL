USE home_work2;
CREATE TABLE sales
(
	id INT PRIMARY KEY NOT NULL auto_increment,
	order_date date NOT NULL,
    count_product int
);
INSERT INTO sales (order_date,count_product)
VALUES ('2022-01-01','156'),
('2022-01-02','180'),
('2022-01-03','21'),
('2022-01-04','124'),
('2022-01-05','341');
SELECT id,
CASE 
	WhEN count_product<100 THEN 'Маленький заказ'
    WHEN 100<=count_product and count_product<=300 THEN 'Средний заказ'
    ELSE 'Большой заказ'
END AS order_type
FROM sales;

CREATE TABLE orders
(
	id INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
	employee_id VARCHAR(5) NOT NULL,
	amount FLOAT ,
	order_status VARCHAR(20)
);

INSERT INTO orders (employee_id, amount, order_status)
VALUES ('e03', '15.00', 'OPEN'),
('e01', '25.50', 'OPEN'),
('e05', '100.70', 'CLOSED'),
('e02', '22.18', 'OPEN'),
('e04', '9.50', 'CANCELLED');

SELECT id,
CASE 
	WhEN order_status='OPEN' THEN 'Order is in open state'
    WHEN order_status='CLOSED' THEN 'Order is closed'
    WHEN order_status='CANCELLED' THEN 'Order is cancelled'
END AS full_order_status
FROM orders;
    