load("@bazel_common//tools/maven:pom_file.bzl", "pom_file")
load("@rules_java//java:defs.bzl", "java_binary", "java_library", "java_test")

package(default_visibility = ["//visibility:public"])

java_library(
    name = "module_a",
    srcs = glob(["src/main/java/com/example/module_a/*.java"]),
    deps = ["//packages/module_b/java:module_b"],
)

pom_file(
    name = "lib-pom",
    substitutions = {
        "group_id": "com.example",
    },
    targets = [
        "//packages/module_a/java:module_a",
    ],
    template_file = "pom_template.xml",
)
