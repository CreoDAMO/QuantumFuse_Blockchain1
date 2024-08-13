# Rust targets
setup-rust:
	rustup toolchain install nightly || exit 1
	rustup override set nightly --path $(RUST_DIR) || exit 1
	rustup component add rust-src --toolchain nightly || exit 1
	sudo apt-get update && sudo apt-get install -y protobuf-compiler || exit 1
	cd $(RUST_DIR) && rustup run nightly cargo update || exit 1
	cd $(RUST_DIR) && rustup run nightly cargo build || exit 1

build-rust:
	cd $(RUST_DIR) && rustup run nightly cargo build --release || exit 1

run-rust:
	cd $(RUST_DIR) && rustup run nightly cargo run || exit 1

test-rust:
	cd $(RUST_DIR) && rustup run nightly cargo test || exit 1

clean-rust:
	cd $(RUST_DIR) && rustup run nightly cargo clean || exit 1

update-rust:
	cd $(RUST_DIR) && rustup run nightly cargo update || exit 1
