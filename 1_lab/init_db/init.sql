DROP SCHEMA IF EXISTS lab1 CASCADE;
CREATE SCHEMA lab1 AUTHORIZATION example;

DROP TABLE IF EXISTS lab1.users CASCADE;
DROP TABLE IF EXISTS lab1.task CASCADE;
DROP TABLE IF EXISTS lab1.send_task CASCADE;
DROP TABLE IF EXISTS lab1.likes CASCADE;
DROP TABLE IF EXISTS lab1.difficulty_task CASCADE;

create table lab1.task
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

ALTER TABLE lab1.task ADD pole1 char(10);       -- добавление столбца 
ALTER TABLE lab1.task ALTER pole1 TYPE text;    -- изменение типа столбца
ALTER TABLE lab1.task DROP COLUMN pole1;        -- удаление столбца
ALTER TABLE lab1.task RENAME TO tasks;          -- переименование таблицы

alter table lab1.tasks add constraint UNIQUE (note);

CREATE TABLE lab1.users (
    id integer PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    username VARCHAR(256) NOT NULL,
    password VARCHAR(256) NOT NULL,
    cold_start BOOL NOT NULL DEFAULT false,
    registration_date TIMESTAMP DEFAULT now() + interval '3 hours' NOT NULL
);

CREATE TYPE lab1.send_task_status AS ENUM ('success', 'fail');

CREATE TABLE lab1.send_task (
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
    status lab1.send_task_status,
    date TIMESTAMP DEFAULT now() + interval '3 hours' NOT NULL
);

CREATE TABLE lab1.likes (
    id integer PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    user_id integer NOT NULL,
    foreign key (user_id) references lab1.users (id),
    task_id integer NOT NULL,
    foreign key (task_id) references lab1.tasks (id)
);

CREATE TABLE lab1.difficulty_task (
    id integer PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    user_id integer NOT NULL,
    foreign key (user_id) references lab1.users (id),
    task_id integer NOT NULL,
    foreign key (task_id) references lab1.tasks (id),
    difficulty int NOT NULL
);

INSERT INTO lab1.tasks (name, description, public_tests, private_tests, generated_tests, difficulty, cf_contest_id, cf_index, cf_points, cf_rating, cf_tags, time_limit, memory_limit_bytes, link, short_link, name_ru, task_ru, input, output, note, master_solution, checker, checkers) 
VALUES ('name1', 'description', ARRAY['public_tests1', 'public_tests2'], ARRAY['private_tests1', 'private_tests2'], ARRAY['generated_tests1', 'generated_tests2'], 1, 1, 'A1B', 1, 1, ARRAY[1, 2], 1, 1, 'link', 'short_link', 'name_ru', 'task_ru', 'input', 'output', 'note', 'master_solution', 'checker', ARRAY['checker1', 'checker2']);

INSERT INTO lab1.users ( username, password, cold_start)
VALUES ('username', 'password', false), ('username1', 'password1', false);

INSERT INTO lab1.send_task (user_id, task_id, check_time, build_time, check_result, check_message, tests_passed, tests_total, lint_success, code_text, status)
VALUES (1,1,1,1,1,1,1,1,true, 'code_text', 'success');

INSERT INTO lab1.likes (user_id, task_id)
VALUES (1, 1);

INSERT INTO lab1.difficulty_task (user_id, task_id, difficulty)
VALUES (1, 1, 1);

UPDATE lab1.difficulty_task SET user_id=2 where id=1;
DELETE FROM lab1.difficulty_task WHERE id=1;

-- POINT

CREATE TABLE locations (
    id integer PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    position POINT
);

INSERT INTO locations (position) VALUES (point(1.0, 2.0));
INSERT INTO locations (position) VALUES (point(3.0, 4.0));

SELECT area(box '(2,2),(0,0)');

-- INT 4 RANGE

SELECT int4range(10, 20);
SELECT int4range(10, 20) '* int4range(15, 25); '-- пересечение

-- JSON

CREATE TABLE example_table (
    id SERIAL PRIMARY KEY,
    json_column JSON
);

INSERT INTO example_table (json_column)
VALUES ('{"name": "John Smith", "age": 30, "address": {"city": "New York", "state": "NY"}}');


SELECT json_column->>'name' AS name, json_column->>'age' AS age, json_column->'address'->>'city' AS city
FROM example_table
WHERE json_column ->> 'name' = 'John Smith';

-- struct type

DROP TYPE IF EXISTS inventory_item;

CREATE TYPE inventory_item AS (
    name text,
    price int
);

CREATE TABLE on_hand (
    item inventory_item,
    count integer
);

INSERT INTO on_hand (item.name, item.price, count)
VALUES ('name',1,1);


-- SUPER TABLE

create table lab1.super_table (
    id SERIAL PRIMARY KEY,
    position POINT,
    json_column JSON,
    item inventory_item,
    ch1 int[][]
);


--

DROP TABLE IF EXISTS lab1.super_table CASCADE;

DROP TYPE IF EXISTS lab1.inventory_item;

CREATE TYPE lab1.inventory_item AS (
    name text,
    price int
    );

create table lab1.super_table (
  id SERIAL PRIMARY KEY,
  position POINT,
  json_column JSON,
  item lab1.inventory_item,
  ch1 int[][],
  ch2 int4range,
  ch3 int[]
);

insert into lab1.super_table (position, json_column, item.name, item.price, ch1, ch2, ch3)
values (point(1.0, 2.0), '{"name": "John Smith", "age": 30, "address": {"city": "New York", "state": "NY"}}', 'name',
        1, ARRAY[[1,2],[3,4]], '[10,20]', ARRAY[1,2]);

SELECT area(box '(2,2),(0,0)');

SELECT box '(2,2),(0,0)' @> point '(1,1)';

SELECT circle '((0,0),2)' @> point '(1,3)';

-- SELECT ch2 from lab1.super_table;
SELECT ch2 * int4range(15, 25) from lab1.super_table;

SELECT json_column->>'age' AS age
FROM lab1.super_table
where json_column #>> '{address, state}' = 'NY';

select item from lab1.super_table;
select (item).name, (item).price from lab1.super_table;

update lab1.super_table set item.price=(item).price * 2 where (item).price > 0;

-- select * from lab1.super_table;

update lab1.super_table SET ch3 = array_append(ch3, 10) where 1 = any (ch3);

-- CREATE TABLE lab1.perent (
-- 	id SERIAL PRIMARY KEY,
-- 	column1 int
-- );

-- CREATE TABLE lab1.child (
-- 	column2 text,
-- 	column3 text
-- ) INHERITS (lab1.perent);

-- CREATE TABLE lab1.perent (
-- 	id SERIAL PRIMARY KEY,
-- 	column1 int
-- );

-- CREATE TABLE lab1.child (
-- 	column2 text,
-- 	column3 text
-- ) INHERITS (lab1.perent);

-- insert into lab1.perent (id, column1) values(1,2);
-- insert into lab1.child (id, column1, column2, column3) values(1,2,'3','4');

select * from lab1.perent;
-- select * from only lab1.perent;-- CREATE TABLE lab1.perent (
-- 	id SERIAL PRIMARY KEY,
-- 	column1 int
-- );

-- CREATE TABLE lab1.child (
-- 	column2 text,
-- 	column3 text
-- ) INHERITS (lab1.perent);

-- insert into lab1.perent (id, column1) values(1,2);
-- insert into lab1.child (id, column1, column2, column3) values(1,2,'3','4');

select * from lab1.perent;
-- select * from only lab1.perent;

настройка внешного ключа

SET NULL
SET DEFAULT
RESTRICT
NO ACTION
CASCADE

ограничение наследования исключений

Дочерние таблицы автоматически наследуют от родительской таблицы ограничения-проверки и ограничения
NOT NULL (если только для них не задано явно NO INHERIT).
Все остальные ограничения (уникальности, первичный ключ и внешние ключи) не наследуются