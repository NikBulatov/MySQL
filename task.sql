/*
https://docs.google.com/document/d/1yE0wn1m-EwqcJ458ga3eCptvBJcSIi1HaBp48OlT5ZI/edit
*/
-- Создаю столбцы, чтобы выполнить задание
USE vk;
ALTER TABLE users
    ADD COLUMN created_at DATETIME DEFAULT NOW();
ALTER TABLE users
    ADD COLUMN updated_at DATETIME DEFAULT NOW();

UPDATE users
SET created_at = '2005-12-06 13:56:02',
    updated_at = '2006-06-06 13:56:04';

-- 1. В таблице users поля created_at и updated_at оказались незаполненными. Заполните их текущими датой и временем
UPDATE users
SET created_at = NOW(),
    updated_at = NOW();
/*
2. Таблица users была неудачно спроектирована.
Записи created_at и updated_at были заданы типом VARCHAR и в них долгое время помещались значения в формате 20.10.2017 8:10.
Необходимо преобразовать поля к типу DATETIME, сохранив введённые ранее значения.
Изменяю тип данных в столбцах.
 */
ALTER TABLE users
    MODIFY COLUMN created_at VARCHAR(255) DEFAULT NULL;
ALTER TABLE users
    MODIFY COLUMN updated_at VARCHAR(255) DEFAULT NULL;
-- преобразовываю
UPDATE users
SET created_at = STR_TO_DATE(created_at, '%d.%m.%Y %k:%i'),
    updated_at = STR_TO_DATE(updated_at, '%d.%m.%Y %k:%i');

/*
 3. В таблице складских запасов storehouses_products в поле value могут встречаться самые разные цифры:
 0, если товар закончился и выше нуля, если на складе имеются запасы.
 Необходимо отсортировать записи таким образом, чтобы они выводились в порядке увеличения значения value.
 Однако нулевые запасы должны выводиться в конце, после всех записей.
 */
SELECT value FROM storehouses_products WHERE value <> 0 ORDER BY value ;



