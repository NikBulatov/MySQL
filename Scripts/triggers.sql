USE site;
DELIMITER //
CREATE TRIGGER insert_services
    BEFORE INSERT
    ON services
    FOR EACH ROW
BEGIN
    SELECT @req := r.type_id FROM requests r WHERE r.type_id = 7;
    IF NEW.request_id IN @req THEN


    END IF;
    END
    //