package(default_visibility = ["//visibility:public"])

java_binary(
    name = "Runner",
    srcs = glob(["src/main/java/com/example/app/*.java"]),
    main_class = "com.example.app.Runner",
    deps = [
        "//packages/module_a/java:module_a",
    ],
)
