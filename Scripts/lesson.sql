USE vk;

SELECT -- id,
       firstname,
       (SELECT hometown FROM profiles WHERE user_id = users.id)                                         AS 'city',
       (SELECT filename FROM media WHERE id = (SELECT photo_id FROM profiles WHERE user_id = users.id)) AS 'main_photo'
FROM users
ORDER BY id;

SELECT id, user_id, media_type_id, filename
FROM media
WHERE user_id = 1
  AND media_type_id IN (SELECT id FROM media_types WHERE name LIKE 'p%');
-- SELECT * FROM media WHERE user_id = 1 AND media_type_id = 1;
-- Видео по разрешению
SELECT *
FROM media
WHERE user_id = 1
  AND (filename LIKE '%.avi' OR filename LIKE '%.mp4');
-- скобки повлияют на выборку

-- посчитать количество фото у пользователя с id = 1
SELECT COUNT(*)
FROM media
WHERE user_id = 1
  AND media_type_id = 1;

SELECT
    -- DISTINCT
    (SELECT name FROM media_types WHERE id = media.media_type_id) AS 'Media type',
    COUNT(*)                                                      AS cnt
FROM media
GROUP BY media_type_id
ORDER BY cnt DESC;

-- сколько в каждом месяце быо создано файлов media

-- агрегирующие функции (...)
SELECT MONTH(created_at)     AS month_number,
       MONTHNAME(created_at) AS month_name,
       COUNT(*)              AS cnt
FROM media
GROUP BY month_number
ORDER BY cnt DESC;

-- сколько документов у каждого пользователя
SELECT user_id,
       (SELECT email FROM users WHERE id = media.user_id) AS user,
       MONTH(created_at)                                  AS month_number,
       MONTHNAME(created_at)                              AS month_name,
       COUNT(*)                                           AS cnt
FROM media
GROUP BY user_id, month_number, month_name
ORDER BY user_id DESC, cnt DESC;

SELECT COUNT(id)                                          AS cnt,
       (SELECT email FROM users WHERE id = media.user_id) AS user,
       ANY_VALUE(created_at) -- просто created_at можно
FROM media
GROUP BY user_id;
-- страшно! очень страшно! Мы не знаем, что это такое, если бы мы знали, что это такое, мы не знаем, что это такое
SELECT @@sql_mode;
SET @@sql_mode = CONCAT(@@sql_mode, ',ONLY_FULL_GROUP_BY');

SET @@sql_mode = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION';
-- страшно! очень страшно! Мы не знаем, что это такое, если бы мы знали, что это такое, мы не знаем, что это такое

-- посмотреть друзей пользователя с id = 1
SELECT initiator_user_id, target_user_id, requested_at
FROM friend_requests
WHERE (initiator_user_id = 1 OR target_user_id = 1)
  AND status = 'approved';

-- документы только моих друзей
SELECT *
FROM media
WHERE user_id IN (
-- 4, 3, 10);
    SELECT initiator_user_id -- КОЛИЧЕСТВО ПОЛЕЙ в  UNION должно быть ОДИНАКОВОЕ
    FROM friend_requests
    WHERE target_user_id = 1
      AND status = 'approved'
    UNION
    -- медленнее JOIN, по умолчанию работает как DISTINCT
    SELECT target_user_id -- КОЛИЧЕСТВО ПОЛЕЙ в  UNION должно быть ОДИНАКОВОЕ
    FROM friend_requests
    WHERE initiator_user_id = 1
      AND status = 'approved'
)
   OR user_id = 1
ORDER BY user_id;

-- show likes for my docs (my media)
SELECT media_id,
       COUNT(*) AS cnt -- 1 id и сколько строк с таким значением
FROM likes
WHERE media_id IN (SELECT id FROM media WHERE user_id = 1)
GROUP BY media_id;

-- read messages
SELECT *
FROM messages
WHERE from_user_id = 1
   OR to_user_id = 1
ORDER BY created_at DESC;

ALTER TABLE messages
    ADD COLUMN is_read BIT DEFAULT b'0';
SELECT *
FROM messages
WHERE is_read = b'0'
  AND to_user_id = 1;
-- OR from_user_id = 1); условие избыточно

-- вывести друзей преобразовывать пол и возраст
SELECT user_id, CASE (gender) WHEN 'm' THEN 'мужской' WHEN 'f' THEN 'женский' ELSE 'не указан' END AS gender, birthday
FROM profiles
WHERE user_id IN (SELECT initiator_user_id
                  FROM friend_requests
                  WHERE (target_user_id = 1)
                    AND status = 'approved'
                  UNION
                  SELECT target_user_id
                  FROM friend_requests
                  WHERE (initiator_user_id = 1)
                    AND status = 'approved');

-- определить является пользователь admin'ом в группе
ALTER TABLE friend_requests
    ADD CHECK ( initiator_user_id <> target_user_id); -- изменить данные в таблице перед условием
SELECT 1 = (SELECT admin_user_id FROM communities WHERE id = 6) AS 'is_admin';