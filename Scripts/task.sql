/*
https://docs.google.com/document/d/1yE0wn1m-EwqcJ458ga3eCptvBJcSIi1HaBp48OlT5ZI/edit
*/
-- Практическое задание по теме «Операторы, фильтрация, сортировка и ограничение»
-- Создаю столбцы, чтобы выполнить задание
USE vk;
ALTER TABLE profiles
    ADD COLUMN updated_at DATETIME DEFAULT NOW();
UPDATE profiles
SET created_at = '2005-12-06 13:56:02',
    updated_at = '2006-06-06 13:56:04';

-- 1. В таблице users поля created_at и updated_at оказались незаполненными. Заполните их текущими датой и временем
UPDATE profiles
SET created_at = NULL,
    updated_at = NULL;
UPDATE profiles
SET created_at = NOW(),
    updated_at = NOW();

SELECT user_id, created_at, updated_at
FROM profiles;
/*
2. Таблица users была неудачно спроектирована.
Записи created_at и updated_at были заданы типом VARCHAR и в них долгое время помещались значения в формате 20.10.2017 8:10.
Необходимо преобразовать поля к типу DATETIME, сохранив введённые ранее значения.
Изменяю тип данных в столбцах.
 */
ALTER TABLE profiles
    MODIFY COLUMN created_at VARCHAR(255) DEFAULT NULL;
ALTER TABLE profiles
    MODIFY COLUMN updated_at VARCHAR(255) DEFAULT NULL;
UPDATE profiles
SET created_at = '20.10.2017 8:10',
    updated_at = '20.10.2017 8:10';
-- преобразовываю
UPDATE profiles
SET created_at = STR_TO_DATE(created_at, '%d.%m.%Y %k:%i'),
    updated_at = STR_TO_DATE(updated_at, '%d.%m.%Y %k:%i');
DESCRIBE profiles;
ALTER TABLE profiles
    CHANGE created_at created_at DATETIME DEFAULT CURRENT_TIMESTAMP;
ALTER TABLE profiles
    CHANGE updated_at updated_at DATETIME DEFAULT CURRENT_TIMESTAMP;
DESCRIBE profiles;
SELECT user_id, created_at, updated_at
FROM profiles;
/*
 3. В таблице складских запасов storehouses_products в поле value могут встречаться самые разные цифры:
 0, если товар закончился и выше нуля, если на складе имеются запасы.
 Необходимо отсортировать записи таким образом, чтобы они выводились в порядке увеличения значения value.
 Однако нулевые запасы должны выводиться в конце, после всех записей.
 */
USE storehouse;
SELECT value
FROM storehouses_products
ORDER BY IF(value = 0, 1, 0), value;
-- ORDER BY IF(value > 0, 0, 1), value;

/*
 4. (по желанию) Из таблицы users необходимо извлечь пользователей, родившихся в августе и мае.
 Месяцы заданы в виде списка английских названий (may, august)
 */
USE vk;
SELECT (SELECT firstname FROM users WHERE id = profiles.user_id) AS 'Name',
       CASE
           WHEN MONTH(birthday) = 05 THEN 'May'
           WHEN MONTH(birthday) = 08 THEN 'August' END           AS 'Month'
FROM profiles
WHERE MONTH(birthday) = 05
   OR MONTH(birthday) = 08
ORDER BY MONTH(birthday);
-- разбор: SELECT name FROM users WHERE DATE_FORMAT(birthday_at, '%M') IN ('may', 'august');
/*
 5. (по желанию) Из таблицы catalogs извлекаются записи при помощи запроса.
 SELECT * FROM catalogs WHERE id IN (5, 1, 2);
 Отсортируйте записи в порядке, заданном в списке IN.
 */
USE storehouse;
DROP TABLE IF EXISTS catalogs;
CREATE TABLE catalogs
(
    id      SERIAL PRIMARY KEY,
    catalog VARCHAR(255)
);
-- разбор задания
SELECT id, catalog
FROM catalogs
WHERE id IN (5, 1, 2)
order by FIELD(id, 5, 1, 2);
-- Практическое задание теме «Агрегация данных»
/*
1. Подсчитайте средний возраст пользователей в таблице users.
 */
-- совпало с разбором
USE vk;
SELECT ROUND(AVG(TIMESTAMPDIFF(YEAR, birthday, NOW()))) AS 'Mean age'
FROM profiles;
/*
 2. Подсчитайте количество дней рождения, которые приходятся на каждый из дней недели.
 Следует учесть, что необходимы дни недели текущего года, а не года рождения.
 2.1 Находим разницу в годах с днями рождения, прибавляем эту разницу к их дате рождения.
 2.2 У каждой получившейся дате определяем деь недели (100 штук)
 2.3 Считаем количество по дням недели и группируем по дням
 */
USE vk;
SELECT day_week, COUNT(new_date) AS total
FROM (SELECT new_date, DATE_FORMAT(new_date, '%W') AS day_week
      FROM (SELECT birthday + INTERVAL (YEAR(NOW()) - YEAR(birthday)) YEAR AS new_date
            FROM profiles) birthday_now) days_week
GROUP BY day_week
ORDER BY total DESC ;
-- разбор задания
SELECT COUNT(*)                                                                             AS total,
       DATE_FORMAT(DATE(CONCAT_WS('-', YEAR(NOW()), MONTH(birthday), DAY(birthday))), '%W') AS day
from profiles
GROUP BY day
ORDER BY total DESC ;
/*
 3. (по желанию) Подсчитайте произведение чисел в столбце таблицы.
 */
-- совпало с разбором
USE storehouse;
SELECT value
FROM storehouses_products;
SELECT ROUND(EXP(SUM(LN(value)))) AS multiply
FROM storehouses_products; -- логарифм произведения равен сумме логарифмов
