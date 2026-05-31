const express = require("express");
const { Pool } = require("pg");

const port = Number(process.env.PORT || 3000);
const databaseUrl =
  process.env.DATABASE_URL || "postgres://app:app_password@database:5432/tasksdb";

const pool = new Pool({
  connectionString: databaseUrl,
  max: 10
});

const app = express();

app.use(express.json());

async function bootstrapDatabase() {
  await pool.query(`
    CREATE TABLE IF NOT EXISTS tasks (
      id SERIAL PRIMARY KEY,
      title TEXT NOT NULL,
      completed BOOLEAN NOT NULL DEFAULT FALSE,
      created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
    );
  `);

  const result = await pool.query("SELECT COUNT(*)::int AS count FROM tasks");
  if (result.rows[0].count === 0) {
    await pool.query(
      "INSERT INTO tasks (title, completed) VALUES ($1, $2), ($3, $4)",
      [
        "Split monolith into services",
        true,
        "Run the stack with Docker Compose",
        false
      ]
    );
  }
}

app.get("/health", async (_req, res) => {
  try {
    await pool.query("SELECT 1");
    res.json({
      status: "ok",
      service: "backend-api",
      database: "connected"
    });
  } catch (error) {
    res.status(503).json({
      status: "error",
      service: "backend-api",
      database: "unavailable"
    });
  }
});

app.get("/api/status", async (_req, res, next) => {
  try {
    const result = await pool.query("SELECT COUNT(*)::int AS count FROM tasks");
    res.json({
      service: "backend-api",
      database: "postgresql",
      tasks: result.rows[0].count,
      timestamp: new Date().toISOString()
    });
  } catch (error) {
    next(error);
  }
});

app.get("/api/load", (req, res) => {
  const requestedMs = Number(req.query.ms || 250);
  const durationMs = Math.max(
    50,
    Math.min(Number.isFinite(requestedMs) ? requestedMs : 250, 2000)
  );
  const startedAt = Date.now();
  let iterations = 0;

  while (Date.now() - startedAt < durationMs) {
    Math.sqrt(iterations * Date.now());
    iterations += 1;
  }

  res.json({
    status: "ok",
    service: "backend-api",
    loadMs: durationMs,
    iterations
  });
});

app.get("/api/tasks", async (_req, res, next) => {
  try {
    const result = await pool.query(
      "SELECT id, title, completed, created_at FROM tasks ORDER BY id ASC"
    );
    res.json(result.rows);
  } catch (error) {
    next(error);
  }
});

app.post("/api/tasks", async (req, res, next) => {
  try {
    const title = String(req.body.title || "").trim();
    if (title.length < 3) {
      res.status(400).json({ error: "Task title must contain at least 3 characters." });
      return;
    }

    const result = await pool.query(
      "INSERT INTO tasks (title) VALUES ($1) RETURNING id, title, completed, created_at",
      [title]
    );
    res.status(201).json(result.rows[0]);
  } catch (error) {
    next(error);
  }
});

app.patch("/api/tasks/:id", async (req, res, next) => {
  try {
    const id = Number(req.params.id);
    const completed = Boolean(req.body.completed);

    const result = await pool.query(
      "UPDATE tasks SET completed = $1 WHERE id = $2 RETURNING id, title, completed, created_at",
      [completed, id]
    );

    if (result.rowCount === 0) {
      res.status(404).json({ error: "Task not found." });
      return;
    }

    res.json(result.rows[0]);
  } catch (error) {
    next(error);
  }
});

app.delete("/api/tasks/:id", async (req, res, next) => {
  try {
    const id = Number(req.params.id);
    await pool.query("DELETE FROM tasks WHERE id = $1", [id]);
    res.status(204).send();
  } catch (error) {
    next(error);
  }
});

app.use((error, _req, res, _next) => {
  console.error(error);
  res.status(500).json({ error: "Internal server error." });
});

async function start() {
  await bootstrapDatabase();
  app.listen(port, "0.0.0.0", () => {
    console.log(`backend-api is listening on port ${port}`);
  });
}

start().catch((error) => {
  console.error("Failed to start backend-api", error);
  process.exit(1);
});

process.on("SIGTERM", async () => {
  await pool.end();
  process.exit(0);
});
