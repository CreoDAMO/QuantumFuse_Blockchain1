# Prometheus
FROM prom/prometheus

COPY prometheus.yml /etc/prometheus/prometheus.yml

# Grafana
FROM grafana/grafana

COPY dashboards /var/lib/grafana/dashboards
COPY grafana.ini /etc/grafana/grafana.ini
