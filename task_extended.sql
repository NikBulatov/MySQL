-- 4. (по желанию) Ознакомьтесь более подробно с документацией утилиты mysqldump. Создайте дамп единственной таблицы help_keyword базы данных mysql. Причем добейтесь того, чтобы дамп содержал только первые 100 строк таблицы

/*
mysqldump -uroot -p --where="true limit 100" --allow-keywords mysql help_keyword > dumpmysql.sql
mysql -uroot -p example < dumpmysql.sql
ERROR 3723 (HY000) at line 25: The table 'help_keyword' may not be created in the reserved tablespace 'mysql'.
*/

