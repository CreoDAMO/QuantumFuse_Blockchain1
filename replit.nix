{ pkgs }: {
  deps = [
    pkgs.cargo
    pkgs.rustup
    pkgs.go
    pkgs.python3
    pkgs.nodejs
    pkgs.protobuf
    pkgs.python3Packages.pip
    pkgs.python3Packages.virtualenv
    pkgs.openssl
    pkgs.pkg-config
  ];

  shellHook = ''
    # Rust setup
    export PATH=$HOME/.cargo/bin:$PATH
    rustup toolchain install nightly
    rustup default nightly
    rustup component add rust-src

    # Go setup
    export GOPATH=$HOME/go
    export PATH=$GOPATH/bin:$PATH
    mkdir -p $GOPATH

    # Python setup
    python3 -m venv QuantumFuse/api/venv
    source QuantumFuse/api/venv/bin/activate
    pip install -r QuantumFuse/api/requirements.txt

    # Node.js setup
    cd QuantumFuse/frontend/quantumfuse-app
    npm install
  '';
}
