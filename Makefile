# Project Directories
RUST_DIR = QuantumFuse/core
GO_DIR = QuantumFuse/core/QuantumFuse/node
PYTHON_DIR = QuantumFuse/core/QuantumFuse/node/api
FRONTEND_DIR = QuantumFuse/core/QuantumFuse/node/frontend

# Targets
.PHONY: all setup build run test clean

# Default target
all: setup build

# Setup all projects
setup: setup-rust setup-go setup-python setup-node

# Build all projects
build: build-rust build-go build-python build-node

# Run all projects
run: run-rust run-go run-python run-node

# Test all projects
test: test-rust test-go test-python test-node

# Clean all projects
clean: clean-rust clean-go clean-python clean-node

# Rust targets
setup-rust:
	@if [ -d $(RUST_DIR) ]; then \
		cd $(RUST_DIR) && cargo build; \
	else \
		echo "Error: $(RUST_DIR) does not exist."; \
		exit 1; \
	fi

build-rust:
	@if [ -d $(RUST_DIR) ]; then \
		cd $(RUST_DIR) && cargo build --release; \
	else \
		echo "Error: $(RUST_DIR) does not exist."; \
		exit 1; \
	fi

run-rust:
	@if [ -d $(RUST_DIR) ]; then \
		cd $(RUST_DIR) && cargo run; \
	else \
		echo "Error: $(RUST_DIR) does not exist."; \
		exit 1; \
	fi

test-rust:
	@if [ -d $(RUST_DIR) ]; then \
		cd $(RUST_DIR) && cargo test; \
	else \
		echo "Error: $(RUST_DIR) does not exist."; \
		exit 1; \
	fi

clean-rust:
	@if [ -d $(RUST_DIR) ]; then \
		cd $(RUST_DIR) && cargo clean; \
	else \
		echo "Error: $(RUST_DIR) does not exist."; \
		exit 1; \
	fi

# Go targets
setup-go:
	@if [ -d $(GO_DIR) ]; then \
		cd $(GO_DIR) && go mod tidy; \
	else \
		echo "Error: $(GO_DIR) does not exist."; \
		exit 1; \
	fi

build-go:
	@if [ -d $(GO_DIR) ]; then \
		cd $(GO_DIR) && go build; \
	else \
		echo "Error: $(GO_DIR) does not exist."; \
		exit 1; \
	fi

run-go:
	@if [ -d $(GO_DIR) ]; then \
		cd $(GO_DIR) && go run main.go; \
	else \
		echo "Error: $(GO_DIR) does not exist."; \
		exit 1; \
	fi

test-go:
	@if [ -d $(GO_DIR) ]; then \
		cd $(GO_DIR) && go test ./...; \
	else \
		echo "Error: $(GO_DIR) does not exist."; \
		exit 1; \
	fi

clean-go:
	@if [ -d $(GO_DIR) ]; then \
		rm -f $(GO_DIR)/main; \
	else \
		echo "Error: $(GO_DIR) does not exist."; \
		exit 1; \
	fi

# Python targets
setup-python:
	@if [ -d $(PYTHON_DIR) ]; then \
		cd $(PYTHON_DIR) && pip install -r requirements.txt; \
	else \
		echo "Error: $(PYTHON_DIR) does not exist."; \
		exit 1; \
	fi

build-python: # No build step needed for Python
	@echo "No build step needed for Python."

run-python:
	@if [ -d $(PYTHON_DIR) ]; then \
		cd $(PYTHON_DIR) && python api.py; \
	else \
		echo "Error: $(PYTHON_DIR) does not exist."; \
		exit 1; \
	fi

test-python:
	@if [ -d $(PYTHON_DIR) ]; then \
		cd $(PYTHON_DIR) && pytest; \
	else \
		echo "Error: $(PYTHON_DIR) does not exist."; \
		exit 1; \
	fi

clean-python:
	@if [ -d $(PYTHON_DIR) ]; then \
		find $(PYTHON_DIR) -type f -name "*.pyc" -delete; \
		find $(PYTHON_DIR) -type d -name "__pycache__" -delete; \
	else \
		echo "Error: $(PYTHON_DIR) does not exist."; \
		exit 1; \
	fi

# Node.js targets
setup-node:
	@if [ -d $(FRONTEND_DIR) ]; then \
		cd $(FRONTEND_DIR) && npm install; \
	else \
		echo "Error: $(FRONTEND_DIR) does not exist."; \
		exit 1; \
	fi

build-node:
	@if [ -d $(FRONTEND_DIR) ]; then \
		cd $(FRONTEND_DIR) && npm run build; \
	else \
		echo "Error: $(FRONTEND_DIR) does not exist."; \
		exit 1; \
	fi

run-node:
	@if [ -d $(FRONTEND_DIR) ]; then \
		cd $(FRONTEND_DIR) && npm start; \
	else \
		echo "Error: $(FRONTEND_DIR) does not exist."; \
		exit 1; \
	fi

test-node:
	@if [ -d $(FRONTEND_DIR) ]; then \
		cd $(FRONTEND_DIR) && npm test; \
	else \
		echo "Error: $(FRONTEND_DIR) does not exist."; \
		exit 1; \
	fi

clean-node:
	@if [ -d $(FRONTEND_DIR) ]; then \
		rm -rf $(FRONTEND_DIR)/node_modules; \
		rm -rf $(FRONTEND_DIR)/build; \
	else \
		echo "Error: $(FRONTEND_DIR) does not exist."; \
		exit 1; \
	fi
