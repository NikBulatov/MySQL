import MySQLdb
import gc

# создаём подключение с помощью метода Connect
# передаём имя базы через db="" вместо init_command=
db = MySQLdb.connect(host='localhost', database='python_vk', user='root', password=input('Password: '))

# создаём объект db с помощью метода cursor() модуля MySQLdb
cursor = db.cursor()

# добавим обработку ошибок
try:
    # создаём переменную с запросом
    insert = """insert into test_table(first_col, second_col, int_col) values ('newline', 'newline', '100')"""

    # выполняем запрос
    cursor.execute(insert)

    cursor.execute("select * from testtable")

    # используем fetchall() вместо fetchone()
    # что бы получить все данные
    # а не только последнюю строку
    data = cursor.fetchall()
    print(data)

# добавим обработку ошибок
except MySQLdb.Error as e:
    print("MySQL Error [%d]: %s" % (e.args[0], e.args[1]))  # первый элемент - это номер ошибки, второй ошибка?

else:
    # и отключаемся от сервера
    db.close()
    gc.collect()
