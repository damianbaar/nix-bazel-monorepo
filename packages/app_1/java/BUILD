load("@bazel_common//tools/maven:pom_file.bzl", "pom_file")
load("@rules_java//java:defs.bzl", "java_binary", "java_library", "java_test")

package(default_visibility = ["//visibility:public"])

local_deps = [
    "//packages/module_a/java:module_a",
]

workspace_deps = [
    "@maven//:com_google_guava_guava",
    "@maven//:com_google_inject_guice",
    "@maven//:org_springframework_boot_spring_boot",
    "@maven//:org_springframework_boot_spring_boot_autoconfigure",
    "@maven//:org_springframework_boot_spring_boot_starter_web",
]

java_binary(
    name = "Runner",
    srcs = glob(["src/main/java/com/example/app/*.java"]),
    main_class = "com.example.app.Runner",
    # resources = [],
    deps = workspace_deps + local_deps,
)

load("@workspace//:tools/generate-pom.bzl", "generate_local_deps")

pom_file(
    name = "pom",
    substitutions = {
        "local": generate_local_deps(
            local_deps,
        ),
        "group_id": "com.example",
        "name": "app",
    },
    targets = [
        "//packages/app_1/java:Runner",
    ],
    template_file = "pom_template.xml",
)
