USE master

DROP DATABASE DidulaFurniture;

CREATE DATABASE DidulaFurniture;

USE DidulaFurniture;

DROP TABLE IF EXISTS Customer;
CREATE TABLE Customer
( 
customer_id INT IDENTITY(1000,3) PRIMARY KEY NOT NULL,
first_name VARCHAR(30) NOT NULL,
last_name VARCHAR(30) NOT NULL,
customer_mobile VARCHAR(10) NOT NULL,
customer_address VARCHAR(200) DEFAULT 'No address',
CONSTRAINT customer_mobile_validation CHECK (ISNUMERIC(customer_mobile) = 1), --mobile field will only take numbers
CONSTRAINT first_name_validation CHECK (first_name NOT LIKE '%[^A-Za-z]+$%'), --check if input is only letters
CONSTRAINT last_name_validation CHECK (last_name NOT LIKE '%[^A-Za-z]+$%') --check if input is only letters
);

DROP TABLE IF EXISTS Supplier;
CREATE TABLE Supplier
( 
supplier_id INT IDENTITY(2000,2) PRIMARY KEY NOT NULL,
supplier_name VARCHAR(30) NOT NULL,
supplier_mobile VARCHAR(10) NOT NULL,
CONSTRAINT supplier_mobile_validation CHECK (ISNUMERIC(supplier_mobile) = 1),
CONSTRAINT supplier_name_validation CHECK (supplier_name NOT LIKE '%[^A-Za-z]+$%')
);

DROP TABLE IF EXISTS Delivery;
CREATE TABLE Delivery
( 
delivery_id INT IDENTITY(3000,4) PRIMARY KEY NOT NULL,
delivery_date DATE NOT NULL,
delivery_status VARCHAR(50) NOT NULL,
CONSTRAINT deliver_status_validation CHECK (delivery_status NOT LIKE '%[^A-Za-z]+$%')
);

--self-referencial 
DROP TABLE IF EXISTS Employee
CREATE TABLE Employee 
( 
employee_id INT IDENTITY(4000,3) PRIMARY KEY NOT NULL,
manager_id INT DEFAULT 'No manager',
emp_first_name VARCHAR(30) NOT NULL,
emp_last_name VARCHAR(30) NOT NULL,
employee_mobile VARCHAR(10) NOT NULL,
employee_address VARCHAR(200) NULL DEFAULT 'No address',
FOREIGN KEY (manager_id) REFERENCES Employee(employee_id),
CONSTRAINT employee_mobile_validation CHECK (ISNUMERIC(employee_mobile) = 1),
CONSTRAINT emp_first_name_validation CHECK (emp_first_name NOT LIKE '%[^A-Za-z]+$%'),
CONSTRAINT emp_last_name_validation CHECK (emp_last_name NOT LIKE '%[^A-Za-z]+$%')
);

DROP TABLE IF EXISTS Orders
CREATE TABLE Orders 
( 
order_id INT IDENTITY(5000,6) PRIMARY KEY NOT NULL,
order_type VARCHAR(30) NOT NULL, --custom or regular
customer_id INT NOT NULL,
employee_id INT NOT NULL,
delivery_id INT DEFAULT 'No delivery',
order_description VARCHAR(200) DEFAULT 'No description', 
FOREIGN KEY (customer_id) REFERENCES Customer(customer_id),
FOREIGN KEY (employee_id) REFERENCES Employee(employee_id),
FOREIGN KEY (delivery_id) REFERENCES Delivery(delivery_id),
);

DROP TABLE IF EXISTS Furniture
CREATE TABLE Furniture 
( 
furniture_id INT IDENTITY(6000,3) PRIMARY KEY NOT NULL,
furniture_name VARCHAR(30) NOT NULL,
unit_price VARCHAR(10) NOT NULL,
furniture_quantity VARCHAR(20) DEFAULT 0,
CONSTRAINT unit_price_validation CHECK (ISNUMERIC(unit_price) = 1),
CONSTRAINT furniture_quantity_validation CHECK (ISNUMERIC(furniture_quantity) = 1),
CONSTRAINT furniture_name_validation CHECK (furniture_name NOT LIKE '%[^A-Za-z]+$%')
);

DROP TABLE IF EXISTS Invoice
CREATE TABLE Invoice 
( 
invoice_id INT IDENTITY(7000,7) PRIMARY KEY NOT NULL,
order_id INT NOT NULL,
invoice_date DATE NOT NULL,
invoice_quantity INT DEFAULT 0,
--invoice_price VARCHAR(10) NOT NULL,
FOREIGN KEY (order_id) REFERENCES Orders(order_id),
CONSTRAINT invoice_quantity_validation CHECK (ISNUMERIC(invoice_quantity) = 1)
);

DROP TABLE IF EXISTS OrderFurniture
CREATE TABLE OrderFurniture
(
order_id INT NOT NULL,
furniture_id INT NOT NULL,
FOREIGN KEY (order_id) REFERENCES Orders(order_id),
FOREIGN KEY (furniture_id) REFERENCES Furniture(furniture_id),
PRIMARY KEY (order_id, furniture_id) --composite primary key
);

DROP TABLE IF EXISTS Build
CREATE TABLE Build
(
employee_id INT NOT NULL,
order_id INT NOT NULL,
FOREIGN KEY (employee_id) REFERENCES Employee(employee_id),
FOREIGN KEY (order_id) REFERENCES Orders(order_id),
PRIMARY KEY(employee_id,order_id) --composite primary key
);

DROP TABLE IF EXISTS FurnitureSupplier
CREATE TABLE FurnitureSupplier
(
furniture_id INT NOT NULL,
supplier_id INT NOT NULL,
FOREIGN KEY (furniture_id) REFERENCES Furniture(furniture_id),
FOREIGN KEY (supplier_id) REFERENCES Supplier(supplier_id),
PRIMARY KEY (furniture_id, supplier_id) --composite primary key
);

DROP TABLE IF EXISTS EmployeeDelivery
CREATE TABLE EmployeeDelivery
(
employee_id INT NOT NULL,
delivery_id INT NOT NULL,
FOREIGN KEY (employee_id) REFERENCES Employee(employee_id),
FOREIGN KEY (delivery_id) REFERENCES Delivery(delivery_id),
PRIMARY KEY (employee_id, delivery_id) --composite primary key
);

DROP TABLE IF EXISTS CustomOrderSupplier;
CREATE TABLE CustomOrderSupplier
(
order_id INT NOT NULL,
supplier_id INT NOT NULL,
custom_price VARCHAR(10) NOT NULL,
CONSTRAINT custom_price_validation CHECK (ISNUMERIC(custom_price) = 1),
FOREIGN KEY (order_id) REFERENCES Orders(order_id),
FOREIGN KEY (supplier_id) REFERENCES Supplier(supplier_id),
PRIMARY KEY(order_id,supplier_id) --composite primary key
);
---------------------------------------------------------

INSERT INTO Customer (first_name, last_name, customer_mobile, customer_address)
VALUES ('Nimal','Perera',0771234567,'123 Galle Road, Colombo'),
		('Sujatha','Rajapaksa',0712345678,'456 Kandy Road, Kandy'),
		('Ananda','Silva',0763456789,DEFAULT), --'789 Nawala Road, Colombo'
		('Mallika','Gunawardana',0754567890,'321 Negombo Road, Negombo'),
		('Sampath','Fernando',0725678901,'567 Havelock Road, Colombo'),
		('Shanthi','Bandara',0776789012,DEFAULT), --'890 Gampaha Road, Gampaha'
		('Kusal','Peris',0767890123,'234 High Level Road, Colombo'),
		('Ishara','de Silva',0718901234,DEFAULT), --'876 Main Street, Kandy'
		('Lakshman','Rajakaruna',0759012345,'432 Colombo Road, Kurunegala'),
		('Dharshani','Gunasekara',0770112233,'765 Negombo Road, Negombo');



INSERT INTO Furniture (furniture_name, unit_price, furniture_quantity)
VALUES ('Teak dinning table', 5000, 20),
		('Mahogany Wardrobe', 8000, 15),
		('Rosewood Bed', 10000, DEFAULT),
		('Bamboo Chair', 2000, 10),
		('Ebony Bookshelf', 4000, 25),
		('Pine Dresser', 6000, DEFAULT),
		('Oak Desk', 3000, 18),
		('Sandalwood Sofa', 15000, 5),
		('Maple Nightstand', 2500, 7),
		('Walnut Coffee Table', 3500, 10);



INSERT INTO Employee (manager_id, emp_first_name, emp_last_name, employee_mobile, employee_address)
VALUES (4009, 'Chaminda','Perera',0777111223 ,'123 Galle Road, Colombo'),
		(NULL, 'Saliya','Rajapaksa',0718234567 ,'	456 Kandy Road, Kandy'),
		(4009, 'Anuradha','Silva',0769345678 ,'789 Nawala Road, Colombo'),
		(NULL, 'Menaka','Gunawardana',0758456789 ,'321 Negombo Road, Negombo'),
		(4003, 'Vidura','Fernando',0727567890 ,'567 Havelock Road, Colombo'),
		(4009, 'Shalini','Bandara',0778678901 ,'	890 Gampaha Road, Gampaha'),
		(4003, 'Kasun','Fernando',0769789012 ,'234 High Level Road, Colombo'),
		(4009, 'Iresha','Silva',0710901234 ,'	876 Main Street, Kandy'),
		(NULL, 'Lakmal','Rajakaruna', 0751012345,'432 Colombo Road, Kurunegala'),
		(4003, 'Dhanushka','Gunasekara', 0772112233,'765 Negombo Road, Negombo');



INSERT INTO Delivery (delivery_date, delivery_status)
VALUES ('2023-05-07', 'Delivered'),
		('2023-07-15', 'Delivered'),
		('2023-06-25', 'Delivered'),
		('2023-09-28', 'Delivered'),
		('2023-08-05', 'Delivered'),
		('2023-10-06', 'Pending'),
		('2024-01-04', 'Pending'),
		('2024-01-06', 'Pending'),
		('2024-01-19', 'Pending'),
		('2024-01-21', 'Pending');


INSERT INTO Orders (order_type,customer_id,employee_id,delivery_id, order_description)
VALUES ('Regular',1000,4003, 3000,'Teak Dining Table'),
		('Custom', 1003, 4006, 3004,'Luxury Outdoor Patio Furniture Set'),
		('Regular', 1006, 4009,3008,'Mahogany Wardrobe'),
		('Regular', 1009, 4012,3012,'Bamboo Chair'),
		('Regular', 1012,4015,NULL,'Ebony Bookshelf'),
		('Custom', 1015,4018,3020,'Premium Study Room Essentials Collection with Modern Design'),
		('Custom', 1018,4021,3024,'Designer Kitchen Cabinets and State-of-the-Art Appliances'),
		('Regular', 1021,4024,3028,'Maple Nightstand'),
		('Custom', 1024, 4000,3032,'Executive Office Furniture Set for Professionals'),
		('Regular', 1027, 4027,3036,'Ebony Bookshelf'),
		('Regular', 1012,4000,3016,'Elegant Walnut Coffee Table');


INSERT INTO Invoice (order_id, invoice_date,invoice_quantity)
VALUES (5000, '2023-12-01',2),
    (5006, '2023-12-02', 1),
    (5012, '2023-12-03', 1),
    (5018, '2023-12-04', 3),     
    (5030, '2023-12-05', 1),
    (5036, '2023-12-06', 1),
    (5042, '2023-12-07', 2),
    (5048, '2023-12-08', 2),
    (5054, '2023-12-09', 3),
    (5060, '2023-12-10', 1);


INSERT INTO Supplier (supplier_name,supplier_mobile)
VALUES ('Crestwood Materials',711234444),
('Quality suppliers',701234464),
('Prime Materials Ltd.',721231011),
('Pro FurniSupplies',771233353),
('Elite Materials Hub',721234556),
('Supreme FurniMarts',711231232),
('OptiCraft Suppliers',701235678),
('Superior FurniMaterials',721298374),
('Evergreen Supplies',705234525),
('Swift FurniSolutions',701233582);


--only 2 employees incharge of delivery
INSERT INTO EmployeeDelivery
VALUES(4000, 3000),
		(4003, 3004),
		(4003, 3008),
		(4000,3012),
		(4000,3020),
		(4003,3024),
		(4000,3028),
		(4003,3032),
		(4000,3036),
		(4000,3016);


INSERT INTO OrderFurniture
VALUES (5000,6000),
		(5012,6003),
		(5018,6009),
		(5024,6012),
		(5042,6024),
		(5054,6012),
		(5060,6027);


--manager 4003 manages employees incharge of order
--manager 4009 manages employees who build furniture
INSERT INTO Build
VALUES (4000,5006),
		(4006,5030),
		(4015,5036),
		(4021,5048);


INSERT INTO FurnitureSupplier
VALUES (6000,2000),
		(6003,2002),
		(6006,2006),
		(6009,2012),
		(6012,2010),
		(6015,2014),
		(6018,2010),
		(6021,2000),
		(6024,2018),
		(6027,2010);


INSERT INTO CustomOrderSupplier
VALUES (5006,2000,20000),   
		(5030,2010,16000),
		(5036,2018,10000),
		(5048,2016,27000);