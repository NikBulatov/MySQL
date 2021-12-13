USE site;
-- Услуги парикмахера
DROP VIEW IF EXISTS v_hairdressers_services;
CREATE VIEW v_hairdressers_services AS
SELECT cat_data.id,
       cat_data.value_print AS service
FROM catalog_data cat_data
         JOIN catalog c ON cat_data.id_catalog = c.id
WHERE cat_data.id_catalog_data = 10;

SELECT *
FROM v_hairdressers_services;
-- Читабельный вид таблицы запросов
DROP VIEW IF EXISTS v_requests;
CREATE VIEW v_requests AS
SELECT r.id, c.value_print AS request_name, r.user_id, CONCAT(u.firstname, ' ', u.lastname) AS name
FROM requests r
         JOIN users u ON r.user_id = u.id
         JOIN catalog_data c ON c.id_catalog = 3 AND r.type_id = c.id;

SELECT *
FROM v_requests;

