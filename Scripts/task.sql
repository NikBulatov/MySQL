/*
 Практическое задание по теме “Сложные запросы”
 1. Пусть задан некоторый пользователь.
 Из всех друзей этого пользователя найдите человека, который больше всех общался с нашим пользователем.
 */
USE vk;
SELECT from_user_id                                                                   AS friend,
       (SELECT CONCAT(firstname, ' ', lastname) FROM users WHERE id = m.from_user_id) AS name,
       COUNT(m.id)                                                                       AS messages
FROM messages m
         JOIN friend_requests fr
              ON from_user_id = fr.initiator_user_id OR from_user_id = fr.target_user_id -- он может быть инициатором и жертвой
WHERE status = 'approved' -- у которого принята дружба
  AND to_user_id = 1      -- пользователь
GROUP BY friend
ORDER BY messages
        DESC
LIMIT 1;
-- 2. Подсчитать общее количество лайков, которые ПОЛУЧИЛИ пользователи младше 10 лет.
SELECT COUNT(id) AS amount
FROM likes
WHERE media_id IN (SELECT id
                   FROM media
                   WHERE user_id IN (SELECT user_id
                                     FROM profiles
                                     WHERE TIMESTAMPDIFF(YEAR, birthday, NOW()) < 10));
-- через JOIN
SELECT COUNT(likes.id) AS amount
FROM likes
         JOIN media
         JOIN profiles
              ON media_id = media.id AND media.user_id = profiles.user_id AND TIMESTAMPDIFF(YEAR, birthday, NOW()) < 10;
-- 3. Определить кто больше поставил лайков (всего): мужчины или женщины.
-- моё решение (на урок по join)
SELECT COUNT(*) AS amount, gender
FROM likes
         JOIN
     profiles
     ON likes.user_id = profiles.user_id
GROUP BY gender;