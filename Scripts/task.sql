/*
 Практическое задание по теме “Операторы, фильтрация, сортировка и ограничение. Агрегация данных”
 1. Пусть задан некоторый пользователь.
 Из всех друзей этого пользователя найдите человека, который больше всех общался с нашим пользователем.
 */
USE vk;
/*
SELECT COUNT(id) AS mess, friend
FROM (SELECT id, to_user_id AS friend
      FROM messages
      WHERE from_user_id = 1
      UNION ALL
      SELECT id, from_user_id AS friend
      FROM messages
      WHERE to_user_id) AS history
GROUP BY friend
ORDER BY mess DESC;
*/
SELECT from_user_id, to_user_id, COUNT(id) AS amount
FROM (SELECT id, from_user_id, to_user_id
      FROM messages
               JOIN
           friend_requests
           ON (from_user_id = friend_requests.initiator_user_id = 1
           OR to_user_id = friend_requests.target_user_id) AND status = 'approved') AS mess
GROUP BY from_user_id
ORDER BY amount DESC;
-- 2. Подсчитать общее количество лайков, которые получили пользователи младше 10 лет.
SELECT COUNT(*)
FROM likes,
     profiles
WHERE likes.user_id = profiles.user_id
  AND TIMESTAMPDIFF(YEAR, birthday, NOW()) < 10;
-- 3. Определить кто больше поставил лайков (всего): мужчины или женщины.
SELECT COUNT(*) AS amount, gender
FROM likes,
     profiles
WHERE likes.user_id = profiles.user_id
GROUP BY gender;