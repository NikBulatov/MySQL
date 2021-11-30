/*
 Практическое задание по теме “Операторы, фильтрация, сортировка и ограничение. Агрегация данных”
 1. Пусть задан некоторый пользователь.
 Из всех друзей этого пользователя найдите человека, который больше всех общался с нашим пользователем.
 */
USE vk;
SELECT COUNT(*) mess, friend
FROM (SELECT to_user_id AS friend
      FROM messages
      WHERE from_user_id = 1
      UNION ALL
      SELECT from_user_id AS friend
      FROM messages
      WHERE to_user_id = 1) as history
GROUP BY friend
ORDER BY mess DESC
LIMIT 1;

-- 2. Подсчитать общее количество лайков, которые получили пользователи младше 10 лет.
SELECT SUM(likes), user
FROM (SELECT COUNT(*) AS likes, likes.user_id AS user
      FROM likes, profiles, users
      WHERE likes.user_id = users.id AND TIMESTAMPDIFF(YEAR, birthday, NOW()) > 10) AS amount;
-- 3. Определить кто больше поставил лайков (всего): мужчины или женщины.
SELECT COUNT(*) AS amount, gender FROM likes, profiles WHERE likes.user_id = profiles.user_id GROUP BY gender;