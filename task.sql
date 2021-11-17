USE vk;
/*
 Домашнее задание к 4 уроку "CRUD-операции"
 1. Заполнить все таблицы БД vk данными (по 10-100 записей в каждой таблице). файл filldb-deta.sql
 Не получается заполнить таблицу wallet через сайт. Заполняет только одной записью, и через скрипты тоде одной записью
 */
INSERT INTO wallet(owner_id)
SELECT id
FROM users
ON DUPLICATE KEY UPDATE currency='RUB';
/*
2. Написать скрипт, возвращающий список имен (только firstname) пользователей без повторений в алфавитном порядке.
*/
SELECT DISTINCT firstname
FROM users
ORDER BY firstname;

-- 3. Первые пять пользователей пометить как удаленные.
UPDATE users
SET is_deleted = 1
ORDER BY firstname
LIMIT 5;
SELECT firstname, is_deleted
FROM users
ORDER BY firstname
LIMIT 5;
-- 4. Написать скрипт, удаляющий сообщения «из будущего» (дата больше сегодняшней).
DELETE
FROM messages
WHERE created_at > NOW();
SELECT *
FROM messages
WHERE created_at < NOW()
ORDER BY created_at;
-- 5. Написать название темы курсового проекта
-- Сайт мастера по услугам красоты
