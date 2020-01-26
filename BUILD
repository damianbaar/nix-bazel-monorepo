load("//bazel:rules/generate-pom.bzl", "pom_file")
load("//config:__generated__/config.bzl", "namespace", "workspace")
load("@io_bazel_rules_docker//container:container.bzl", "container_image")

# pom_file(
#     name = "pom",
#     artifact_config = {
#         "group_id": namespace,
#     },
#     modules = workspace,
#     template_file = "//bazel/template:workspace_pom.xml",
# )

# container_test(
#     name = "extended_alpine_dockerfile_test",
#     configs = ["//extended/test_configs:extended_alpine.yaml"],
#     driver = "tar",
#     image = "@extended_alpine_dockerfile//image:dockerfile_image",
# )
filegroup(
    name = "repo",
    srcs = glob([
        "nix/**",
    ]),
)

container_image(
    name = "nix-shell",
    base = "@nix_custom_image//image:dockerfile_image.tar",
    env = {
        "TEST": "yAay!",
        "INPUT": "inputFolder",
        "OUTPUT": "outputFolder",
    },
    files = [
        ":repo",
    ],
    labels = {"maintainer": "damian.baar"},
    workdir = "/workspace",
    ports = [
        "80",
        "443",
    ],
    # symlinks = {},
    # volumes = ["/"],
    # entrypoint = ["/entrypoint.sh"],
    # cmd = ["/run.sh"],
    # files = ["entrypoint.sh",
    #          "run.sh",
    #          "nginx-inputs.json",
    #          ],
)

genrule(
    name = "test_rule",
    outs = ["dupa.szatana"],
    cmd = "ls -la > $@",
)
