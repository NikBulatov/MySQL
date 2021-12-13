USE site;
-- Показать пользователей, посетивших парикмахера и подолога
SELECT CONCAT(u.firstname, ' ', u.lastname) AS name, visit_time
FROM users u
         JOIN services s ON u.id = s.user_id AND status = 'done'
    AND s.type_master_id IN (10, 13);
-- Посчитать количество оказанных услуг маникюра и педикюра
SELECT COUNT(id) AS amount
FROM services
WHERE type_master_id IN (12, 11)
  AND status = 'created';
