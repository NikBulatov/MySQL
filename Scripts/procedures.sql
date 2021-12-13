USE site;
DROP PROCEDURE IF EXISTS insert_data;
CREATE PROCEDURE insert_data()
BEGIN
   -- запись на приём
    INSERT INTO users (user_type_id, firstname, lastname, phone, email)

END;