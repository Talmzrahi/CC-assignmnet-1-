FROM python:3.12.14-slim

RUN useradd --create-home --uid 6210 user6210 \
 && mkdir -p /data \
 && chown user6210:user6210 /data

ENV GREETING="Hello from the container" \
    DATA_DIR=/data \
    PORT=8000 \
    PYTHONUNBUFFERED=1

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY app.py .

USER user6210

VOLUME /data

EXPOSE 8000

CMD ["python", "app.py"]
