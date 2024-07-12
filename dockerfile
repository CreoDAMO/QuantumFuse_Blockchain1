# Stage 1: Prometheus
FROM prom/prometheus:latest as prometheus

# Copy Prometheus configuration file
COPY prometheus.yml /etc/prometheus/prometheus.yml

# Stage 2: Grafana
FROM grafana/grafana:latest as grafana

# Copy Grafana dashboards and configuration
COPY dashboards /var/lib/grafana/dashboards
COPY grafana.ini /etc/grafana/grafana.ini

# Stage 3: QuantumFuse API
FROM python:3.9-slim as api

# Set working directory
WORKDIR /app

# Copy requirements and install dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy API source code
COPY api/ ./api

# Expose port for API
EXPOSE 5000

# Command to run the API
CMD ["gunicorn", "-b", "0.0.0.0:5000", "api.api:app"]

# Stage 4: QuantumFuse Node
FROM golang:1.18 as node

# Set working directory
WORKDIR /app

# Copy Go module files
COPY QuantumFuseNode/go.mod QuantumFuseNode/go.sum ./

# Download dependencies
RUN go mod download

# Copy node source code
COPY QuantumFuseNode/ .

# Build the Go application
RUN go build -o /quantumfuse-node main.go

# Expose port for the node
EXPOSE 8080

# Command to run the Go application
CMD ["/quantumfuse-node"]

# Stage 5: QuantumFuse Frontend
FROM node:16 as frontend

# Set working directory
WORKDIR /app

# Copy package.json and package-lock.json
COPY frontend/quantumfuse-app/package*.json ./

# Install dependencies
RUN npm install

# Copy frontend source code
COPY frontend/quantumfuse-app/ .

# Build the frontend application
RUN npm run build

# Stage 6: Final Stage
FROM nginx:alpine

# Copy built frontend from previous stage
COPY --from=frontend /app/build /usr/share/nginx/html

# Copy nginx configuration file
COPY nginx.conf /etc/nginx/nginx.conf

# Expose port for the frontend
EXPOSE 80

# Start nginx server
CMD ["nginx", "-g", "daemon off;"]
