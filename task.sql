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
ALTER TABLE users MODIFY COLUMN created_at VARCHAR(255) DEFAULT NULL;
ALTER TABLE users MODIFY COLUMN updated_at VARCHAR(255) DEFAULT NULL;

UPDATE users SET created_at = '20.10.2017 8:10';
UPDATE users SET updated_at = '20.10.2017 8:10';
