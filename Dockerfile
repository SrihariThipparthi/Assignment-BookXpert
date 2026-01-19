FROM python:3.10-slim

ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

WORKDIR /app

RUN apt-get update && apt-get install -y \
    git \
    build-essential \
    curl \
    && rm -rf /var/lib/apt/lists/*

COPY requirements.txt .

RUN pip install --upgrade pip && \
    pip install --no-cache-dir -r requirements.txt

COPY backend ./backend
COPY frontend ./frontend
COPY config.py ./
COPY services ./services
COPY models ./models

EXPOSE 8000
EXPOSE 8501


CMD uvicorn backend.api_handler:app --host 0.0.0.0 --port 8000 & \
    streamlit run frontend/app.py --server.port=8501 --server.address=0.0.0.0
