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
            "username": "username",
            "password": "password",
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
db.users.find().pretty();
db.users.find({coldstart: {$eq : true}});

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
            $all: [
                1, 2, 3
            ]
        }
    }
);

db.users.find(
    {
        tags: {
            $elemMatch: {
                "first": "first",
                "second": "second",
            }
        }
    }
);

db.users.find(
    {
        tags: {
            $size: 1
        }
    }
);

db.users.find(
    {
        tasks: {
            $in: [
                1, 2
            ]
        }
    }
);

db.users.find(
    {
        tasks: {
            $nin: [
                4
            ]
        }
    }
);

db.users.find(
    {
        tasks: {
            $elemMatch: [
                1, 2
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
            $exists: false
        }
    }
);

db.users.find(
    {coldstart: true},
    {username: 1}
);

