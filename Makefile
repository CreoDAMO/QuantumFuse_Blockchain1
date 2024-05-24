# Project Directories
RUST_DIR = core
GO_DIR = node
PYTHON_DIR = api
FRONTEND_DIR = frontend

# Targets
.PHONY: all setup build run test clean

# Default target
all: setup build

# Setup all projects
setup: setup-check setup-rust setup-go setup-python setup-node

# Build all projects
build: build-rust build-go build-python build-node

# Run all projects
run: run-rust run-go run-python run-node

# Test all projects
test: test-rust test-go test-python test-node

# Clean all projects
clean: clean-rust clean-go clean-python clean-node

# Check for necessary tools
setup-check:
	@command -v cargo >/dev/null 2>&1 || { echo >&2 "Cargo is not installed. Aborting."; exit 1; }
	@command -v go >/dev/null 2>&1 || { echo >&2 "Go is not installed. Aborting."; exit 1; }
	@command -v python >/dev/null 2>&1 || { echo >&2 "Python is not installed. Aborting."; exit 1; }
	@command -v npm >/dev/null 2>&1 || { echo >&2 "npm is not installed. Aborting."; exit 1; }

# Rust targets
setup-rust:
	@[ -d $(RUST_DIR) ] && (cd $(RUST_DIR) && cargo build) || echo "Rust directory not found."

build-rust:
	@[ -d $(RUST_DIR) ] && (cd $(RUST_DIR) && cargo build --release) || echo "Rust directory not found."

run-rust:
	@[ -d $(RUST_DIR) ] && (cd $(RUST_DIR) && cargo run) || echo "Rust directory not found."

test-rust:
	@[ -d $(RUST_DIR) ] && (cd $(RUST_DIR) && cargo test) || echo "Rust directory not found."

clean-rust:
	@[ -d $(RUST_DIR) ] && (cd $(RUST_DIR) && cargo clean) || echo "Rust directory not found."

# Go targets
setup-go:
	@[ -d $(GO_DIR) ] && (cd $(GO_DIR) && go mod tidy) || echo "Go directory not found."

build-go:
	@[ -d $(GO_DIR) ] && (cd $(GO_DIR) && go build) || echo "Go directory not found."

run-go:
	@[ -d $(GO_DIR) ] && (cd $(GO_DIR) && go run main.go) || echo "Go directory not found."

test-go:
	@[ -d $(GO_DIR) ] && (cd $(GO_DIR) && go test ./...) || echo "Go directory not found."

clean-go:
	@[ -d $(GO_DIR) ] && rm -f $(GO_DIR)/main || echo "Go directory not found."

# Python targets
setup-python:
	@[ -d $(PYTHON_DIR) ] && (cd $(PYTHON_DIR) && pip install -r requirements.txt) || echo "Python directory not found."

build-python: # No build step needed for Python
	@echo "No build step needed for Python."

run-python:
	@[ -d $(PYTHON_DIR) ] && (cd $(PYTHON_DIR) && python api.py) || echo "Python directory not found."

test-python:
	@[ -d $(PYTHON_DIR) ] && (cd $(PYTHON_DIR) && pytest) || echo "Python directory not found."

clean-python:
	@[ -d $(PYTHON_DIR) ] && find $(PYTHON_DIR) -type f -name "*.pyc" -delete || echo "Python directory not found."
	@[ -d $(PYTHON_DIR) ] && find $(PYTHON_DIR) -type d -name "__pycache__" -delete || echo "Python directory not found."

# Node.js targets
setup-node:
	@[ -d $(FRONTEND_DIR) ] && (cd $(FRONTEND_DIR) && npm install) || echo "Node.js directory not found."

build-node:
	@[ -d $(FRONTEND_DIR) ] && (cd $(FRONTEND_DIR) && npm run build) || echo "Node.js directory not found."

run-node:
	@[ -d $(FRONTEND_DIR) ] && (cd $(FRONTEND_DIR) && npm start) || echo "Node.js directory not found."

test-node:
	@[ -d $(FRONTEND_DIR) ] && (cd $(FRONTEND_DIR) && npm test) || echo "Node.js directory not found."

clean-node:
	@[ -d $(FRONTEND_DIR) ] && rm -rf $(FRONTEND_DIR)/node_modules || echo "Node.js directory not found."
	@[ -d $(FRONTEND_DIR) ] && rm -rf $(FRONTEND_DIR)/build || echo "Node.js directory not found."
