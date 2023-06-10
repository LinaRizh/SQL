USE lesson_4;

/* Создайте представление, в которое попадет информация о пользователях (имя, фамилия, город и пол), которые не старше 20 лет. */
DROP VIEW IF EXISTS young;
CREATE VIEW young AS
SELECT firstname, lastname, gender, hometown 
FROM users JOIN 
(SELECT * FROM profiles
		WHERE ((YEAR(CURRENT_DATE) - YEAR(birthday))- 
		(DATE_FORMAT(CURRENT_DATE, '%m%d') < DATE_FORMAT(birthday, '%m%d')))<21
) as p
ON users.id=p.user_id;

/*Найдите кол-во, отправленных сообщений каждым пользователем и выведите ранжированный список пользователей, 
указав имя и фамилию пользователя, количество отправленных сообщений и место в рейтинге 
(первое место у пользователя с максимальным количеством сообщений) . (используйте DENSE_RANK) */

DROP VIEW IF EXISTS messages_list;
CREATE VIEW messages_list AS
SELECT CONCAT(firstname, ' ', lastname) AS 'Пользователь', count_m,
	DENSE_RANK()
	OVER (ORDER BY count_m) AS 'Dense_Rank'
	FROM users JOIN
	(SELECT from_user_id, COUNT(from_user_id) AS count_m 
	FROM messages GROUP BY from_user_id
	) as m
	ON users.id=m.from_user_id;

/*Выберите все сообщения, отсортируйте сообщения по возрастанию даты отправления (created_at) и 
найдите разницу дат отправления между соседними сообщениями, получившегося списка. (используйте LEAD или LAG) created_at-LAG(created_at) OVER()*/

DROP VIEW IF EXISTS all_messages;
CREATE VIEW all_messages AS
SELECT body, created_at, (TIMESTAMPDIFF(SECOND,LAG(created_at) OVER(),created_at)) AS 'Разница во времени в секундах'
FROM messages ORDER BY created_at
