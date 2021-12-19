USE site;
DROP TRIGGER IF EXISTS update_media;
DELIMITER //
CREATE TRIGGER update_media
    BEFORE INSERT
    ON media
    FOR EACH ROW
BEGIN
    IF filename = '%.png' OR filename = '%.jpg' THEN
        SET NEW.media_type_id = 4;
    ELSEIF filename = '%.avi' OR filename = '%.mp4' THEN
        SET NEW.media_type_id = 5;
    ELSE
        SET NEW.media_type_id = 6;
    END IF;
END //
DELIMITER ;
DROP TRIGGER IF EXISTS insert_photo_album;
DELIMITER //
-- добавление фотографий в созданный по умолчанию альбом, у которого id совпадает с id пользователя
CREATE TRIGGER insert_photo_album
    BEFORE INSERT
    ON photos
    FOR EACH ROW
BEGIN
    IF NEW.album_id IS NULL THEN
        SET NEW.album_id = NEW.user_id;
    END IF;
END //
DELIMITER ;

INSERT INTO photos (media_id, album_id, user_id)
VALUES (17, NULL, 17);
SELECT *
FROM photos
ORDER BY user_id DESC
LIMIT 2;
SELECT *
FROM photo_albums
ORDER BY user_id DESC
LIMIT 2;