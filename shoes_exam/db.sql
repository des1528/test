SET NAMES utf8mb4;
DROP DATABASE IF EXISTS shoes;
CREATE DATABASE shoes CHARACTER SET utf8mb4;
USE shoes;

CREATE TABLE roles (id INT AUTO_INCREMENT PRIMARY KEY, name VARCHAR(50) NOT NULL UNIQUE);
CREATE TABLE categories (id INT AUTO_INCREMENT PRIMARY KEY, name VARCHAR(50) NOT NULL UNIQUE);
CREATE TABLE units (id INT AUTO_INCREMENT PRIMARY KEY, name VARCHAR(20) NOT NULL UNIQUE);
CREATE TABLE suppliers (id INT AUTO_INCREMENT PRIMARY KEY, name VARCHAR(100) NOT NULL UNIQUE);
CREATE TABLE manufacturers (id INT AUTO_INCREMENT PRIMARY KEY, name VARCHAR(100) NOT NULL UNIQUE);
CREATE TABLE statuses (id INT AUTO_INCREMENT PRIMARY KEY, name VARCHAR(50) NOT NULL UNIQUE);
CREATE TABLE pickup_points (id INT AUTO_INCREMENT PRIMARY KEY, address VARCHAR(200) NOT NULL);

CREATE TABLE users (
  id INT AUTO_INCREMENT PRIMARY KEY,
  role_id INT NOT NULL,
  full_name VARCHAR(150) NOT NULL,
  login VARCHAR(100) NOT NULL UNIQUE,
  password VARCHAR(100) NOT NULL,
  FOREIGN KEY (role_id) REFERENCES roles(id)
);

CREATE TABLE products (
  id INT AUTO_INCREMENT PRIMARY KEY,
  article VARCHAR(10) NOT NULL UNIQUE,
  name VARCHAR(100) NOT NULL,
  unit_id INT NOT NULL,
  price DECIMAL(10,2) NOT NULL CHECK (price >= 0),
  supplier_id INT NOT NULL,
  manufacturer_id INT NOT NULL,
  category_id INT NOT NULL,
  discount INT NOT NULL DEFAULT 0,
  quantity INT NOT NULL DEFAULT 0 CHECK (quantity >= 0),
  description TEXT,
  photo VARCHAR(255),
  FOREIGN KEY (unit_id) REFERENCES units(id),
  FOREIGN KEY (supplier_id) REFERENCES suppliers(id),
  FOREIGN KEY (manufacturer_id) REFERENCES manufacturers(id),
  FOREIGN KEY (category_id) REFERENCES categories(id)
);

CREATE TABLE orders (
  id INT AUTO_INCREMENT PRIMARY KEY,
  order_date DATE NOT NULL,
  delivery_date DATE NOT NULL,
  pickup_point_id INT NOT NULL,
  user_id INT NOT NULL,
  code INT NOT NULL,
  status_id INT NOT NULL,
  FOREIGN KEY (pickup_point_id) REFERENCES pickup_points(id),
  FOREIGN KEY (user_id) REFERENCES users(id),
  FOREIGN KEY (status_id) REFERENCES statuses(id)
);

CREATE TABLE order_items (
  order_id INT NOT NULL,
  product_id INT NOT NULL,
  quantity INT NOT NULL,
  PRIMARY KEY (order_id, product_id),
  FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE CASCADE,
  FOREIGN KEY (product_id) REFERENCES products(id)
);

INSERT INTO roles (name) VALUES
('Администратор'),
('Менеджер'),
('Авторизированный клиент');
INSERT INTO categories (name) VALUES
('Женская обувь'),
('Мужская обувь');
INSERT INTO units (name) VALUES
('шт.');
INSERT INTO suppliers (name) VALUES
('Kari'),
('Обувь для вас');
INSERT INTO manufacturers (name) VALUES
('Kari'),
('Marco Tozzi'),
('Рос'),
('Rieker'),
('Alessio Nesca'),
('CROSBY');
INSERT INTO statuses (name) VALUES
('Завершен'),
('Новый');
INSERT INTO pickup_points (address) VALUES
('420151, г. Лесной, ул. Вишневая, 32'),
('125061, г. Лесной, ул. Подгорная, 8'),
('630370, г. Лесной, ул. Шоссейная, 24'),
('400562, г. Лесной, ул. Зеленая, 32'),
('614510, г. Лесной, ул. Маяковского, 47'),
('410542, г. Лесной, ул. Светлая, 46'),
('620839, г. Лесной, ул. Цветочная, 8'),
('443890, г. Лесной, ул. Коммунистическая, 1'),
('603379, г. Лесной, ул. Спортивная, 46'),
('603721, г. Лесной, ул. Гоголя, 41'),
('410172, г. Лесной, ул. Северная, 13'),
('614611, г. Лесной, ул. Молодежная, 50'),
('454311, г.Лесной, ул. Новая, 19'),
('660007, г.Лесной, ул. Октябрьская, 19'),
('603036, г. Лесной, ул. Садовая, 4'),
('394060, г.Лесной, ул. Фрунзе, 43'),
('410661, г. Лесной, ул. Школьная, 50'),
('625590, г. Лесной, ул. Коммунистическая, 20'),
('625683, г. Лесной, ул. 8 Марта'),
('450983, г.Лесной, ул. Комсомольская, 26'),
('394782, г. Лесной, ул. Чехова, 3'),
('603002, г. Лесной, ул. Дзержинского, 28'),
('450558, г. Лесной, ул. Набережная, 30'),
('344288, г. Лесной, ул. Чехова, 1'),
('614164, г.Лесной,  ул. Степная, 30'),
('394242, г. Лесной, ул. Коммунистическая, 43'),
('660540, г. Лесной, ул. Солнечная, 25'),
('125837, г. Лесной, ул. Шоссейная, 40'),
('125703, г. Лесной, ул. Партизанская, 49'),
('625283, г. Лесной, ул. Победы, 46'),
('614753, г. Лесной, ул. Полевая, 35'),
('426030, г. Лесной, ул. Маяковского, 44'),
('450375, г. Лесной ул. Клубная, 44'),
('625560, г. Лесной, ул. Некрасова, 12'),
('630201, г. Лесной, ул. Комсомольская, 17'),
('190949, г. Лесной, ул. Мичурина, 26');
INSERT INTO users (role_id, full_name, login, password) VALUES
(1, 'Никифорова Весения Николаевна', '94d5ous@gmail.com', 'uzWC67'),
(1, 'Сазонов Руслан Германович', 'uth4iz@mail.com', '2L6KZG'),
(1, 'Одинцов Серафим Артёмович', 'yzls62@outlook.com', 'JlFRCZ'),
(2, 'Степанов Михаил Артёмович', '1diph5e@tutanota.com', '8ntwUp'),
(2, 'Ворсин Петр Евгеньевич', 'tjde7c@yahoo.com', 'YOyhfR'),
(2, 'Старикова Елена Павловна', 'wpmrc3do@tutanota.com', 'RSbvHv'),
(3, 'Михайлюк Анна Вячеславовна', '5d4zbu@tutanota.com', 'rwVDh9'),
(3, 'Ситдикова Елена Анатольевна', 'ptec8ym@yahoo.com', 'LdNyos'),
(3, 'Ворсин Петр Евгеньевич', '1qz4kw@mail.com', 'gynQMT'),
(3, 'Старикова Елена Павловна', '4np6se@mail.com', 'AtnDjr');
INSERT INTO products (article, name, unit_id, price, supplier_id, manufacturer_id, category_id, discount, quantity, description, photo) VALUES
('А112Т4', 'Ботинки', 1, 4990, 1, 1, 1, 3, 6, 'Женские Ботинки демисезонные kari', '1.jpg'),
('F635R4', 'Ботинки', 1, 3244, 2, 2, 1, 2, 13, 'Ботинки Marco Tozzi женские демисезонные, размер 39, цвет бежевый', '2.jpg'),
('H782T5', 'Туфли', 1, 4499, 1, 1, 2, 4, 5, 'Туфли kari мужские классика MYZ21AW-450A, размер 43, цвет: черный', '3.jpg'),
('G783F5', 'Ботинки', 1, 5900, 1, 3, 2, 2, 8, 'Мужские ботинки Рос-Обувь кожаные с натуральным мехом', '4.jpg'),
('J384T6', 'Ботинки', 1, 3800, 2, 4, 2, 2, 16, 'B3430/14 Полуботинки мужские Rieker', '5.jpg'),
('D572U8', 'Кроссовки', 1, 4100, 2, 3, 2, 3, 6, '129615-4 Кроссовки мужские', '6.jpg'),
('F572H7', 'Туфли', 1, 2700, 1, 2, 1, 2, 14, 'Туфли Marco Tozzi женские летние, размер 39, цвет черный', '7.jpg'),
('D329H3', 'Полуботинки', 1, 1890, 2, 5, 1, 4, 4, 'Полуботинки Alessio Nesca женские 3-30797-47, размер 37, цвет: бордовый', '8.jpg'),
('B320R5', 'Туфли', 1, 4300, 1, 4, 1, 2, 6, 'Туфли Rieker женские демисезонные, размер 41, цвет коричневый', '9.jpg'),
('G432E4', 'Туфли', 1, 2800, 1, 1, 1, 3, 15, 'Туфли kari женские TR-YR-413017, размер 37, цвет: черный', '10.jpg'),
('S213E3', 'Полуботинки', 1, 2156, 2, 6, 2, 3, 6, '407700/01-01 Полуботинки мужские CROSBY', NULL),
('E482R4', 'Полуботинки', 1, 1800, 1, 1, 1, 2, 14, 'Полуботинки kari женские MYZ20S-149, размер 41, цвет: черный', NULL),
('S634B5', 'Кеды', 1, 5500, 2, 6, 2, 3, 0, 'Кеды Caprice мужские демисезонные, размер 42, цвет черный', NULL),
('K345R4', 'Полуботинки', 1, 2100, 2, 6, 2, 2, 3, '407700/01-02 Полуботинки мужские CROSBY', NULL),
('O754F4', 'Туфли', 1, 5400, 2, 4, 1, 4, 18, 'Туфли женские демисезонные Rieker артикул 55073-68/37', NULL),
('G531F4', 'Ботинки', 1, 6600, 1, 1, 1, 12, 9, 'Ботинки женские зимние ROMER арт. 893167-01 Черный', NULL),
('J542F5', 'Тапочки', 1, 500, 1, 1, 2, 13, 0, 'Тапочки мужские Арт.70701-55-67син р.41', NULL),
('B431R5', 'Ботинки', 1, 2700, 2, 4, 2, 2, 5, 'Мужские кожаные ботинки/мужские ботинки', NULL),
('P764G4', 'Туфли', 1, 6800, 1, 6, 1, 15, 15, 'Туфли женские, ARGO, размер 38', NULL),
('C436G5', 'Ботинки', 1, 10200, 1, 5, 1, 15, 9, 'Ботинки женские, ARGO, размер 40', NULL),
('F427R5', 'Ботинки', 1, 11800, 2, 4, 1, 15, 11, 'Ботинки на молнии с декоративной пряжкой FRAU', NULL),
('N457T5', 'Полуботинки', 1, 4600, 1, 6, 1, 3, 13, 'Полуботинки Ботинки черные зимние, мех', NULL),
('D364R4', 'Туфли', 1, 12400, 1, 1, 1, 16, 5, 'Туфли Luiza Belly женские Kate-lazo черные из натуральной замши', NULL),
('S326R5', 'Тапочки', 1, 9900, 2, 6, 2, 17, 15, 'Мужские кожаные тапочки "Профиль С.Дали"', NULL),
('L754R4', 'Полуботинки', 1, 1700, 1, 1, 1, 2, 7, 'Полуботинки kari женские WB2020SS-26, размер 38, цвет: черный', NULL),
('M542T5', 'Кроссовки', 1, 2800, 2, 4, 2, 18, 3, 'Кроссовки мужские TOFA', NULL),
('D268G5', 'Туфли', 1, 4399, 2, 4, 1, 3, 12, 'Туфли Rieker женские демисезонные, размер 36, цвет коричневый', NULL),
('T324F5', 'Сапоги', 1, 4699, 1, 6, 1, 2, 5, 'Сапоги замша Цвет: синий', NULL),
('K358H6', 'Тапочки', 1, 599, 1, 4, 2, 20, 2, 'Тапочки мужские син р.41', NULL),
('H535R5', 'Ботинки', 1, 2300, 2, 4, 1, 2, 7, 'Женские Ботинки демисезонные', NULL);
INSERT INTO orders (id, order_date, delivery_date, pickup_point_id, user_id, code, status_id) VALUES
(1, '2025-02-27', '2025-04-20', 1, 4, 901, 1),
(2, '2022-09-28', '2025-04-21', 11, 1, 902, 1),
(3, '2025-03-21', '2025-04-22', 2, 2, 903, 1),
(4, '2025-02-20', '2025-04-23', 11, 3, 904, 1),
(5, '2025-03-17', '2025-04-24', 2, 4, 905, 1),
(6, '2025-03-01', '2025-04-25', 15, 1, 906, 1),
(7, '2025-02-28', '2025-04-26', 3, 2, 907, 1),
(8, '2025-03-31', '2025-04-27', 19, 3, 908, 2),
(9, '2025-04-02', '2025-04-28', 5, 4, 909, 2),
(10, '2025-04-03', '2025-04-29', 19, 4, 910, 2);
INSERT INTO order_items (order_id, product_id, quantity) VALUES
(1, 1, 2),
(1, 2, 2),
(2, 3, 1),
(2, 4, 1),
(3, 5, 10),
(3, 6, 10),
(4, 7, 5),
(4, 8, 4),
(5, 1, 2),
(5, 2, 2),
(6, 3, 1),
(6, 4, 1),
(7, 5, 10),
(7, 6, 10),
(8, 7, 5),
(8, 8, 4),
(9, 9, 5),
(9, 10, 1),
(10, 11, 5),
(10, 12, 5);

