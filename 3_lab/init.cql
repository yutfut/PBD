-- cqlsh

CREATE KEYSPACE IF NOT EXISTS lab3 WITH REPLICATION = { 'class' : 'SimpleStrategy', 'replication_factor' : 1};

USE lab3;

DROP TABLE IF EXISTS lab3.user;
CREATE TABLE IF NOT EXISTS lab3.user (
    id uuid,
    username text,
    password text,
    cold_start boolean,
    PRIMARY KEY (id)
);

INSERT INTO lab3.user (id, username, password, cold_start) VALUES (now(), 'username1', 'password1', false);
INSERT INTO lab3.user (id, username, password, cold_start) VALUES (now(), 'username2', 'password2', false);
INSERT INTO lab3.user (id, username, password, cold_start) VALUES (now(), 'username3', 'password3', false);
INSERT INTO lab3.user (id, username, password, cold_start) VALUES (now(), 'username4', 'password4', false) USING TTL 60;
-- UPDATE lab3.user SET username='1', password='1', cold_start=false WHERE id=now();
-- INSERT INTO user (id, username, password, cold_start) VALUES (137fd010-d1c5-11ee-9c2a-27a45ff9c0f1, '2', '2', true);
-- delete from lab3.user where id=137fd010-d1c5-11ee-9c2a-27a45ff9c0f1;

UPDATE lab3.user SET username='name_user' WHERE username='username1';
-- UPDATE lab3.user  USING TTL 15 SET username='name_user' WHERE id=;

SELECT * FROM lab3.user;

-- UPDATE user SET cold_start=true WHERE id=;
-- SELECT * FROM user;

-- DELETE FROM user WHERE id = ;
-- SELECT * FROM user;

DROP TABLE IF EXISTS lab3.tasks;
CREATE TABLE IF NOT EXISTS lab3.tasks (
    id timeuuid,
    cf_rating int,
    cf_points float,
    PRIMARY KEY (cf_rating, id)
-- id класстерный ключ              // группировка данных внутри узла
-- cf_rating распределительный ключ // распределение данных по узлам
) WITH default_time_to_live = 120 and CLUSTERING ORDER BY (id DESC);

ALTER TABLE lab3.tasks DROP cf_points;
ALTER TABLE lab3.tasks ADD cf_points float;
ALTER TABLE lab3.tasks ALTER cf_points TYPE double; -- нельзя удалть с версии 3.10
ALTER TABLE lab3.tasks RENAME cf_points TO cf_points_1;

INSERT INTO lab3.tasks (id, cf_rating, cf_points) VALUES (now(), 1, 0.1);
INSERT INTO lab3.tasks (id, cf_rating, cf_points) VALUES (now(), 2, 0.2);
INSERT INTO lab3.tasks (id, cf_rating, cf_points) VALUES (now(), 3, 0.3);

SELECT * FROM lab3.tasks;

TRUNCATE lab3.tasks; -- удаление всех кортежей

--

SELECT * FROM lab3.user WHERE username='username1';
SELECT * FROM lab3.user WHERE username='username1' ALLOW FILTERING;

CREATE INDEX username_index ON lab3.user (username); -- создание индекса
DROP INDEX username_index; -- удаление индекса

SELECT * FROM lab3.user WHERE username='username1';

-- агрегатные функции

SELECT COUNT(*) FROM lab3.user;
SELECT MAX(id) FROM lab3.user;

-- сортировка

INSERT INTO lab3.tasks (id, cf_rating, cf_points) VALUES (now(), 1, 0.1);
INSERT INTO lab3.tasks (id, cf_rating, cf_points) VALUES (now(), 2, 0.2);
INSERT INTO lab3.tasks (id, cf_rating, cf_points) VALUES (now(), 3, 0.3);
INSERT INTO lab3.tasks (id, cf_rating, cf_points) VALUES (now(), 1, 0.4);
INSERT INTO lab3.tasks (id, cf_rating, cf_points) VALUES (now(), 2, 0.5);
INSERT INTO lab3.tasks (id, cf_rating, cf_points) VALUES (now(), 3, 0.6);

select * from lab3.tasks where cf_rating=1 order by id desc;    -- по убыванию
select * from lab3.tasks where cf_rating=1 order by id asc;     -- по возрастанию

-- групировка

select cf_rating, AVG(cf_points) from lab3.tasks group by cf_rating;

-- матеиализированное представление

-- materialized_views_enabled: true

create materialized view view_tasks_by_cf_rating as
select id, cf_rating, cf_points from lab3.tasks
where cf_rating is not null and id is not null
PRIMARY KEY (cf_rating, id);

select * from view_tasks_by_cf_rating;

-- batch

begin batch
    insert into lab3.tasks (id, cf_rating, cf_points)
    values (now(), 100, 100.01);
apply batch;

select * from lab3.tasks;

-- update if

INSERT INTO lab3.tasks (id, cf_rating, cf_points) VALUES (now(), 1, 0.1);
INSERT INTO lab3.tasks (id, cf_rating) VALUES (now(), 2);

select * from lab3.tasks;

-- update lab3.tasks
-- set cf_points = 0.1
-- where id = 1e691e40-d31a-11ee-a5f7-b37f26eb9b91 and cf_rating = 2
-- if cf_points = null;

-- delete if

-- delete from lab3.tasks
-- where id = 1e691e40-d31a-11ee-a5f7-b37f26eb9b91 and cf_rating = 2
-- if cf_points = 0.1;

