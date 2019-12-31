load("//bazel:rules/generate-pom.bzl", "pom_file")
load("//bazel:variables/project.bzl", "namespace")
load("//bazel:variables/config.bzl", "modules")

pom_file(
    name = "pom",
    artifact_config = {
        "group_id": namespace,
    },
    modules = [],
    template_file = "//bazel/template:workspace_pom.xml",
)
