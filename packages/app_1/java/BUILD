load("@rules_java//java:defs.bzl", "java_binary", "java_library", "java_test")
load("@com_example//bazel:rules/generate-pom.bzl", "pom_file")
load("//bazel:variables/project.bzl", "namespace")

package(default_visibility = ["//visibility:public"])

deps = [
    "@com_example//packages/module_a/java:module_a",
    "@maven//:com_google_guava_guava",
    "@maven//:com_google_inject_guice",
    "@maven//:org_springframework_boot_spring_boot",
    "@maven//:org_springframework_boot_spring_boot_autoconfigure",
    "@maven//:org_springframework_boot_spring_boot_starter_web",
]

java_binary(
    name = "Runner",
    srcs = glob(["src/main/java/com/example/app_1/*.java"]),
    main_class = "com.example.app.Runner",
    # resources = [],
    deps = deps,
)

pom_file(
    name = "pom",
    artifact_config = {
        "group_id": namespace,
    },
    targets = [
        ":Runner",
    ],
    template_file = "//bazel/template:artifact_pom.xml",
)
