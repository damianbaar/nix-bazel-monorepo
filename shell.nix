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
    bazel build $(bazel query 'kind(pom_file, deps(//...))')
    write-bazel-vars 
  '';

  # TODO rename variables/nix to variables/configuration or mvn_config

  # TODO result bazel build //:pom //packages:pom //packages/app_1/java:pom
  # BETTER bazel query 'kind(pom_file, deps(packages/...))'
  # FROM whole WORKSPACE -> bazel query 'kind(pom_file, deps(//...))'
  # INSTEAD OF (cd ${rootFolder} && bazel build //...)
  writeBazelVars = writeShellScriptBin "write-bazel-vars" ''
    JAVA_MODULES_=$(find packages/**/java -print | grep -i 'BUILD' | sed -e 's/\/BUILD//')
    JAVA_MODULES=$(echo $JAVA_MODULES_ | sed  -e 's/\.\/packages\///' -e 's/\(.*\)/"\1"/g' | tr ' ' ',')
    echo $JAVA_MODULES
    echo $JAVA_MODULES_

    cat <<EOF > ${rootFolder}/bazel/variables/nix.bzl
    modules = [$JAVA_MODULES]
    workspace = ["packages"]
    EOF
  '';
  # TODO cp poms
  # JAVA_POMS=$(find bazel-bin/ -print | grep -i '.*[.]xml')
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
    figlet
    writeBazelVars
    ];
  # BAZEL_OUTPUT
  # for d in $RUNFILES/*/bin; do PATH="$PATH:$d"; done
  # INFO isLorri = name=lorri-keep-env-hack-nix-shell (printenv | grep lorri)
  shellHook = ''
    figlet "bazel & nix"
    bootstrap
  '';
}

