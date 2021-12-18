USE site;
-- Сколько клиентов было у каждого мастера
SELECT COUNT(s.user_id) AS amount, (SELECT value_print FROM catalog_data WHERE id = s.type_master_id) AS master
FROM services s
WHERE status = 'done'
GROUP BY type_master_id;
-- Количество услуг по группам
SELECT COUNT(user_id), (SELECT value_print FROM catalog_data WHERE id = s.type_id) AS service_name
FROM services s
GROUP BY type_id
