DROP SCHEMA IF EXISTS lab7 CASCADE;
CREATE SCHEMA lab7 AUTHORIZATION example;

DROP TABLE IF EXISTS lab7.task CASCADE;
create table lab7.task
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
INSERT INTO lab7.task (name, description, public_tests, private_tests, generated_tests, difficulty, cf_contest_id, cf_index, cf_points, cf_rating, cf_tags, time_limit, memory_limit_bytes, link, short_link, name_ru, task_ru, input, output, note, master_solution, checker, checkers)
VALUES ('name1', 'Codehorses has just hosted the second Codehorses Cup. This year, the same as the previous one, organizers are giving T-shirts for the winners.', ARRAY['public_tests1', 'public_tests2'], ARRAY['private_tests1', 'private_tests2'], ARRAY['generated_tests1', 'generated_tests2'], 1, 1, 'A1B', 1, 1, ARRAY[1, 2], 1, 1, 'link', 'short_link', 'name_ru', 'task_ru', 'input', 'output', 'note', 'master_solution', 'checker', ARRAY['checker1', 'checker2']),
       ('name1', 'In the intergalactic empire Bubbledom there are N planets, of which some pairs are directly connected by two-way wormholes. There are N-1 wormholes. The wormholes are of extreme religious importance in Bubbledom, a set of planets in Bubbledom consider themselves one intergalactic kingdom if and only if any two planets in the set can reach each other by traversing the wormholes. You are given that Bubbledom is one kingdom. In other words, the network of planets and wormholes is a tree.', ARRAY['public_tests1', 'public_tests2'], ARRAY['private_tests1', 'private_tests2'], ARRAY['generated_tests1', 'generated_tests2'], 1, 1, 'A1B', 1, 1, ARRAY[1, 2], 1, 1, 'link', 'short_link', 'name_ru', 'task_ru', 'input', 'output', 'note', 'master_solution', 'checker', ARRAY['checker1', 'checker2']),
       ('name1', 'Ivan unexpectedly saw a present from one of his previous birthdays. It is array of n numbers from 1 to 200. Array is old and some numbers are hard to read. Ivan remembers that for all elements at least one of its neighbours ls not less than it, more formally:', ARRAY['public_tests1', 'public_tests2'], ARRAY['private_tests1', 'private_tests2'], ARRAY['generated_tests1', 'generated_tests2'], 1, 1, 'A1B', 1, 1, ARRAY[1, 2], 1, 1, 'link', 'short_link', 'name_ru', 'task_ru', 'input', 'output', 'note', 'master_solution', 'checker', ARRAY['checker1', 'checker2']),
       ('name1', 'One fine day Sasha went to the park for a walk. In the park, he saw that his favorite bench is occupied, and he had to sit down on the neighboring one. He sat down and began to listen to the silence. Suddenly, he got a question: what if in different parts of the park, the silence sounds in different ways? So it was. Let''s divide the park into 1 × 1 meter squares and call them cells, and numerate rows from 1 to n from up to down, and columns from 1 to m from left to right. And now, every cell can be described with a pair of two integers (x, y), where x — the number of the row, and y — the number of the column. Sasha knows that the level of silence in the cell (i, j) equals to f_{i,j}, and all f_{i,j} form a permutation of numbers from 1 to n ⋅ m. Sasha decided to count, how many are there pleasant segments of silence?', ARRAY['public_tests1', 'public_tests2'], ARRAY['private_tests1', 'private_tests2'], ARRAY['generated_tests1', 'generated_tests2'], 1, 1, 'A1B', 1, 1, ARRAY[1, 2], 1, 1, 'link', 'short_link', 'name_ru', 'task_ru', 'input', 'output', 'note', 'master_solution', 'checker', ARRAY['checker1', 'checker2']),
       ('name1', 'You are given a tree (a connected undirected graph without cycles) of n vertices. Each of the n - 1 edges of the tree is colored in either black or red.
                  You are also given an integer k. Consider sequences of k vertices. Let''s call a sequence [a_1, a_2, …, a_k] good if it satisfies the following criterion:', ARRAY['public_tests1', 'public_tests2'], ARRAY['private_tests1', 'private_tests2'], ARRAY['generated_tests1', 'generated_tests2'], 1, 1, 'A1B', 1, 1, ARRAY[1, 2], 1, 1, 'link', 'short_link', 'name_ru', 'task_ru', 'input', 'output', 'note', 'master_solution', 'checker', ARRAY['checker1', 'checker2']);

SELECT to_tsvector('english', 'Codehorses has empire');

SELECT 'has just hosted the second Codehorses Cup'::tsvector;

SELECT to_tsquery('the & intergalactic & park');

SELECT to_tsquery('park & intergalactic & ! cat');

-- CREATE TEXT SEARCH DICTIONARY lab7.my_dict (
--
--     stopwords = '/volumes'
-- )

-- SELECT ts_lexize('lab7.my_dict', 'HELLO')

