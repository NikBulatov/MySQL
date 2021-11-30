USE samples;
/*
 Домашнее задание по теме “Сложные запросы”
 1. Составьте список пользователей users, которые осуществили хотя бы один заказ orders в интернет магазине.
 */
DROP TABLE IF EXISTS orders;
CREATE TABLE IF NOT EXISTS orders
(
    id         SERIAL,
    product_id BIGINT UNSIGNED NOT NULL,
    user_id    BIGINT UNSIGNED NOT NULL,
    PRIMARY KEY (id, product_id, user_id)
);

DROP TABLE IF EXISTS users;
CREATE TABLE IF NOT EXISTS users
(
    id   SERIAL PRIMARY KEY,
    name VARCHAR(20)
);

DROP TABLE IF EXISTS products;
CREATE TABLE IF NOT EXISTS products
(
    id   SERIAL PRIMARY KEY,
    name VARCHAR(50)
);
ALTER TABLE orders
    ADD CONSTRAINT product_id_fk FOREIGN KEY (product_id) REFERENCES products (id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE orders
    ADD CONSTRAINT user_id_fk FOREIGN KEY (user_id) REFERENCES users (id) ON UPDATE CASCADE ON DELETE CASCADE;

INSERT INTO users
VALUES (1, 'John'),
       (2, 'Fred'),
       (3, 'Katy');
INSERT INTO products
VALUES (1, 'Microwave'),
       (2, 'Computer'),
       (3, 'Coffee machine');
INSERT INTO orders
VALUES (1, 3, 2),
       (2, 1, 3),
       (3, 2, 1),
       (4, 1, 1);

SELECT id, product, user
FROM (SELECT orders.id, users.name AS user, products.name AS product
      FROM orders
               JOIN
           users
               JOIN
           products
           ON user_id = users.id
               AND product_id = products.id) AS result
ORDER BY id;
SELECT COUNT(id) AS amount, user
FROM (SELECT orders.id, users.name AS user
      FROM orders
               JOIN
           users
           ON user_id = users.id
     ) AS result
GROUP BY user;


/*
 3. (по желанию) Пусть имеется таблица рейсов flights (id, from, to) и таблица городов cities (label, name).
 Поля from, to и label содержат английские названия городов, поле name — русское.
 Выведите список рейсов flights с русскими названиями городов.
 */
DROP TABLE IF EXISTS flights;
CREATE TABLE IF NOT EXISTS flights
(
    id     SERIAL PRIMARY KEY,
    `from` VARCHAR(50),
    `to`   VARCHAR(50)
);
DROP TABLE IF EXISTS cities;
CREATE TABLE IF NOT EXISTS cities
(
    label VARCHAR(50),
    name  VARCHAR(50)
);
INSERT INTO cities
VALUES ('moscow', 'Москва'),
       ('bor', 'Бор'),
       ('omsk', 'Омск'),
       ('kazan', 'Казань'),
       ('balahna', 'Балахна'),
       ('ufa', 'Уфа'),
       ('novgorod', 'Новгород');
INSERT INTO flights
VALUES (1, 'moscow', 'omsk'),
       (2, 'novgorod', 'kazan'),
       (3, 'bor', 'balahna'),
       (4, 'omsk', 'ufa');
SELECT DISTINCT f_name, t_name
FROM (SELECT name AS f_name FROM flights JOIN cities ON `from`=cities.label) AS f_n JOIN
    (SELECT name AS t_name FROM flights JOIN cities ON `to`=cities.label) AS t_n;

