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
    srcs = glob(["src/main/java/com/example/app_1/*.java"]),
    main_class = "com.example.app.Runner",
    # resources = [],
    deps = deps,
)

load("@root_workspace//:tools/generate-pom.bzl", "pom_file")

pom_file(
    name = "pom",
    artifact_config = {
        "workspace": "root_workspace",
        "group_id": "com.example",
    },
    substitutions = {
        "name": "app",
    },
    targets = [
        "//packages/app_1/java:Runner",
    ],
    # how to externalize that file?
    template_file = "pom_template.xml",
)

sh_binary(
    name = "run-{0}".format("helloo"),
    srcs = ["test_bin.sh"],
    args = ["$(location @{0}//:bin)".format("hello")],
    data = ["@{0}//:bin".format("hello")],
)

# genrule(
#     name = "main",
#     srcs = ["test_bin.sh"],
#     outs = [
#         "main.o1",
#         "main.o2",
#     ],
#     cmd = "echo $(location @hello//:bin) > $@",
#     # data = ["@{0}//:bin".format("hello")],
# )

sh_binary(
    name = "foo",
    srcs = ["test_bin.sh"],
    args = ["$(location @hello//:bin)".format("hello")],
    data = ["@hello//:bin".format("hello")],
    deps = [
        "@hello_2//:bin",
    ],
    # data = [
    #     "//hello:bin",  # an sh_binary with srcs
    #     # ":deploy_foo",  # another sh_binary with srcs
    # ],
)
# genrule(
#     name = "pull_and_build",
#     srcs = "test_bin.sh",
#     outs = ["built_project.tar.gz"],
#     cmd = """
#     $@""",
#     # tools = [":pull_sh", ":build_sh"],
#     tools = [],
# )

[
    sh_test(
        name = "run-{0}.sh".format(test),
        timeout = "short",
        srcs = ["test_bin.sh"],
        args = ["$(location @{0}//:bin)".format(test)],
        data = ["@{0}//:bin".format(test)],
    )
    for test in [
        "hello",
        "hello_2",
    ]
]
