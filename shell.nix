{
  nixpkgs ? import <nixos-unstable> {}
}:
with nixpkgs.pkgs;
with lib;
with builtins;
let
  rootFolder = toString ./.;

  javaModulesQuery = ''
    bazel query 'filter("packages", kind(java_*, deps(packages/...)))' --output package
  '';

  pomQuery = ''
    bazel build $(bazel query 'kind(pom_file, deps(//...))')
  '';

  # TODO build only poms
  generatePOMs = writeScriptBin "generate-poms" ''
    ${pomQuery}
    ${writeBazelVars}/bin/write-bazel-vars
  '';

# TODO get all poms alternative? bazel query 'kind("generated file", //foo:*)'
  # TODO move all of these to bazel-helpers
  # TODO rename variables/nix to variables/configuration or mvn_config

  # TODO result bazel build //:pom //packages:pom //packages/app_1/java:pom
  # BETTER bazel query 'kind(pom_file, deps(packages/...))'
  # FROM whole WORKSPACE -> bazel query 'kind(pom_file, deps(//...))'
  # INSTEAD OF (cd ${rootFolder} && bazel build //...)

  # bazel query 'filter("packages", kind(java_*, deps(packages/...)))' --output package
  # TODO get java libs bazel query 'kind(java_lib, deps(packages/...))'
  # TODO bazel query 'filter("packages", kind(java_*, deps(packages/...)))' - only internals

  writeBazelVars = writeShellScriptBin "write-bazel-vars" ''
    JAVA_MODULES="$(echo ${javaModulesQuery} | tr '\n' ' ')"
    dhall <<< '(./config/config.dhall).bazel_config("'$JAVA_MODULES'")' > ${rootFolder}/bazel/variables/config.bzl
  '';
    # cat <<EOF > ${rootFolder}/bazel/variables/nix.bzl
    # modules = [$JAVA_MODULES]
    # workspace = ["packages"]
    # EOF
  # alternative dhall <<< '(./config/config.dhall).bazel_config'
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
    dhall
    dhall-json
    bazel-watcher
    generatePOMs
    figlet
    ];
  # BAZEL_OUTPUT
  # for d in $RUNFILES/*/bin; do PATH="$PATH:$d"; done
  # INFO isLorri = name=lorri-keep-env-hack-nix-shell (printenv | grep lorri)
  # TODO run generatePOMs if not in lorri
  shellHook = ''
    figlet "bazel & nix"
  '';
}

