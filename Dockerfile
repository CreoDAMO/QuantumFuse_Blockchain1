# Stage 1: Prometheus
FROM prom/prometheus:v2.41.0 as prometheus  # Version pinning for stability

COPY prometheus.yml /etc/prometheus/prometheus.yml

# Stage 2: Grafana
FROM grafana/grafana:9.3.2 as grafana  # Version pinning

COPY dashboards /var/lib/grafana/dashboards
COPY grafana.ini /etc/grafana/grafana.ini

# Stage 3: QuantumFuse API
FROM python:3.9-slim as api

WORKDIR /app

# Install dependencies first to leverage Docker's caching
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy the rest of the application code
COPY api/ ./api

# Add a non-root user for better security
RUN adduser --disabled-password apiuser && chown -R apiuser /app
USER apiuser

EXPOSE 5000
CMD ["gunicorn", "-b", "0.0.0.0:5000", "api.api:app"]

# Stage 4: QuantumFuse Node
FROM golang:1.18 as node

WORKDIR /app

# Copy and download dependencies first for caching
COPY QuantumFuseNode/go.mod QuantumFuseNode/go.sum ./
RUN go mod download

# Copy the application code and build the binary
COPY QuantumFuseNode/ .
RUN go build -o /quantumfuse-node main.go

# Add a non-root user for security
RUN adduser --disabled-password nodeuser && chown -R nodeuser /app
USER nodeuser

EXPOSE 8080
CMD ["/quantumfuse-node"]

# Stage 5: QuantumFuse Frontend
FROM node:16 as frontend

WORKDIR /app

# Copy package.json and install dependencies first for caching
COPY frontend/quantumfuse-app/package*.json ./
RUN npm install

# Copy the rest of the app and build it
COPY frontend/quantumfuse-app/ .
RUN npm run build

# Stage 6: Final Stage (Nginx for Frontend)
FROM nginx:alpine

# Copy frontend build output to Nginx web root
COPY --from=frontend /app/build /usr/share/nginx/html

# Copy Nginx configuration
COPY nginx.conf /etc/nginx/nginx.conf

# Expose port 80 for the frontend
EXPOSE 80

# Add a health check for Nginx
HEALTHCHECK CMD curl --fail http://localhost/ || exit 1

CMD ["nginx", "-g", "daemon off;"]
