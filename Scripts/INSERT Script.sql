USE site;
INSERT INTO catalog (name)
VALUES ('types_users'),
       ('types_media'),
       ('types_requests'),
       ('types_masters'),
       ('types_services');


-- справочник
INSERT INTO catalog_data (id_catalog, value, sequence, value_print)
VALUES (1, 'admin', 1, 'Администратор'),
       (1, 'client', 2, 'Клиент'),
       (1, 'developer', 3, 'Разработчик'),
       --
       (2, 'photo', 2, 'Фотографии'),
       (2, 'video', 3, 'Видео'),
       (2, 'file', 4, 'Файл'),
       --
       (3, 'to_service',1 , 'Запись на услугу'),
       (3, 'cancel_service', 2, 'Отменить запись'),
       (3, 'update_service', 3, 'Обновить данные на запись'),
       --
       (4, 'hairdresser', 1, 'Услуги парикмахера'),
       (4, 'manicure', 2, 'Маникюр'),
       (4, 'pedicure', 3, 'Педикюр'),
       (4, 'podologist', 4, 'Услуги подолога'),
       --
       (5, 'haircut', 1, 'Стрижка'),
       (5, 'hairstyle', 2, 'Укладка'),
       (5, 'care', 3, 'Уход и восстановление'),
       (5, 'coloring', 4, 'Окрашивание'),
       (5, 'carving', 5, 'Карвинг'),
       (5, 'podology', 6, 'Подология'),
       (5, 'nails', 7, 'Ногти на руках'),
       (5, 'toes_nails', 8, 'Ногти на ногах');

INSERT INTO users (user_type_id, firstname, lastname, phone, email)
VALUES (1, 'Elena', 'Bulatova', '+7 (951) 973-19-72', 'el.bulatova70@yandex.ru'),
       (3, 'Nikita', 'Bulatov', '+7 (999) 137-03-05', 'nikitabulatov0699@gmail.com');

INSERT INTO profiles (user_id, gender, birthday)
VALUES (1, 'f', '1970-01-03');

INSERT INTO masters (type_master_id, name) SELECT id_catalog, value FROM catalog_data WHERE id_catalog = 4;

INSERT INTO services (type_id, request_id)