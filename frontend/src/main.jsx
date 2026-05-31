import React, { useEffect, useMemo, useState } from "react";
import { createRoot } from "react-dom/client";
import "./styles.css";

function App() {
  const [status, setStatus] = useState(null);
  const [tasks, setTasks] = useState([]);
  const [title, setTitle] = useState("");
  const [error, setError] = useState("");
  const completedCount = useMemo(
    () => tasks.filter((task) => task.completed).length,
    [tasks]
  );

  async function loadData() {
    setError("");
    try {
      const [statusResponse, tasksResponse] = await Promise.all([
        fetch("/api/status"),
        fetch("/api/tasks")
      ]);

      if (!statusResponse.ok || !tasksResponse.ok) {
        throw new Error("API request failed");
      }

      setStatus(await statusResponse.json());
      setTasks(await tasksResponse.json());
    } catch (requestError) {
      setError("Backend API is unavailable. Check docker compose ps and logs.");
    }
  }

  async function addTask(event) {
    event.preventDefault();
    if (title.trim().length < 3) {
      setError("Task title must contain at least 3 characters.");
      return;
    }

    await fetch("/api/tasks", {
      method: "POST",
      headers: { "content-type": "application/json" },
      body: JSON.stringify({ title })
    });

    setTitle("");
    await loadData();
  }

  async function toggleTask(task) {
    await fetch(`/api/tasks/${task.id}`, {
      method: "PATCH",
      headers: { "content-type": "application/json" },
      body: JSON.stringify({ completed: !task.completed })
    });
    await loadData();
  }

  useEffect(() => {
    loadData();
  }, []);

  return (
    <main className="app-shell">
      <section className="top-bar">
        <div>
          <p className="eyebrow">Lab 02</p>
          <h1>Microservices Tasks App</h1>
        </div>
        <button className="refresh-button" onClick={loadData}>
          Refresh
        </button>
      </section>

      <section className="architecture-strip" aria-label="Architecture">
        <article>
          <span>Frontend</span>
          <strong>React + nginx</strong>
        </article>
        <article>
          <span>Backend API</span>
          <strong>Node.js</strong>
        </article>
        <article>
          <span>Database</span>
          <strong>PostgreSQL</strong>
        </article>
      </section>

      <section className="status-grid">
        <article>
          <span>API service</span>
          <strong>{status?.service || "loading"}</strong>
        </article>
        <article>
          <span>Database</span>
          <strong>{status?.database || "loading"}</strong>
        </article>
        <article>
          <span>Tasks</span>
          <strong>
            {completedCount}/{tasks.length} done
          </strong>
        </article>
      </section>

      {error && <p className="error-message">{error}</p>}

      <section className="task-panel">
        <form onSubmit={addTask}>
          <input
            value={title}
            onChange={(event) => setTitle(event.target.value)}
            placeholder="Add a task"
          />
          <button type="submit">Add</button>
        </form>

        <ul>
          {tasks.map((task) => (
            <li key={task.id}>
              <label>
                <input
                  type="checkbox"
                  checked={task.completed}
                  onChange={() => toggleTask(task)}
                />
                <span className={task.completed ? "done" : ""}>{task.title}</span>
              </label>
            </li>
          ))}
        </ul>
      </section>
    </main>
  );
}

createRoot(document.getElementById("root")).render(<App />);

