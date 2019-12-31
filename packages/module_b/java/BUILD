load("//bazel:rules/generate-pom.bzl", "pom_file")

package(default_visibility = ["//visibility:public"])

java_library(
    name = "module_b",
    srcs = glob(["src/main/java/com/example/module_b/*.java"]),
)

pom_file(
    name = "pom",
    artifact_config = {
        "group_id": "com.example",
    },
    targets = [
        ":module_b",
    ],
    template_file = "//bazel/template:artifact_pom.xml",
)
