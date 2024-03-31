// Создание узла со свойствами
create (u:user{
  id: 1,
  username: 'username',
  password: 'password',
  cold_start: false
})

// Изменение свойства узла
MATCH (u)
  WHERE u.id=1
  SET u.cold_start=true
  RETURN u

// Удаление свойства узла
MATCH (u)
  WHERE u.id=1
  REMOVE u.username
  RETURN u

// Изменение метки
MATCH 
  (u:user{id:1}) 
  REMOVE u:user 
  SET u: admin 
  RETURN u

// Удаление метки
MATCH 
  (u:admin{id:1}) 
  REMOVE u: admin 
  RETURN u

// Создание нескольких пользователей
create (u:user{
  id: 1,
  username: '1username',
  password: 'password1',
  cold_start: false
})

create (u:user{
  id: 2,
  username: '2username',
  password: 'password2',
  cold_start: false
})

create (u:user{
  id: 3,
  username: '3username',
  password: 'password3',
  cold_start: false
})

// Создание задач
create (t:task{
  id: 1,
  title: 'task'
})

create (t:task:math{
  id: 2,
  title: 'task math'
})

create (t:task:game{
  id: 2,
  title: 'task game'
})

// Создание связи между существующими узлами
MATCH (u:user{id:1}), (t:task{id:1}) MERGE (u)-[s:Solution{solved: true}]->(t)
MATCH (u:user{id:1}), (t:task:math{id:2}) MERGE (u)-[s:Solution{solved: false}]->(t)
MATCH (u:user{id:2}), (t:task:math{id:2}) MERGE (u)-[s:Solution{solved: true}]->(t)
MATCH (u:user{id:2}), (t:task:game{id:3}) MERGE (u)-[s:Solution{solved: true}]->(t)

MATCH (u:user{id:1}), (t:task{id:1}) MERGE (u)-[l:Like{like: true}]->(t)
MATCH (u:user{id:3}), (t:task{id:1}) MERGE (u)-[l:Like{like: true}]->(t)
MATCH (u:user{id:3}), (t:task:math{id:2}) MERGE (u)-[l:Like{like: true}]->(t)
MATCH (u:user{id:3}), (t:task:game{id:3}) MERGE (u)-[l:Like{like: true}]->(t)


// MATCH/WHERE/RETURN
MATCH (u:user) WHERE u.id=1 AND u.cold_start=false RETURN u
MATCH (u:user) WHERE u.id=1 OR u.id=2 RETURN u

MATCH (u:user) WHERE u.cold_start IS NOT NULL RETURN u

MATCH (u:user) RETURN u.username, u.password ORDER BY u.username DESC

MATCH (u:user)-->(t:task) RETURN u, t
MATCH (u:user)-->(t:task:math) RETURN u, t

MATCH (u:user)-[s:Solution]->(t:task) WHERE s.solved=false RETURN u, t

// Создание отношения между новыми узлами
CREATE (u:user{
  id: 4,
  username: '4username',
  password: 'password4',
  cold_start: false}
)-[s:Solution{solved: false}]->
(t:task:hash{
  id: 4,
  title: 'task hash'
}) RETURN u, t

// Удаление всех узлов и связей
MATCH (n) DETACH DELETE n

// Удаление одного узла и всех его связей
MATCH (u:user{id:1}) DETACH DELETE u

// Удаление только связей
MATCH (u:user{id: 1})-[s:Solution]->()
DELETE r

MATCH (u:user)-[r]->(t:task) 
WHERE u.id=1 AND t.id=1 
DELETE r

// MERGE
MERGE (u:user{username:'5username',password:'password5'})
MERGE (u:user{username:'1username',password:'password1'}) 

//UNION
MATCH (u:user) WHERE u.id=1 RETURN u
UNION
MATCH (u:user) WHERE u.id=2 RETURN u

MATCH (u:user{id:1}) RETURN u
UNION
MATCH (u:user{id:2}) RETURN u

//LIMIT
MATCH (u:user) WHERE u.cold_start=false RETURN u LIMIT 2

//SKIP
MATCH (u:user) WHERE u.cold_start=false RETURN u SKIP 2

//DISTINCT
MATCH (u:user) RETURN DISTINCT u.cold_start

// Агрегирование
MATCH (u:user) RETURN count(u.id)

// Строковые функции
MATCH (u:user) RETURN toUpper(u.username)

// Индексы
CREATE INDEX user_cold_start_index FOR (u:user) ON (u.cold_start)

// Ограничение уникальности свойства
CREATE CONSTRAINT username_unique FOR (u:user) REQUIRE u.usernmae IS UNIQUE

// SELECT
MATCH (u:user)-[r]->(t:task) RETURN u, t
MATCH (u:user), (t:task) RETURN u, t

// Удаление узла
MATCH (u:user) WHERE u.id=1 DELETE u

// Вернуть все узлы БД
MATCH (n) RETURN n

// Вернуть все узды БД с определенной меткой
MATCH (u:user) RETURN u

// Создать узел с несколькими лейблами
CREATE (node:label1:label2{
  id: 1
})

// Вернуть узлы с несколькими лейблами
MATCH (node:label1:label2) RETURN node

// Удалить уазлы с несколькими лейблами
MATCH (node:label1:label2) DELETE node

