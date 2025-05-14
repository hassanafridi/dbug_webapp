
{ pkgs }: {
    deps = [
        pkgs.flutter
        pkgs.dart
        pkgs.clang
        pkgs.pkg-config
        pkgs.gtk3
        pkgs.pcre
        pkgs.cmake
        pkgs.ninja
    ];
}


{ pkgs ? import <nixpkgs> {} }:
pkgs.mkShell {
  buildInputs = [
    pkgs.dart_3_5_0
  ];
}