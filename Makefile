# Directories
DIRS = core api frontend

# Tools
RUST_VERSION = 1.65.0
NODE_VERSION = 20.

# Targets  
.PHONY: all lint test

all: setup test

setup:
 	@echo "Installing tools..."
 	rustup install $(RUST_VERSION)
 	npm install -g n $(NODE_VERSION)

lint: 
 	@echo "Linting code..."
	@for dir in $(DIRS); do \
	  printf "%s\n" "Linting $$dir"; \  
	  (cd $$dir && $(LINT_COMMAND)); \
	done

test:
 	@echo "Testing code..."
 	cargo test --all --verbose
 	cd api && pytest
 	cd frontend && npm test

# Directory specific linting
core: LINT_COMMAND = cargo clippy --all-targets --all-features -- -D warnings
api: LINT_COMMAND = pylint --exclude=tests 
frontend: LINT_COMMAND = npm run lint
