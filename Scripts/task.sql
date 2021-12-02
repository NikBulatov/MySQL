/*
 Практическое задание по теме “Операторы, фильтрация, сортировка и ограничение. Агрегация данных”
 1. Пусть задан некоторый пользователь.
 Из всех друзей этого пользователя найдите человека, который больше всех общался с нашим пользователем.
 */
USE vk;
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
ORDER BY amount DESC
LIMIT 1;

-- 2. Подсчитать общее количество лайков, которые получили пользователи младше 10 лет.
SELECT COUNT(*)
FROM likes
         JOIN
     profiles
     ON likes.user_id = profiles.user_id
         AND TIMESTAMPDIFF(YEAR, birthday, NOW()) < 10;

-- 3. Определить кто больше поставил лайков (всего): мужчины или женщины.
SELECT COUNT(*) AS amount, gender
FROM likes
         JOIN
     profiles
     ON likes.user_id = profiles.user_id
GROUP BY gender;