
{ pkgs }: {
  deps = [
    pkgs.flutter
    pkgs.androidenv.androidPkgs_9_0.platform-tools
    pkgs.jdk11
    pkgs.unzip
    pkgs.which
    pkgs.ncurses
    pkgs.cmake
    pkgs.ninja
    pkgs.gtk3
    pkgs.pkg-config
    pkgs.xz
    pkgs.clang
  ];
}
