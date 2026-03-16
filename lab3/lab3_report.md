University: [ITMO University](https://itmo.ru/ru/)

Faculty: [FICT](https://fict.itmo.ru)

Course: [Введение в веб технологии](https://itmo-ict-faculty.github.io/introduction-in-web-tech/)

Year: 2025/2026

Group:  U4125

Author: Vlasov Igor Alekseevich

Lab: Lab3

Date of create: 16.03.2026

Date of finished:


## Цель работы

Научиться настраивать локальную систему мониторинга, собирать метрики с помощью Prometheus и создавать дашборды в Grafana для визуализации данных.

# Ход работы

## Подготовка конфигурации Prometheus


В файле была задана конфигурация для сбора метрик с самого Prometheus и с сервиса **Node Exporter**, который собирает системные метрики (CPU, память, диск и другие).

Пример конфигурационного файла:

```yaml
global:
  scrape_interval: 15s

scrape_configs:
  - job_name: 'prometheus'
    static_configs:
      - targets: ['localhost:9090']

  - job_name: 'node-exporter'
    static_configs:
      - targets: ['node-exporter:9100']
```

Параметр scrape_interval определяет интервал сбора метрик (15 секунд).

Для сбора системных метрик был запущен контейнер Node Exporter.

```
docker run -d \
  --name node-exporter \
  --network monitoring \
  --restart=unless-stopped \
  -p 9100:9100 \
  -v "/proc:/host/proc:ro" \
  -v "/sys:/host/sys:ro" \
  -v "/:/rootfs:ro" \
  prom/node-exporter \
  --path.procfs=/host/proc \
  --path.rootfs=/rootfs \
  --path.sysfs=/host/sys \
  --collector.filesystem.mount-points-exclude="^/(sys|proc|dev|host|etc)($$|/)"
```

Проверка: curl http://localhost:9100/metrics

## Запуск Prometheus

Для хранения данных Prometheus был создан том: docker volume create prometheus-data

Был запущен контейнер:

```
docker run -d \
  --name prometheus \
  --network monitoring \
  --restart=unless-stopped \
  -p 9090:9090 \
  -v prometheus-data:/prometheus \
  -v $(pwd)/prometheus:/etc/prometheus \
  prom/prometheus \
  --config.file=/etc/prometheus/prometheus.yml \
  --storage.tsdb.path=/prometheus \
  --storage.tsdb.retention.time=200h \
  --web.enable-lifecycle
```

Проверка: http://localhost:9090


## Grafana
Для хранения данных Grafana был создан отдельный том: docker volume create grafana-data

Проверка: http://localhost:3000

##  Дашборды

После настройки системы были произведены работы в Grafana, а именно:
- Добавление нового источника Prometheus
- Создание графиков CPU, Memeory, Disk
- Создание дашборда с этими графикми.

Результаты проделанной работы можно провалидировать в скриншотах в текущей папке