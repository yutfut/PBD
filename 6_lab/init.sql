DROP SCHEMA IF EXISTS lab6 CASCADE;
CREATE SCHEMA lab6 AUTHORIZATION example;

DROP TABLE IF EXISTS lab6.user CASCADE;
CREATE TABLE lab6.user (
    id integer PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    username VARCHAR(256) NOT NULL,
    password VARCHAR(256) NOT NULL,
    cold_start BOOL NOT NULL DEFAULT false,
    registration_date TIMESTAMP DEFAULT now() + interval '3 hours' NOT NULL
);
INSERT INTO lab6.user ( username, password, cold_start)
VALUES ('username1', 'password1', false),
       ('username2', 'password2', false),
       ('username3', 'password3', false),
       ('username4', 'password4', false),
       ('username4', 'password4', false);

DROP TABLE IF EXISTS lab6.task CASCADE;
create table lab6.task
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
INSERT INTO lab6.task (name, description, public_tests, private_tests, generated_tests, difficulty, cf_contest_id, cf_index, cf_points, cf_rating, cf_tags, time_limit, memory_limit_bytes, link, short_link, name_ru, task_ru, input, output, note, master_solution, checker, checkers)
VALUES ('name1', 'description', ARRAY['public_tests1', 'public_tests2'], ARRAY['private_tests1', 'private_tests2'], ARRAY['generated_tests1', 'generated_tests2'], 1, 1, 'A1B', 1, 1, ARRAY[1, 2], 1, 1, 'link', 'short_link', 'name_ru', 'task_ru', 'input', 'output', 'note', 'master_solution', 'checker', ARRAY['checker1', 'checker2']),
       ('name1', 'description', ARRAY['public_tests1', 'public_tests2'], ARRAY['private_tests1', 'private_tests2'], ARRAY['generated_tests1', 'generated_tests2'], 1, 1, 'A1B', 1, 1, ARRAY[1, 2], 1, 1, 'link', 'short_link', 'name_ru', 'task_ru', 'input', 'output', 'note', 'master_solution', 'checker', ARRAY['checker1', 'checker2']),
       ('name1', 'description', ARRAY['public_tests1', 'public_tests2'], ARRAY['private_tests1', 'private_tests2'], ARRAY['generated_tests1', 'generated_tests2'], 1, 1, 'A1B', 1, 1, ARRAY[1, 2], 1, 1, 'link', 'short_link', 'name_ru', 'task_ru', 'input', 'output', 'note', 'master_solution', 'checker', ARRAY['checker1', 'checker2']),
       ('name1', 'description', ARRAY['public_tests1', 'public_tests2'], ARRAY['private_tests1', 'private_tests2'], ARRAY['generated_tests1', 'generated_tests2'], 1, 1, 'A1B', 1, 1, ARRAY[1, 2], 1, 1, 'link', 'short_link', 'name_ru', 'task_ru', 'input', 'output', 'note', 'master_solution', 'checker', ARRAY['checker1', 'checker2']),
       ('name1', 'description', ARRAY['public_tests1', 'public_tests2'], ARRAY['private_tests1', 'private_tests2'], ARRAY['generated_tests1', 'generated_tests2'], 1, 1, 'A1B', 1, 1, ARRAY[1, 2], 1, 1, 'link', 'short_link', 'name_ru', 'task_ru', 'input', 'output', 'note', 'master_solution', 'checker', ARRAY['checker1', 'checker2']);

COPY lab6.task TO '/volumes/task.xml';

select table_to_xml('lab6.task',true,true,'');

COPY (SELECT table_to_xml('lab6.task',true,true,'')) TO '/volumes/task.xml';

select query_to_xml('select * from lab6.user', true, true, 'k');

COPY (SELECT query_to_xml('select * from lab6.user', true, true, '')) TO '/volumes/task.xml';

SELECT xmlelement(name user, xmlattributes(username, password)) FROM lab6.user;

SELECT xmlelement(name user, xmlattributes(username as name, password as pass)) FROM lab6.user;

SELECT xmlelement(name user, xmlelement(name user, username), xmlelement(name pass, password)) FROM lab6.user;

SELECT xmlforest(id, username, password, cold_start, registration_date) FROM lab6.user;

SELECT xmlroot(xmlelement(name user, xmlforest(id, username, password)), version '1.1', standalone yes) FROM lab6.user;

SELECT xmlelement(name root,xmlagg(xmlelement(name user, xmlforest(id, username, password)))) FROM lab6.user;

-- вложенная структура
copy (
select xmlelement(name mydbs, xmlagg(xmlelement(name MyOrg,
xmlattributes(username as title,password, registration_date),
xmlconcat( (select xmlagg(xmlelement(name person,
xmlattributes(username,password), registration_date ))
from lab6.user where id <> 0)) ) )) from lab6.user
) to '/volumes/task.xml';

SELECT xmlparse(DOCUMENT pg_read_file('/volumes/task.xml'));

SELECT xpath_exists('//@ZONE=4', xmlparse(DOCUMENT pg_read_file('/volumes/example.xml')));

SELECT unnest(xpath('//ZONE', xmlparse(DOCUMENT pg_read_file('/volumes/example.xml'))));

SELECT unnest(xpath('//COMMON/text()', xmlparse(DOCUMENT pg_read_file('/volumes/example.xml'))));

SELECT unnest(xpath('count(//COMMON)', xmlparse(DOCUMENT pg_read_file('/volumes/example.xml'))));