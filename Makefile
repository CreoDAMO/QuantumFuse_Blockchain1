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
	rustup install nightly-2018-10-05
	rustup default nightly-2018-10-05
	rustup component add rust-src --toolchain nightly-2018-10-05
	cd $(RUST_DIR) && cargo update && cargo build

build-rust:
	cd $(RUST_DIR) && cargo build --release

run-rust:
	cd $(RUST_DIR) && cargo run

test-rust:
	cd $(RUST_DIR) && cargo test

clean-rust:
	cd $(RUST_DIR) && cargo clean

update-rust:
	cd $(RUST_DIR) && cargo update

# Go targets
setup-go:
	go mod tidy
	cd $(GO_DIR) && go get ./...

build-go:
	cd $(GO_DIR) && go build

run-go:
	cd $(GO_DIR) && go run main.go

test-go:
	cd $(GO_DIR) && go test ./...

clean-go:
	rm -rf $(GO_DIR)/bin

update-go:
	cd $(GO_DIR) && go get -u ./...

# Python targets
setup-python:
	pip install -r $(PYTHON_DIR)/requirements.txt

build-python:
	@echo "Python does not require a build step."

run-python:
	python $(PYTHON_DIR)/main.py

test-python:
	pytest $(PYTHON_DIR)/tests

clean-python:
	rm -rf $(PYTHON_DIR)/__pycache__

update-python:
	pip install --upgrade -r $(PYTHON_DIR)/requirements.txt

# Node.js targets
setup-node:
	cd $(FRONTEND_DIR) && npm install

build-node:
	cd $(FRONTEND_DIR) && npm run build

run-node:
	cd $(FRONTEND_DIR) && npm start

test-node:
	cd $(FRONTEND_DIR) && npm test

clean-node:
	rm -rf $(FRONTEND_DIR)/node_modules

update-node:
	cd $(FRONTEND_DIR) && npm update

