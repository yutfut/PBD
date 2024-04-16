DROP SCHEMA IF EXISTS lab6 CASCADE;
CREATE SCHEMA lab6 AUTHORIZATION example;

DROP TABLE IF EXISTS lab6.user CASCADE;
CREATE TABLE lab6.user (
    id integer PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    username VARCHAR(256),
    password VARCHAR(256) NOT NULL,
    cold_start BOOL NOT NULL DEFAULT false,
    registration_date TIMESTAMP DEFAULT now() + interval '3 hours' NOT NULL
);
INSERT INTO lab6.user ( username, password, cold_start)
VALUES ('username1', 'password1', false),
       ('username2', 'password2', false),
       ('username3', 'password3', false),
       ('username4', 'password4', false),
       ('username5', 'password5', false);
INSERT INTO lab6.user (password, cold_start)
VALUES ('password1', false);

DROP TABLE IF EXISTS lab6.group CASCADE;
CREATE TABLE lab6.group (
                            id integer PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
                            group_name VARCHAR(256) NOT NULL,
                            owner_id integer NOT NULL,
                            foreign key (owner_id) references lab6.user (id)
);
INSERT INTO lab6.group (group_name, owner_id)
VALUES ('group_username1', 1),
       ('group_username2', 2),
       ('group_username3', 3),
       ('group_username4', 4),
       ('group_username5', 5);

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

select table_to_xml('lab6.user',true,true,'');

COPY (SELECT table_to_xml('lab6.task',true,true,'')) TO '/volumes/task.xml';

select query_to_xml('select * from lab6.user', true, true, 'k');

COPY (SELECT query_to_xml('select * from lab6.user', true, true, '')) TO '/volumes/task.xml';

SELECT xmlelement(name user, xmlattributes(username, password)) FROM lab6.user;

SELECT xmlelement(name users, xmlelement(name user, xmlattributes(username, password))) FROM lab6.user;
SELECT xmlelement(name user, xmlattributes(username, password)) FROM lab6.user;



SELECT xmlelement(name user, xmlattributes(username as name, password as pass)) FROM lab6.user;

SELECT xmlelement(name user, xmlelement(name user, username), xmlelement(name pass, password)) FROM lab6.user;

SELECT xmlforest(id, username, password, cold_start, registration_date) FROM lab6.user;

SELECT xmlroot(xmlelement(name user, xmlforest(id, username, password)), version '1.1', standalone yes) FROM lab6.user;

SELECT xmlelement(name root,xmlagg(xmlelement(name user, xmlforest(id, username, password)))) FROM lab6.user;

-- вложенная структура
select xmlelement(
    name mydbs, xmlagg(
        xmlelement(
            name owner, xmlattributes(
                username as title, registration_date
            ),
            xmlconcat(
                (
                    select xmlagg(
                        xmlelement(
                           name group, xmlattributes(
                               group_name as title
                           )
                        )
                    )
                    from lab6.group where "group".id = "user".id
                )
            )
        )
    )
) from lab6.user;

SELECT xmlparse(DOCUMENT pg_read_file('/volumes/example.xml'));

SELECT xpath_exists('//@ZONE=4', xmlparse(DOCUMENT pg_read_file('/volumes/example.xml')));

SELECT xpath_exists('//COMMON[@a=1]', xmlparse(DOCUMENT pg_read_file('/volumes/example.xml')));

SELECT unnest(xpath('//ZONE[..//COMMON[@a=3]]', xmlparse(DOCUMENT pg_read_file('/volumes/example.xml'))));

SELECT unnest(xpath('//COMMON[@b][@a=3]/@b', xmlparse(DOCUMENT pg_read_file('/volumes/example.xml'))));

SELECT unnest(xpath('//COMMON/text()', xmlparse(DOCUMENT pg_read_file('/volumes/example.xml'))));

SELECT unnest(xpath('count(//COMMON)', xmlparse(DOCUMENT pg_read_file('/volumes/example.xml'))));

SELECT unnest(xpath('count(//p)', xmlparse(DOCUMENT pg_read_file('/volumes/html.xml'))));
SELECT unnest(xpath('//p//img/@src', xmlparse(DOCUMENT pg_read_file('/volumes/html.xml'))));

select xmlroot(xmlelement(name root, table_to_xml_and_xmlschema('lab6.task', true, true, '/volumes/hello.xml')), version '1.1', standalone yes);
select query_to_xml_and_xmlschema(task, true, true, '/volumes/hello.xml') from lab6.task;

-- /html/body/div[1]/div[1]/div[2]/main/div/div/div/div[1]/div/div[4]/div/div[1]/article[2]/div[1]/h2/a/span

select unnest(xpath('//body//article//div[1]//h2//a//span[contains(text(), "ChatGPT")]', xmlparse(DOCUMENT pg_read_file('/volumes/habr.xml'))));
select unnest(xpath('//body//article//div[1]//h2//a//span[not (contains(text(), "Яндекс"))]', xmlparse(DOCUMENT pg_read_file('/volumes/habr.xml'))));
select unnest(xpath('//body//article//div[2]//button//span[2]/text()', xmlparse(DOCUMENT pg_read_file('/volumes/habr.xml'))));
select unnest(xpath('count(//body//article//div[2]//button//span[2][text()>10])', xmlparse(DOCUMENT pg_read_file('/volumes/habr.xml'))));
select unnest(xpath('//body//article//div[2]//button//span[2][text()>10]/text()', xmlparse(DOCUMENT pg_read_file('/volumes/habr.xml'))));
