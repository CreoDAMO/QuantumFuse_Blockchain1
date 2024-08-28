# Directories
RUST_DIR = QuantumFuse/core
GO_DIR = QuantumFuse/core/QuantumFuse/node
PYTHON_DIR = QuantumFuse/core/QuantumFuse/node/QuantumFuse/api
FRONTEND_DIR = QuantumFuse/core/QuantumFuse/node/QuantumFuse/frontend/quantumfuse-app

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
	@rustup toolchain install nightly
	@rustup override set nightly --path $(RUST_DIR)
	@rustup component add rust-src --toolchain nightly
	@rustup run nightly cargo update --manifest-path=$(RUST_DIR)/Cargo.toml

build-rust: force-schnorrkel-version
	@rustup run nightly cargo build --release --manifest-path=$(RUST_DIR)/Cargo.toml

run-rust:
	@rustup run nightly cargo run --manifest-path=$(RUST_DIR)/Cargo.toml

test-rust:
	@rustup run nightly cargo test --manifest-path=$(RUST_DIR)/Cargo.toml

clean-rust:
	@rustup run nightly cargo clean --manifest-path=$(RUST_DIR)/Cargo.toml

update-rust: force-schnorrkel-version
	@rustup run nightly cargo update --manifest-path=$(RUST_DIR)/Cargo.toml

force-schnorrkel-version:
	@rustup run nightly cargo update -p schnorrkel --precise 0.11.4 --manifest-path=$(RUST_DIR)/Cargo.toml

# Go targets
setup-go:
	@cd $(GO_DIR) && go mod tidy
	@cd $(GO_DIR) && go get ./...

build-go:
	@cd $(GO_DIR) && go build -o main

run-go:
	@cd $(GO_DIR) && ./main

test-go:
	@cd $(GO_DIR) && go test ./...

clean-go:
	@rm -rf $(GO_DIR)/main

update-go:
	@cd $(GO_DIR) && go get -u ./...

# Python targets
setup-python:
	@cd $(PYTHON_DIR) && pip install -r requirements.txt

build-python:
	@echo "Python does not require a build step."

run-python:
	@cd $(PYTHON_DIR) && python main.py

test-python:
	@cd $(PYTHON_DIR) && pytest tests

clean-python:
	@rm -rf $(PYTHON_DIR)/__pycache__

update-python:
	@cd $(PYTHON_DIR) && pip install --upgrade -r requirements.txt

# Node.js targets
setup-node:
	@cd $(FRONTEND_DIR) && npm install

build-node:
	@cd $(FRONTEND_DIR) && npm run build

run-node:
	@cd $(FRONTEND_DIR) && npm start

test-node:
	@cd $(FRONTEND_DIR) && npm test

clean-node:
	@rm -rf $(FRONTEND_DIR)/node_modules

update-node:
	@cd $(FRONTEND_DIR) && npm update
