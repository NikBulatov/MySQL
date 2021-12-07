DROP DATABASE IF EXISTS site;
CREATE DATABASE IF NOT EXISTS site;
USE site;

DROP TABLE IF EXISTS catalog;
CREATE TABLE IF NOT EXISTS catalog
(
    id   SERIAL PRIMARY KEY COMMENT 'Номер справочника',
    name VARCHAR(255) COMMENT 'Название справочника'
) COMMENT 'Справочник';

DROP TABLE IF EXISTS catalog_data;
CREATE TABLE IF NOT EXISTS catalog_data
(
    id              SERIAL PRIMARY KEY,
    id_catalog      BIGINT UNSIGNED COMMENT 'Номер справочника',
    id_catalog_data BIGINT UNSIGNED COMMENT 'Рекурсивный ключ', -- для многоуровневого каталога типов
    value           VARCHAR(255) COMMENT 'Значение данных',
    sequence        BIGINT UNSIGNED COMMENT 'Порядковый номер',
    value_print     VARCHAR(255) COMMENT 'Значение данных для вывода',

    FOREIGN KEY (id_catalog_data) REFERENCES catalog_data (id),
    FOREIGN KEY (id_catalog) REFERENCES catalog (id)            -- триггеры нужны!
) COMMENT 'Данные справочника';


DROP TABLE IF EXISTS users;
CREATE TABLE IF NOT EXISTS users
(
    id           SERIAL PRIMARY KEY,
    user_type_id BIGINT UNSIGNED                    NOT NULL COMMENT 'Тип пользователя',
    firstname    VARCHAR(255)                       NOT NULL COMMENT 'Имя пользователя',
    lastname     VARCHAR(255)                       NOT NULL COMMENT 'Фамилия пользователя',
    phone        VARCHAR(255)                       NOT NULL COMMENT 'Номер телефона',
    email        VARCHAR(255)                       NOT NULL COMMENT 'Электронная почта пользователя',
    created_at   DATETIME DEFAULT CURRENT_TIMESTAMP NOT NULL COMMENT 'Дата создания',
    updated_at   DATETIME DEFAULT CURRENT_TIMESTAMP NOT NULL COMMENT 'Дата обновления информации',
    INDEX phone_idx (phone),
    INDEX email_idx (email),

    FOREIGN KEY (user_type_id) REFERENCES catalog (id) ON UPDATE CASCADE ON DELETE NO ACTION-- триггеры
) COMMENT 'Пользователи';

DROP TABLE IF EXISTS profiles;
CREATE TABLE IF NOT EXISTS profiles
(
    user_id    SERIAL PRIMARY KEY,
    gender     CHAR(1)  NOT NULL,
    birthday   DATE,
    photo_id   BIGINT UNSIGNED,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (user_id) REFERENCES users (id) ON UPDATE CASCADE ON DELETE CASCADE
) COMMENT 'Профили';


DROP TABLE IF EXISTS media;
CREATE TABLE media
(
    id            SERIAL PRIMARY KEY,
    media_type_id BIGINT UNSIGNED,
    user_id       BIGINT UNSIGNED NOT NULL,
    filename      VARCHAR(255),
    size          INT,
    metadata      JSON,
    created_at    DATETIME DEFAULT NOW(),
    updated_at    DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    FOREIGN KEY (user_id) REFERENCES users (id) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (media_type_id) REFERENCES catalog (id) ON UPDATE CASCADE -- триггеры
) COMMENT 'Файлы';

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
    FOREIGN KEY (media_id) REFERENCES media (id) ON UPDATE CASCADE ON DELETE CASCADE
) COMMENT 'Сообщения';

DROP TABLE IF EXISTS requests;
CREATE TABLE IF NOT EXISTS requests
(
    id         SERIAL PRIMARY KEY,
    type_id    BIGINT UNSIGNED NOT NULL COMMENT 'Номер типа запроса',
    message_id BIGINT UNSIGNED NOT NULL COMMENT 'Номер сообщения пользователя',

    FOREIGN KEY (message_id) REFERENCES messages (id) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (type_id) REFERENCES catalog (id) ON UPDATE CASCADE ON DELETE NO ACTION -- triggers
) COMMENT 'Заявки';


DROP TABLE IF EXISTS masters;
CREATE TABLE IF NOT EXISTS masters
(
    id             SERIAL PRIMARY KEY,
    type_master_id BIGINT UNSIGNED NOT NULL COMMENT 'Тип мастера',
    name           VARCHAR(255)    NOT NULL,

    FOREIGN KEY (type_master_id) REFERENCES catalog_data (id_catalog) ON UPDATE CASCADE ON DELETE NO ACTION -- triggers
);

DROP TABLE IF EXISTS services;
CREATE TABLE IF NOT EXISTS services
(
    id             SERIAL PRIMARY KEY,
    type_master_id BIGINT UNSIGNED NOT NULL,
    type_id        BIGINT UNSIGNED NOT NULL,
    message_id     BIGINT UNSIGNED,
    request_id     BIGINT UNSIGNED NOT NULL,

    FOREIGN KEY (type_master_id) REFERENCES catalog (id) ON UPDATE CASCADE,
    FOREIGN KEY (type_id) REFERENCES catalog (id) ON UPDATE CASCADE -- триггеры!
) COMMENT 'Услуги';

DROP TABLE IF EXISTS photo_albums;
CREATE TABLE photo_albums
(
    id      SERIAL PRIMARY KEY,
    name    varchar(255)    DEFAULT NULL,
    user_id BIGINT UNSIGNED DEFAULT NULL,

    FOREIGN KEY (user_id) REFERENCES users (id) ON UPDATE CASCADE ON DELETE SET NULL
) COMMENT 'Фото альбомы';

DROP TABLE IF EXISTS photos;
CREATE TABLE photos
(
    id       SERIAL PRIMARY KEY,
    album_id BIGINT UNSIGNED NOT NULL,
    media_id BIGINT UNSIGNED NOT NULL,

    FOREIGN KEY (album_id) REFERENCES photo_albums (id) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (media_id) REFERENCES media (id) ON UPDATE CASCADE ON DELETE CASCADE
) COMMENT 'Фотографии';

ALTER TABLE profiles
    ADD CONSTRAINT fk_photo_id FOREIGN KEY (photo_id) REFERENCES photos (id) ON UPDATE CASCADE ON DELETE SET NULL;



