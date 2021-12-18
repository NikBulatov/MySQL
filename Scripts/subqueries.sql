USE site;
-- Кто чаще посещал парикмахера
SELECT (SELECT COUNT(*) FROM profiles WHERE gender = 'm') AS men,
       (SELECT COUNT(*) FROM profiles WHERE gender = 'f') AS women;
-- Сколько было запросов на отмену услуг и обновление информации
SELECT (SELECT COUNT(id) FROM requests WHERE type_id = 9) AS update_info,
       (SELECT COUNT(id) FROM requests WHERE type_id = 8) AS delete_info;
