# Directories
RUST_DIR = QuantumFuse/core
GO_DIR = QuantumFuseNode
PYTHON_DIR = QuantumFuse/api
FRONTEND_DIR = QuantumFuse/frontend/quantumfuse-app

# Targets
.PHONY: all setup build run test clean update

all: setup build

setup: setup-rust setup-go setup-python setup-node

build: build-rust build-go build-python build-node

run: run-rust run-go run-python run-node

test: test-rust test-go test-python test-node

clean: clean-rust clean-go clean-python clean-node

update: update-rust update-go update-python update-node

# Rust targets
setup-rust:
	@echo "Setting up Rust..."
	rustup toolchain install nightly
	rustup default nightly
	rustup component add rust-src --toolchain nightly
	cd $(RUST_DIR) && cargo update && cargo build

build-rust:
	@echo "Building Rust..."
	rustup default nightly
	cd $(RUST_DIR) && cargo build --release

run-rust:
	@echo "Running Rust..."
	rustup default nightly
	cd $(RUST_DIR) && cargo run

test-rust:
	@echo "Testing Rust..."
	rustup default nightly
	cd $(RUST_DIR) && cargo test

clean-rust:
	@echo "Cleaning Rust..."
	cd $(RUST_DIR) && cargo clean

update-rust:
	@echo "Updating Rust..."
	cd $(RUST_DIR) && cargo update

# Go targets
setup-go:
	@echo "Setting up Go..."
	cd $(GO_DIR) && go mod tidy

build-go:
	@echo "Building Go..."
	cd $(GO_DIR) && go build -o QuantumFuseNode

run-go:
	@echo "Running Go..."
	cd $(GO_DIR) && ./QuantumFuseNode

test-go:
	@echo "Testing Go..."
	cd $(GO_DIR) && go test ./...

clean-go:
	@echo "Cleaning Go..."
	rm -f $(GO_DIR)/QuantumFuseNode

update-go:
	@echo "Updating Go..."
	cd $(GO_DIR) && go get -u ./...

# Python targets
setup-python:
	@echo "Setting up Python..."
	cd $(PYTHON_DIR) && pip install -r requirements.txt

build-python: # No build step needed for Python
	@echo "No build step needed for Python."

run-python:
	@echo "Running Python..."
	cd $(PYTHON_DIR) && python api.py

test-python:
	@echo "Testing Python..."
	cd $(PYTHON_DIR) && pytest

clean-python:
	@echo "Cleaning Python..."
	find $(PYTHON_DIR) -type f -name "*.pyc" -delete
	find $(PYTHON_DIR) -type d -name "__pycache__" -delete

update-python:
	@echo "Updating Python..."
	cd $(PYTHON_DIR) && pip install --upgrade -r requirements.txt

# Node.js targets
setup-node: update-npm
	@echo "Setting up Node.js..."
	cd $(FRONTEND_DIR) && npm install

build-node:
	@echo "Building Node.js..."
	cd $(FRONTEND_DIR) && npm run build

run-node:
	@echo "Running Node.js..."
	cd $(FRONTEND_DIR) && npm start

test-node:
	@echo "Testing Node.js..."
	cd $(FRONTEND_DIR) && npm test

clean-node:
	@echo "Cleaning Node.js..."
	rm -rf $(FRONTEND_DIR)/node_modules
	rm -rf $(FRONTEND_DIR)/build

update-node:
	@echo "Updating Node.js..."
	cd $(FRONTEND_DIR) && ncu -u && npm install

update-npm:
	@echo "Updating npm..."
	npm install -g npm@latest
