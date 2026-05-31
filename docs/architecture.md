# Architecture

## Target Local Architecture

```mermaid
flowchart TD
    User["Browser / User"]
    Frontend["Frontend service<br/>React static build<br/>nginx"]
    Backend["Backend API service<br/>Node.js / Express"]
    Database["Database service<br/>PostgreSQL"]

    User -->|"http://localhost:8080"| Frontend
    Frontend -->|"nginx proxy /api"| Backend
    Backend -->|"SQL over Docker network"| Database
```

## Final Project Direction

```mermaid
flowchart TD
    Internet["Internet"]
    Ingress["Ingress (TLS)"]
    Frontend["Frontend (React/nginx)"]
    Backend["Backend API (Node.js)"]
    Database["Database (PostgreSQL)"]

    Internet --> Ingress
    Ingress --> Frontend
    Frontend --> Backend
    Backend --> Database
```

## Service Responsibilities

| Service | Responsibility |
| --- | --- |
| Frontend | UI, static assets, browser experience, reverse proxy to `/api` |
| Backend API | Business logic, validation, REST endpoints, database access |
| Database | Persistent storage for tasks |

