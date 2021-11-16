DROP DATABASE IF EXISTS site;
CREATE DATABASE IF NOT EXISTS site;
USE site;

-- create dictionary!!
/*
 * 
 * 
 * */

DROP TABLE IF EXISTS users;
CREATE TABLE IF NOT EXISTS users
(
    id         SERIAL PRIMARY KEY,
    firstname  VARCHAR(255)                       NOT NULL COMMENT 'Имя пользователя',
    lastname   VARCHAR(255)                       NOT NULL COMMENT 'Фамилия пользователя',
    phone      VARCHAR(255)                       NOT NULL,
    email      VARCHAR(255)                       NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP NOT NULL,
    INDEX phone_idx (phone),
    INDEX email_idx (email)
);

DROP TABLE IF EXISTS messages;
CREATE TABLE IF NOT EXISTS messages
(
    id           SERIAL PRIMARY KEY,
    from_user_id BIGINT UNSIGNED                    NOT NULL,
    to_user_id   BIGINT UNSIGNED                    NOT NULL,
    created_at   DATETIME DEFAULT CURRENT_TIMESTAMP NOT NULL,
    body         TEXT                               NOT NULL,
    FOREIGN KEY (from_user_id) REFERENCES users (id) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (to_user_id) REFERENCES users (id) ON UPDATE CASCADE ON DELETE CASCADE
);

DROP TABLE IF EXISTS requests;
CREATE TABLE IF NOT EXISTS requests
(
    id           SERIAL PRIMARY KEY,
    type_request ENUM ('Service', 'Question'),
    message_id   BIGINT UNSIGNED NOT NULL COMMENT 'Сообщение пользователя',
    FOREIGN KEY (message_id) REFERENCES messages (id) ON UPDATE CASCADE ON DELETE CASCADE
);