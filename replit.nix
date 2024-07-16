{ pkgs }: {
  deps = [
    pkgs.cmake
    pkgs.clang
    pkgs.gcc
    pkgs.pkg-config
    pkgs.openssl
  ];
}
