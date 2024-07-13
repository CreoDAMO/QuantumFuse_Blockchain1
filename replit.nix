{ pkgs }: {
  deps = [
    pkgs.cmake
    pkgs.clang
    pkgs.gcc
    pkgs.pkg-config
    pkgs.openssl
    pkgs.python3
    pkgs.python3Packages.pip
    pkgs.go
    pkgs.ipfs
    pkgs.nodejs-18_x
    pkgs.yarn
  ];
}
