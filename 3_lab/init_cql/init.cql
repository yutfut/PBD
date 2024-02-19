CREATE KEYSPACE IF NOT EXISTS lab3 WITH REPLICATION = { 'class' : 'SimpleStrategy', 'replication_factor' : 1};

CREATE TABLE IF NOT EXISTS user (
    id uuid,
    username text,
    password text,
    cold_start boolean,
    PRIMARY KEY (id)
);

-- INSERT INTO user (id, username, password, cold_start) VALUES (now(), '', '', false);
INSERT INTO user (id, username, password, cold_start) VALUES (now(), 'username1', 'password1', false);
INSERT INTO user (id, username, password, cold_start) VALUES (now(), 'username2', 'password2', false);
INSERT INTO user (id, username, password, cold_start) VALUES (now(), 'username3', 'password3', false);
INSERT INTO user (id, username, password, cold_start) VALUES (now(), 'username4', 'password4', false) USING TTL 60;

SELECT * FROM user;

-- UPDATE user SET cold_start=true WHERE id=;
-- SELECT * FROM user;

-- DELETE FROM user WHERE id = ;
-- SELECT * FROM user;

CREATE TABLE IF NOT EXISTS tasks (
    id timeuuid,
    cf_rating int,
    cf_points float,
    PRIMARY KEY (cf_rating, id)
) WITH default_time_to_live = 120 and CLUSTERING ORDER BY (id DESC);

ALTER TABLE tasks ALTER id TYPE uuid;

INSERT INTO tasks (id, cf_rating, cf_points) VALUES (now(), 1, 0.1);
INSERT INTO tasks (id, cf_rating, cf_points) VALUES (now(), 2, 0.2);
INSERT INTO tasks (id, cf_rating, cf_points) VALUES (now(), 3, 0.3);

SELECT * FROM tasks;

-- TRUNCATE tasks; -- удаление таблицы

CREATE INDEX cf_pointsIndex ON tasks (cf_points); -- создание индекса
DROP INDEX cf_pointsIndex; -- удаление индекса

-- SELECT * FROM user WHERE username='username1' ALLOW FILTERING;

SELECT count(*) FROM user WHERE cold_start = false ALLOW FILTERING;

SELECT * FROM tasks ORDER BY cf_rating;
SELECT * FROM tasks ORDER BY cf_rating, cf_points;

