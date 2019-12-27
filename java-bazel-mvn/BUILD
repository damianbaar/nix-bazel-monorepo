load("@rules_java//java:defs.bzl", "java_binary", "java_test", "java_library")
load("@bazel_common//tools/maven:pom_file.bzl", "pom_file")

package(default_visibility = ["//visibility:public"])

java_library(
    name = "ProjectRunnerLib",
    srcs = glob(["src/main/java/com/example/*.java"]),
    visibility = ["//visibility:public"],
     deps = [
        "@maven//:com_google_guava_guava",
        "@maven//:com_google_inject_guice",
        "@maven//:org_springframework_boot_spring_boot",
        "@maven//:org_springframework_boot_spring_boot_autoconfigure",
        "@maven//:org_springframework_boot_spring_boot_starter_web",
    ],
)

java_binary(
    name = "ProjectRunner",
    main_class = "com.example.ProjectRunner",
    runtime_deps = [
      "//:ProjectRunnerLib"
    ],
)

pom_file(
    name = "lib-pom",
    targets = [
        "//:ProjectRunnerLib",
    ],
    substitutions = {
      "group_id": "com.example"
    },
    template_file = "pom_template.xml",
)

