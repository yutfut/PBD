use lab4;

db;

show dbs;

db.movie.insertOne({name:"Hello World!"});
db.movie.drop();
db.dropDatabase();

db.createCollection(users);
db.users.insertOne(
    {
        username: "username",
        password: "password",
        coldstart: true
    }
);

db.users.insertMany(
    [
        {
            "username": "username1",
            "password": "password1",
            "coldstart": true
        },
        {
            "username": "username2",
            "password": "password2",
            "coldstart": false
        },
        {
            "username": "username3",
            "password": "password3",
            "coldstart": true,
            "tasks": [
                1,2,3
            ]
        },
        {
            username: "username4",
            password: "password4",
            coldstart: true,
            tasks: [
                1,2,4
            ],
            tags: [
                {
                    first: "first",
                    second: "second"
                }
            ]
        }
    ]
);

db.users.find();
db.users.findOne();
db.users.find().pretty();

// операторы сравнения

db.users.find({coldstart: {$eq : true}});   // eq - равенство
db.users.find({coldstart: {$ne : true}});   // ne - неравенство

// логические операторы

db.users.find(
    {
        $and: [
            {username: "username"},
            {password: "password"}
        ]
    }
);

db.users.find(
    {
        $or: [
            {username: "username"},
            {password: "password1"}
        ]
    }
);

// операторы для работы с массивами

db.users.find(
    {
        tasks: {
            $all: [     // all - полное совавдение массива
                1, 2, 3
            ]
        }
    }
);

db.users.find(
    {
        tags: {
            $elemMatch: {   // elemMatch - частичное совпадение елементов, достаточно одного
                "first": "first",
//                "second": "second",
            }
        }
    }
);

db.users.find(
    {
        tags: {
            $size: 1    // size - совпадение по кол-ву элементов массива
        }
    }
);

db.users.find(
    {
        tasks: {
            $in: [      // in - нахождение элементов в массиве
                1, 2
            ]
        }
    }
);

db.users.find(
    {
        tasks: {
            $nin: [     // nin - не нахождение элемента в массиве
                4
            ]
        }
    }
);

// условие на наличия поля

db.users.find(
    {
        tags: {
            $exists: true
        }
    }
);

db.users.find(
    {
        tags: {
            $exists: false  // exists - проверка наличия поля в кортеже
        }
    }
);

// проекция вывода

db.users.find(
    {coldstart: true},
//    {username: 1}
    {_id:0, username: 1, password: 1}
);

// условия на поля вложенных структур

db.createCollection(tasks);
db.tasks.insertOne(
    {
        name: "name",
        description: "description",
        public_tests:[
            {
                input: "input",
                output: "output"
            },
            {
                input: "input1",
                output: "output1"
            }
        ],
        html: {
            name_ru: "name_ru",
            task_ru: "task_ru",
            input: "input",
            output: "output",
            note: "note",
        }
    }
);

db.tasks.find(
    {"html.name_ru": "name_ru"}
);

// изменение документов коллекции

db.tasks.updateOne(
    {name: "name"},
    {
        $set: {
            description: "descriptionn"
        }
    }
);
db.tasks.find();

db.tasks.updateOne(
    {name: "name1"},
    {
        $set: {
            description: "descriptionn"
        }
    },
    {
        $upsert: true
    }
);

// удаление поля

db.tasks.updateOne(
    {description: "descriptionn"},
    {
        $unset: {
            description: ""
        }
    }
)

// изменение элемента массива

db.tasks.updateOne(
    {name: "name"},
    {
        $set: {
            "public_tests.1": {
                input: "input1"
            }
        }
    }
);

db.tasks.find(
    {"public_tests.1.input": "input1"}
);

//

db.tasks.find();

db.tasks.updateMany(
    {
        name: {
            $exists: true
        }
    },
    {
        $set: {
            cf: {
                cf_contest_id: 1,
                cf_index: "12a",
                cf_points: 0.1,
                cf_rating: 1000,
                cf_tags: [
                    1, 2, 3
                ],
            }
        }
    }
);

// удаление окументов коллекции

db.tasks.deleteOne();
db.tasks.deleteMany(
    {name: "name"}
);
db.tasks.find();

// сортировка

db.tasks.insertMany(
    [
        {
            name: "name1",
            description: "description1",
            public_tests:[
                {
                    input: "input",
                    output: "output"
                },
                {
                    input: "input1",
                    output: "output1"
                }
            ],
            html: {
                name_ru: "name_ru",
                task_ru: "task_ru",
                input: "input",
                output: "output",
                note: "note",
            },
            cf: {
                    cf_contest_id: 1,
                    cf_index: "12a",
                    cf_points: 0.1,
                    cf_rating: 1000,
                    cf_tags: [
                        1, 2, 3
                    ],
                }
        },
        {
            name: "name2",
            description: "description1",
            public_tests:[
                {
                    input: "input",
                    output: "output"
                },
                {
                    input: "input1",
                    output: "output1"
                }
            ],
            html: {
                name_ru: "name_ru",
                task_ru: "task_ru",
                input: "input",
                output: "output",
                note: "note",
            },
            cf: {
                    cf_contest_id: 1,
                    cf_index: "12a",
                    cf_points: 0.2,
                    cf_rating: 2000,
                    cf_tags: [
                        1, 2, 3
                    ],
                }
        },
        {
            name: "name3",
            description: "description1",
            public_tests:[
                {
                    input: "input",
                    output: "output"
                },
                {
                    input: "input1",
                    output: "output1"
                }
            ],
            html: {
                name_ru: "name_ru",
                task_ru: "task_ru",
                input: "input",
                output: "output",
                note: "note",
            },
            cf: {
                    cf_contest_id: 1,
                    cf_index: "12a",
                    cf_points: 0.3,
                    cf_rating: 1500,
                    cf_tags: [
                        1, 2, 3
                    ],
                }
        }
    ]
);

db.tasks.find().sort(
    {
        "cf.cf_points": -1
    }
);

// кол-во документов

db.tasks.count();

db.tasks.count(
    {
        "cf.cf_points": {
            $lt: 0.2
        }
    }
);

// skip

db.tasks.count(
    {},
    {
        skip: 3
    }
);

// уникальные кортежи

db.tasks.distinct("name");

// ограничение limit

db.tasks.find().limit(3);

// Добавление в коллекцию связаннх объектов

db.users.find();
[
  {"_id": {"$oid": "65e30a5ac2605e41b46e2f4b"}},
  {"_id": {"$oid": "65e30a69c2605e41b46e2f4e"}},
  {"_id": {"$oid": "65e30a73c2605e41b46e2f50"}},
  {"_id": {"$oid": "65e30a73c2605e41b46e2f51"}},
  {"_id": {"$oid": "65e30a73c2605e41b46e2f52"}},
  {"_id": {"$oid": "65e30a73c2605e41b46e2f53"}}
]
db.tasks.find();
[
  {"_id": {"$oid": "65e32509fd4117263153c0c0"}},
  {"_id": {"$oid": "65e32509fd4117263153c0c1"}},
  {"_id": {"$oid": "65e32509fd4117263153c0c2"}},
  {"_id": {"$oid": "65e3256efd4117263153c0c4"}},
  {"_id": {"$oid": "65e3256efd4117263153c0c5"}},
  {"_id": {"$oid": "65e3256efd4117263153c0c6"}}
]

db.likes.insertOne();

db.likes.insertMany(
    [
        {
            "user_id": {
                $ref:   users,
                $id:    "65e30a5ac2605e41b46e2f4b"
            },
            "task_id": {
                $ref:   tasks,
                $id:    "65e32509fd4117263153c0c0"
            }
        }
    ]
);

// комбинация этапов при группировке

db.tasks.aggregate(
    [
        {
            $match: {
                name: {
                    $exists: true
                }
            }
        },
        {
            $group: {
                _id: "$name"
//                _id: ["$name", "$cf.cf_points"]
//                total: {
//                    $avg: "$cf.cf_points"
//                }
            }
        }
    ]
);

// индексы

db.tasks.find();

db.tasks.createIndex({name: 1}, {unique: true});

// управление индексами

db.tasks.getIndexes();          // получение индекса
db.tasks.dropIndex("name_1");   // удаление индекса

db.tasks.find().explain();

