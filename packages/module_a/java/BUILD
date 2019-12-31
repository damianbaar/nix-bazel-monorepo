load("@bazel_common//tools/maven:pom_file.bzl", "pom_file")
load("//bazel:rules/generate-pom.bzl", "pom_file")

package(default_visibility = ["//visibility:public"])

java_library(
    name = "module_a",
    srcs = glob(["src/main/java/com/example/module_a/*.java"]),
    deps = ["//packages/module_b/java:module_b"],
)

pom_file(
    name = "pom",
    artifact_config = {
        "group_id": "com.example",
    },
    targets = [
        ":module_a",
    ],
    template_file = "//bazel/template:artifact_pom.xml",
)
