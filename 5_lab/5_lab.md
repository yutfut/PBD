# 5_lab

### 1. В чем особенности графовых СУБД?

Графовая база данных — это такая база данных, которая использует графовые структуры для построения семантических запросов с узлов, ребер и свойств в процессе представления и хранения данных.

### 2. Модель данных графовой СУБД на примере Neo4j?



### 3. Что такое узел, отношение, метки и свойства?

Узлы (nodes) – используются для представления сущностей, но в зависимости от отношений в графе могут быть использованы для представления связи.

Узлы (nodes) – используются для представления сущностей, но в зависимости от отношений в графе могут быть использованы для представления связи.

Свойства (prosperties) – именованные значения, где имя – это строка. Поддерживаемые значения: числовые, строковые, двоичные, списки предыдущих типов.

Метки (labels) – предоставляют собой графы, которые были сгруппированы в наборы. Все узлы, помеченные одной меткой, принадлежит к одному набору.

### 4. Как в Neo4j создавать узлы и их связи? Как задавать свойства и метки?

```SQL
create (u:user{
  id: 1,
  username: 'username',
  password: 'password',
  cold_start: false
})
```

```SQL
MATCH (u:user{id:1}), (t:task{id:1}) 
MERGE (u)-[s:Solution{solved: true}]->(t)
```

### 5. Функциональные возможности и языки запросов для СУБД Neo4j?



### 6. Типы данных, поддерживаемые СУБД Neo4j?

* Число, абстрактный тип, содержит подтипы Integer и Float;
* Строковый тип данных – String;
* Логический тип данных – Boolean, принимает значения true и false;
* Пространственный тип — Point (точка);
* Временные типы: Date, Time, LocalTime, DateTime, LocalDateTime и Duration;
* Структурные типы: узлы, отношения, пути (последовательность узлов и отношений);
* Составные типы: Lists (коллекции, каждый элемент которых имеет какой-то определенный тип) и Maps (коллекции вида (key: value), где key имеет тип String, а value любого типа).

### 7. Как организована идентификация узлов?

\<id>

### 8. Базовая конструкция запросов на выборку данных? Как в запросе указать условие на свойства, метки и шабон отношений?



### 9. Основные CRUD команды и конструкции запросов языка CQL?

> CREATE

> MATCH RETURN

> MATCH WHERE SET

> MATCH DELETE


### 10. Команды CREATE, MERGE. В чем их отличие?

MERGE создает объект если его не существует

### 11. Технология репликации и фрагментации в СУБД Neo4j?

При масштабировании баз данных NoSQL широко используется фрагментация, в ходе которой данные разделяются и распределяются по разным серверам. В графовых базах данных фрагментацию сделать трудно, поскольку они ориентированы не на агрегаты, а на отношения. Поскольку любой узел может быть связан отношением с любым другим узлом, хранение связанных узлов на одном и том же сервере позволяет повысить эффективность обхода графа. Обход графа, узлы которого разбросаны по разным компьютерам, имеет низкую эффективность.

1. увеличи кол-во ОЗУ
2. Репликация Master-Slave


### 12. Поддержка транзакций в СУБД Neo4j?

База Neo4J поддерживает транзакции ACID. Прежде чем изменить какой-нибудь узел или добавить какое-то отношение к существующим узлам, необходимо начать транзакцию.

```SQL
Transaction transaction = database.beginTx();
try {
    Node node = database.createNode();
node.setProperty("name", "NoSQL Distilled");
node.setProperty("published", "2012");
transaction.success();
} finally {
transaction.finish();
}
```