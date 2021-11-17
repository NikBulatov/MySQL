/*
 Домашнее задание к 4 уроку "CRUD-операции"
 1. файл filldb-deta.sql
 2. Написать скрипт, возвращающий список имен (только firstname) пользователей без повторений в алфавитном порядке.
 */
USE vk;
SELECT DISTINCT firstname FROM users ORDER BY firstname;

-- 3. Первые пять пользователей пометить как удаленные.
UPDATE users SET is_deleted = 1 ORDER BY firstname LIMIT 5;
SELECT firstname, is_deleted FROM users ORDER BY firstname LIMIT 5;
-- 4. Написать скрипт, удаляющий сообщения «из будущего» (дата больше сегодняшней).
DELETE FROM messages WHERE created_at > NOW();
SELECT * FROM messages WHERE created_at < NOW() ORDER BY created_at;
-- 5. Написать название темы курсового проекта
-- Сайт мастера по услугам красоты
