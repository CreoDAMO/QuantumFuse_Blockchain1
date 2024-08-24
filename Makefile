# Directories
RUST_DIR = QuantumFuse/core
GO_DIR = QuantumFuse/core/QuantumFuse/node
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
	@rustup toolchain install nightly || exit 1
	@rustup override set nightly --path $(RUST_DIR) || exit 1
	@rustup component add rust-src --toolchain nightly || exit 1
	@rustup run nightly cargo update --manifest-path=$(RUST_DIR)/Cargo.toml || exit 1

build-rust:
	@rustup run nightly cargo build --release --manifest-path=$(RUST_DIR)/Cargo.toml || exit 1

run-rust:
	@rustup run nightly cargo run --bin main --manifest-path=$(RUST_DIR)/Cargo.toml || exit 1

run-community-wallet:
	@rustup run nightly cargo run --bin community_wallet --manifest-path=$(RUST_DIR)/Cargo.toml || exit 1

run-founder-wallet:
	@rustup run nightly cargo run --bin founder_wallet --manifest-path=$(RUST_DIR)/Cargo.toml || exit 1

test-rust:
	@rustup run nightly cargo test --manifest-path=$(RUST_DIR)/Cargo.toml || exit 1

clean-rust:
	@rustup run nightly cargo clean --manifest-path=$(RUST_DIR)/Cargo.toml || exit 1

update-rust:
	@rustup run nightly cargo update --manifest-path=$(RUST_DIR)/Cargo.toml || exit 1

# Go targets
setup-go:
	@cd $(GO_DIR) && go mod tidy || exit 1
	@cd $(GO_DIR) && go get ./... || exit 1

build-go:
	@cd $(GO_DIR) && go build -o main || exit 1

run-go:
	@cd $(GO_DIR) && ./main || exit 1

test-go:
	@cd $(GO_DIR) && go test ./... || exit 1

clean-go:
	@rm -rf $(GO_DIR)/main || exit 1

update-go:
	@cd $(GO_DIR) && go get -u ./... || exit 1

# Python targets
setup-python:
	@pip install -r $(PYTHON_DIR)/requirements.txt || exit 1

build-python:
	@echo "Python does not require a build step."

run-python:
	@python $(PYTHON_DIR)/main.py || exit 1

test-python:
	@pytest $(PYTHON_DIR)/tests || exit 1

clean-python:
	@rm -rf $(PYTHON_DIR)/__pycache__ || exit 1

update-python:
	@pip install --upgrade -r $(PYTHON_DIR)/requirements.txt || exit 1

# Node.js targets
setup-node:
	@cd $(FRONTEND_DIR) && npm install || exit 1

build-node:
	@cd $(FRONTEND_DIR) && npm run build || exit 1

run-node:
	@cd $(FRONTEND_DIR) && npm start || exit 1

test-node:
	@cd $(FRONTEND_DIR) && npm test || exit 1

clean-node:
	@rm -rf $(FRONTEND_DIR)/node_modules || exit 1

update-node:
	@cd $(FRONTEND_DIR) && npm update || exit 1
