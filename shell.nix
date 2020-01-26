{
  system ? builtins.currentSystem,
  nixpkgs ? import ./nix { inherit system; },
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

  # TODO as dhall is handling env vars
  # move JAVA_MODULES to .direnv and read from there
  # all find has to be in array format - as dhall does not support string split

  # TOOO for loop over files *-config.dhall
  generateConfigs = writeShellScriptBin "generate-configs" ''
    JAVA_MODULES="$(echo $(${javaModulesQuery}) | sed -e 's/\ /,/')"
    export JAVA_MODULES_2=$(${javaModulesQuery})
    WORKSPACE="packages"

    ${dhall-text}/bin/dhall-to-text \
      <<< '(./config/config.dhall).bazel_config { modules = ["'$JAVA_MODULES'"], workspaces = ["'$WORKSPACE'"]}' \
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
    deps = import ./preloaded_deps.nix {
      inherit nixpkgs;
    };
in
mkShell {
  DOCKER_BUILDKIT=1;

  buildInputs = [
    # dhall
    # dhall-json
    # dhall-text
    # dhall-haskell.dhall-lsp-server
    # generatePOMs
    # generateConfigs
    # copyPOMs
  ] + deps;

  shellHook = ''
    figlet "bazel nix dhall"
  '';
    # generate-configs
}

