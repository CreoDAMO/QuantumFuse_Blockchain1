{ pkgs }: {
  deps = [
    pkgs.cargo
    pkgs.rustup
  ];

  shellHook = ''
    export PATH=$HOME/.cargo/bin:$PATH
    rustup toolchain install nightly
    rustup default nightly
    rustup component add rust-src
  '';
}
