-- Управление БД
-- 1. Установите СУБД MySQL. Создайте в домашней директории файл my.ini, задав в нем логин и пароль, который указывался при установке.
-- C:\Program Files\MySQL\MySQL Server 8.0> 
/*
[mysql]
# no-beep=
user=root
password=password
*/
-- 2. Создайте базу данных example, разместите в ней таблицу users, состоящую из двух столбцов, числового id и строкового name.

create database example;
-- use example;
create table users(id serial primary key, name varchar(100) not null unique);
/*
 show tables;
+-------------------+
| Tables_in_example |
+-------------------+
| users             |
+-------------------+
1 row in set (0.00 sec)
 */
-- \q
-- 3. Создайте дамп базы данных example из предыдущего задания, разверните содержимое дампа в новую базу данных sample.
-- mysqldump -u root -p example > example.sql
create database sample;
-- \q
-- mysql -u root -p sample< example.sql
-- use sample
show tables;
/*
+------------------+
| Tables_in_sample |
+------------------+
| users            |
+------------------+
1 row in set (0.00 sec)
 */

