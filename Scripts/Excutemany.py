import MySQLdb as mysql
import gc
# Для множественного добавления данных – используем executemany() Несколько строк упоминаются как список различных
# кортежей. Каждый элемент списка рассматривается как одна конкретная строка, тогда как каждый элемент кортежа
# рассматривается как одно конкретное значение столбца(атрибут).
put_it = [('line1', 'line2', 1), ('line3', 'line4', 2), ('line5', 'line6', 3), ('line7', 'line8', 4)]
with mysql.connect(host='localhost', database='python_vk', user='root', password=input('Password: ')) as connect:
    cursor = connect.cursor()
    cursor.execute('create table if not exists test_table(first_col char(20) not null, second_col char(20), '
                   'int_col int)')

    # запрос лучше создавать отдельной переменной, так как для выполнения команды потребуется форматирование строки
    # исходя из данных put_it'а
    # put_it = [               table('Первый столбец', 'Второй','Третий') values ('line1', 'line2', 1)
    insert = "insert into test_table(first_col, second_col, int_col) values (%s, %s, %s)"

    print('Выполняем запрос INSERT...')
    # первый аргумент - это запрос, второй данные в виде списка кортежей, в котором элемент - это значение для строки.
    # по порядку идут столбцы как в таблице!
    cursor.executemany(insert, put_it)
    # чтобы зафиксировать действия!
    # connect.commit()

    print('Выполняем SELECT, чтобы посмотреть результат:')
    cursor.execute('select * from test_table')
    data = cursor.fetchall()
    print(data)
    connect.commit()
    try:
        # удалит первую строку в таблице в каждом столбце!!
        drop = 'delete from test_table where true limit 1'
        cursor.execute(drop)
    except mysql.Error as e:
        print("MySQL Error [%d]: %s" % (e.args[0], e.args[1]))
    connect.commit()
    print('Выполняем SELECT, чтобы посмотреть результат:')
    cursor.execute('select * from test_table')
    print(cursor.fetchall())
gc.collect()
