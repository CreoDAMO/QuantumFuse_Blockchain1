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
	rustup default nightly
	rustup component add rust-src --toolchain nightly
	cd $(RUST_DIR) && cargo update && cargo build

build-r
