# Directories
RUST_DIR = QuantumFuse/core
GO_DIR = QuantumFuse/core/QuantumFuse/node
PYTHON_DIR = QuantumFuse/core/QuantumFuse/node/QuantumFuse/api
FRONTEND_DIR = QuantumFuse/core/QuantumFuse/node/QuantumFuse/frontend/QuantumFuse/frontend/src

# Targets
.PHONY: all setup build run test clean update

all: setup build

setup: setup-rust setup-go setup-python setup-node

build: build-rust build-go build-python build-node

run: run-rust run-go run-python run-node

test: test-rust test-go test-python test-node

clean: clean-rust clean-go clean-python clean-node

update: update-node

# Rust targets
setup-rust:
	cd $(RUST_DIR) && cargo build

build-rust:
	cd $(RUST_DIR) && cargo build --release

run-rust:
	cd $(RUST_DIR) && cargo run

test-rust:
	cd $(RUST_DIR) && cargo test

clean-rust:
	cd $(RUST_DIR) && cargo clean

# Go targets
setup-go:
	cd $(GO_DIR) && go mod tidy

build-go:
	cd $(GO_DIR) && go build -o QuantumFuseNode

run-go:
	cd $(GO_DIR) && ./QuantumFuseNode

test-go:
	cd $(GO_DIR) && go test ./...

clean-go:
	rm -f $(GO_DIR)/QuantumFuseNode

# Python targets
setup-python:
	cd $(PYTHON_DIR) && pip install -r requirements.txt

build-python: # No build step needed for Python
	@echo "No build step needed for Python."

run-python:
	cd $(PYTHON_DIR) && python api.py

test-python:
	cd $(PYTHON_DIR) && pytest

clean-python:
	find $(PYTHON_DIR) -type f -name "*.pyc" -delete
	find $(PYTHON_DIR) -type d -name "__pycache__" -delete

# Node.js targets
setup-node: update-npm
	cd $(FRONTEND_DIR) && npm install

build-node:
	cd $(FRONTEND_DIR) && npm run build

run-node:
	cd $(FRONTEND_DIR) && npm start

test-node:
	cd $(FRONTEND_DIR) && npm test

clean-node:
	rm -rf $(FRONTEND_DIR)/node_modules
	rm -rf $(FRONTEND_DIR)/build

update-node:
	cd $(FRONTEND_DIR) && ncu -u && npm install

update-npm:
	npm install -g npm@latest
