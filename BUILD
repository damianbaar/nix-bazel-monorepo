load("@com_example//bazel:rules/generate-pom.bzl", "pom_file")
load("//bazel:variables/project.bzl", "namespace")
load("//bazel:variables/nix.bzl", "workspace")

pom_file(
    name = "pom",
    artifact_config = {
        "group_id": namespace,
    },
    folders = workspace,
    template_file = "//bazel/template:workspace_pom.xml",
)
