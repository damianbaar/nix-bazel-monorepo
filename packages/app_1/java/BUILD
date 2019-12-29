load("@rules_java//java:defs.bzl", "java_binary", "java_library", "java_test")

package(default_visibility = ["//visibility:public"])

deps = [
    "@root_workspace//packages/module_a/java:module_a",
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
    deps = deps,
)

load("@root_workspace//:tools/generate-pom.bzl", "pom_file")

pom_file(
    name = "pom",
    artifact_config = {
        "workspace": "root_workspace",
        "group_id": "com.example.app_1",
    },
    substitutions = {
        "name": "app",
    },
    targets = [
        "//packages/app_1/java:Runner",
    ],
    template_file = "pom_template.xml",
)

# pom(
#     ["//packages/app_1/java:Runner"],
#     "pom",
#     "pom_template.xml",
# )
# substitutions = {
#     "group_id": "com.example.app_1",
#     "name": "app",
# },
# workspace = "root_workspace",
