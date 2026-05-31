# From LAMP Monolith To Microservices

## Before

The legacy LAMP application keeps everything in one unit:

```text
Apache + PHP templates + PHP business logic + SQL queries + MySQL
```

Problems:

- frontend and backend cannot be deployed independently;
- database access is mixed into page rendering;
- scaling UI and API separately is hard;
- testing and CI/CD are less flexible;
- one runtime contains too many responsibilities.

## After

The application is split into independent services:

```text
Frontend (React/nginx)
↓
Backend API (Node.js)
↓
Database (PostgreSQL)
```

Benefits:

- frontend can be rebuilt and deployed separately;
- backend API owns business logic and validation;
- database is isolated as a stateful service;
- Docker Compose can run the full stack locally;
- the same structure can later be moved to Kubernetes and Helm.

## Mapping

| Monolith part | Microservice replacement |
| --- | --- |
| PHP templates | React frontend |
| Apache static serving | nginx frontend container |
| PHP business logic | Node.js Backend API |
| Inline SQL queries | API database layer |
| MySQL in same stack | PostgreSQL service |
| One deployment unit | Separate Docker images and Compose services |

