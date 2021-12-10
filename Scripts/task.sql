/*
Практическое задание по теме “Оптимизация запросов”
1) Создайте таблицу logs типа Archive.
Пусть при каждом создании записи в таблицах users, catalogs и products
 в таблицу logs помещается время и дата создания записи, название таблицы,
 идентификатор первичного ключа и содержимое поля name.

2) Создайте SQL-запрос, который помещает в таблицу users миллион записей.
 */
-- 1
USE samples;
DROP TABLE IF EXISTS `logs`;
CREATE TABLE `logs`
(
    id SERIAL PRIMARY KEY,
    user_id BIGINT UNSIGNED NOT NULL,
    catalog_id BIGINT UNSIGNED NOT NULL,
    product_id BIGINT UNSIGNED NOT NULL,
    table_name VARCHAR(255),
    catalog_updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    product_updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    user_updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (user_id) REFERENCES users(id) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (catalog_id) REFERENCES catalogs(id) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES products(id) ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE = Archive;
-- 2
