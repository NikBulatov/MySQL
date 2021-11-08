# https://rtfm.co.ua/python-rabota-s-mysql-s-ispolzovaniem-mysqldb/
from MySQLdb import connect

# создаём подключение с помощью метода Connect
# тут с помощью init_command указываем первое действие, которое надо выполнить после подключения
# но для выбора базы - правильнее использовать db="databasename",
# init_command='use python_vk' вместо database для примера

with connect(host='localhost', database='python_vk', user='root', password=input('Password')) as connect:
    cursor = connect.cursor()  # объект БД курсор (для ввода запроса в клиент наверное)
    cursor.execute('select version()')  # String is a SQL query!
    """
     Выполнить запрос.
    
    запрос -- строка, запрашиваемая запрос у сервера
    args -- необязательная последовательность или сопоставление, параметры для использования с запросом.
    
    Note: If args is a sequence, then %s must be used as the
    parameter placeholder in the query. If a mapping is used,
    %(key)s must be used as the placeholder.
    
    Возвращает целое число, представляющее затронутые строки, если таковые имеются
    """
    data = cursor.fetchone()  # return one string. fetchall - all strings.
    print('MySQL version: %s' % data)
    cursor.execute('drop table if exists wallet')  # a new query
    query = """create table if not exists wallet(id serial primary key, 
    user_id bigint unsigned not null, foreign key (user_id) references users(id) on update cascade on delete cascade)"""
    cursor.execute(query)
    cursor.execute('show tables')
    for data in cursor:
        print(data[0])  # потому что в data одна строка!!! 24 строка кода
    # или так, но в виде кортежей
    # print('-' * 30)
    # tables = cursor.fetchall()
    # print(*tables)
    cursor.execute('describe wallet')
    for data in cursor:
        print(data[0])
    # print(connect.open)  # status of connection
    # print(connect.port)  # port of connection
    # # print(connect.converter)
    # print(connect.get_proto_info())  # protocol
    # # help(connect)  # documentation
