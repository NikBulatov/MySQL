DROP DATABASE IF EXISTS site;
CREATE DATABASE IF NO EXISTS site;
USE site;

-- create dictonary!!
/*
 * 
 * 
 * */

DROP TABLE IF EXISTS users;
CREATE TABLE IF NOT EXISTS users
( 
	id SERIAL PRIMARY KEY,
	firstname VARCHAR(255) NOT NULL COMMENT 'Имя пользователя',
	lastname VARCHAR(255) NOT NULL COMMENT 'Фамилия пользователя',
	phone VARCHAR(255) NOT NULL,
	email VARCHAR(255) NOT NULL,
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP NOT NULL,
	updated_at DATETIME DEFAULT CURRENT_TIMESTAMP NOT NULL,
	INDEX phone_idx(phone),
	INDEX email_idx(email)
);

DROP TABLE IF EXISTS messages;
CREATE TABLE IF NOT EXISTS messages
(
	from_user_id BIGINT UNSIGNED NOT NULL,
	to_user_id BIGINT UNSIGNED NOT NULL,
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP NOT NULL,
	body TEXT NOT NULL,
	PRIMARY KEY (from_user_id, to_user_id)
	FOREIGN KEY (from_user_id) REFERENCES users(id) ON UPDATE CASCADE ON DELETE CASCADE,
	FOREIGN KEY (to_user_id) REFERENCES users(id) ON UPDATE CASCADE ON DELETE CASCADE
);

DROP TABLE IF EXISTS requestes;
CREATE TABLE IF NOT EXISTS requestes
(
	id SERIAL PRIMARY KEY,
	type_request ENUM ('Service', 'Question'),
	message_id BIGINT UNSIGNED NOT NULL COMMENT 'Сообщение пользоватля',
	FOREIGN KEY (message_id) REFERENCES messages(id) ON UPDATE CASCADE ON DELETE CASCADE
);