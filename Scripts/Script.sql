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
	id SERIAL PRIMARY KEY, -- у каждого файла свой номер
	name VARCHAR(120) NOT NULL, -- имя файла
	media_id BIGINT UNSIGNED NOT NULL, -- заносим его в медиа, а от туда в типы
	user_id BIGINT UNSIGNED NOT NULL, -- у какого пользователя
	FOREIGN KEY (user_id) REFERENCES users(id) ON UPDATE CASCADE ON DELETE CASCADE, -- привязка к пользователю
	FOREIGN KEY (media_id) REFERENCES media(id) ON UPDATE CASCADE ON DELETE CASCADE -- делаем файл связным с сущностью media
);

-- М:М
DROP TABLE IF EXISTS `dialogs`;
CREATE TABLE `dialogs` -- создать таблицу диалогов
(
	id SERIAL PRIMARY KEY, 
	admin_user_id BIGINT UNSIGNED NOT NULL,
	name VARCHAR(100) NOT NULL, -- название группы
	created_at DATETIME DEFAULT NOW(),
	main_message TEXT DEFAULT NULL COMMENT 'Закреплённое сообщение',
	INDEX dialogs_name_idx(name), -- ищем по названию
	FOREIGN KEY (admin_user_id) REFERENCES users(id) ON UPDATE CASCADE ON DELETE CASCADE -- администратор из таблицы users
);

DROP TABLE IF EXISTS dialog_messages; 
CREATE TABLE dialog_messages -- сообщения диалога
(
	message_id BIGINT UNSIGNED NOT NULL,
	dialog_id BIGINT UNSIGNED NOT NULL,
	is_main_message BIT DEFAULT 0,
	PRIMARY KEY (dialog_id, message_id),
    FOREIGN KEY (dialog_id) REFERENCES `dialogs`(id) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (message_id) REFERENCES messages(id) ON UPDATE CASCADE ON DELETE CASCADE
);

DROP TABLE IF EXISTS dialog_users; -- пользователи диалога
CREATE TABLE dialog_users
(	
	dialog_id BIGINT UNSIGNED NOT NULL,
	user_id BIGINT UNSIGNED NOT NULL,
	PRIMARY KEY (dialog_id, user_id),
	FOREIGN KEY (dialog_id) REFERENCES `dialogs`(id) ON UPDATE CASCADE ON DELETE CASCADE,
	FOREIGN KEY (user_id) REFERENCES users(id) ON UPDATE CASCADE ON DELETE CASCADE
);

DROP TABLE IF EXISTS dialog_users_message; -- сообщения пользователей диалога
CREATE TABLE dialog_users_message
( 
	dialog_users_id BIGINT UNSIGNED NOT NULL,
	dialog_messages_id BIGINT UNSIGNED NOT NULL,
	PRIMARY KEY (dialog_messages_id, dialog_users_id),
	FOREIGN KEY (dialog_messages_id) REFERENCES dialog_messages(message_id) ON UPDATE CASCADE ON DELETE CASCADE,
	FOREIGN KEY (dialog_users_id) REFERENCES dialog_users(user_id) ON UPDATE CASCADE ON DELETE CASCADE
);
-- 1:1
DROP TABLE IF EXISTS wallet;
CREATE TABLE wallet -- кошелёк для попукоп в соцсети
(
	id SERIAL PRIMARY KEY,
	owner_id BIGINT UNSIGNED NOT NULL, 
	created_at DATETIME DEFAULT NOW(),
	balance DOUBLE UNSIGNED DEFAULT 0,
	currency VARCHAR(100) NOT NULL UNIQUE COMMENT 'Валюта',
	is_deleted BIT DEFAULT 0 COMMENT 'Существует ли кошелёк',
	FOREIGN KEY (owner_id) REFERENCES users(id) ON UPDATE CASCADE ON DELETE CASCADE
);

DROP TABLE IF EXISTS playlists;
CREATE TABLE playlists -- плейлисты
(
	id SERIAL PRIMARY KEY,
	name VARCHAR(100) DEFAULT NULL,
	user_id BIGINT UNSIGNED DEFAULT NULL,
	FOREIGN KEY (user_id) REFERENCES users(id) ON UPDATE CASCADE ON DELETE CASCADE
);

ALTER TABLE `profiles` ADD COLUMN audio_id BIGINT UNSIGNED;

DROP TABLE IF EXISTS audio;
CREATE TABLE audio -- аудиозаписи
(
	id SERIAL PRIMARY KEY,
	media_id BIGINT UNSIGNED NOT NULL,
	playlist_id BIGINT UNSIGNED NOT NULL,
	FOREIGN KEY (playlist_id) REFERENCES playlists(id) ON UPDATE CASCADE ON DELETE CASCADE,
	FOREIGN KEY (media_id) REFERENCES media(id) ON UPDATE CASCADE ON DELETE CASCADE
);

ALTER TABLE `profiles` ADD CONSTRAINT fk_audio_id FOREIGN KEY (audio_id) REFERENCES audio(id) ON UPDATE CASCADE ON DELETE SET NULL; -- внешний ключ для аудио