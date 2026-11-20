FROM docker.io/library/python:3.11-slim

ENV PYTHONUNBUFFERED=1
ENV PYTHONDONTWRITEBYTECODE=1
ENV LOG_LEVEL=WARNING

WORKDIR /app

# Copy and install Python dependencies only
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy only backend Python files (frontend excluded via .dockerignore)
COPY *.py .
COPY gunicorn_conf.py gunicorn_worker.py .

EXPOSE 4042

CMD ["gunicorn", "-k", "gunicorn_worker.ProductionUvicornWorker", "-c", "gunicorn_conf.py", "main:app", "--timeout", "7200", "--keep-alive", "300"]
