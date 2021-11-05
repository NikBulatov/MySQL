DROP DATABASE IF EXISTS vk; -- удаляем БД, если есть такая
CREATE DATABASE vk;
USE vk;

DROP TABLE IF EXISTS users; -- удаляем таблицу, если есть такая
CREATE TABLE users -- создаём таблицу (сущность)
(   -- атрибуты сущности, т.е столбцы в таблице
    id            SERIAL PRIMARY KEY,
    firstname     VARCHAR(100) NOT NULL COMMENT 'Имя пользователя',
    lastname      VARCHAR(100) NOT NULL COMMENT 'Фамилия пользователя',
    password_hash VARCHAR(255),
    email         VARCHAR(255) NOT NULL UNIQUE,
    phone         VARCHAR(100) NOT NULL UNIQUE,
    is_deleted    BIT DEFAULT 0,
    INDEX users_lastname_firstname_idx (lastname, firstname) -- то, по чему чаще всего будут искать в БД: фамилия и имя
);

-- 1:1
DROP TABLE IF EXISTS `profiles`; -- `` указваются, если считаешь, что есть таблицы с таким же именем в системных БД
CREATE TABLE `profiles`
(
    user_id    SERIAL PRIMARY KEY,
    gender     CHAR(1), -- М или Ж
    birthday   DATE,
    photo_id   BIGINT UNSIGNED,
    created_at DATETIME DEFAULT NOW(),
    hometown   VARCHAR(100)
    -- , FOREIGN KEY (photo_id) REFERENCES media(id) -- пока рано, т.к. таблицы media еще нет
);

ALTER TABLE `profiles` ADD CONSTRAINT fk_user_id -- добавляем внешний ключ связанный с таблицей users столбцом id
    FOREIGN KEY (user_id) REFERENCES users(id)
    ON UPDATE CASCADE ON DELETE CASCADE;

-- 1:M   
DROP TABLE IF EXISTS messages;
CREATE TABLE messages
(
	id SERIAL PRIMARY KEY, -- первичный ключ, используем SERIAL 
	from_user_id BIGINT UNSIGNED NOT NULL, -- Мы не можем использовать serial, поэтому добавляем из него то, что можно
	to_user_id BIGINT UNSIGNED NOT NULL,
	created_at DATETIME DEFAULT NOW(), -- можно будет даже не упоминать это поле при вставке
	body TEXT, -- содержимое
	FOREIGN KEY (from_user_id) REFERENCES users(id) ON UPDATE CASCADE ON DELETE CASCADE,
	FOREIGN KEY (to_user_id) REFERENCES users(id) ON UPDATE CASCADE ON DELETE CASCADE
);

DROP TABLE IF EXISTS friend_requests;
CREATE TABLE friend_requests 
(
	initiator_user_id BIGINT UNSIGNED NOT NULL, -- инициатор
	target_user_id 	  BIGINT UNSIGNED NOT NULL, -- получатель
	`status` 		  ENUM('requested', 'approved','declined', 'unfriended'), -- состояние. Нумерованный список
	requested_at 	  DATETIME DEFAULT NOW(), -- время создания запроса
	updated_at 		  DATETIME ON UPDATE NOW(), -- время изменения статуса запроса
	PRIMARY KEY (initiator_user_id, target_user_id), -- первичный составной ключ от инициатора к получателю,
	-- но если получатль будет отравлять, то будет уже две заявки с одинаковой парой людей
	FOREIGN KEY (initiator_user_id) REFERENCES users(id) ON UPDATE CASCADE ON DELETE CASCADE, -- внешний ключ
	FOREIGN KEY (target_user_id) REFERENCES users(id) ON UPDATE CASCADE ON DELETE CASCADE
);

DROP TABLE IF EXISTS communities;
CREATE TABLE communities
(
	id SERIAL PRIMARY KEY,
	name VARCHAR(150), -- название группы
	admin_user_id BIGINT UNSIGNED, -- администратор (создатель) группы
	INDEX communities_name_idx(name), -- индекс для поиска
	FOREIGN KEY (admin_user_id) REFERENCES users(id) ON UPDATE CASCADE ON DELETE SET NULL -- внешний ключ
);
-- М:М
DROP TABLE IF EXISTS users_communities; -- пользователи группы
CREATE TABLE users_communities
(
	user_id BIGINT UNSIGNED NOT NULL,
	community_id BIGINT UNSIGNED NOT NULL,
	PRIMARY KEY (user_id, community_id), -- чтобы не было 2 записей о пользователе и сообществе
    FOREIGN KEY (user_id) REFERENCES users(id) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (community_id) REFERENCES communities(id) ON UPDATE CASCADE ON DELETE CASCADE
);
-- классический справочник
DROP TABLE IF EXISTS media_types;
CREATE TABLE media_types(
	id SERIAL PRIMARY KEY,
    name VARCHAR(255),
    created_at DATETIME DEFAULT NOW(),
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP

    -- записей мало, поэтому индекс будет лишним (замедлит работу)!
);

DROP TABLE IF EXISTS media;
CREATE TABLE media
(
	id SERIAL PRIMARY KEY,
    media_type_id BIGINT UNSIGNED,
    user_id BIGINT UNSIGNED NOT NULL,
  	body TEXT,
  	-- filename BLOB много места занимает в базе
    filename VARCHAR(255), -- ссылка на файл в другой БД. 
    `size` INT,
	metadata JSON, -- metadata??? для чего? для связи с backend частью
    created_at DATETIME DEFAULT NOW(),
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (media_type_id) REFERENCES media_types(id) ON UPDATE CASCADE ON DELETE SET NULL
);

DROP TABLE IF EXISTS likes;
CREATE TABLE likes
(
	PRIMARY KEY (user_id, media_id),
    user_id BIGINT UNSIGNED NOT NULL,
    media_id BIGINT UNSIGNED NOT NULL,
    created_at DATETIME DEFAULT NOW(),
  	-- слишком увлекаться индексами тоже опасно, рациональнее их добавлять по мере необходимости (напр., провисают по времени какие-то запросы)  
	-- намеренно забыли, чтобы позднее увидеть их отсутствие в ER-диаграмме
    FOREIGN KEY (user_id) REFERENCES users(id) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (media_id) REFERENCES media(id) ON UPDATE CASCADE ON DELETE CASCADE
);

DROP TABLE IF EXISTS photo_albums;
CREATE TABLE photo_albums
(
	id SERIAL PRIMARY KEY,
	name VARCHAR(255) DEFAULT NULL,
	user_id BIGINT UNSIGNED DEFAULT NULL,
	FOREIGN KEY (user_id) REFERENCES users(id) ON UPDATE CASCADE ON DELETE CASCADE
);

DROP TABLE IF EXISTS photos;
CREATE TABLE photos 
(
	id SERIAL PRIMARY KEY,
	album_id BIGINT UNSIGNED NOT NULL,
	media_id BIGINT UNSIGNED NOT NULL,
	FOREIGN KEY (album_id) REFERENCES photo_albums(id) ON UPDATE CASCADE ON DELETE CASCADE,
	FOREIGN KEY (media_id) REFERENCES media(id) ON UPDATE CASCADE ON DELETE CASCADE
);

ALTER TABLE `profiles` ADD CONSTRAINT fk_photo_id 
FOREIGN KEY (photo_id) REFERENCES photos(id) ON UPDATE CASCADE ON DELETE SET NULL;