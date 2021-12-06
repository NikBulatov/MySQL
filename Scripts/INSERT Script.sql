USE site;
INSERT INTO catalog
VALUES (1, 'types_users'),
       (2, 'types_media'),
       (3, 'types_requests'),
       (4, 'types_services');


-- справочник
INSERT INTO catalog_data (id_catalog, value, sequence, value_print)
VALUES (1, 'admin', 1, 'Администратор'),
       (1, 'client', 2, 'Клиент'),
       (1, 'developer', 3, 'Разработчик'),
       (2, 'types_services', 4, 'Тип услуги'),
       (2, 'photo', 4, 'Фотографии'),
       (2, 'video', 5, 'Видео'),
       (2, 'file', 6, 'Файл'),
       (3, 'to_service', 7, 'Запись на услугу'),
       (3, 'cancel_service', 8, 'Отменить запись'),
       (3, 'update_service', 9, 'Обновить данные на запись'),
       (4, 'haircut', 10, 'На стрижку'),
       (4, 'coloring', 11, 'На окрашивание');
       -- (4, '');

INSERT INTO users (user_type_id, firstname, lastname, phone, email)
VALUES ()
