# Лабораторна робота 2: Побудова мікросервісної архітектури

## Ціль

Перейти від LAMP-style моноліту до локального microservices stack:

- frontend;
- backend API;
- database;
- docker-compose для локальної розробки.

## Що має вийти

Після виконання має працювати стек:

```text
Browser
↓
Frontend (React/nginx) on localhost:8080
↓
Backend API (Node.js) on localhost:3000
↓
Database (PostgreSQL)
```

## Крок 1. Перейти в папку лабораторної

```powershell
cd "C:\Users\andri\Documents\Codex\2026-05-30\production-ready-images-multi-stage-build\outputs\lab-02-microservices"
```

Перевір структуру:

```powershell
dir
```

Скріншот 1: структура проєкту.

## Крок 2. Запустити стек

```powershell
docker compose up --build -d
```

Скріншот 2: успішний build і запуск services.

## Крок 3. Перевірити статус контейнерів

```powershell
docker compose ps
```

Очікування: `frontend`, `backend`, `database` мають бути `running` або `healthy`.

Скріншот 3: статус контейнерів.

## Крок 4. Відкрити frontend

Відкрий у браузері:

```text
http://localhost:8080
```

Скріншот 4: React frontend у браузері.

## Крок 5. Перевірити backend health

```powershell
curl.exe http://localhost:3000/health
```

Очікуваний результат:

```json
{"status":"ok","service":"backend-api","database":"connected"}
```

Скріншот 5: backend health.

## Крок 6. Перевірити frontend-to-backend proxy

```powershell
curl.exe http://localhost:8080/api/status
```

Скріншот 6: API status через frontend nginx proxy.

## Крок 7. Перевірити database

```powershell
docker compose exec database psql -U app -d tasksdb -c "SELECT id, title, completed FROM tasks ORDER BY id;"
```

Скріншот 7: дані в PostgreSQL.

## Крок 8. Подивитися logs

```powershell
docker compose logs backend
```

Скріншот 8: backend logs.

## Крок 9. Показати зв'язок з Lab 1

У цій лабораторній використано практики з першої лабораторної: optimized Dockerfiles, `.dockerignore`, healthchecks і scan images.

Перевір images:

```powershell
docker compose images
```

Опційно проскануй images через Docker Scout:

```powershell
docker scout cves lab02-microservices-frontend
docker scout cves lab02-microservices-backend
```

Скріншот 9: images або scan результат.

## Крок 10. Зупинити стек

```powershell
docker compose down
```

Якщо треба повністю очистити database volume:

```powershell
docker compose down -v
```

## Список скріншотів для звіту

Збережи скріншоти в папку `screenshots`:

```text
01-project-structure.png
02-compose-up.png
03-compose-ps.png
04-frontend-browser.png
05-backend-health.png
06-api-status-proxy.png
07-database-query.png
08-backend-logs.png
09-compose-images-or-scan.png
```
