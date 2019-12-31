# javaModulesQuery = ''
#   ${bazel}/bin/bazel query \
#     'filter("packages", kind(java_*, deps(packages/...)))' \
#     --output package
# '';

# pomQuery = ''
#   ${bazel}/bin/bazel query \
#     'kind(pom_file, deps(//...))'
# '';

# folderWithPomQuery = ''
#   pom
#   bazel query 'kind("pom_file", //...)' --output package
# '';

# generatePOMs = writeScriptBin "generate-poms" ''
#   ${bazel}/bin/bazel build $(${pomQuery})
#   ${generateConfigs}/bin/generate-configs
# '';

# generateConfigs = writeShellScriptBin "generate-configs" ''
#   JAVA_MODULES="$(echo $(${javaModulesQuery}))"
#   ${dhall}/bin/dhall <<< '(./config/config.dhall).bazel_config("'$JAVA_MODULES'")' > ${rootFolder}/bazel/variables/config.bzl
# '';