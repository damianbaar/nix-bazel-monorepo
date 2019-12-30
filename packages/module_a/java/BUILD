load("@bazel_common//tools/maven:pom_file.bzl", "pom_file")
load("@com_example//:tools/generate-pom.bzl", "pom_file")

package(default_visibility = ["//visibility:public"])

java_library(
    name = "module_a",
    srcs = glob(["src/main/java/com/example/module_a/*.java"]),
    deps = ["@com_example//packages/module_b/java:module_b"],
)

pom_file(
    name = "pom",
    artifact_config = {
        "group_id": "com.example",
    },
    targets = [
        ":module_a",
    ],
    # how to externalize that file?
    template_file = "pom_template.xml",
)
