// Создание узла со свойствами
create (users: user{
  id: 1,
  username: 'username',
  password: 'password',
  cold_start: false
})

// Изменение свойства узла
MATCH (users)
  WHERE users.id=1
  SET users.cold_start=false
  RETURN users

// Удаление свойства узла
MATCH (users)
  WHERE users.id=1
  REMOVE users.username
  RETURN users

