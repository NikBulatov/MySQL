USE site;
-- Показать пользователей, посетивших парикмахера и подолога отсортировать по фамилии
SELECT CONCAT(u.firstname, ' ', u.lastname) AS name, visit_time
FROM users u
         JOIN services s ON u.id = s.user_id AND status = 'done'
    AND s.type_master_id IN (10, 13)
ORDER BY u.lastname;
-- Посчитать количество оказанных услуг маникюра и педикюра
SELECT (SELECT cd.value_print FROM catalog_data cd WHERE s.type_master_id = cd.id) AS master,
       COUNT(id)                                                                   AS amount
FROM services s
WHERE type_master_id IN (12, 11)
  AND status = 'done'
GROUP BY master;
-- Кто чаще посещал парикмахера
SELECT (SELECT COUNT(user_id) FROM profiles WHERE gender = 'm') AS men,
       (SELECT COUNT(user_id) FROM profiles WHERE gender = 'f') AS women;
-- Сколько было запросов на отмену услуг и обновление информации
SELECT (SELECT COUNT(id) FROM requests WHERE type_id = 9) AS update_info,
       (SELECT COUNT(id) FROM requests WHERE type_id = 8) AS delete_info;
-- Сколько клиентов было у каждого мастера
SELECT COUNT(s.user_id) AS amount, cd.value_print AS master
FROM services s
         JOIN catalog_data cd ON s.type_master_id = cd.id
WHERE status = 'done'
GROUP BY master;
-- Количество услуг по группам
SELECT COUNT(user_id), cd.value_print AS service_name
FROM services s
         JOIN catalog_data cd on s.type_id = cd.id
GROUP BY type_id;
-- у кого нет фотографии в профиле
SELECT p.user_id, CONCAT(u.firstname, ' ', u.lastname) AS name
FROM profiles p
         JOIN users u ON p.user_id = u.id
WHERE p.photo_id IS NULL;