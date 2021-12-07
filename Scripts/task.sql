/*
 Практическое задание по теме “Транзакции, переменные, представления”:
 1. В базе данных shop и sample присутствуют одни и те же таблицы, учебной базы данных.
 Переместите запись id = 1 из таблицы shop.users в таблицу sample.users. Используйте транзакции.
*/
SELECT @`values` := name
FROM shop.users
WHERE id = 1;
START TRANSACTION;
SELECT *
FROM samples.users;
SAVEPOINT samples_users;
UPDATE samples.users
SET name = @`values`
WHERE id = 1;
COMMIT;
SELECT *
FROM shop.users;

/* 2. Создайте представление, которое выводит название name товарной позиции из таблицы products
   и соответствующее название каталога name из таблицы catalogs.
 */
USE samples;
SELECT id, name, catalog_name
FROM v_products_and_catalogs;

/*
 Практическое задание по теме “Хранимые процедуры и функции, триггеры"
2. В таблице products есть два текстовых поля: name с названием товара и description с его описанием.
 Допустимо присутствие обоих полей или одно из них.
 Ситуация, когда оба поля принимают неопределенное значение NULL неприемлема.
 Используя триггеры, добейтесь того, чтобы одно из этих полей или оба поля были заполнены.
 При попытке присвоить полям NULL-значение необходимо отменить операцию.
 */
DROP TRIGGER IF EXISTS insert_name_or_description;
DELIMITER //
CREATE TRIGGER insert_name_or_description
    BEFORE INSERT
    ON products
    FOR EACH ROW
BEGIN
    IF NEW.name <=> NULL AND NEW.description <=> NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Оба поля не может быть пустым. Только одно';
    ELSE
        SET NEW.name = NEW.name;
        SET NEW.description = NEW.description;
    END IF;
END //
DROP TRIGGER IF EXISTS update_name_or_description //
CREATE TRIGGER update_name_or_description
    BEFORE UPDATE
    ON products
    FOR EACH ROW
BEGIN
    IF NEW.name <=> NULL AND NEW.description <=> NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Оба поля не могут быть пустыми. Только одно';
    ELSE
        SET NEW.name = NEW.name;
        SET NEW.description = NEW.description;
    END IF;
END //
DELIMITER ;
SELECT *
FROM products;
INSERT INTO products (catalog_id, name, description)
VALUES (1, NULL, 'DJFSNFKSNFJSDFNSF');
INSERT INTO products (catalog_id, name, description)
VALUES (1, 'Coffee machine', 'DJFSNFKSNFJSDFNSF');
INSERT INTO products (catalog_id, name, description)
VALUES (1, NULL, NULL); -- [45000][1644] Оба поля не может быть пустым. Только одно
UPDATE products
SET name = NULL
WHERE id = 2;
UPDATE products
SET description = NULL
WHERE id = 2; -- [45000][1644] Оба поля не могут быть пустыми. Только одно
/*
3. (по желанию) Напишите хранимую функцию для вычисления произвольного числа Фибоначчи.
 Вызов функции FIBONACCI(10) должен возвращать число 55.
 */
DROP FUNCTION IF EXISTS FIBONACCI;
DELIMITER //
CREATE FUNCTION FIBONACCI(n INT)
    RETURNS INT DETERMINISTIC
BEGIN
    DECLARE i INT DEFAULT 0;
    DECLARE a INT DEFAULT 0;
    DECLARE b INT DEFAULT 1;
    DECLARE temp INT;
    WHILE i < n
        DO
            SET temp = a;
            SET a = b;
            SET b = temp + b;
            SET i = i + 1;
        END WHILE;
    RETURN a;
END //
DELIMITER ;
SELECT FIBONACCI(10);
