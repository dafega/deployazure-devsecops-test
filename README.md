# deployazure-devsecops-test

Proyecto de prueba para un flujo de despliegue en Azure (Terraform) con dos aplicaciones Python y init container.

## Estructura de aplicaciones

| Componente | Descripción | Dockerfile |
|------------|-------------|------------|
| **App 1 – API** | CRUD HTTP de inventario de bicicletas (Flask). Endpoints: `GET/POST /api/bicycles`, `GET/PUT/DELETE /api/bicycles/<id>`, `GET /api/secret` (MY_SECRET), `GET /api/bicycles/health`. | `Dockerfile.api` |
| **App 2 – Job** | Job que imprime "Job ejecutado con éxito" y termina (simula proceso de limpieza). La ejecución cada 2 minutos se configura en Azure Container Apps Jobs (trigger cron). | `job/Dockerfile` |
| **Init container** | Imagen Alpine ligera que ejecuta `echo Iniciando...` para preparar el entorno antes del contenedor principal. | `init-container/Dockerfile` |

## Build de imágenes (para Azure Container Apps)

```bash
# App 1 – API (desde la raíz del repo)
docker build -f Dockerfile.api -t bicycles-api .

# App 2 – Job
docker build -t maintenance-job ./job

# Init container
docker build -t init-container ./init-container
```

## Ejecución local con Docker Compose (recomendado)

Desde la raíz del proyecto:

```bash
# Levantar init container + API (el init se ejecuta primero y termina; luego arranca la API)
docker compose up --build

# La API queda en http://localhost:5001 (5001 para no chocar con AirPlay en macOS)
# Opcional: pasar MY_SECRET
MY_SECRET=mi-secreto docker compose up --build
```

Ejecutar el job de mantenimiento (una vez):

```bash
docker compose run --rm job
```

Ejecutar tests (pytest) en Docker:

```bash
docker compose run --rm test
```

Con reporte de cobertura:

```bash
docker compose run --rm test pytest tests/ -v --cov=app --cov-report=term-missing
```

Solo construir sin levantar:

```bash
docker compose build
```

## Ejecución local con Docker (sin Compose)

```bash
# API (puerto 5001 en host para evitar conflicto con AirPlay en macOS)
docker run -p 5001:5000 -e MY_SECRET=mi-secreto bicycles-api

# Job (una ejecución)
docker run maintenance-job

# Init container (solo muestra "Iniciando...")
docker run init-container
```

La API expone:
- `GET /api/bicycles` – listar bicicletas
- `POST /api/bicycles` – crear (JSON: propietario, marca, tamano, color)
- `GET/PUT/DELETE /api/bicycles/<id>`
- `GET /api/secret` – valor de la variable de entorno `MY_SECRET`
- `GET /api/bicycles/health` – health check

**Nota (macOS):** Si usas Docker Compose o `docker run` con el mapeo anterior, la API se expone en **http://localhost:5001** porque el puerto 5000 suele estar ocupado por AirPlay Receiver.
