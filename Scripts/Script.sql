DROP DATABASE IF EXISTS site;
CREATE DATABASE IF NOT EXISTS site;
USE site;

DROP TABLE IF EXISTS user_type;
CREATE TABLE IF NOT EXISTS user_type
(
    id        SERIAL PRIMARY KEY,
    name_type ENUM ('Client', 'Master', 'Developer') DEFAULT 'Client'
) COMMENT 'Тип пользователя';

DROP TABLE IF EXISTS users;
CREATE TABLE IF NOT EXISTS users
(
    id           SERIAL PRIMARY KEY,
    user_type_id BIGINT UNSIGNED                    NOT NULL,
    firstname    VARCHAR(255)                       NOT NULL COMMENT 'Имя пользователя',
    lastname     VARCHAR(255)                       NOT NULL COMMENT 'Фамилия пользователя',
    phone        VARCHAR(255)                       NOT NULL,
    email        VARCHAR(255)                       NOT NULL,
    created_at   DATETIME DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at   DATETIME DEFAULT CURRENT_TIMESTAMP NOT NULL,
    INDEX phone_idx (phone),
    INDEX email_idx (email),

    FOREIGN KEY (user_type_id) REFERENCES user_type (id) ON UPDATE CASCADE ON DELETE CASCADE -- возможно что надо иначе RESTRICT
);

DROP TABLE IF EXISTS profiles;
CREATE TABLE IF NOT EXISTS profiles
(
    user_id    SERIAL PRIMARY KEY,
    gender     CHAR(1),
    birthday   DATE,
    photo_id   BIGINT UNSIGNED,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    hometown   VARCHAR(100),
    FOREIGN KEY (user_id) REFERENCES users (id) ON UPDATE CASCADE ON DELETE CASCADE
) COMMENT 'Профиль';

DROP TABLE IF EXISTS media_types;
CREATE TABLE media_types
(
    id         SERIAL PRIMARY KEY,
    name       VARCHAR(255),
    created_at DATETIME DEFAULT NOW(),
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

DROP TABLE IF EXISTS media;
CREATE TABLE media
(
    id            SERIAL PRIMARY KEY,
    media_type_id BIGINT UNSIGNED,
    user_id       BIGINT UNSIGNED NOT NULL,
    body          text,
    filename      VARCHAR(255),
    size          INT,
    metadata      JSON,
    created_at    DATETIME DEFAULT NOW(),
    updated_at    DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    FOREIGN KEY (user_id) REFERENCES users (id) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (media_type_id) REFERENCES media_types (id) ON UPDATE CASCADE ON DELETE SET NULL
);

DROP TABLE IF EXISTS messages;
CREATE TABLE IF NOT EXISTS messages
(
    id           SERIAL PRIMARY KEY,
    from_user_id BIGINT UNSIGNED                    NOT NULL,
    to_user_id   BIGINT UNSIGNED                    NOT NULL,
    created_at   DATETIME DEFAULT CURRENT_TIMESTAMP NOT NULL,
    body         TEXT                               NOT NULL,
    media_id     BIGINT UNSIGNED,
    FOREIGN KEY (from_user_id) REFERENCES users (id) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (to_user_id) REFERENCES users (id) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (media_id) REFERENCES media (id) ON UPDATE CASCADE -- не знаю что при удалении поставить.
);

DROP TABLE IF EXISTS requests;
CREATE TABLE IF NOT EXISTS requests
(
    id           SERIAL PRIMARY KEY,
    type_request ENUM ('Service', 'Question'),
    message_id   BIGINT UNSIGNED NOT NULL COMMENT 'Сообщение пользователя',
    FOREIGN KEY (message_id) REFERENCES messages (id) ON UPDATE CASCADE ON DELETE CASCADE
) COMMENT 'Заявка';

DROP TABLE IF EXISTS type_service;
CREATE TABLE IF NOT EXISTS type_service
(
    service_id SERIAL PRIMARY KEY,
    type_name  VARCHAR(255) NOT NULL,

    FOREIGN KEY (service_id) REFERENCES requests (id) ON UPDATE CASCADE ON DELETE CASCADE -- правильно?
);

DROP TABLE IF EXISTS services;
CREATE TABLE IF NOT EXISTS services
(
    request_id SERIAL PRIMARY KEY,
    type_name BIGINT UNSIGNED NOT NULL,
    message_id BIGINT UNSIGNED,

    FOREIGN KEY (type_name) REFERENCES type_service(type_name) ON UPDATE CASCADE ON DELETE NO ACTION,
    FOREIGN KEY (request_id) REFERENCES requests(id) ON UPDATE CASCADE ON DELETE NO ACTION
);

DROP TABLE IF EXISTS photo_albums;
CREATE TABLE photo_albums
(
    id      SERIAL PRIMARY KEY,
    name    varchar(255)    DEFAULT NULL,
    user_id BIGINT UNSIGNED DEFAULT NULL,

    FOREIGN KEY (user_id) REFERENCES users (id) ON UPDATE CASCADE ON DELETE SET NULL
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

ALTER TABLE profiles
    ADD CONSTRAINT fk_photo_id FOREIGN KEY (photo_id) REFERENCES photos (id) ON UPDATE CASCADE ON DELETE set NULL;

DROP TABLE IF EXISTS catalog;
CREATE TABLE IF NOT EXISTS catalog
(
    id   SERIAL PRIMARY KEY,
    name VARCHAR(255)
) COMMENT 'Справочник';

DROP TABLE IF EXISTS data_catalog;
CREATE TABLE IF NOT EXISTS data_catalog
(
    id          SERIAL PRIMARY KEY,
    value       VARCHAR(255),
    sequence    BIGINT UNSIGNED,
    value_print VARCHAR(255),
    id_catalog  BIGINT UNSIGNED,
    FOREIGN KEY (id_catalog) REFERENCES catalog (id) -- триггеры нужны!
) COMMENT 'Данные справочника';

