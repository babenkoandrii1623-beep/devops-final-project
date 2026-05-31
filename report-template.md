# Звіт з лабораторної роботи 2

## Тема

Побудова мікросервісної архітектури: перехід від LAMP-моноліту до Docker Compose stack.

## Мета

Навчитися розбивати монолітний застосунок на окремі сервіси: frontend, backend API та database. Запустити локально працюючий стек мікросервісів за допомогою Docker Compose.

## Архітектура

```text
Browser
↓
Frontend (React/nginx)
↓
Backend API (Node.js)
↓
Database (PostgreSQL)
```

## Структура проєкту

```text
lab-02-microservices/
├── frontend/
├── backend/
├── database/
├── legacy-monolith/
├── docs/
├── k8s/
├── helm/
├── terraform/
├── .github/workflows/
└── docker-compose.yml
```

## Хід роботи

### 1. Перевірка структури проєкту

Команда:

```powershell
dir
```

Скріншот: `01-project-structure.png`.

### 2. Запуск Docker Compose stack

Команда:

```powershell
docker compose up --build -d
```

Скріншот: `02-compose-up.png`.

### 3. Перевірка контейнерів

Команда:

```powershell
docker compose ps
```

Скріншот: `03-compose-ps.png`.

### 4. Перевірка frontend

URL:

```text
http://localhost:8080
```

Скріншот: `04-frontend-browser.png`.

### 5. Перевірка backend API

Команда:

```powershell
curl.exe http://localhost:3000/health
```

Скріншот: `05-backend-health.png`.

### 6. Перевірка nginx proxy до API

Команда:

```powershell
curl.exe http://localhost:8080/api/status
```

Скріншот: `06-api-status-proxy.png`.

### 7. Перевірка database

Команда:

```powershell
docker compose exec database psql -U app -d tasksdb -c "SELECT id, title, completed FROM tasks ORDER BY id;"
```

Скріншот: `07-database-query.png`.

### 8. Перевірка logs

Команда:

```powershell
docker compose logs backend
```

Скріншот: `08-backend-logs.png`.

### 9. Використання практик з лабораторної 1

У цій роботі використано підхід production-ready Docker images з першої лабораторної.

Команда:

```powershell
docker compose images
```

Опційно:

```powershell
docker scout cves lab02-microservices-frontend
docker scout cves lab02-microservices-backend
```

Скріншот: `09-compose-images-or-scan.png`.

Практики з Lab 1, які використані в Lab 2:

- multi-stage Dockerfile для frontend;
- optimized Dockerfile для backend;
- `.dockerignore` для frontend і backend;
- healthchecks для services;
- non-root user у backend image;
- можливість vulnerability scanning через Docker Scout або Trivy.

## Пояснення переходу від моноліту

| Було в LAMP-моноліті | Стало в microservices |
| --- | --- |
| PHP templates | React frontend |
| Apache serving | nginx container |
| PHP business logic | Node.js API |
| Inline SQL queries | Backend database layer |
| MySQL у спільному stack | PostgreSQL service |
| Один deployment | Окремі Docker services |

## Висновок

У лабораторній роботі було створено локальний microservices stack з трьох сервісів: frontend, backend API та database. Frontend працює через nginx, backend реалізовано на Node.js, а дані зберігаються в PostgreSQL. Docker Compose дозволяє запускати весь стек однією командою і перевіряти взаємодію між сервісами локально.
