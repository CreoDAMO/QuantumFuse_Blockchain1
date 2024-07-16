{ pkgs }: 
let 
  rust = pkgs.rust-bin.stable.latest;
  go = pkgs.go_1_20;
  python = pkgs.python3.withPackages (ps: with ps; [ 
    pip 
    pytest 
    # Add other Python dependencies here if needed 
  ]);
  nodejs = pkgs.nodejs-18_x;
in pkgs.mkShell {
  buildInputs = [
    rust
    go
    python
    nodejs
    pkgs.cmake
    pkgs.pkg-config
    pkgs.openssl
    pkgs.libtool
    pkgs.libsecp256k1
  ];

  shellHook = ''
    export PATH=$PATH:$HOME/.cargo/bin
    export PATH=$PATH:$HOME/go/bin

    # Install Rust components
    rustup toolchain install nightly
    rustup default nightly
    rustup component add rust-src --toolchain nightly

    # Install Python dependencies
    pip install -r QuantumFuse/api/requirements.txt

    # Install Node.js dependencies
    cd QuantumFuse/frontend/quantumfuse-app && npm install

    echo "Development environment is ready."
  '';
}
