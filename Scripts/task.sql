/*
Практическое задание по теме “Оптимизация запросов”
1) Создайте таблицу logs типа Archive.
Пусть при каждом создании записи в таблицах users, catalogs и products
 в таблицу logs помещается время и дата создания записи, название таблицы,
 идентификатор первичного ключа и содержимое поля name.

2) Создайте SQL-запрос, который помещает в таблицу users миллион записей.
 */
-- 1
USE shop;
DROP TABLE IF EXISTS `logs`;
CREATE TABLE `logs`
(
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP NOT NULL,
    table_name VARCHAR(255)                       NOT NULL,
    id_pk      BIGINT UNSIGNED                    NOT NULL,
    row_name   VARCHAR(255)                       NOT NULL
) ENGINE = Archive;

DROP TRIGGER IF EXISTS users_log;
DELIMITER //
CREATE TRIGGER users_log
    AFTER INSERT
    ON users
    FOR EACH ROW
BEGIN
    INSERT INTO logs
    SET table_name = 'users',
        id_pk      = NEW.id,
        row_name   = NEW.name;
END //

DROP TRIGGER IF EXISTS catalogs_log//
CREATE TRIGGER catalogs_log
    AFTER INSERT
    ON catalogs
    FOR EACH ROW
BEGIN
    INSERT INTO logs
    SET table_name = 'catalogs',
        id_pk      = NEW.id,
        row_name   = NEW.name;
END //
DROP TRIGGER IF EXISTS products_log//
CREATE TRIGGER products_log
    AFTER INSERT
    ON products
    FOR EACH ROW
BEGIN
    INSERT INTO logs
    SET table_name = 'products',
        id_pk      = NEW.id,
        row_name   = NEW.name;
END //
DELIMITER ;
-- 2
DROP PROCEDURE IF EXISTS insert_million;
DELIMITER //
CREATE PROCEDURE insert_million()
BEGIN
    DECLARE count INT DEFAULT 7;
    WHILE count < 1000000
        DO
            INSERT INTO users (name, birthday_at)
            VALUES (CONCAT('user_', count), NOW());
            SET count = count + 1;
        END WHILE;
END//
DELIMITER ;
-- checking
CALL insert_million();
SELECT id
FROM users;