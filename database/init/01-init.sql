CREATE TABLE IF NOT EXISTS tasks (
  id SERIAL PRIMARY KEY,
  title TEXT NOT NULL,
  completed BOOLEAN NOT NULL DEFAULT FALSE,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

INSERT INTO tasks (title, completed)
VALUES
  ('Split monolith into services', TRUE),
  ('Run the stack with Docker Compose', FALSE)
ON CONFLICT DO NOTHING;

