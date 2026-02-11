# App 2: Job de mantenimiento (limpieza / tareas periódicas)
# Se programa cada 2 minutos desde Azure Container Apps Jobs (trigger cron).
FROM python:3.11-alpine

WORKDIR /app

COPY run.py .

CMD ["python", "run.py"]
