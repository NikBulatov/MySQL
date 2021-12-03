/*
 Практическое задание по теме “Операторы, фильтрация, сортировка и ограничение. Агрегация данных”
 1. Пусть задан некоторый пользователь.
 Из всех друзей этого пользователя найдите человека, который больше всех общался с нашим пользователем.
 */
USE vk;
-- Саша помог
/*
SELECT from_user_id AS target_result, to_user_id AS our_user, amount
FROM (
         SELECT messages.from_user_id, messages.to_user_id, COUNT(DISTINCT messages.id) AS amount
         FROM messages
                  JOIN
              (SELECT from_user_id, to_user_id, id
               FROM messages
               UNION
               SELECT to_user_id, from_user_id, id
               FROM messages) AS mess
                  JOIN friend_requests
                       ON initiator_user_id IN (mess.from_user_id, mess.to_user_id) AND status = 'approved'
         WHERE mess.from_user_id = 1
         GROUP BY from_user_id, to_user_id) AS result
GROUP BY from_user_id
ORDER BY amount DESC
LIMIT 1;
  */
-- решение
SELECT from_user_id                                                                          AS friend,
       (SELECT CONCAT(firstname, ' ', lastname) FROM users WHERE id = messages.from_user_id) AS name,
       COUNT(*)                                                                              AS messages
FROM messages
WHERE to_user_id = 1
  AND from_user_id IN (SELECT initiator_user_id
                       FROM friend_requests
                       WHERE (target_user_id = 1)
                         AND status = 'approved'
                       UNION
                       SELECT target_user_id
                       FROM friend_requests
                       WHERE (initiator_user_id = 1)
                         AND status = 'approved')
GROUP BY friend
ORDER BY messages DESC
LIMIT 1;
-- 2. Подсчитать общее количество лайков, которые ПОЛУЧИЛИ пользователи младше 10 лет.
SELECT COUNT(id) AS amount
FROM likes
WHERE media_id IN (SELECT id
                   FROM media
                   WHERE user_id IN (SELECT user_id
                                     FROM profiles
                                     WHERE TIMESTAMPDIFF(YEAR, birthday, NOW()) < 10));
-- 3. Определить кто больше поставил лайков (всего): мужчины или женщины.
-- решение с урока
SELECT COUNT(*) AS amount, gender
FROM (SELECT user_id AS user, (SELECT gender FROM profiles WHERE user_id = user) AS gender FROM likes) AS dummy
GROUP BY gender;
-- моё решение (на урок по join)
SELECT COUNT(*) AS amount, gender
FROM likes
         JOIN
     profiles
     ON likes.user_id = profiles.user_id
GROUP BY gender;