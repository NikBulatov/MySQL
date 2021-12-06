/*
 Практическое задание по теме “Транзакции, переменные, представления”:
 1. В базе данных shop и sample присутствуют одни и те же таблицы, учебной базы данных.
 Переместите запись id = 1 из таблицы shop.users в таблицу sample.users. Используйте транзакции.
*/

/* 2. Создайте представление, которое выводит название name товарной позиции из таблицы products
   и соответствующее название каталога name из таблицы catalogs.
 */
USE samples;

DROP VIEW IF EXISTS v_products_and_catalogs;
CREATE OR REPLACE VIEW v_products_and_catalogs AS
SELECT id, name, (SELECT name FROM catalogs WHERE catalog_id = catalogs.id) AS catalog_name
FROM products;

SELECT id, name, catalog_name FROM v_products_and_catalogs;

