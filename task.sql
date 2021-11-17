DROP DATABASE IF EXISTS vk; -- удаляем БД, если есть такая
CREATE DATABASE vk;
USE vk;

DROP TABLE IF EXISTS users; -- удаляем таблицу, если есть такая
CREATE TABLE users -- создаём таблицу (сущность)
(                                                            -- атрибуты сущности, т.е столбцы в таблице
    id            SERIAL PRIMARY KEY,
    firstname     VARCHAR(100) NOT NULL COMMENT 'Имя пользователя',
    lastname      VARCHAR(100) NOT NULL COMMENT 'Фамилия пользователя',
    password_hash VARCHAR(255),
    email         VARCHAR(255) NOT NULL UNIQUE,
    phone         VARCHAR(100) NOT NULL UNIQUE,
    is_deleted    BIT DEFAULT 0 COMMENT 'Cуществует ли пользователь',
    INDEX users_lastname_firstname_idx (lastname, firstname) -- то, по чему чаще всего будут искать в БД: фамилия и имя
);

-- 1:1
DROP TABLE IF EXISTS `profiles`; -- `` указваются, если считаешь, что есть таблицы с таким же именем в системных БД
CREATE TABLE `profiles`
(
    user_id    SERIAL PRIMARY KEY,
    gender     CHAR(1),                -- М или Ж
    birthday   DATE,
    photo_id   BIGINT UNSIGNED,
    created_at DATETIME DEFAULT NOW(), -- время сервера, на котором находится БД
    hometown   VARCHAR(100)
    -- , FOREIGN KEY (photo_id) REFERENCES media(id) -- пока рано, т.к. таблицы media еще нет
);

ALTER TABLE `profiles`
    ADD CONSTRAINT fk_user_id -- добавляем внешний ключ связанный с таблицей users столбцом id
        FOREIGN KEY (user_id) REFERENCES users (id) ON UPDATE CASCADE ON DELETE CASCADE;

-- 1:M   
DROP TABLE IF EXISTS messages;
CREATE TABLE messages
(
    id           SERIAL PRIMARY KEY,       -- первичный ключ, используем SERIAL
    from_user_id BIGINT UNSIGNED NOT NULL, -- Мы не можем использовать serial, поэтому добавляем из него то, что можно
    to_user_id   BIGINT UNSIGNED NOT NULL,
    created_at   DATETIME DEFAULT NOW(),   -- можно будет даже не упоминать это поле при вставке
    body         TEXT,                     -- содержимое
    FOREIGN KEY (from_user_id) REFERENCES users (id) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (to_user_id) REFERENCES users (id) ON UPDATE CASCADE ON DELETE CASCADE
    /* атрибут связи и направление связи: что, через что, с чем соединять */
);

DROP TABLE IF EXISTS friend_requests;
CREATE TABLE friend_requests
(
    initiator_user_id BIGINT UNSIGNED NOT NULL,                                                -- инициатор
    target_user_id    BIGINT UNSIGNED NOT NULL,                                                -- получатель
    `status`          ENUM ('requested', 'approved','declined', 'unfriended'),                 -- состояние. Нумерованный список
    requested_at      DATETIME DEFAULT NOW(),                                                  -- время создания запроса
    updated_at        DATETIME ON UPDATE NOW(),                                                -- время изменения статуса запроса
    PRIMARY KEY (initiator_user_id, target_user_id), /*первичный составной ключ от инициатора к получателю,
	но если получатль будет отравлять, то будет уже две заявки с одинаковой парой людей*/
    FOREIGN KEY (initiator_user_id) REFERENCES users (id) ON UPDATE CASCADE ON DELETE CASCADE, -- внешний ключ
    FOREIGN KEY (target_user_id) REFERENCES users (id) ON UPDATE CASCADE ON DELETE CASCADE
);

DROP TABLE IF EXISTS communities;
CREATE TABLE communities
(
    id            SERIAL PRIMARY KEY,
    name          VARCHAR(150),                                                            -- название группы
    admin_user_id BIGINT UNSIGNED,                                                         -- администратор (создатель) группы
    INDEX communities_name_idx (name),                                                     -- индекс для поиска
    FOREIGN KEY (admin_user_id) REFERENCES users (id) ON UPDATE CASCADE ON DELETE SET NULL -- внешний ключ
);

-- М:М
DROP TABLE IF EXISTS users_communities; -- пользователи группы
CREATE TABLE users_communities
(
    user_id      BIGINT UNSIGNED NOT NULL,
    community_id BIGINT UNSIGNED NOT NULL,
    PRIMARY KEY (user_id, community_id), -- чтобы не было 2 записей о пользователе и сообществе
    FOREIGN KEY (user_id) REFERENCES users (id) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (community_id) REFERENCES communities (id) ON UPDATE CASCADE ON DELETE CASCADE
);

-- классический справочник
DROP TABLE IF EXISTS media_types;
CREATE TABLE media_types
(
    id         SERIAL PRIMARY KEY,
    name       VARCHAR(255),
    created_at DATETIME DEFAULT NOW(),
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
    -- записей мало, поэтому индекс будет лишним (замедлит работу)!
);

DROP TABLE IF EXISTS media;
CREATE TABLE media
(
    id            SERIAL PRIMARY KEY,
    media_type_id BIGINT UNSIGNED,
    user_id       BIGINT UNSIGNED NOT NULL,
    body          TEXT,         -- filename BLOB много места занимает в базе
    filename      VARCHAR(255), -- ссылка на файл в другой БД.
    `size`        INT,
    metadata      JSON,         -- metadata??? для чего? для связи с backend частью
    created_at    DATETIME DEFAULT NOW(),
    updated_at    DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users (id) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (media_type_id) REFERENCES media_types (id) ON UPDATE CASCADE ON DELETE SET NULL
);

DROP TABLE IF EXISTS likes;
CREATE TABLE likes
(
    PRIMARY KEY (user_id, media_id),
    user_id    BIGINT UNSIGNED NOT NULL,
    media_id   BIGINT UNSIGNED NOT NULL,
    created_at DATETIME DEFAULT NOW(),
    -- слишком увлекаться индексами тоже опасно, рациональнее их добавлять по мере необходимости (напр., провисают по времени какие-то запросы)
    -- намеренно забыли, чтобы позднее увидеть их отсутствие в ER-диаграмме
    FOREIGN KEY (user_id) REFERENCES users (id) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (media_id) REFERENCES media (id) ON UPDATE CASCADE ON DELETE CASCADE
);

DROP TABLE IF EXISTS photo_albums;
CREATE TABLE photo_albums
(
    id      SERIAL PRIMARY KEY,
    name    VARCHAR(255)    DEFAULT NULL,
    user_id BIGINT UNSIGNED DEFAULT NULL,
    FOREIGN KEY (user_id) REFERENCES users (id) ON UPDATE CASCADE ON DELETE CASCADE
);

DROP TABLE IF EXISTS photos;
CREATE TABLE photos
(
    id       SERIAL PRIMARY KEY,
    album_id BIGINT UNSIGNED NOT NULL,
    media_id BIGINT UNSIGNED NOT NULL,
    FOREIGN KEY (album_id) REFERENCES photo_albums (id) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (media_id) REFERENCES media (id) ON UPDATE CASCADE ON DELETE CASCADE
);

ALTER TABLE `profiles`
    ADD CONSTRAINT fk_photo_id
        FOREIGN KEY (photo_id) REFERENCES photos (id) ON UPDATE CASCADE ON DELETE SET NULL;

/*
 Практическое задание по теме “Введение в проектирование БД”
Написать cкрипт, добавляющий в БД vk, которую создали на 3 вебинаре, 3-4 новые таблицы 
(с перечнем полей, указанием индексов и внешних ключей).
(по желанию: организовать все связи 1-1, 1-М, М-М)
 */
-- 1:M
DROP TABLE IF EXISTS `files`;
CREATE TABLE `files` -- создать таблицу для файлов
(
    id       SERIAL PRIMARY KEY,                                                     -- у каждого файла свой номер
    name     VARCHAR(120)    NOT NULL,                                               -- имя файла
    media_id BIGINT UNSIGNED NOT NULL,                                               -- заносим его в медиа, а от туда в типы
    user_id  BIGINT UNSIGNED NOT NULL,                                               -- у какого пользователя
    FOREIGN KEY (user_id) REFERENCES users (id) ON UPDATE CASCADE ON DELETE CASCADE, -- привязка к пользователю
    FOREIGN KEY (media_id) REFERENCES media (id) ON UPDATE CASCADE ON DELETE CASCADE -- делаем файл связным с сущностью media
);

DROP TABLE IF EXISTS video;
CREATE TABLE IF NOT EXISTS video
(
    id       SERIAL PRIMARY KEY,
    name     VARCHAR(255)    NOT NULL,
    media_id BIGINT UNSIGNED NOT NULL,
    FOREIGN KEY (media_id) REFERENCES media (id) ON UPDATE CASCADE ON DELETE CASCADE
);

ALTER TABLE `profiles`
    ADD COLUMN video_id BIGINT UNSIGNED;
ALTER TABLE `profiles`
    ADD CONSTRAINT fk_video_id
        FOREIGN KEY (video_id) REFERENCES video (id) ON UPDATE CASCADE ON DELETE SET NULL;

-- М:М
DROP TABLE IF EXISTS `chats`;
CREATE TABLE `chats` -- создать таблицу бесед
(
    id            SERIAL PRIMARY KEY,
    admin_user_id BIGINT UNSIGNED NOT NULL,
    name          VARCHAR(100)    NOT NULL,                                               -- название группы
    created_at    DATETIME DEFAULT NOW(),
    main_message  TEXT     DEFAULT NULL COMMENT 'Закреплённое сообщение',
    INDEX chats_name_idx (name),                                                          -- ищем по названию
    FOREIGN KEY (admin_user_id) REFERENCES users (id) ON UPDATE CASCADE ON DELETE CASCADE -- администратор из таблицы users
);
/*
DROP TABLE IF EXISTS chat_messages; 
CREATE TABLE chat_messages -- сообщения беседы
(
	message_id 		BIGINT UNSIGNED NOT NULL,
	chat_id 		BIGINT UNSIGNED NOT NULL,
	is_main_message BIT DEFAULT 0,
	PRIMARY KEY (chat_id, message_id),
    FOREIGN KEY (chat_id) REFERENCES `chats`(id) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (message_id) REFERENCES messages(id) ON UPDATE CASCADE ON DELETE CASCADE
);
*/
DROP TABLE IF EXISTS chat_users; -- пользователи беседы
CREATE TABLE chat_users
(
    chat_id BIGINT UNSIGNED NOT NULL,
    user_id BIGINT UNSIGNED NOT NULL,
    PRIMARY KEY (chat_id, user_id),
    FOREIGN KEY (chat_id) REFERENCES `chats` (id) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES users (id) ON UPDATE CASCADE ON DELETE CASCADE
);

DROP TABLE IF EXISTS chat_users_message; -- сообщения пользователей беседы
CREATE TABLE chat_users_message
(
    chat_id    BIGINT UNSIGNED NOT NULL,
    message_id BIGINT UNSIGNED NOT NULL,
    user_id    BIGINT UNSIGNED NOT NULL,
    PRIMARY KEY (message_id, chat_id),
    FOREIGN KEY (message_id) REFERENCES messages (id) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (chat_id) REFERENCES `chats` (id) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES users (id) ON UPDATE CASCADE ON DELETE CASCADE
);
-- 1:1
DROP TABLE IF EXISTS wallet;
CREATE TABLE wallet -- кошелёк для покупок в соцсети
(
    id         SERIAL PRIMARY KEY,
    owner_id   BIGINT UNSIGNED NOT NULL,
    created_at DATETIME        DEFAULT NOW(),
    balance    DOUBLE UNSIGNED DEFAULT 0,
    currency   VARCHAR(100)    NOT NULL UNIQUE COMMENT 'Валюта',
    is_deleted BIT             DEFAULT 0 COMMENT 'Существует ли кошелёк',
    FOREIGN KEY (owner_id) REFERENCES users (id) ON UPDATE CASCADE ON DELETE CASCADE
);

DROP TABLE IF EXISTS playlists;
CREATE TABLE playlists -- плейлисты
(
    id      SERIAL PRIMARY KEY,
    name    VARCHAR(100)    DEFAULT NULL,
    user_id BIGINT UNSIGNED DEFAULT NULL,
    FOREIGN KEY (user_id) REFERENCES users (id) ON UPDATE CASCADE ON DELETE CASCADE
);

DROP TABLE IF EXISTS audio;
CREATE TABLE audio -- аудиозаписи
(
    id          SERIAL PRIMARY KEY,
    media_id    BIGINT UNSIGNED NOT NULL,
    playlist_id BIGINT UNSIGNED NOT NULL,
    FOREIGN KEY (playlist_id) REFERENCES playlists (id) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (media_id) REFERENCES media (id) ON UPDATE CASCADE ON DELETE CASCADE
);

ALTER TABLE `profiles`
    ADD COLUMN audio_id BIGINT UNSIGNED;
ALTER TABLE `profiles`
    ADD CONSTRAINT fk_audio_id
        FOREIGN KEY (audio_id) REFERENCES audio (id) ON UPDATE CASCADE ON DELETE SET NULL; -- внешний ключ для аудио