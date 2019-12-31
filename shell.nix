{
  nixpkgs ? import ./nix {},
}:
with nixpkgs.pkgs;
with lib;
with builtins;
let
  rootFolder = toString ./.;

  # TODO move all of these to bazel-helpers
  # TODO separate execution, query and output
  javaModulesQuery = ''
    ${bazel}/bin/bazel query \
      'filter("packages", kind(java_*, deps(packages/...)))' \
      --output package
  '';

  pomQuery = ''
    ${bazel}/bin/bazel query \
      'kind(pom_file, deps(//...))'
  '';

  folderWithPomQuery = ''
    bazel query 'kind("pom_file", //...)' --output package
  '';

  generatePOMs = writeScriptBin "generate-poms" ''
    ${bazel}/bin/bazel build $(${pomQuery})
  '';

  generateConfigs = writeShellScriptBin "generate-configs" ''
    JAVA_MODULES="$(echo $(${javaModulesQuery}))"
    ${dhall-text}/bin/dhall-to-text <<< '(./config/config.dhall).bazel_config("'$JAVA_MODULES'")' > ${rootFolder}/bazel/variables/config.bzl
  '';

  # TODO cp poms
  # QUERY?
  # TODO get all poms alternative? bazel query 'kind("generated file", //foo:*)'
  # bazel query 'kind("pom_file", deps(//...))' --output package
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
    dhall-text
    bazel-watcher
    # dhall-haskell.dhall-lsp-server
    generatePOMs
    generateConfigs
    figlet
    ];
  # BAZEL_OUTPUT
  # for d in $RUNFILES/*/bin; do PATH="$PATH:$d"; done
  # INFO isLorri = name=lorri-keep-env-hack-nix-shell (printenv | grep lorri)
  # TODO run generatePOMs if not in lorri
  shellHook = ''
    figlet "bazel nix dhall"
  '';
}

