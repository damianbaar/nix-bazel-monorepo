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
    pom
    bazel query 'kind("pom_file", //...)' --output package
  '';

  generatePOMs = writeScriptBin "generate-poms" ''
    ${bazel}/bin/bazel build $(${pomQuery})
    ${generateConfigs}/bin/generate-configs
  '';

  generateConfigs = writeShellScriptBin "generate-configs" ''
    JAVA_MODULES="$(echo $(${javaModulesQuery}))"
    ${dhall}/bin/dhall <<< '(./config/config.dhall).bazel_config("'$JAVA_MODULES'")' > ${rootFolder}/bazel/variables/config.bzl
  '';

  # TODO cp poms
  # QUERY?
  # TODO get all poms alternative? bazel query 'kind("generated file", //foo:*)'
  # bazel query 'kind("pom_file", deps(//...))' --output package
  # JAVA_POMS=$(find bazel-bin/ -print | grep -i '.*[.]xml')
  # BAZEL_BIN=$(bazel info bazel-bin)
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
    # dhall-haskell.dhall-lsp-server
    generatePOMs
    figlet
    ];
  # BAZEL_OUTPUT
  # for d in $RUNFILES/*/bin; do PATH="$PATH:$d"; done
  # INFO isLorri = name=lorri-keep-env-hack-nix-shell (printenv | grep lorri)
  # TODO run generatePOMs if not in lorri
  shellHook = ''
    figlet "bazel & nix & dhall"
  '';
}

