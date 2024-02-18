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
    foreign key (user_id) references lab1.users (id),
    task_id integer NOT NULL,
    foreign key (task_id) references lab1.tasks (id),
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
    foreign key (user_id) references lab1.users (id),
    task_id integer NOT NULL,
    foreign key (task_id) references lab1.tasks (id)
);

CREATE TABLE lab2.difficulty_task (
    id integer PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    user_id integer NOT NULL,
    foreign key (user_id) references lab1.users (id),
    task_id integer NOT NULL,
    foreign key (task_id) references lab1.tasks (id),
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