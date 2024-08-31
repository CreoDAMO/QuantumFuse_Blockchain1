# Stage 1: Prometheus
FROM prom/prometheus:latest as prometheus

COPY prometheus.yml /etc/prometheus/prometheus.yml

# Stage 2: Grafana
FROM grafana/grafana:latest as grafana

COPY dashboards /var/lib/grafana/dashboards
COPY grafana.ini /etc/grafana/grafana.ini

# Stage 3: QuantumFuse API
FROM python:3.9-slim as api

WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
COPY api/ ./api
EXPOSE 5000
CMD ["gunicorn", "-b", "0.0.0.0:5000", "api.api:app"]

# Stage 4: QuantumFuse Node
FROM golang:1.18 as node

WORKDIR /app
COPY QuantumFuseNode/go.mod QuantumFuseNode/go.sum ./
RUN go mod download
COPY QuantumFuseNode/ .
RUN go build -o /quantumfuse-node main.go
EXPOSE 8080
CMD ["/quantumfuse-node"]

# Stage 5: QuantumFuse Frontend
FROM node:16 as frontend

WORKDIR /app
COPY frontend/quantumfuse-app/package*.json ./
RUN npm install
COPY frontend/quantumfuse-app/ .
RUN npm run build

# Stage 6: Final Stage
FROM nginx:alpine

COPY --from=frontend /app/build /usr/share/nginx/html
COPY nginx.conf /etc/nginx/nginx.conf
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
