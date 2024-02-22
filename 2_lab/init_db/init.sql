DROP SCHEMA IF EXISTS lab2 CASCADE;
CREATE SCHEMA lab2 AUTHORIZATION yutfut;

DROP TABLE IF EXISTS lab2.users CASCADE;
DROP TABLE IF EXISTS lab2.task CASCADE;
DROP TABLE IF EXISTS lab2.send_task CASCADE;
DROP TABLE IF EXISTS lab2.likes CASCADE;
DROP TABLE IF EXISTS lab2.difficulty_task CASCADE;

create table lab2.task
(
    id integer PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    name VARCHAR(256) NOT NULL,
    description text,
    public_tests text[],
    private_tests text[],
    generated_tests text[],
    difficulty integer,
    cf_contest_id integer,
    cf_index VARCHAR(3),
    cf_points float,
    cf_rating integer NOT NULL check (cf_rating > 0), -- ограничения проверки
    cf_tags integer[],
    time_limit float,
    memory_limit_bytes integer,
    link VARCHAR(256),
    short_link VARCHAR(256),
    name_ru text,
    task_ru text,
    input text,
    output text,
    note text,
    master_solution text,
    checker text,
    checkers text[]
);

ALTER TABLE lab2.task ADD pole1 char(10);       -- добавление столбца 
ALTER TABLE lab2.task ALTER pole1 TYPE text;    -- изменение типа столбца
ALTER TABLE lab2.task DROP COLUMN pole1;        -- удаление столбца
ALTER TABLE lab2.task RENAME TO tasks;          -- переименование таблицы

CREATE TABLE lab2.users (
    id integer PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    username VARCHAR(256) NOT NULL,
    password VARCHAR(256) NOT NULL,
    cold_start BOOL NOT NULL DEFAULT false,
    registration_date TIMESTAMP DEFAULT now() + interval '3 hours' NOT NULL
);

CREATE TYPE lab2.send_task_status AS ENUM ('success', 'fail');

CREATE TABLE lab2.send_task (
    id integer PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    user_id integer NOT NULL,
    foreign key (user_id) references lab2.users (id),
    task_id integer NOT NULL,
    foreign key (task_id) references lab2.tasks (id),
    check_time float,
    build_time float,
    check_result int,
    check_message text,
    tests_passed integer,
    tests_total integer,
    lint_success bool,
    code_text text,
    status lab2.send_task_status,
    date TIMESTAMP DEFAULT now() + interval '3 hours' NOT NULL
);

CREATE TABLE lab2.likes (
    id integer PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    user_id integer NOT NULL,
    foreign key (user_id) references lab2.users (id),
    task_id integer NOT NULL,
    foreign key (task_id) references lab2.tasks (id)
);

CREATE TABLE lab2.difficulty_task (
    id integer PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    user_id integer NOT NULL,
    foreign key (user_id) references lab2.users (id),
    task_id integer NOT NULL,
    foreign key (task_id) references lab2.tasks (id),
    difficulty int NOT NULL
);

INSERT INTO lab2.tasks (name, description, public_tests, private_tests, generated_tests, difficulty, cf_contest_id, cf_index, cf_points, cf_rating, cf_tags, time_limit, memory_limit_bytes, link, short_link, name_ru, task_ru, input, output, note, master_solution, checker, checkers) 
VALUES ('name1', 'description', ARRAY['public_tests1', 'public_tests2'], ARRAY['private_tests1', 'private_tests2'], ARRAY['generated_tests1', 'generated_tests2'], 1, 1, 'A1B', 1, 1, ARRAY[1, 2], 1, 1, 'link', 'short_link', 'name_ru', 'task_ru', 'input', 'output', 'note', 'master_solution', 'checker', ARRAY['checker1', 'checker2']);

INSERT INTO lab2.users ( username, password, cold_start)
VALUES ('username', 'password', false), ('username1', 'password1', false), ('username2', 'password2', true);

INSERT INTO lab2.send_task (user_id, task_id, check_time, build_time, check_result, check_message, tests_passed, tests_total, lint_success, code_text, status)
VALUES (1, 1, 1, 1, 1, 1, 1, 1, true, 'code_text', 'success');

INSERT INTO lab2.likes (user_id, task_id)
VALUES (1, 1);

INSERT INTO lab2.difficulty_task (user_id, task_id, difficulty)
VALUES (1, 1, 1);

-- скалярная функция

create or replace function "count_true_cold_start"()
returns int as 'SELECT count(*) FROM lab2.users WHERE cold_start=true'
LANGUAGE SQL volatile;

select * from lab2.users;
select count_true_cold_start();

-- скалярная функция с использованием переменной

create or replace function "count_false_cold_start"()
returns int as
$$
declare count_false int;
begin
select count(*) into count_false FROM lab2.users WHERE cold_start=false;
return count_false;
end
$$
LANGUAGE plpgsql;

select count_false_cold_start();

-- табличные функции inline

create or replace function "get_cold_start_users"(x bool)
returns table(id int, username VARCHAR(256)) as
$$
	select id, username from lab2.users where cold_start=x;
$$
language sql;

select get_cold_start_users(true);

-- табличные функции multi-statement

create or replace function get_all_users()
returns setof int as
$BODY$
declare r int;
begin
for r in select id from lab2.users 
	loop
		return next r;
	end loop;
return;
end
$BODY$
LANGUAGE plpgsql;

select get_all_users();

-- хранимая процедура
-- Создать хранимую процедуру, содержащую запросы, вызов и перехват исключений. 
-- Вызвать процедуру из окна запроса. Проверить перехват и создание исключений.

create or replace procedure lab2.get_user(x int) as
$$
declare usern varchar(256);
begin
	select username into usern from lab2.users where id=x;
	if usern is NULL then
		raise exception using errcode='E0001', hint='error', message='error';
	else
		EXECUTE format('delete from lab2.users where username = %I;', usern);
-- 		delete from lab2.users where username=usern;
-- 		exception when others then RAISE NOTICE 'перехватили ошибку';
	end if;
end;
$$
LANGUAGE plpgsql;

-- call lab2.get_user(1);
-- call lab2.get_user(1);
-- call lab2.get_user(5);

-- перехват исключений

create or replace FUNCTION lab2.get_user1(x int)
    RETURNS SETOF varchar(256) AS
$BODY$
BEGIN
    RETURN QUERY
        select username from lab2.users where id=$1;
    IF NOT FOUND THEN
        RAISE EXCEPTION 'Нет такого пользователя';
    END IF;
    RETURN;
END;
$BODY$
    LANGUAGE plpgsql;

select lab2.get_user1(1);
select lab2.get_user1(10);

-- Продемонстрировать в функциях и процедурах работу условных операторов и выполнение динамического запроса.

create or replace function get_user(x int)
returns varchar(256) as
$$
declare usern varchar(256);
begin
	select username into usern from lab2.users where id=x;
	if usern is NULL then
		raise exception using errcode='E0001', hint='error', message='error';
	else
		EXECUTE format('delete from lab2.users where username = %I;', usern);
		return usern;
-- 		delete from lab2.users where username=usern;
-- 		exception when others then RAISE NOTICE 'перехватили ошибку';
	end if;
end;
$$
LANGUAGE plpgsql;

select get_user(1);

-- рекурсивный

WITH RECURSIVE r AS (
    -- стартовая часть рекурсии
    SELECT
        1 AS i,
        1 AS factorial

    UNION

    -- рекурсивная часть
    SELECT
        i+1 AS i,
        factorial * (i+1) as factorial
    FROM r
    WHERE i < 10
)
SELECT * FROM r;

-- YET

DROP TABLE IF EXISTS lab2.geo CASCADE;
CREATE TABLE IF NOT EXISTS lab2.geo (
    id int not null primary key,
    parent_id int references lab2.geo(id),
    name varchar(1000)
);

INSERT INTO lab2.geo (id, parent_id, name) VALUES
(1, null, 'Планета Земля'),
(2, 1, 'Континент Евразия'),
(3, 1, 'Континент Северная Америка'),
(4, 2, 'Европа'),
(5, 4, 'Россия'),
(6, 4, 'Германия'),
(7, 5, 'Москва'),
(8, 5, 'Санкт-Петербург'),
(9, 6, 'Берлин');

WITH RECURSIVE r AS (
    SELECT id, parent_id, name
    FROM lab2.geo
    WHERE parent_id = 4

    UNION

    SELECT lab2.geo.id, lab2.geo.parent_id, lab2.geo.name
    FROM lab2.geo
             JOIN r
                  ON lab2.geo.parent_id = r.id
)

SELECT * FROM r;

-- LIMIT

select * from lab2.users Limit 3;

-- returning

INSERT INTO lab2.users (username, password, cold_start) VALUES ('username', 'password', false) RETURNING (id, username, password, cold_start);

-- ранжированние оконные функции

DROP TABLE IF EXISTS lab2.range CASCADE;
CREATE TABLE IF NOT EXISTS lab2.range (
id integer PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
name text,
price integer
);

insert into lab2.range (name, price) values
 ('a', 1),
 ('a', 5),
 ('a', 6),
 ('a', 7),
 ('b', 8),
 ('b', 2),
 ('b', 3),
 ('b', 1);

SELECT id, name, price,
       rank() OVER (PARTITION BY name ORDER BY price) --DESC
FROM lab2.range;

-- курсор

CREATE OR REPLACE FUNCTION func_with_cursor_user(
    OUT user_name varchar(256),
    OUT pass_word varchar(256)
)
    RETURNS SETOF RECORD AS
$$
DECLARE
    edges_cursor CURSOR FOR
        SELECT username, password
        FROM lab2.users;
    edge_record RECORD;
BEGIN
    -- Open cursor
    OPEN edges_cursor;

    -- Fetch rows and return
    LOOP
        FETCH NEXT FROM edges_cursor INTO edge_record;
        EXIT WHEN NOT FOUND;
        user_name := edge_record.username;
        pass_word := edge_record.password;
        RETURN NEXT;
    END LOOP;

    -- Close cursor
    CLOSE edges_cursor;
END;
$$
    LANGUAGE PLPGSQL;

select func_with_cursor_user();

-- оконные функции

-- встроенная функция

select * from lab2.users where substring(username for 2) = 'us';
select * from lab2.users where substring(username, '.*ern.*') <> '';
select substring('username' from '.*ern.*');