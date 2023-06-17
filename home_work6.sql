USE lesson_4;

/* Создайте таблицу users_old, аналогичную таблице users. 
Создайте процедуру, с помощью которой можно переместить любого (одного) пользователя из таблицы users в таблицу users_old. 
(использование транзакции с выбором commit или rollback – обязательно). */
DROP TABLE IF EXISTS users_old;
CREATE TABLE users_old (
	id INT PRIMARY KEY AUTO_INCREMENT,
    firstname VARCHAR(50),
    lastname VARCHAR(50) COMMENT 'Фамилия',
    email VARCHAR(120) UNIQUE
);
DROP PROCEDURE IF EXISTS change_table_users;
DELIMITER //
CREATE PROCEDURE change_table_users(id INT)
BEGIN
INSERT INTO users_old (firstname, lastname, email) 
SELECT firstname, lastname, email
		FROM users u
		WHERE u.id=id;
DELETE FROM users u WHERE u.id=id;
COMMIT;
END //
DELIMITER ;

CALL change_table_users(5);

/* Создайте хранимую функцию hello(), которая будет возвращать приветствие, в зависимости от текущего времени суток. 
С 6:00 до 12:00 функция должна возвращать фразу "Доброе утро", 
с 12:00 до 18:00 функция должна возвращать фразу "Добрый день", 
с 18:00 до 00:00 — "Добрый вечер", 
с 00:00 до 6:00 — "Доброй ночи".*/

DROP FUNCTION IF EXISTS hello;
DELIMITER //
CREATE FUNCTION hello()
	RETURNS CHAR(30) 
    DETERMINISTIC
BEGIN
DECLARE result CHAR(30);
SELECT CASE 
		WHEN CURRENT_TIME()>='06:00:00' AND CURRENT_TIME()<'12:00:00'
			THEN 'Доброе утро'
		WHEN CURRENT_TIME()>='12:00:00' AND CURRENT_TIME()<'18:00:00'
			THEN 'Добрый день'
		WHEN CURRENT_TIME()>='18:00:00' AND CURRENT_TIME()<'00:00:00'
			THEN 'Добрый вечер'
		ELSE 'Добрый ночи'
END INTO result;
RETURN result;
END //
DELIMITER ;
SELECT hello();

/* (по желанию)* Создайте таблицу logs типа Archive. Пусть при каждом создании записи в таблицах users, 
communities и messages в таблицу logs помещается время и дата создания записи, название таблицы, идентификатор первичного ключа. */
USE lesson_4;
CREATE TABLE logs (
	date_created DATETIME DEFAULT NOW(),
    table_name VARCHAR(30) NOT NULL ,
    ident INT NOT NULL
)ENGINE= ARCHIVE;

CREATE TRIGGER users_trig AFTER INSERT ON users
FOR EACH ROW
	INSERT INTO logs SET table_name = 'users', ident = NEW.id;

CREATE TRIGGER communities_trig AFTER INSERT ON communities
FOR EACH ROW
	INSERT INTO logs SET table_name = 'communities', ident = NEW.id;

CREATE TRIGGER messages_trig AFTER INSERT ON messages
FOR EACH ROW
	INSERT INTO logs SET table_name = 'messages', ident = NEW.id;