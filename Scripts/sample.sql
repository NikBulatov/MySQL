USE samples;
DROP TABLE IF EXISTS accounts;
CREATE TABLE accounts
(
    id         SERIAL PRIMARY KEY,
    user_id    BIGINT UNSIGNED,
    total      DECIMAL(11, 2) COMMENT 'Счет',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) COMMENT = 'Счета пользователей и интернет магазина';
INSERT INTO accounts (user_id, total)
VALUES (4, 5000.00),
       (3, 0.00),
       (2, 200.00),
       (NULL, 25000.00);

START TRANSACTION; -- начало транзакции, начало наброска
SELECT total FROM accounts WHERE user_id = 4;
UPDATE accounts SET total = total - 2000 WHERE user_id = 4;
SELECT total FROM accounts WHERE user_id = 4;
UPDATE accounts SET total =total + 2000 WHERE user_id IS NULL;
SELECT * FROM accounts; -- изменения не зафиксировались
COMMIT; -- чистовик, фиксируем
SELECT * FROM accounts; -- изменения зафиксировались

START TRANSACTION;
SELECT total FROM accounts WHERE user_id = 4;
UPDATE accounts SET total = total - 2000 WHERE user_id = 4;
UPDATE accounts SET total =total + 2000 WHERE user_id IS NULL;
SELECT * FROM accounts; -- изменения не зафиксировались
ROLLBACK;
SELECT * FROM accounts; -- изменения не зафиксировались

-- SAVE POINTS
START TRANSACTION;
SELECT total FROM accounts WHERE user_id = 4;
SAVEPOINT accounts_4;
UPDATE accounts SET total = total - 2000 WHERE user_id = 4;

-- отменить текущую транзакцию
ROLLBACK TO SAVEPOINT accounts_4;
SELECT * FROM accounts; -- изменения не зафиксировались

-- в MySQL каждый запрос по сути одна транзакция, чтобы это изменить нужно изменить параметр AUTOCOMMIT с 1 на 0
SET AUTOCOMMIT = 0;

SELECT total FROM accounts WHERE user_id = 4;
UPDATE accounts SET total = total - 2000 WHERE user_id = 4;
UPDATE accounts SET total =total + 2000 WHERE user_id IS NULL;
SELECT * FROM accounts;
-- чтобы сохранить изменения нужно выполнить команду COMMIT
COMMIT;
-- или отменить выполнив
-- ROLLBACK;

-- возвращаем автоматическое завершение транзакций
SET AUTOCOMMIT = 1;
