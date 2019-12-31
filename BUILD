load("//bazel:rules/generate-pom.bzl", "pom_file")
load("//config:__generated__/config.bzl", "namespace", "workspace")

pom_file(
    name = "pom",
    artifact_config = {
        "group_id": namespace,
    },
    modules = workspace,
    template_file = "//bazel/template:workspace_pom.xml",
)
