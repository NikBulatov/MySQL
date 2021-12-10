/*
 Практическое задание по теме “Сложные запросы”
 1. Пусть задан некоторый пользователь.
 Из всех друзей этого пользователя найдите человека, который больше всех общался с нашим пользователем.
 */
USE vk;
SELECT from_user_id                            AS friend,
       CONCAT_WS(' ', u.firstname, u.lastname) AS name,
       COUNT(m.id)                             AS messages
FROM messages m
         JOIN users u ON u.id = m.from_user_id
         JOIN friend_requests fr
              ON from_user_id = fr.initiator_user_id OR from_user_id = fr.target_user_id -- он может быть инициатором и жертвой
WHERE status = 'approved' -- у которого принята дружба
  AND to_user_id = 1      -- пользователь
GROUP BY friend
ORDER BY messages
        DESC
LIMIT 1;

-- 2. Подсчитать общее количество лайков, которые ПОЛУЧИЛИ пользователи младше 10 лет.
SELECT COUNT(l.id) AS amount
FROM likes l
         JOIN media m ON l.media_id = m.id
         JOIN profiles p
              ON m.user_id = p.user_id AND TIMESTAMPDIFF(YEAR, birthday, NOW()) < 10;

-- 3. Определить кто больше поставил лайков (всего): мужчины или женщины.
-- моё решение (на урок по join)
SELECT COUNT(*) AS amount, p.gender
FROM likes l
         JOIN
     profiles p
     ON l.user_id = p.user_id
GROUP BY gender
ORDER BY amount DESC;