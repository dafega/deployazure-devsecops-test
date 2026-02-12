# deployazure-devsecops-test

Proyecto de prueba para despliegue en **Azure** con Terraform e integración DevSecOps (CI/CD, escaneo de seguridad).

Incluye una **API REST** (Flask) de inventario de bicicletas que expone CRUD, health check; un **job** de mantenimiento programado; y un **init container** que se ejecuta antes de la API. Todo se despliega en **Azure Container Apps**.

Las instrucciones y convenciones del proyecto (prompt para IA, estándares de código, rol DevSecOps) están definidas en **`.cursor/rules/`** (Cursor IDE).

---

## Ejecución en local

### Con Docker Compose (recomendado)

Desde la raíz del proyecto:

```bash
docker compose up --build
```

La API queda en **http://localhost:5001**. Opcional: `MY_SECRET=mi-secreto docker compose up --build`.

Ejecutar el job una vez:

```bash
docker compose run --rm job
```

Tests (pytest):

```bash
docker compose run --rm test
```

Con cobertura:

```bash
docker compose run --rm test pytest tests/ -v --cov=app --cov-report=term-missing
```

### Sin Compose

```bash
# API
docker build -f Dockerfile.api -t bicycles-api .
docker run -p 5001:5000 -e MY_SECRET=mi-secreto bicycles-api

# Job
docker build -t maintenance-job ./job
docker run maintenance-job
```

---

## Pipelines (GitHub Actions)

| Workflow | Cuándo se ejecuta | Qué hace |
|----------|-------------------|----------|
| **CI** | Push a `Feature/*` y PR a `main`/`dev` | tfsec (Terraform), flake8, pip-audit, pytest, build de imágenes, Trivy (vulnerabilidades en imágenes) |
| **IaC** | Manual (`workflow_dispatch`) | Terraform init, plan y apply en Azure (stag/prod). Requiere secrets de Service Principal (ARM_*). |
| **CD** | Manual (`workflow_dispatch`) | Login a Azure y ACR, build y push de imágenes (api, init, job), Terraform apply con las nuevas imágenes. Requiere secrets ARM_* y variable ACR_NAME (p. ej. por environment). |

### Cómo usar los pipelines

- **CI:** Se ejecuta solo al hacer push o abrir PR en las ramas indicadas. No requiere configuración extra si el repo ya tiene los workflows.
- **IaC:** En GitHub → **Actions** → **IaC Pipeline** → **Run workflow**. Elige entorno (`stag` o `prod`) y opción de destroy si aplica. Debe existir un *environment* en el repo con los secrets: `ARM_CLIENT_ID_*`, `ARM_CLIENT_SECRET_*`, `ARM_TENANT_ID_*`, `ARM_SUBSCRIPTION_ID_*`.
- **CD:** En GitHub → **Actions** → **CD Pipeline** → **Run workflow**. Elige entorno. Además de los secrets ARM_*, el environment debe tener la variable `ACR_NAME_*` (nombre del ACR, ej. `acrdevsecopsstag`). El pipeline construye las imágenes, las sube al ACR y actualiza la Container App con Terraform.

Detalle de la infra (Terraform, backend remoto, variables) está en **terraform/README.md**.
