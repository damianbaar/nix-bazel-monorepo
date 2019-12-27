{
  nixpkgs ? import <nixos-unstable> {}
}:
with nixpkgs.pkgs;
mkShell {
  buildInputs = [bazel bash maven jdk bazel-buildtools];
  shellHook = ''
    echo elo!
  '';
}

