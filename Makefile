# Directories
RUST_DIR = QuantumFuse/core
GO_DIR = QuantumFuse/core/QuantumFuse/node
PYTHON_DIR = QuantumFuse/core/QuantumFuse/node/QuantumFuse/api
FRONTEND_DIR = QuantumFuse/core/QuantumFuse/node/QuantumFuse/frontend/quantumfuse-app

# Common Variables
RUST_TOOLCHAIN = nightly
PROTOTOOL = protoc
CACHE_DIR = ~/.cache/quantumfuse

# Targets
.PHONY: all setup build run test clean update install-protoc help \
        setup-rust build-rust run-rust test-rust clean-rust update-rust lint-rust coverage-rust \
        setup-go build-go run-go test-go clean-go update-go lint-go coverage-go \
        setup-python build-python run-python test-python clean-python update-python \
        setup-node build-node run-node test-node clean-node update-node \
        docker_build docker_run cache

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

# Rust targets
setup-rust: install-protoc
	@rustup toolchain install $(RUST_TOOLCHAIN)
	@rustup override set $(RUST_TOOLCHAIN) --path $(RUST_DIR)
	@rustup component add rust-src --toolchain $(RUST_TOOLCHAIN)
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
	@rustup run $(RUST_TOOLCHAIN) cargo build --release --manifest-path=$(RUST_DIR)/Cargo.toml --features=wasm

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
	@rustup run $(RUST_TOOLCHAIN) cargo update --manifest-path=$(RUST_DIR)/Cargo

# Go targets
setup-go:
	@cd $(GO_DIR) && go mod tidy && go get -v ./...

build-go: setup-go
	@cd $(GO_DIR) && go build -o main

run-go: build-go
	@cd $(GO_DIR) && ./main

test-go: setup-go
	@cd $(GO_DIR) && go test ./...

lint-go:
	@cd $(GO_DIR) && golangci-lint run ./...

coverage-go:
	@cd $(GO_DIR) && go test -coverprofile=coverage.out && go tool cover -html=coverage.out -o coverage.html

clean-go:
	@rm -f $(GO_DIR)/main

update-go:
	@cd $(GO_DIR) && go get -u ./...

# Python targets
setup-python:
	@cd $(PYTHON_DIR) && pip install -r requirements.txt

build-python: setup-python
	@echo "Python does not require a build step."

run-python: build-python
	@cd $(PYTHON_DIR) && python main.py

test-python: setup-python
	@cd $(PYTHON_DIR) && pytest tests

clean-python:
	@rm -rf $(PYTHON_DIR)/__pycache__

update-python:
	@cd $(PYTHON_DIR) && pip install --upgrade -r requirements.txt

# Node.js targets
setup-node:
	@cd $(FRONTEND_DIR) && npm install

build-node: setup-node
	@cd $(FRONTEND_DIR) && npm run build

run-node: build-node
	@cd $(FRONTEND_DIR) && npm start

test-node: setup-node
	@cd $(FRONTEND_DIR) && npm test

clean-node:
	@rm -rf $(FRONTEND_DIR)/node_modules $(FRONTEND_DIR)/build

update-node:
	@cd $(FRONTEND_DIR) && npm update

# Docker targets
docker_build:
	docker build -t quantumfuse .

docker_run:
	docker run -it -p 3000:3000 quantumfuse

# Cache dependencies
cache:
	mkdir -p $(CACHE_DIR)
	@echo "Caching dependencies..."
