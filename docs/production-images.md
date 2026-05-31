# Production-Ready Images From Lab 1

У другій лабораторній використано практики з першої лабораторної:

| Практика з Lab 1 | Де використано в Lab 2 |
| --- | --- |
| Multi-stage build | `frontend/Dockerfile`, `backend/Dockerfile` |
| Мінімальні base images | `node:22-bookworm-slim`, `nginx:1.27-alpine`, `postgres:16-alpine` |
| `.dockerignore` | `frontend/.dockerignore`, `backend/.dockerignore` |
| Healthcheck | `docker-compose.yml`, `frontend/Dockerfile`, `backend/Dockerfile` |
| Non-root runtime | `backend/Dockerfile` використовує `USER node` |
| Розділення runtime/build | frontend збирається в Node stage, а запускається в nginx stage |
| Security scan | images можна перевірити через Docker Scout або Trivy |

## Images

Після запуску stack можна переглянути створені images:

```powershell
docker image ls | findstr lab02
```

Або:

```powershell
docker compose images
```

## Vulnerability Scan

Docker Scout:

```powershell
docker scout cves lab02-microservices-frontend
docker scout cves lab02-microservices-backend
docker scout cves postgres:16-alpine
```

Trivy:

```powershell
trivy image --scanners vuln,secret --severity HIGH,CRITICAL lab02-microservices-frontend
trivy image --scanners vuln,secret --severity HIGH,CRITICAL lab02-microservices-backend
trivy image --scanners vuln,secret --severity HIGH,CRITICAL postgres:16-alpine
```

## Висновок

Lab 2 не починається з нуля: вона бере production-ready Docker image підхід з Lab 1 і застосовує його вже до кількох сервісів. Це важливо для фінального проєкту, бо кожен microservice має мати власний Dockerfile, `.dockerignore`, healthcheck і security scan.
