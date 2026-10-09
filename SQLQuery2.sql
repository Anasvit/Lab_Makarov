
BEGIN TRANSACTION;

IF OBJECT_ID('OrderProducts', 'U') IS NOT NULL DROP TABLE OrderProducts;
IF OBJECT_ID('Orders', 'U') IS NOT NULL DROP TABLE Orders;
IF OBJECT_ID('Products', 'U') IS NOT NULL DROP TABLE Products;
IF OBJECT_ID('PickUpPoint', 'U') IS NOT NULL DROP TABLE PickUpPoint;
IF OBJECT_ID('ProductCategories', 'U') IS NOT NULL DROP TABLE ProductCategories;
IF OBJECT_ID('Companies', 'U') IS NOT NULL DROP TABLE Companies;
IF OBJECT_ID('OrderStatuses', 'U') IS NOT NULL DROP TABLE OrderStatuses;
IF OBJECT_ID('Users', 'U') IS NOT NULL DROP TABLE Users;
IF OBJECT_ID('Roles', 'U') IS NOT NULL DROP TABLE Roles;

CREATE TABLE Companies (
	Id INT IDENTITY(1,1) NOT NULL,
	Name NVARCHAR(MAX) NOT NULL,
	CONSTRAINT PK_Companies PRIMARY KEY (Id)
);

CREATE TABLE OrderStatuses (
	Id INT IDENTITY(1,1) NOT NULL,
	Name NVARCHAR(MAX) NULL,
	CONSTRAINT PK_OrderStatuses PRIMARY KEY (Id)
);

CREATE TABLE Roles (
	Id INT IDENTITY(1,1) NOT NULL,
	Name NVARCHAR(MAX) NOT NULL,
	CONSTRAINT PK_Roles PRIMARY KEY (Id)
);

CREATE TABLE Users (
	Id INT IDENTITY(1,1) NOT NULL,
	RoleId INT NULL,
	FullName NVARCHAR(MAX) NOT NULL,
	Login NVARCHAR(255) NOT NULL,
	Password NVARCHAR(255) NOT NULL,
	CONSTRAINT PK_Users PRIMARY KEY (Id),
	CONSTRAINT UQ_Users_Login UNIQUE (Login)
);

CREATE TABLE PickUpPoint (
	Id INT IDENTITY(1,1) NOT NULL,
	Address NVARCHAR(MAX) NOT NULL,
	CONSTRAINT PK_PickUpPoint PRIMARY KEY (Id)
);

CREATE TABLE ProductCategories (
	Id INT IDENTITY(1,1) NOT NULL,
	Name NVARCHAR(MAX) NOT NULL,
	CONSTRAINT PK_ProductCategories PRIMARY KEY (Id)
);

CREATE TABLE Products (
	Article NVARCHAR(50) NOT NULL,
	Name NVARCHAR(MAX) NOT NULL,
	Unit NVARCHAR(50) NOT NULL,
	Price INT NOT NULL,
	ProviderId INT NOT NULL,
	ManufacturerId INT NOT NULL,
	CategoryId INT NOT NULL,
	CurrentDiscount INT NOT NULL,
	Count INT NOT NULL,
	Description NVARCHAR(MAX) NOT NULL,
	PhotoPath NVARCHAR(MAX) NULL,
	CONSTRAINT PK_Products PRIMARY KEY (Article),
	CONSTRAINT UQ_Products_Article UNIQUE (Article)
);

CREATE TABLE Orders (
	OrderId INT IDENTITY(1,1) NOT NULL,
	OrderedDate DATE NOT NULL,
	DeliveryDate DATE NOT NULL,
	PickUpPointId INT NOT NULL,
	UserId INT NOT NULL,
	DeliveryCode INT NOT NULL,
	StatusId INT NOT NULL,
	CONSTRAINT PK_Orders PRIMARY KEY (OrderId)
);

CREATE TABLE OrderProducts (
	OrderId INT NOT NULL,
	Article NVARCHAR(50) NOT NULL,
	Count INT NOT NULL,
	CONSTRAINT PK_OrderProducts PRIMARY KEY (OrderId, Article)
);

ALTER TABLE Users ADD CONSTRAINT FK_Users_Roles FOREIGN KEY (RoleId) REFERENCES Roles(Id);

ALTER TABLE Products ADD CONSTRAINT FK_Products_ProductCategories FOREIGN KEY (CategoryId) REFERENCES ProductCategories(Id);
ALTER TABLE Products ADD CONSTRAINT FK_Products_Companies_Manufacturer FOREIGN KEY (ManufacturerId) REFERENCES Companies(Id);
ALTER TABLE Products ADD CONSTRAINT FK_Products_Companies_Provider FOREIGN KEY (ProviderId) REFERENCES Companies(Id);

ALTER TABLE Orders ADD CONSTRAINT FK_Orders_PickUpPoint FOREIGN KEY (PickUpPointId) REFERENCES PickUpPoint(Id);
ALTER TABLE Orders ADD CONSTRAINT FK_Orders_Users FOREIGN KEY (UserId) REFERENCES Users(Id);
ALTER TABLE Orders ADD CONSTRAINT FK_Orders_OrderStatuses FOREIGN KEY (StatusId) REFERENCES OrderStatuses(Id);

ALTER TABLE OrderProducts ADD CONSTRAINT FK_OrderProducts_Orders FOREIGN KEY (OrderId) REFERENCES Orders(OrderId);
ALTER TABLE OrderProducts ADD CONSTRAINT FK_OrderProducts_Products FOREIGN KEY (Article) REFERENCES Products(Article);

SET IDENTITY_INSERT Companies ON;
INSERT INTO Companies (Id, Name) VALUES 
(1, N'Обувь для вас'),
(2, N'Рос'),
(3, N'Marco Tozzi'),
(4, N'Alessio Nesca'),
(5, N'Kari'),
(6, N'CROSBY'),
(7, N'Rieker');
SET IDENTITY_INSERT Companies OFF;

SET IDENTITY_INSERT OrderStatuses ON;
INSERT INTO OrderStatuses (Id, Name) VALUES 
(1, N'Новый'),
(2, N'Завершен');
SET IDENTITY_INSERT OrderStatuses OFF;

SET IDENTITY_INSERT Roles ON;
INSERT INTO Roles (Id, Name) VALUES 
(1, N'Авторизированный клиент'),
(2, N'Менеджер'),
(3, N'Администратор');
SET IDENTITY_INSERT Roles OFF;

SET IDENTITY_INSERT Users ON;
INSERT INTO Users (Id, RoleId, FullName, Login, Password) VALUES 
(1, 3, N'Никифорова Весения Николаевна', N'94d5ous@gmail.com', N'uzWC67'),
(2, 3, N'Сазонов Руслан Германович', N'uth4iz@mail.com', N'2L6KZG'),
(3, 3, N'Одинцов Серафим Артёмович', N'yzls62@outlook.com', N'JlFRCZ'),
(4, 2, N'Степанов Михаил Артёмович', N'1diph5e@tutanota.com', N'8ntwUp'),
(5, 2, N'Ворсин Петр Евгеньевич', N'tjde7c@yahoo.com', N'YOyhfR'),
(6, 2, N'Старикова Елена Павловна', N'wpmrc3do@tutanota.com', N'RSbvHv'),
(7, 1, N'Михайлюк Анна Вячеславовна', N'5d4zbu@tutanota.com', N'rwVDh9'),
(8, 1, N'Ситдикова Елена Анатольевна', N'ptec8ym@yahoo.com', N'LdNyos'),
(9, 1, N'Ворсин Петр Евгеньевич', N'1qz4kw@mail.com', N'gynQMT'),
(10, 1, N'Старикова Елена Павловна', N'4np6se@mail.com', N'AtnDjr');
SET IDENTITY_INSERT Users OFF;

-- 5. PickUpPoint (родительская для Orders)
SET IDENTITY_INSERT PickUpPoint ON;
INSERT INTO PickUpPoint (Id, Address) VALUES 
(1, N'420151, г. Лесной, ул. Вишневая, 32'),
(2, N'125061, г. Лесной, ул. Подгорная, 8'),
(3, N'630370, г. Лесной, ул. Шоссейная, 24'),
(4, N'400562, г. Лесной, ул. Зеленая, 32'),
(5, N'614510, г. Лесной, ул. Маяковского, 47'),
(6, N'410542, г. Лесной, ул. Светлая, 46'),
(7, N'620839, г. Лесной, ул. Цветочная, 8'),
(8, N'443890, г. Лесной, ул. Коммунистическая, 1'),
(9, N'603379, г. Лесной, ул. Спортивная, 46'),
(10, N'603721, г. Лесной, ул. Гоголя, 41'),
(11, N'410172, г. Лесной, ул. Северная, 13'),
(12, N'614611, г. Лесной, ул. Молодежная, 50'),
(13, N'454311, г.Лесной, ул. Новая, 19'),
(14, N'660007, г.Лесной, ул. Октябрьская, 19'),
(15, N'603036, г. Лесной, ул. Садовая, 4'),
(16, N'394060, г.Лесной, ул. Фрунзе, 43'),
(17, N'410661, г. Лесной, ул. Школьная, 50'),
(18, N'625590, г. Лесной, ул. Коммунистическая, 20'),
(19, N'625683, г. Лесной, ул. 8 Марта'),
(20, N'450983, г.Лесной, ул. Комсомольская, 26'),
(21, N'394782, г. Лесной, ул. Чехова, 3'),
(22, N'603002, г. Лесной, ул. Дзержинского, 28'),
(23, N'450558, г. Лесной, ул. Набережная, 30'),
(24, N'344288, г. Лесной, ул. Чехова, 1'),
(25, N'614164, г.Лесной, ул. Степная, 30'),
(26, N'394242, г. Лесной, ул. Коммунистическая, 43'),
(27, N'660540, г. Лесной, ул. Солнечная, 25'),
(28, N'125837, г. Лесной, ул. Шоссейная, 40'),
(29, N'125703, г. Лесной, ул. Партизанская, 49'),
(30, N'625283, г. Лесной, ул. Победы, 46'),
(31, N'614753, г. Лесной, ул. Полевая, 35'),
(32, N'426030, г. Лесной, ул. Маяковского, 44'),
(33, N'450375, г. Лесной ул. Клубная, 44'),
(34, N'625560, г. Лесной, ул. Некрасова, 12'),
(35, N'630201, г. Лесной, ул. Комсомольская, 17'),
(36, N'190949, г. Лесной, ул. Мичурина, 26');
SET IDENTITY_INSERT PickUpPoint OFF;

SET IDENTITY_INSERT ProductCategories ON;
INSERT INTO ProductCategories (Id, Name) VALUES 
(1, N'Женская обувь'),
(2, N'Мужская обувь');
SET IDENTITY_INSERT ProductCategories OFF;

INSERT INTO Products (Article, Name, Unit, Price, ProviderId, ManufacturerId, CategoryId, CurrentDiscount, Count, Description, PhotoPath) VALUES 
(N'А112Т4', N'Ботинки', N'шт.', 4990, 5, 5, 1, 3, 6, N'Женские Ботинки демисезонные 5', N'1.jpg'),
(N'F635R4', N'Ботинки', N'шт.', 3244, 1, 3, 1, 2, 13, N'Ботинки 3 женские демисезонные, размер 39, цвет бежевый', N'2.jpg'),
(N'H782T5', N'Туфли', N'шт.', 4499, 5, 5, 2, 4, 5, N'Туфли 5 мужские классика MYZ21AW-450A, размер 43, цвет: черный', N'3.jpg'),
(N'G783F5', N'Ботинки', N'шт.', 5900, 5, 2, 2, 2, 8, N'Мужские ботинки 2-Обувь кожаные с натуральным мехом', N'4.jpg'),
(N'J384T6', N'Ботинки', N'шт.', 3800, 1, 7, 2, 2, 16, N'B3430/14 Полуботинки мужские 7', N'5.jpg'),
(N'D572U8', N'Кроссовки', N'шт.', 4100, 1, 2, 2, 3, 6, N'129615-4 Кроссовки мужские', N'6.jpg'),
(N'F572H7', N'Туфли', N'шт.', 2700, 5, 3, 1, 2, 14, N'Туфли 3 женские летние, размер 39, цвет черный', N'7.jpg'),
(N'D329H3', N'Полуботинки', N'шт.', 1890, 1, 4, 1, 4, 4, N'Полуботинки 4 женские 3-30797-47, размер 37, цвет: бордовый', N'8.jpg'),
(N'B320R5', N'Туфли', N'шт.', 4300, 5, 7, 1, 2, 6, N'Туфли 7 женские демисезонные, размер 41, цвет коричневый', N'9.jpg'),
(N'G432E4', N'Туфли', N'шт.', 2800, 5, 5, 1, 3, 15, N'Туфли 5 женские TR-YR-413017, размер 37, цвет: черный', N'10.jpg'),
(N'S213E3', N'Полуботинки', N'шт.', 2156, 1, 6, 2, 3, 6, N'407700/01-01 Полуботинки мужские 6', NULL),
(N'E482R4', N'Полуботинки', N'шт.', 1800, 5, 5, 1, 2, 14, N'Полуботинки 5 женские MYZ20S-149, размер 41, цвет: черный', NULL),
(N'S634B5', N'Кеды', N'шт.', 5500, 1, 6, 2, 3, 0, N'Кеды Caprice мужские демисезонные, размер 42, цвет черный', NULL),
(N'K345R4', N'Полуботинки', N'шт.', 2100, 1, 6, 2, 2, 3, N'407700/01-02 Полуботинки мужские 6', NULL),
(N'O754F4', N'Туфли', N'шт.', 5400, 1, 7, 1, 4, 18, N'Туфли женские демисезонные 7 артикул 55073-68/37', NULL),
(N'G531F4', N'Ботинки', N'шт.', 6600, 5, 5, 1, 12, 9, N'Ботинки женские зимние ROMER арт. 893167-01 Черный', NULL),
(N'J542F5', N'Тапочки', N'шт.', 500, 5, 5, 2, 13, 0, N'Тапочки мужские Арт.70701-55-67син р.41', NULL),
(N'B431R5', N'Ботинки', N'шт.', 2700, 1, 7, 2, 2, 5, N'Мужские кожаные ботинки/мужские ботинки', NULL),
(N'P764G4', N'Туфли', N'шт.', 6800, 5, 6, 1, 15, 15, N'Туфли женские, ARGO, размер 38', NULL),
(N'C436G5', N'Ботинки', N'шт.', 10200, 5, 4, 1, 15, 9, N'Ботинки женские, ARGO, размер 40', NULL),
(N'F427R5', N'Ботинки', N'шт.', 11800, 1, 7, 1, 15, 11, N'Ботинки на молнии с декоративной пряжкой FRAU', NULL),
(N'N457T5', N'Полуботинки', N'шт.', 4600, 5, 6, 1, 3, 13, N'Полуботинки Ботинки черные зимние, мех', NULL),
(N'D364R4', N'Туфли', N'шт.', 12400, 5, 5, 1, 16, 5, N'Туфли Luiza Belly женские Kate-lazo черные из натуральной замши', NULL),
(N'S326R5', N'Тапочки', N'шт.', 9900, 1, 6, 2, 17, 15, N'Мужские кожаные тапочки "Профиль С.Дали"', NULL),
(N'L754R4', N'Полуботинки', N'шт.', 1700, 5, 5, 1, 2, 7, N'Полуботинки 5 женские WB2020SS-26, размер 38, цвет: черный', NULL),
(N'M542T5', N'Кроссовки', N'шт.', 2800, 1, 7, 2, 18, 3, N'Кроссовки мужские TOFA', NULL),
(N'D268G5', N'Туфли', N'шт.', 4399, 1, 7, 1, 3, 12, N'Туфли 7 женские демисезонные, размер 36, цвет коричневый', NULL),
(N'T324F5', N'Сапоги', N'шт.', 4699, 5, 6, 1, 2, 5, N'Сапоги замша Цвет: синий', NULL),
(N'K358H6', N'Тапочки', N'шт.', 599, 5, 7, 2, 20, 2, N'Тапочки мужские син р.41', NULL),
(N'H535R5', N'Ботинки', N'шт.', 2300, 1, 7, 1, 2, 7, N'Женские Ботинки демисезонные', NULL);

SET IDENTITY_INSERT Orders ON;
INSERT INTO Orders (OrderId, OrderedDate, DeliveryDate, PickUpPointId, UserId, DeliveryCode, StatusId) VALUES 
(1, '2025-02-27', '2025-04-20', 1, 4, 901, 2),
(2, '2022-09-28', '2025-04-21', 11, 1, 902, 2),
(3, '2025-03-21', '2025-04-22', 2, 2, 903, 2),
(4, '2025-02-20', '2025-04-23', 11, 3, 904, 2),
(5, '2025-03-17', '2025-04-24', 2, 4, 905, 2),
(6, '2025-03-01', '2025-04-25', 15, 1, 906, 2),
(7, '2025-03-02', '2025-04-26', 3, 2, 907, 2),
(8, '2025-03-31', '2025-04-27', 19, 3, 908, 1),
(9, '2025-04-02', '2025-04-28', 5, 4, 909, 1),
(10, '2025-04-03', '2025-04-29', 19, 4, 910, 1);
SET IDENTITY_INSERT Orders OFF;

INSERT INTO OrderProducts (OrderId, Article, Count) VALUES 
(1, N'А112Т4', 2),
(1, N'F635R4', 2),
(2, N'H782T5', 1),
(2, N'G783F5', 1),
(3, N'J384T6', 10),
(3, N'D572U8', 10),
(4, N'F572H7', 5),
(4, N'D329H3', 4),
(5, N'А112Т4', 2),
(5, N'F635R4', 2),
(6, N'H782T5', 1),
(6, N'G783F5', 1),
(7, N'J384T6', 10),
(7, N'D572U8', 10),
(8, N'F572H7', 5),
(8, N'D329H3', 4),
(9, N'B320R5', 5),
(9, N'G432E4', 1),
(10, N'S213E3', 5),
(10, N'E482R4', 5);

COMMIT;

SELECT 'Companies' AS TableName, COUNT(*) AS Count FROM Companies
UNION ALL
SELECT 'OrderStatuses', COUNT(*) FROM OrderStatuses
UNION ALL
SELECT 'Roles', COUNT(*) FROM Roles
UNION ALL
SELECT 'Users', COUNT(*) FROM Users
UNION ALL
SELECT 'PickUpPoint', COUNT(*) FROM PickUpPoint
UNION ALL
SELECT 'ProductCategories', COUNT(*) FROM ProductCategories
UNION ALL
SELECT 'Products', COUNT(*) FROM Products
UNION ALL
SELECT 'Orders', COUNT(*) FROM Orders
UNION ALL
SELECT 'OrderProducts', COUNT(*) FROM OrderProducts;
