FROM python:3.9-slim
WORKDIR /app
RUN apt-get update && apt-get install -y curl vim && rm -rf /var/lib/apt/lists/*
COPY requirements.txt /app/
RUN pip install --no-cache-dir -r requirements.txt
COPY app.py /app/
RUN useradd -u 1000 -m appuser
USER appuserdocker run -d -p 5001:5000 --name flask-container my-flask-app
EXPOSE 5000
ENV FLASK_ENV=production
CMD ["python", "app.py"]