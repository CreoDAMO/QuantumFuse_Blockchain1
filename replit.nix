{ pkgs }: {
  deps = [
    pkgs.cargo
    pkgs.rustup
  ];

  shellHook = ''
    export PATH=$HOME/.cargo/bin:$PATH
    if ! rustup show | grep -q "nightly"; then
      rustup install nightly
    fi
    rustup default nightly
    rustup component add rust-src
  '';
}
