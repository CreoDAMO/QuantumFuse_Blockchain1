# Directories
RUST_DIR ?= QuantumFuse/core
GO_DIR ?= QuantumFuse/core/QuantumFuse/node
PYTHON_DIR ?= QuantumFuse/core/QuantumFuse/node/QuantumFuse/api
FRONTEND_DIR ?= QuantumFuse/core/QuantumFuse/node/QuantumFuse/frontend/quantumfuse-app

# Common Variables
RUST_TOOLCHAIN ?= nightly
PROTOTOOL ?= protoc
CACHE_DIR ?= ~/.cache/quantumfuse

# Targets
.PHONY: all setup build run test clean update install-protoc help \
        setup-rust build-rust run-rust test-rust clean-rust update-rust lint-rust coverage-rust \
        setup-go build-go run-go test-go clean-go update-go lint-go coverage-go \
        setup-python build-python run-python test-python clean-python update-python \
        setup-node build-node run-node test-node clean-node update-node \
        docker_build docker_run cache wasm-build

# Default target
all: setup build

# Help target to display available commands
help:
	@echo "Usage: make [target]"
	@echo ""
	@echo "Targets:"
	@echo "  all            - Set up and build the project."
	@echo "  setup          - Set up all components."
	@echo "  build          - Build all components."
	@echo "  run            - Run all components."
	@echo "  test           - Run tests for all components."
	@echo "  lint           - Lint the codebase."
	@echo "  coverage       - Generate and publish coverage reports."
	@echo "  clean          - Clean up all build artifacts."
	@echo "  update         - Update all dependencies."
	@echo "  install-protoc - Install protobuf compiler (protoc)."
	@echo "  docker_build   - Build Docker image."
	@echo "  docker_run     - Run Docker container."
	@echo "  cache          - Set up caching for dependencies."
	@echo "  wasm-build     - Build the Rust project with the wasm feature enabled."
	@echo "  help           - Display this help message."
	@echo ""
	@echo "Component-specific targets (use with 'make component-target'):"
	@echo "  rust, go, python, node - setup, build, run, test, clean, update"

# Main Targets
setup: setup-rust setup-go setup-python setup-node
build: build-rust build-go build-python build-node
run: run-rust run-go run-python run-node
test: test-rust test-go test-python test-node
lint: lint-rust lint-go
coverage: coverage-rust coverage-go
clean: clean-rust clean-go clean-python clean-node
update: update-rust update-go update-python update-node
docker_build: docker_build
docker_run: docker_run
cache: cache
wasm-build: build-rust-wasm

# Rust targets
setup-rust: install-protoc
	@rustup toolchain install $(RUST_TOOLCHAIN)
	@rustup override set $(RUST_TOOLCHAIN) --path $(RUST_DIR)
	@rustup component add rust-src --toolchain $(RUST_TOOLCHAIN)
	@rustup target add wasm32-unknown-unknown --toolchain $(RUST_TOOLCHAIN)
	@rustup run $(RUST_TOOLCHAIN) cargo update --manifest-path=$(RUST_DIR)/Cargo.toml

install-protoc:
	@if ! command -v $(PROTOTOOL) &> /dev/null; then \
		echo "Installing protoc..."; \
		if [ "$$(uname)" = "Darwin" ]; then \
			brew install protobuf; \
		else \
			sudo apt-get update && sudo apt-get install -y protobuf-compiler; \
		fi \
	else \
		echo "protoc is already installed."; \
	fi

build-rust: setup-rust
	@rustup run $(RUST_TOOLCHAIN) cargo build --release --manifest-path=$(RUST_DIR)/Cargo.toml

build-rust-wasm: setup-rust
	@rustup run $(RUST_TOOLCHAIN) cargo build --release --manifest-path=$(RUST_DIR)/Cargo.toml --features wasm

run-rust: build-rust
	@rustup run $(RUST_TOOLCHAIN) cargo run --manifest-path=$(RUST_DIR)/Cargo.toml

test-rust: setup-rust
	@rustup run $(RUST_TOOLCHAIN) cargo test --manifest-path=$(RUST_DIR)/Cargo.toml

lint-rust:
	@rustup run $(RUST_TOOLCHAIN) cargo clippy --manifest-path=$(RUST_DIR)/Cargo.toml

coverage-rust:
	@rustup run $(RUST_TOOLCHAIN) cargo install grcov
	@rustup run $(RUST_TOOLCHAIN) cargo test --all --all-features --no-run
	@rustup run $(RUST_TOOLCHAIN) grcov target/debug/ -s . --binary --output=coverage.info

clean-rust:
	@rustup run $(RUST_TOOLCHAIN) cargo clean --manifest-path=$(RUST_DIR)/Cargo.toml

update-rust:
	@rustup run $(RUST_TOOLCHAIN) cargo update --manifest-path=$(RUST_DIR)/Cargo.toml

# Go targets (unchanged)
setup-go:
	@echo "Setting up Go environment..."
	@go mod tidy -C $(GO_DIR)

build-go: setup-go
	@echo "Building Go project..."
	@go build -o $(GO_DIR)/QuantumFuseNode $(GO_DIR)/main.go

run-go: build-go
	@echo "Running Go project..."
	@$(GO_DIR)/QuantumFuseNode

test-go: setup-go
	@echo "Testing Go project..."
	@go test -v -cover -C $(GO_DIR)

clean-go:
	@echo "Cleaning Go build..."
	@rm -f $(GO_DIR)/QuantumFuseNode

update-go: setup-go
	@echo "Updating Go dependencies..."
	@go get -u -C $(GO_DIR)

lint-go:
	@golangci-lint run $(GO_DIR)

coverage-go:
	@go test -coverprofile=coverage.out -C $(GO_DIR)
	@go tool cover -html=coverage.out

# Python targets (unchanged)
setup-python:
	@echo "Setting up Python environment..."
	@pip install -r $(PYTHON_DIR)/requirements.txt

build-python: setup-python
	@echo "Building Python project..."
	@echo "Python project does not require explicit build."

run-python: setup-python
	@echo "Running Python API..."
	@python $(PYTHON_DIR)/api.py

test-python:
	@echo "Running Python tests..."
	@pytest $(PYTHON_DIR)

clean-python:
	@echo "Cleaning Python environment..."
	@find $(PYTHON_DIR) -name "*.pyc" -exec rm -f {} \;

update-python:
	@echo "Updating Python dependencies..."
	@pip install --upgrade -r $(PYTHON_DIR)/requirements.txt

# Node.js (unchanged)
setup-node:
	@echo "Setting up Node.js environment..."
	@npm install --prefix $(FRONTEND_DIR)

build-node: setup-node
	@echo "Building Node.js frontend..."
	@npm run build --prefix $(FRONTEND_DIR)

run-node: setup-node
	@echo "Running Node.js frontend..."
	@npm start --prefix $(FRONTEND_DIR)

test-node:
	@echo "Testing Node.js project..."
	@npm test --prefix $(FRONTEND_DIR)

clean-node:
	@echo "Cleaning Node.js environment..."
	@rm -rf $(FRONTEND_DIR)/node_modules

update-node:
	@echo "Updating Node.js dependencies..."
	@npm update --prefix $(FRONTEND_DIR)

# Docker targets
docker_build:
	docker build -t quantumfuse .

docker_run:
	docker run -it -p 3000:3000 quantumfuse

# Cache dependencies
cache:
	mkdir -p $(CACHE_DIR)
	@echo "Caching dependencies..."
