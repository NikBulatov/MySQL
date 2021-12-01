USE vk;
SELECT * FROM users JOIN profiles; -- работает как декартовое произведение
SELECT users.id, profiles.user_id FROM users, profiles;
/*
 ON - проверит перед построением таблицы,  WHERE после построения таблицы и потом фильтрует
 */
 -- самообъединение таблиц
SELECT * FROM likes AS l1, likes AS l2 WHERE l1.id = l2.id; -- USING(id) вместо WHERE
SELECT messages.body FROM messages, users ON user_id = isers.id WHERE