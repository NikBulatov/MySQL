USE site;
DROP PROCEDURE IF EXISTS to_service_old_user;
DELIMITER //
-- запись на услугу c существующим пользователем
CREATE PROCEDURE to_service_old_user(user_id BIGINT, type_master_id BIGINT, service_id BIGINT)
BEGIN
    SET @user_id = user_id;
    SET @request_id = 7;
    SET @service_id = service_id;
    SET @type_master_id = type_master_id;
    -- создаём запись в таблице запросов
    INSERT INTO requests (type_id, user_id) VALUES (7, @user_id);
    -- запись к парикмахеру
    IF @type_master_id = 10 AND @service_id IN (14, 15, 16, 17, 18) THEN
        INSERT INTO services (type_master_id, type_id, user_id, request_id, visit_time)
        VALUES (@type_master_id, @service_id, @user_id, @request_id, NOW());
        -- запись на маникюр
    ELSEIF @type_master_id = 11 AND @service_id = 20 THEN
        INSERT INTO services (type_master_id, type_id, user_id, request_id, visit_time)
        VALUES (@type_master_id, @service_id, @user_id, @request_id, NOW());
        -- запись на педикюр
    ELSEIF @type_master_id = 12 AND @service_id = 21 THEN
        INSERT INTO services (type_master_id, type_id, user_id, request_id, visit_time)
        VALUES (@type_master_id, @service_id, @user_id, @request_id, NOW());
        -- запись к подологу
    ELSEIF @type_master_id = 13 AND @service_id = 19 THEN
        INSERT INTO services (type_master_id, type_id, user_id, request_id, visit_time)
        VALUES (@type_master_id, @service_id, @user_id, @request_id, NOW());
    ELSE
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Ошибка в выборе мастера и/или услуги';
    END IF;
END//
DELIMITER ;
CALL to_service_old_user(3, 10, 16);
SELECT *
FROM services
ORDER BY id DESC
LIMIT 1;
DROP PROCEDURE IF EXISTS add_new_user;
DELIMITER //
CREATE PROCEDURE add_new_user(firstname VARCHAR(255),
                              lastname VARCHAR(255),
                              phone VARCHAR(255),
                              email VARCHAR(255),
                              gender CHAR(1))
BEGIN
    SET @firstname = firstname;
    SET @lastname = lastname;
    SET @email = email;
    SET @phone = phone;
    SET @gender = gender;
    INSERT INTO users (firstname, lastname, phone, email) VALUES (@firstname, @lastname, @phone, @email);
    INSERT INTO profiles (gender) VALUE (@gender);
END//
DELIMITER ;
CALL add_new_user('Michael', 'Dubrovsky', '+7(930)816-40-55', 'misha.d@example.com', 'm');
SELECT *
FROM users
ORDER BY id DESC
LIMIT 1;
SELECT *
FROM profiles
ORDER BY user_id DESC
LIMIT 1;