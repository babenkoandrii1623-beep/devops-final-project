<?php
// Educational example only: a LAMP-style monolith mixes HTML, API logic,
// database access, and application behavior in one deployable unit.

$pdo = new PDO('mysql:host=mysql;dbname=tasks;charset=utf8mb4', 'app', 'app_password');
$tasks = $pdo->query('SELECT id, title, completed FROM tasks ORDER BY id')->fetchAll();
?>
<!doctype html>
<html>
  <head>
    <title>Legacy Tasks Monolith</title>
  </head>
  <body>
    <h1>Legacy Tasks Monolith</h1>
    <ul>
      <?php foreach ($tasks as $task): ?>
        <li><?= htmlspecialchars($task['title']) ?></li>
      <?php endforeach; ?>
    </ul>
  </body>
</html>

