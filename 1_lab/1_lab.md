# 1_lab

### 1. Как создать таблицы, их связи и ограничения используя мастера и DDL-запросы?

> create table table_name(column datatype);

> В PostgreSQL поддерживаются следующие типы ограничений: на уникальность, на допустимость значения NULL, первичный ключ, внешний ключ, ограничения общего вида.

### 2. Что такое ограничения целостности, каких типов они бывают и как их задавать?

> Для таблиц внутри иерархии наследования, могут быть заданы ограничения целостности check. Все ограничения check для родительской таблицы автоматически наследуются всеми её потомками.

### 3. Как определять и использовать в запросах массивы? Перечислите основные функции для работы с массивами.

> int[] массив\
> int[][] двумерный массив\
> insert into table (int[], int[][]) value ({1, 2}, {{1, 2}, {3, 4}})

### 4. Как создавать и использовать составные типы? Как обратиться к полю составного типа и его элементам из запроса?

> CREATE TYPE inventory_item AS (\
> name text,\
> supplier_id integer,\
> price numeric\
> );

> CREATE TABLE on_hand (\
> item inventory_item,\
> count integer\
> );

> select item.name from on_hand;

### 5. Как создавать и использовать перечислимые типы? Какие ограничения для них использования?

> CREATE TYPE mood AS ENUM ('sad', 'ok', 'happy');

> В метках значений регистр имеет значение, т. е. 'happy' и 'HAPPY' — не одно и
то же. Также в метках имеют значение пробелы.

> Удалять существующие значения из перечисления, а также изменять их порядок,
нельзя — для получения нужного результата придётся удалить и заново создать это
перечисление.

### 6. Что такое наследование таблиц? Как создать и обратиться из запроса к базовым и производным таблицам?

> CREATE TABLE base (\
> column1 datatype,\
> column2 datatype,\
> column3 datatype,\
> ....\
> );

> CREATE TABLE child (\
> column1 datatype,\
> column2 datatype,\
> column3 datatype,\
> ....\
> )INHERITS base;

### 7. Что такое пользовательский тип данных? Как определить его поля? Какие функции нужны при создании пользовательского типа и как их определить?

> create type type_name;

> CREATE OR REPLACE FUNCTION marks_in ( s cstring )\
> RETURNS marks AS\
> 'marks_in', 'marks_in'\
> LANGUAGE C IMMUTABLE STRICT;\

> CREATE OR REPLACE FUNCTION marks_out ( v marks )\
> RETURNS cstring AS\
> 'marks_out', 'marks_out'\
> LANGUAGE C IMMUTABLE STRICT;

> create type type_name (\
> internallength = 24,\
> input = marks_in,\
> output = marks_out\
> );
