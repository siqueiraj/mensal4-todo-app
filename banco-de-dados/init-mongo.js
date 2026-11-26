db = db.getSiblingDB('todo-app');

db.createUser({
  user: "todo_user",
  pwd: process.env.MONGO_APP_PASSWORD,
  roles: [
    { role: "readWrite", db: "todo-app" }
  ]
});

db.createCollection('todos');

db.todos.insertMany([
  { text: "Laércio é um excelente professor", completed: false },
  { text: "Estudar Cloud", completed: true },
  { text: "Fazer exercícios da UA", completed: false },
]);
