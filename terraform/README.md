# Terraform – Infraestructura Azure (DevSecOps)

Módulos para aprovisionar:

- **Azure Key Vault** – secreto de prueba
- **Azure Container Registry (ACR)**
- **Container App Environment**
- **Container App** – API Python + init container
- **Container App Job** – job de mantenimiento (cron cada 2 min)

Se usa un **resource group existente** (`rg-devsecops-test` por defecto).  
El **estado de Terraform** se guarda en **Azure Storage** (backend remoto).

## Backend remoto (Azure Storage)

El state se guarda en un blob dentro de una cuenta de almacenamiento en Azure. **Una sola vez** hay que crear esa cuenta y el contenedor (si no existen).

### 1. Crear Storage Account y contenedor (una vez)

Nombre de la cuenta en `providers.tf`: **`sttfstatedevsecops`**. Debe ser **único a nivel global**; si ya existe en Azure, elige otro (3–24 caracteres alfanuméricos) y actualiza `storage_account_name` en `providers.tf`.

```bash
# Variables (ajusta RESOURCE_GROUP y LOCATION si usas otros)
RESOURCE_GROUP="rg-devsecops-test"
LOCATION="East US"
STORAGE_ACCOUNT="sttfstatedevsecops"
CONTAINER="tfstate"

# Crear cuenta de almacenamiento
az storage account create \
  --resource-group "$RESOURCE_GROUP" \
  --name "$STORAGE_ACCOUNT" \
  --location "$LOCATION" \
  --sku Standard_LRS \
  --allow-blob-public-access false

# Crear contenedor para el state
az storage container create \
  --name "$CONTAINER" \
  --account-name "$STORAGE_ACCOUNT" \
  --auth-mode login
```

### 2. Permisos para el state

El usuario o Service Principal que ejecute Terraform debe poder leer/escribir blobs en esa cuenta (por ejemplo **Contributor** en el resource group o **Storage Blob Data Contributor** en la cuenta de almacenamiento). Si ya tienes Contributor en `rg-devsecops-test`, suele ser suficiente.

### 3. Inicializar Terraform con el backend

```bash
cd terraform
terraform init
```

Si antes tenías state local, Terraform preguntará si quieres **migrar** el state al backend remoto; contesta **yes** para no perder el estado.

---

## Requisitos

- [Terraform](https://www.terraform.io/downloads) >= 1.0
- [Azure CLI](https://docs.microsoft.com/cli/azure/install-azure-cli) y sesión iniciada  
  **Si no tienes Azure CLI o no sabes cómo autenticarte (equivalente al “perfil” de AWS):**  
  → Ver **[docs/azure-local-setup.md](../docs/azure-local-setup.md)** (instalación en macOS, `az login` vs variables de entorno).
- Resource group `rg-devsecops-test` ya creado en Azure
- Tu usuario o app registration con permisos sobre ese resource group (y para crear Key Vault, ACR, Container Apps, etc.)

## Probar desde el terminal local

### 1. Login en Azure

```bash
az login
az account set --subscription "TU_SUBSCRIPTION_ID"   # opcional si solo tienes una
```

### 2. Variables (opcional)

Copia el ejemplo y edita si necesitas cambiar algo:

```bash
cd terraform
cp terraform.tfvars.example terraform.tfvars
# Editar terraform.tfvars si quieres (resource_group_name, location, etc.)
```

Si no creas `terraform.tfvars`, se usan los valores por defecto de `variables.tf` (p. ej. `resource_group_name = "rg-devsecops-test"`).

### 3. Inicializar Terraform

```bash
terraform init
```

### 4. Revisar el plan

```bash
terraform plan
```

Revisa que se vayan a crear Key Vault, ACR, Container App Environment, Container App (API + init) y Container App Job en el resource group indicado.

### 5. Aplicar

```bash
terraform apply
```

Confirma con `yes` cuando lo pida. La primera vez puede tardar varios minutos.

### 6. Outputs

Al final verás, entre otros:

- `acr_login_server` – para hacer `docker login` y push de imágenes
- `api_url` – URL pública de la API (con imagen placeholder hasta que subas la tuya)
- `key_vault_name` – nombre del Key Vault
- `job_name` – nombre del job (cron cada 2 minutos)

### 7. Subir tus imágenes y actualizar la API/Job

Cuando tengas el ACR creado:

```bash
# Login al ACR (usa el acr_login_server del output)
az acr login --name NOMBRE_ACR

# Build y push (desde la raíz del repo)
docker build -f Dockerfile.api -t NOMBRE_ACR.azurecr.io/api:latest .
docker push NOMBRE_ACR.azurecr.io/api:latest

docker build -f init-container/Dockerfile -t NOMBRE_ACR.azurecr.io/init:latest ./init-container
docker push NOMBRE_ACR.azurecr.io/init:latest

docker build -f job/Dockerfile -t NOMBRE_ACR.azurecr.io/job:latest ./job
docker push NOMBRE_ACR.azurecr.io/job:latest
```

Luego actualiza las variables y vuelve a aplicar, por ejemplo en `terraform.tfvars`:

```hcl
container_app_api_image  = "NOMBRE_ACR.azurecr.io/api:latest"
container_app_init_image = "NOMBRE_ACR.azurecr.io/init:latest"
container_app_job_image  = "NOMBRE_ACR.azurecr.io/job:latest"
```

```bash
terraform apply
```

### 8. Destruir (opcional)

Para borrar todos los recursos creados por Terraform:

```bash
terraform destroy
```

## Estructura de módulos

```
terraform/
├── main.tf              # Data sources + llamadas a módulos
├── variables.tf          # Variables globales
├── outputs.tf            # Outputs globales
├── providers.tf          # Azure, backend azurerm (state en Azure Storage)
├── modules/
│   ├── keyvault/         # Key Vault + secreto de prueba
│   ├── acr/              # Azure Container Registry
│   ├── aca-environment/ # Container App Environment (+ Log Analytics si hace falta)
│   ├── aca/              # Container App (API + init container)
│   └── aca-job/          # Container App Job (trigger cron)
├── terraform.tfvars.example
└── README.md
```

## Key Vault – acceso

El Key Vault tiene una access policy para el **object_id** del principal con el que ejecutas Terraform (`az login` o service principal). Si el CD usa una app registration distinta, tendrás que darle a esa identidad permisos sobre el Key Vault (p. ej. otra `access_policy` o Azure RBAC).
