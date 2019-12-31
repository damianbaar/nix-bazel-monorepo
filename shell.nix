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
    WORKSPACE="packages"

    ${dhall-text}/bin/dhall-to-text \
      <<< '(./config/config.dhall).bazel_config("'$JAVA_MODULES'")("'$WORKSPACE'")' \
      > ${rootFolder}/config/__generated__/config.bzl
  '';

  copyPOMs = writeScriptBin "copy-poms" ''
    POMS=$(find bazel-bin/ -print | grep -i '.*[.]xml')

    for source in $POMS
    do
      target=$(echo $source | sed 's/^[^/]*\///')
      install -m 0777 $source $target
    done
  '';
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
    figlet

    generatePOMs
    generateConfigs
    copyPOMs
  ];

  shellHook = ''
    figlet "bazel nix dhall"

    generate-configs
    generate-poms
    copy-poms
  '';
}

