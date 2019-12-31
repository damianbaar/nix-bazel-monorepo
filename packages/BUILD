load("//bazel:rules/generate-pom.bzl", "pom_file")

pom_file(
    name = "pom",
    artifact_config = {
        "group_id": "com.example",
    },
    targets = [],
    template_file = "//bazel/template:packages_pom.xml",
)

# get deps from build
# get folders from shell
genrule(
    name = "gen_zip",
    srcs = glob(["**/**"]),
    outs = ["files.txt"],
    cmd = """
      $(location @nix-hello//:bin) > $@
      tree >> $@
      echo $(SRCS) >> $@
    """,
    # echo $(OUTS) >> $@
    # echo "nixpkgs hello location $(location @nix-hello//:bin)" >> $@
    # DIR=$$(dirname $@)
    output_to_bindir = True,
    tools = [
        "@nix-hello//:bin",
    ],
)
