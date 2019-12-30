{
  nixpkgs ? import <nixos-unstable> {}
}:
with nixpkgs.pkgs;
with lib;
with builtins;
let
  rootFolder = toString ./.;

  # TODO build only poms
  bootstrap = writeScriptBin "bootstrap" ''
    write-bazel-vars 
    (cd ${rootFolder} && bazel build //...)
  '';

  writeBazelVars = writeScriptBin "write-bazel-vars" ''
    JAVA_MODULES=$(find ./packages/**/java -print | grep -i 'BUILD' | sed -e 's/\/BUILD//' -e 's/\.\/packages\///' -e 's/\(.*\)/"\1"/g' | tr '\n' ',')
    JAVA_POMS=$(find ./bazel-bin/ -print | grep -i '.*[.]xml')

    cat <<EOF > ./bazel/variables/nix.bzl
    modules = [$JAVA_MODULES]
    workspace = ["packages"]
    EOF
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
    writeBazelVars
    ];
  # BAZEL_OUTPUT
  # for d in $RUNFILES/*/bin; do PATH="$PATH:$d"; done
  shellHook = ''
    echo elo!
    bootstrap
  '';
}

