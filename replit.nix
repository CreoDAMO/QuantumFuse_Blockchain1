{ pkgs }: {
  deps = [
    pkgs.glibcLocales
    pkgs.tk
    pkgs.tcl
    pkgs.qhull
    pkgs.gtk3
    pkgs.gobject-introspection
    pkgs.ghostscript
    pkgs.freetype
    pkgs.ffmpeg-full
    pkgs.cairo
    pkgs.kubo
    pkgs.cmake
    pkgs.clang
    pkgs.gcc
    pkgs.pkg-config
    pkgs.openssl
    pkgs.rustup
    pkgs.rustc
    pkgs.cargo
    pkgs.libopenssl
    pkgs.zlib
    pkgs.libssh2
    pkgs.protobuf
  ];
}
