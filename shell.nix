{
  nixpkgs ? import <nixos-unstable> {}
}:
with nixpkgs.pkgs;
let
  # get poms - for d in bazel-bin/**/pom.xml; do echo $d; done
  bootstrap = writeScriptBin "bootstrap" ''
  '';
in
mkShell {
  buildInputs = [
    bazel 
    bash 
    maven 
    jdk 
    bazel-buildtools
    bazel-watcher
    bootstrap
    ];
  # BAZEL_OUTPUT
  # TODO find all pom.xml
  # for d in $RUNFILES/*/bin; do PATH="$PATH:$d"; done
  shellHook = ''
    echo elo!
    bazel build //...
    for d in bazel-bin/**/pom.xml; do echo $d; done
  '';
}

