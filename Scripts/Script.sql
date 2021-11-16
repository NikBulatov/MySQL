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
) COMMENT 'Заявка';

DROP TABLE IF EXISTS catalog;
CREATE TABLE IF NOT EXISTS catalog
(
    id SERIAL PRIMARY KEY,
    name VARCHAR(255)
) COMMENT 'Справочник';

DROP TABLE IF EXISTS data_catalog;
CREATE TABLE IF NOT EXISTS data_catalog
(
    id SERIAL PRIMARY KEY,
    value VARCHAR(255),
    sequence BIGINT UNSIGNED,
    value_print VARCHAR(255),
    id_catalog BIGINT UNSIGNED,
    FOREIGN KEY (id_catalog) REFERENCES catalog(id) -- триггеры нужны!
) COMMENT 'Данные справочника';