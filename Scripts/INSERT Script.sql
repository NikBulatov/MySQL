USE site;
-- вставка типов сущностей
INSERT INTO catalog (name)
VALUES ('types_users'),
       ('types_media'),
       ('types_requests'),
       ('types_masters'),
       ('types_services');
-- заполнение данными типы сущностей
INSERT INTO catalog_data (id_catalog, value, sequence, value_print, id_catalog_data)
-- типы пользователей (users)
VALUES (1, 'admin', 1, 'Администратор', NULL),
       (1, 'client', 2, 'Клиент', NULL),
       (1, 'developer', 3, 'Разработчик', NULL),
-- типы файлов (media)
       (2, 'photo', 1, 'Фотографии', NULL),
       (2, 'video', 2, 'Видео', NULL),
       (2, 'file', 3, 'Файл', NULL),
-- типы запросов (requests)
       (3, 'to_service', 1, 'Запись на услугу', NULL),
       (3, 'cancel_service', 2, 'Отменить запись', NULL),
       (3, 'update_service', 3, 'Обновить данные на запись', NULL),
-- типы услуг (services)
       (4, 'hairdresser', 1, 'Услуги парикмахера', NULL),
       (4, 'manicure', 2, 'Маникюр', NULL),
       (4, 'pedicure', 3, 'Педикюр', NULL),
       (4, 'podologist', 4, 'Услуги подолога', NULL),
-- Услуги (services)
       (5, 'haircut', 1, 'Стрижка', 10),
       (5, 'hairstyle', 2, 'Укладка', 10),
       (5, 'care', 3, 'Уход и восстановление', 10),
       (5, 'coloring', 4, 'Окрашивание', 10),
       (5, 'carving', 5, 'Карвинг', 10),
       (5, 'podology', 6, 'Подология', 13),
       (5, 'nails', 7, 'Ногти на руках', 12),
       (5, 'toes_nails', 8, 'Ногти на ногах', 12);

INSERT INTO users (user_type_id, firstname, lastname, phone, email)
VALUES (1, 'Elena', 'Bulatova', '+7 (951) 973-19-72', 'el.bulatova70@yandex.ru'),
       (3, 'Nikita', 'Bulatov', '+7 (999) 137-03-05', 'nikitabulatov0699@gmail.com'),
       (2, 'Sammie', 'Koch', '686-389-6308x90654', 'ustehr@example.com'),
       (2, 'Henderson', 'Bashirian', '527-892-0879x91317', 'pcollins@example.com'),
       (2, 'Judd', 'Mitchell', '+09(5)2952788852', 'lang.fermin@example.net'),
       (2, 'Deonte', 'Okuneva', '(958)302-4238x815', 'carmstrong@example.org'),
       (2, 'Luciano', 'Morar', '883.405.8599x73972', 'stanford90@example.com'),
       (2, 'Jarrett', 'Prohaska', '891-063-0332x9890', 'hschroeder@example.org'),
       (2, 'Mike', 'Deckow', '499.819.2226x2727', 'hspinka@example.com'),
       (2, 'Roberto', 'Carter', '308-661-8789x8217', 'ghane@example.com'),
       (2, 'Kenyatta', 'Yost', '(582)090-1666x3696', 'mccullough.lucie@example.org'),
       (2, 'Nannie', 'Yost', '1-195-296-7361', 'predovic.marguerite@example.com'),
       (2, 'Elmo', 'Bode', '1-658-733-9098', 'augustine88@example.com'),
       (2, 'Gia', 'Dibbert', '865-033-0798x1004', 'maxwell.zieme@example.com'),
       (2, 'Isabell', 'McKenzie', '678-264-6553', 'gpadberg@example.net'),
       (2, 'Joe', 'Little', '071.103.6766', 'craig62@example.net'),
       (2, 'Horace', 'Shanahan', '917.129.9385x7061', 'vheathcote@example.org');

-- привязка id'шников
INSERT INTO media (user_id)
SELECT users.id
FROM users;

-- заполнение данными
UPDATE media
SET media_type_id = 4,
    filename      = 'photo_profile.jpg',
    size          = RAND() * 1000
WHERE user_id IN (1, 2);
UPDATE media
SET media_type_id = 4,
    filename      = 'photo_hairs.jpg',
    size          = RAND() * 10000
WHERE user_id NOT IN (1, 2);
UPDATE media
SET size          = RAND() * 100000,
    media_type_id = 5,
    filename      = 'video_hairstyles.mp4'
WHERE user_id NOT IN (1, 2, 12, 0, 6, 9, 3, 4, 8);


-- таблица профилей
INSERT INTO profiles (user_id, gender, birthday)
VALUES (1, 'f', '1970-01-03'),
       (2, 'm', '1999-01-06'),
       (3, 'f', '1985-06-25'),
       (4, 'm', '1997-03-23'),
       (5, 'm', '2003-12-02'),
       (6, 'f', '2001-11-30'),
       (7, 'm', '2000-09-23'),
       (8, 'f', '1999-08-01'),
       (9, 'm', '1995-05-16'),
       (10, 'm', '1980-12-31'),
       (11, 'f', '1998-02-28'),
       (12, 'f', '1990-08-26'),
       (13, 'm', '1985-07-14'),
       (14, 'f', '1987-09-28'),
       (15, 'f', '1971-03-19'),
       (16, 'm', '1985-04-09'),
       (17, 'm', '1965-02-25');

-- Фотоальбомы
INSERT INTO photo_albums (user_id, name)
VALUES (1, 'My haircuts'),
       (2, 'My wishes'),
       (3, 'perspiciatis'),
       (4, 'tempore'),
       (5, 'culpa'),
       (6, 'totam'),
       (7, 'vitae'),
       (8, 'hic'),
       (9, 'ipsa'),
       (10, 'et'),
       (11, 'sed'),
       (12, 'eaque'),
       (13, 'fugit'),
       (14, 'officiis'),
       (15, 'natus'),
       (16, 'ab'),
       (17, 'adipisci');

-- Фотографии
INSERT INTO photos (media_id, user_id)
SELECT id, user_id
FROM media
WHERE media_type_id = 4;

-- Сообщения
INSERT INTO messages (from_user_id, to_user_id, body)
SELECT from_u.id, to_u.id, 'Hello!'
FROM users from_u
         JOIN users to_u ON from_u.id != to_u.id
WHERE from_u.id != 1;

-- Запросы на услугу (заявки) 3 раза выполнить
INSERT INTO requests (type_id, user_id)
SELECT c.id, u.id
FROM catalog_data c
         JOIN users u
WHERE id_catalog = 3
  AND u.id != 1;

-- Услуги
INSERT INTO services (type_master_id, type_id, request_id, user_id, visit_time)
SELECT mas.id, type_s.id, r.id, u.id, NOW()
FROM (SELECT id FROM catalog_data WHERE id_catalog = 4) AS mas
         JOIN (SELECT id FROM catalog_data WHERE id_catalog = 5) AS type_s
         JOIN (SELECT id FROM users WHERE id != 1) AS u
         JOIN (SELECT id FROM requests WHERE type_id != 8) AS r;
