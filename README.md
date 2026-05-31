# Lab 02: From Monolith To Microservices

This lab shows how to split a simple LAMP-style monolith into a local microservices stack:

- `frontend`: React application served by nginx.
- `backend`: Node.js API.
- `database`: PostgreSQL.

The stack is started with Docker Compose and is designed as the first step toward the final project structure:

```text
Internet
↓
Ingress (TLS)
↓
Frontend (React/nginx)
↓
Backend API (Node.js)
↓
Database (PostgreSQL)
```

## Quick Start

```powershell
docker compose up --build -d
docker compose ps
```

Open:

```text
http://localhost:8080
```

Check API:

```powershell
curl.exe http://localhost:3000/health
curl.exe http://localhost:8080/api/status
```

Stop:

```powershell
docker compose down
```

Reset database:

```powershell
docker compose down -v
```

