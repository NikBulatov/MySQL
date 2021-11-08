import MySQLdb

# есть упоминания о том, что некоторые версии MySQLdb
# после выполнения db.close не полностью "убирают мусор"
# добавим вызов garbage collector
import gc

# создаём подключение с помощью метода Connect
# тут с помощью init_command указываем первое действие, которое надо выполнить после подключения
# но для выбора базы - правильнее использовать db="databasename", init_command тут для примера
db = MySQLdb.connect(host='localhost', database='python_vk', user='root', password=input('Password: '))

# создаём объект db с помощью метода cursor() модуля MySQLdb
cursor = db.cursor()

# удалим таблицу, если уже есть
cursor.execute("drop table if exists test_table")

# для коротких запросов из можно можно записать в аргументы к execute
# длинный запрос - удобнее поместить в переменную
# создаём переменную с запросом
sql = """create table test_table(first_col char(20) not null, second_col char(20), int_col int)"""

# выполняем запрос
cursor.execute(sql)

# проверим таблицы, выполнив запрос
cursor.execute("show tables")
# и получаем результат запроса
print("Так:")
for data in cursor:
    print(data[0])
# кортеж
print("Или так:")
tables = cursor.fetchall()
print(tables)

# и отключаемся от сервера
db.close()

# вызываем garbage collector, чтобы собрать мусор
gc.collect()
print(gc.collect())  # 0 is success!
